//
//  LealConstants.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/2/21.
//

import Foundation
import Firebase

struct LCons {
	static let uid = Auth.auth().currentUser!.uid
	// Account Fields
	static let f_cName = "Name"
	static let f_cEmail = "Email"
	static let f_cPhoneNumber = "PhoneNumber"
	static let f_cProfileUrl = "ProfileUrl"
	static let f_cUid = "Uid"
	
	// Account fields
	static let f_bName = "BusinessName"
	static let f_bEmail = "Email"
	static let f_bUsername = "Username"
	static let f_bUid = "Uid"
	static let f_bProfileImageURL = "ProfileUrl"
	static let f_bPhoneNumber = "PhoneNumber"
	static let f_bBusinessType = "BusinessType"
	static let f_bBusinessBio = "BusinessBio"
	static let f_bPromotionsPostedCount = "PromotionsPostedCount"
	static let f_bFollowersCount = "FollowerCount"
	
	// Collections
	static let CustomerUsers = "CustomerUsers"
	static let Locations = "Locations"
	static let BusinessUsers = "BusinessUsers"
	static let UserTools = "Tools"
	static let LoyaltyProgram = "LoyaltyProgram"
	static let CreatePromotion = "CreatePromotion"
	static let Followers = "Followers"
	
	// Loyalty Program Fields
	static let lt_numberOfSteps = "numberOfSteps"
	static let lt_pointsPerStep = "pointsPerStep"
	static let lt_Steps = "Steps"
	// LTP Step Fields
	static let lps_stepNumber = "step_number"
	static let lps_requiredPoints = "required_points"
	static let lps_rewardName = "reward_name"
	static let lps_rewardDescription = "reward_description"
	
	// DB References
	static let db = Firestore.firestore()
	static let AccountDetailsRef = db.collection(CustomerUsers).document(uid)
	static let UserWallet = db.collection(CustomerUsers).document(uid).collection("Wallet")
	
	static let BusinessAccountDetailsRef = db.collection(BusinessUsers)
	static let LocationRef = db.collection(Locations)
	
	static let DiscountsRef = db.collection("Discounts")
	static let BundlesRef = db.collection("Bundles")
	static let AnnouncementsRef = db.collection("Announcements")
	
	
	static let tool_LoyaltyProgram = db.collection(BusinessUsers).document(uid).collection(UserTools).document(LoyaltyProgram)
	
	
}
