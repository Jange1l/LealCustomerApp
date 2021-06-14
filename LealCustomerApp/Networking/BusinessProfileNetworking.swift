//
//  BusinessProfileNetworking.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/25/21.
//

import Foundation
import UIKit
import Firebase
class BusinessProfileNetworking {
	
	let storage = Storage.storage().reference()
	let accountDetailsNetworking = AccountDetailsNetworking()
	let loyaltyProgramNetwroking = LoyaltyProgramNetworking()
	
	func followBusinessWithUid(business: MDStructures.BusinessAccountDetails ,uid: String, followers: Int, completion: @escaping (Bool) ->()) {
		var count = 0 {
			didSet {
				if count == 4 {
					completion(true)
					count = 0
				}
			}
		}
		// Add user to followers list
		LCons.BusinessAccountDetailsRef.document(uid).collection("Followers").document(AccountDetails().getUid()).setData(
			[
				"customerUid": AccountDetails().getUid(),
				"notificationToken": AccountDetails().getNotificationToken(),
				"customerName" : "\(AccountDetails().getCustomerName())"
			]){ err in
			if let err = err {
				print("Error writing document: \(err)")
			} else {
				print("Document successfully written!")
				count += 1
			}
		}
		
		// Increae follower count
		let newFollowers = followers + 1
		LCons.BusinessAccountDetailsRef.document(uid).updateData(
			[
				"FollowerCount" : String(newFollowers)
			]){ err in
			if let err = err {
				print("Error writing document: \(err)")
			} else {
				print("Document successfully written!")
				count += 1
			}
		}
		// Add loyalty copy to customers collection
		loyaltyProgramNetwroking.fetchCurrentLoyaltyProgram(uid: business.uid, completion: {(status, program) in
			
			LCons.AccountDetailsRef.collection("LoyaltyPrograms").document(business.uid).setData(
				[
					"customerPoints" : "0",
					"dateJoined" : "2021",
					"businessName" : business.businessName,
					"timesScanned" : "0",
					"currentStep" : "1",
					"numberOfSteps" : "\(program.numberOfSteps!)",
					"businessUid" : "\(business.uid)",
					"pointsPerStep" : "\(program.pointsPerStep!)"
				]){ err in
				if let err = err {
					print("Error writing document: \(err)")
				} else {
					print("Document successfully written!")
					count += 1
				}
			}
		})
		
		
		accountDetailsNetworking.getAccountDocument(completion: {(status, profile) in
			
			let newCount = String(Int(profile.followersCount)! + 1)
			
			LCons.AccountDetailsRef.updateData(
				[
					"FollowingCount": newCount
				]){ err in
				if let err = err {
					print("Error writing document: \(err)")
				} else {
					print("Document successfully written!")
					count += 1
				}
			}
		})
		
	}
	
	
	
	func unfollowBusinessWithUid(uid: String, followers: Int, completion: @escaping (Bool) ->()) {
//		var count = 0 {
//			didSet {
//				if count == 4 {
//					completion(true)
//					count = 0
//				}
//			}
//		}
		let group = DispatchGroup()
		
		group.enter()
		LCons.BusinessAccountDetailsRef.document(uid).collection("Followers").document(AccountDetails().getUid()).delete() { err in
			if let err = err {
				print("Error removing document: \(err)")
			} else {
				print("Document successfully removed!")
				
			}
			group.leave()
		}
		group.enter()
		LCons.AccountDetailsRef.collection("LoyaltyPrograms").document(uid).delete(){ err in
			if let err = err {
				print("Error removing document: \(err)")
			} else {
				print("Document successfully removed!")
				//count += 1
			}
			group.leave()
		}
		
		let newFollowers = followers - 1
		group.enter()
		LCons.BusinessAccountDetailsRef.document(uid).updateData(
			[
				"FollowerCount" : String(newFollowers)
			]){ err in
			if let err = err {
				print("Error writing document: \(err)")
			} else {
				print("Document successfully written!")
				//count += 1
			}
			group.leave()
		}
		group.enter()
		accountDetailsNetworking.getAccountDocument(completion: {(status, profile) in
			
			let newCount = String(Int(profile.followersCount)! - 1)
			
			LCons.AccountDetailsRef.updateData(
				[
					"FollowingCount": newCount
				]){ err in
				if let err = err {
					print("Error writing document: \(err)")
				} else {
					print("Document successfully written!")
					//count += 1
					group.leave()
				}
			}
		})
		
		group.notify(queue: .main) {
			completion(true)
		}
		
		
	}
	
