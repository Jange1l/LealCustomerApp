//
//  AccountDetails.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/2/21.
//

import Foundation
import Firebase

class AccountDetails {
	var networking: AccountDetailsNetworking!
	
	let defaults = UserDefaults.standard
	
	private let CustomerName = "CustomerName"
	private let CustomerEmail = "CustomerEmail"
	private let CustomerPhoneNumber = "CustomerPhoneNumber"
	private let Uid = "Uid"
	private let FollowersUidList = "FollowersUidList"
	private let AvailableFeaturesNameList = "AvailableFeaturesNameList"
	private let CustomerType = "CustomerType"
	private let CustomerBio = "CustomerBio"
	private let ProfileUrl = "ProfileUrl"
	private let IsLoggedIn = "IsLoggedIn"
	private let NotificationToken = "NotificationToken"
	init() {
		networking = AccountDetailsNetworking()
	}
	
	//MARK: Check User State
	func hasUserLoggedinBefore() -> Bool {
		var permission = false
		if !defaults.bool(forKey: IsLoggedIn) {
			networking.signOut(completion: {(completed) in })
			permission = false
			defaults.setValue(true, forKey: IsLoggedIn)
		} else {
			permission = true
		}
		return permission
	}
	
	// MARK: Getters
	func getCustomerName() -> String {
		
		return defaults.string(forKey: CustomerName) ?? ""
	}
	
	func getCustomerEmail() -> String {
		return defaults.string(forKey: CustomerEmail) ?? "Add email in account details"
	}
	
	func getCustomerPhoneNumber() -> String {
		return defaults.string(forKey: CustomerPhoneNumber) ?? ""
	}
	
	func getUid() -> String {
		return defaults.string(forKey: Uid)!
		
	}
	
	func getProfileUrl() -> String {
		return defaults.string(forKey: ProfileUrl) ?? "No profile picture"
	}
	
	func getNotificationToken() -> String {
		return defaults.string(forKey: NotificationToken)!
	}
	
	
	// MARK: Setters
	func setCustomerName(name: String) {
		defaults.setValue(name, forKey: CustomerName)
	}
	
	func setCustomerEmail(email: String) {
		defaults.setValue(email, forKey: CustomerEmail)
	}
	
	func setCustomerPhoneNumber(number: String) {
		defaults.setValue(number, forKey: CustomerPhoneNumber)
	}
	
	func setUid(uid: String) {
		print("set uid called ->", uid)
		defaults.setValue(uid, forKey: Uid)
	}
	
	func setProfilePUrl(profileUr: String) {
		defaults.setValue(ProfileUrl, forKey: ProfileUrl)
	}
	
	func setNotificationToken(notifToken: String) {
		defaults.setValue(notifToken, forKey: NotificationToken )
	}
	// MARK: Logic Functions
	
	func save_AtLogin_LocalAccountDetails(completion: @escaping (Bool) -> ()) {
		
		networking.getAccountDocument(completion: {(completed, account) in
			self.setFCMToken()
			self.setCustomerName(name: account.name)
			self.setCustomerEmail(email: account.email)
			self.setCustomerPhoneNumber(number: account.phoneNumber)
			self.setProfilePUrl(profileUr: account.profileImageUrl)
			self.setUid(uid: account.uid)
			
			completion(true)
		})
	}
	
	// CONSIDER JUST RE-DOWNLOADING A FRESH PROFILE COPY INSTEAD OF CHECKING FOR DIFFERENCES
	func updateLocalAccountDetails(account: MDStructures.AccountDetails) {
		setFCMToken()
		setCustomerName(name: account.name)
		setCustomerEmail(email: account.email)
		setCustomerPhoneNumber(number: account.phoneNumber)
		setProfilePUrl(profileUr: account.profileImageUrl)
	}
	
	func getAccountDetails(completion: @escaping (Bool) -> ()) {
		networking.getAccountDocument(completion: {(completed, account) in
			
			completion(true)
		})
	}
	
	func getAccount() -> MDStructures.AccountDetails {
		var tempAccount = MDStructures.AccountDetails(name: "", email: "", phoneNumber: "", profileImageUrl: "", profileImage: UIImage(), followersCount: "", totalSaved: "", uid: "")
		
		tempAccount.name = getCustomerName()
		tempAccount.email = getCustomerEmail()
		tempAccount.phoneNumber = getCustomerPhoneNumber()
		tempAccount.profileImageUrl = getProfileUrl()
		tempAccount.uid = getUid()
		return tempAccount
	}
	
	func setFCMToken() {
		
		InstanceID.instanceID().instanceID {(result, error) in
			if let error = error {
				print("Error fetching remote instange ID: \(error)")
			} else if let result = result {
				// Updating the toke in the database for the user
				self.defaults.setValue(result.token, forKey: self.NotificationToken)
				
//				self.userActions.updateUserFCMToken(token: result.token, completion: {_ in})
				
				print("Remote instance ID token: \(result.token)")
			}
		}
	}
}
