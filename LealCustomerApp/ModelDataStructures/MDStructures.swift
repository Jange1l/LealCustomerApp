//
//  MDStructures.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/2/21.
//

import Foundation
import UIKit

struct MDStructures {
	struct AccountDetails: Equatable {
		var name: String
		var email: String
		var phoneNumber: String
		var profileImageUrl: String
		var profileImage: UIImage
		var followersCount: String
		var totalSaved: String
		var uid: String
	}
	
	struct LoyaltyProgramDetails {
		var businessName: String
		var points: String
		var timesUsed: String
		var dateJoined: String
		var currentStep: String
		var businessUid: String
		var pointsPerStep: String
		var numberOfSteps: String
	}
	
	struct BusinessAccountDetails {
		var businessName: String
		var businessEmail: String
		var businessPhoneNumber: String
		var profileImageUrl: String
		var businessType: String
		var businessBio: String
		var promotionsPostedCount: String
		var followersCount: String
		
		var testImage: UIImage
		var isFollowed: Bool
		
		var uid: String
	}
	
	struct LPStep: Equatable {
		var stepNumber: String!
		var requiredPoints: String!
		var rewardName: String!
		var rewardDescription: String!
		var business: String
		var value: String
	}
	
	struct LoyaltyProgram {
		var businessName: String!
		var numberOfSteps: String!
		var pointsPerStep: String!
		var steps: [LPStep]
	}
	
	struct EarnedReward: Equatable {
		var rewardName: String
		var businessName: String
		var rewardId: String
		var rewardNumber: String
		var businessUid: String
		var value: String
	}
	
	struct Discount {
		var businessName: String
		var discount: String
		var timeReleased: String
		var duration: String
		var endDate: String
		var description: String
		var quantity: String
		var profileUrl: String
		var profileImage: UIImage
		var uid: String
		var postUid: String
		var type: String
	}
	
	struct Bundle {
		var businessName: String
		var discount: String
		var timeReleased: String
		var duration: String
		var endDate: String
		var description: String
		var quantity: String
		var profileUrl: String
		var profileImage: UIImage
		var uid: String
		var postUid: String
		var type: String
	}
	
	struct Announcement {
		var businessName: String
		var message: String
		var timeReleased: String
		var profileUrl: String
		var profileImage: UIImage
		var uid: String
		var postUid: String
	}
	
	struct AnnouncementWithDate {
		var businessName: String
		var message: String
		var timeReleased: Date
		var profileUrl: String
		var profileImage: UIImage
		var uid: String
		var postUid: String
	}
	
}
