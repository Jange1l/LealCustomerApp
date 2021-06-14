//
//  AccountDetailsNetworking.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/2/21.
//

import Foundation
import Firebase


class AccountDetailsNetworking {
	
	
	func getAccountDocument(completion: @escaping (Bool, MDStructures.AccountDetails) -> ()){
		
		var account = MDStructures.AccountDetails(name: "", email: "", phoneNumber: "", profileImageUrl: "", profileImage: UIImage(), followersCount: "", totalSaved: "", uid: "")
		
		LCons.AccountDetailsRef.getDocument { (document, err) in
			if let err = err {
				print("Error getting documents for user information: \(err)")
				completion(false, account)
			} else {
				if let document = document, document.exists {
					
					let data = document.data()
					//user.name = (data!["firstName"] as! NSString) as String
					account.name = data![LCons.f_cName] as! String
					account.email = data![LCons.f_cEmail] as! String
					account.phoneNumber = data![LCons.f_cPhoneNumber] as! String
					account.profileImageUrl = data![LCons.f_cProfileUrl] as! String
					account.uid = data![LCons.f_cUid] as! String
					account.followersCount = data!["FollowingCount"] as! String
					account.totalSaved = data!["TotalSaved"] as! String
					
				}
				
				// Get Business Profile Picture
				// Will always check for profile pictur, if one does not exist it will show a black circle
				print("GETTING PICTURE -> ", account.profileImage)
				if account.profileImageUrl != "" {
					
					// Download image
					let storage = Storage.storage().reference()
					let profileImagesRef = storage.child("CustomerProfileImages")
					let p = profileImagesRef.child(account.uid)
					
					p.getData(maxSize: 1 * 1024 * 1024) { data, error in
						if error != nil {
							// Uh-oh, an error occurred!
							
						} else {
							
							let image = UIImage(data: data!)
							account.profileImage = image!
						}
						completion(true, account)
					}
				} else {
					// Set default profile with no picture
					print("NO PICTURE FOUND")
					completion(true, account )
				}
			}
		}
	}
	
	func updateAccountDetails(account:MDStructures.AccountDetails) {
		LCons.AccountDetailsRef.updateData([
			LCons.f_cName: "\(account.name)",
			LCons.f_cEmail: "\(account.email)",
			LCons.f_cPhoneNumber: "\(account.phoneNumber)",
			])
		}
	
		
	func signOut(completion: @escaping (Bool) -> ()) {
		let firebaseAuth = Auth.auth()
		do {
			try firebaseAuth.signOut()
			print("User signed out")
			//self.dismiss(animated: true, completion: nil)
			completion(true)
		} catch let signOutError as NSError {
			print("Error signing out: %@", signOutError)
			completion(false)
		}
		
	}
	
	func updateUserFCMToken() {
		LCons.AccountDetailsRef.updateData(
		[
			"notifToken" : "\(AccountDetails().getNotificationToken())"
		])
	}
}