	func fetchBusinessProfileWithUid(uid: String, completion: @escaping (Bool, MDStructures.BusinessAccountDetails) -> ()) {
		
		var account = MDStructures.BusinessAccountDetails(businessName: "", businessEmail: "", businessPhoneNumber: "", profileImageUrl: "", businessType: "", businessBio: "", promotionsPostedCount: "", followersCount: "", testImage: UIImage(), isFollowed: false, uid: "")
		
		LCons.BusinessAccountDetailsRef.document(uid).getDocument(completion: {(document, err) in
			if let err = err {
				print("Error getting documents for business information: \(err)")
				completion(false, account)
			} else {
				if let document = document, document.exists {
					
					let dt = document.data()!
					
					account.businessName = dt[LCons.f_bName] as! String
					account.businessEmail = dt[LCons.f_bEmail] as! String
					account.businessPhoneNumber = dt[LCons.f_bPhoneNumber] as! String
					account.businessBio = dt[LCons.f_bBusinessBio] as! String
					account.businessType = dt[LCons.f_bBusinessType] as! String
					account.profileImageUrl = dt[LCons.f_bProfileImageURL] as! String
					account.promotionsPostedCount = dt[LCons.f_bPromotionsPostedCount] as! String
					account.followersCount = dt[LCons.f_bFollowersCount] as! String
					account.uid = dt[LCons.f_bUid] as! String
					
				}
				
				// Get Business Profile Picture
				if account.profileImageUrl != "" {
					
					// Download image
					let storage = Storage.storage().reference()
					let profileImagesRef = storage.child("ProfileImages")
					let p = profileImagesRef.child(account.uid)
					
					p.getData(maxSize: 1 * 1024 * 1024) { data, error in
						if error != nil {
							// Uh-oh, an error occurred!
						} else {
							
							let image = UIImage(data: data!)
							account.testImage = image!
							
							completion(true, account)
							
						}
					}
				} else {
					// Set default profile with no picture
					completion(true, account )
				}
				
			}
		})
	}
	
	func isFollowed(uid: String, completion: @escaping (Bool)->()) {
		
		// Check if Customer Follows business
		LCons.BusinessAccountDetailsRef.document(uid).collection("Followers").document(AccountDetails().getUid()).getDocument(completion: {(document, err) in
			if let err = err {
				print("Error getting documents for business information: \(err)")
				
			} else {
				if let document = document, document.exists {
					
					completion(true)
					
				} else {
					completion(false)
				}
			}
		})
	}
	
	func fetchAnnouncements(completion: @escaping (Bool,[MDStructures.Announcement]) ->() ) {
		
		loyaltyProgramNetwroking.fetchAllUpComingRewards(completion: {(s, profiles) in
			
			var announcements = [MDStructures.Announcement]()
			
			
			if profiles.count == 0 {
				completion(false, announcements)
			}
			let group = DispatchGroup()
			for b in profiles {
				group.enter()
				LCons.AnnouncementsRef.whereField("uid", isEqualTo: b.businessUid).getDocuments() { (querySnapshot, err) in
					
					if let err = err {
						print("Error getting documents: \(err)")
						group.leave()
						completion(false, announcements)
					} else {
						for data in querySnapshot!.documents {
							
							var anoun = MDStructures.Announcement(businessName: "", message: "", timeReleased: "", profileUrl: "", profileImage: UIImage(), uid: "", postUid: "")
							
							anoun.businessName = data["businessName"] as! String
							anoun.message = data["message"] as! String
							anoun.timeReleased = data["timeReleased"] as! String
							anoun.profileUrl = data["profileUrl"] as! String
							anoun.uid = data["uid"] as! String
							anoun.postUid = data["postUid"] as! String
							
							announcements.append(anoun)

						}
						group.leave()
					}
					completion(false, announcements)
				}
			}
			group.notify(queue: .main) {
				completion(true, announcements)
			}
		})
		
	}
	
	func getBusinessPostData(businessUid: String, completion: @escaping (Bool, [MDStructures.Announcement], [MDStructures.Discount]) -> ()) {

		var announcements = [MDStructures.Announcement]()
		var discounts = [MDStructures.Discount]()
		
		var count = 0 {
			didSet {
				if count == 2 {
					completion(true, announcements, discounts)
				}
			}
		}
		
		LCons.AnnouncementsRef.whereField("uid", isEqualTo: businessUid).getDocuments(completion: {(snap, err) in
			
			if let err = err {
				print("Error getting douemnts: \(err)")
			} else {
				
				for document in snap!.documents {
					
					let data = document.data()
					
					var anoun = MDStructures.Announcement(businessName: "", message: "", timeReleased: "", profileUrl: "", profileImage: UIImage(), uid: "", postUid: "")
					
					anoun.businessName = data["businessName"] as! String
					anoun.message = data["message"] as! String
					anoun.timeReleased = data["timeReleased"] as! String
					anoun.profileUrl = data["profileUrl"] as! String
					anoun.uid = data["uid"] as! String
					anoun.postUid = data["postUid"] as! String
					
					announcements.append(anoun)
				}
			}
			count += 1
		})
		
		
		LCons.DiscountsRef.whereField("uid", isEqualTo: businessUid).getDocuments(completion: {(snap, err) in
			
			
			if let err = err {
				print("Error getting douemnts: \(err)")
				
			} else {
				
				
				for document in snap!.documents {
					
					let data = document.data()
					
					var discount = MDStructures.Discount(businessName: "", discount: "", timeReleased: "", duration: "", endDate: "", description: "", quantity: "", profileUrl: "", profileImage: UIImage(), uid: "", postUid: "", type: "")
					
					discount.businessName = data["businessName"] as! String
					discount.discount = data["discount"] as! String
					discount.timeReleased = data["timeReleased"] as! String
					discount.duration = data["duration"] as! String
					discount.endDate = data["endDate"] as! String
					discount.description = data["description"] as! String
					discount.quantity = data["quantity"] as! String
					discount.profileUrl = data["profileUrl"] as! String
					discount.uid = data["uid"] as! String
					discount.postUid = data["postUid"] as! String
					discount.type = data["type"] as! String
					discounts.append(discount)
				}
			}
			count += 1
		})
		
		
		
	}
	
	
}


