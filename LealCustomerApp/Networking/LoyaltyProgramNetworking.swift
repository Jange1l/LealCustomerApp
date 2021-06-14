//
//  LoyaltyProgramNetworking.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/9/21.
//

import Foundation
import Firebase


class LoyaltyProgramNetworking {
	
	let BusinessUsers = "BusinessUsers"
	let UserTools = "Tools"
	let LoyaltyProgram = "LoyaltyProgram"
	let db = Firestore.firestore()
	
	func fetchCurrentLoyaltyProgram(uid: String, completion: @escaping (Bool, MDStructures.LoyaltyProgram) -> ()){
		
		var lp = MDStructures.LoyaltyProgram(businessName: "", numberOfSteps: "", pointsPerStep: "", steps: [MDStructures.LPStep]())
		
		db.collection(BusinessUsers).document(uid).collection(UserTools).document(LoyaltyProgram).getDocument { (document, err) in
			if let err = err {
				print("Error getting documents for user information: \(err)")
				completion(false, lp)
			} else {
				if let document = document, document.exists {
					
					let data = document.data()
					lp.numberOfSteps = data!["numberOfSteps"] as? String
					lp.pointsPerStep = data!["pointsPerStep"] as? String
					
				}
				// Perform actions with data
				
				self.db.collection(self.BusinessUsers).document(uid).collection(self.UserTools).document(LCons.LoyaltyProgram).collection("Steps").getDocuments(completion: {(snap, err) in
					if let err = err {
						print("Error getting documents for user information: \(err)")
						completion(false, lp)
					} else {
						
						for document in snap!.documents {
							//var email = document["email"] as! String
							let stepNumber = document[LCons.lps_stepNumber] as! String
							let requiredPoints = document[LCons.lps_requiredPoints] as! String
							let rewardName = document[LCons.lps_rewardName] as! String
							let rewardDescription = document[LCons.lps_rewardDescription] as! String
							
							let value = document["value"] as! String
							
							let step = MDStructures.LPStep(stepNumber: stepNumber, requiredPoints: requiredPoints, rewardName: rewardName, rewardDescription: rewardDescription, business: "", value: value)
							lp.steps.append(step)
						}
					}
					completion(true, lp)
				})
			}
		}
	}
	
	func fetchCustomerLoyaltyProgramProgress(uid: String, completion: @escaping (Bool, MDStructures.LoyaltyProgramDetails) -> ()) {
		
		var customerLp = MDStructures.LoyaltyProgramDetails(businessName: "", points: "", timesUsed: "", dateJoined: "", currentStep: "", businessUid: "", pointsPerStep: "", numberOfSteps: "")
		
		LCons.AccountDetailsRef.collection("LoyaltyPrograms").document(uid).getDocument(completion: {(document, err) in
			if let err = err {
				print("Error getting documents for business information: \(err)")
				completion(false, customerLp)
			} else {
				if let document = document, document.exists {
					
					let dt = document.data()!
					
					customerLp.businessName = dt["businessName"] as! String
					customerLp.dateJoined = dt["dateJoined"] as! String
					customerLp.timesUsed = dt["timesScanned"] as! String
					customerLp.points = dt["customerPoints"] as! String
					customerLp.currentStep = dt["currentStep"] as! String
					customerLp.businessUid = dt["businessUid"] as! String
					
				}
				completion(true, customerLp)
			}
		})
	}
	
	
	 func fetchAllUpComingRewards(completion: @escaping (Bool, [MDStructures.LoyaltyProgramDetails]) -> ()) {
		
		var upcomingProgress = [MDStructures.LoyaltyProgramDetails]()
		
		LCons.AccountDetailsRef.collection("LoyaltyPrograms").getDocuments(completion: {(snap, err) in
			
			if let err = err {
				print("Error getting documents for user information: \(err)")
				completion(false, upcomingProgress)
			} else {
				
				for document in snap!.documents {
					
					let businessName = document["businessName"] as! String
					let currentStep = document["currentStep"] as! String
					let customerPoints = document["customerPoints"] as! String
					let dateJoined = document["dateJoined"] as! String
					let timesScanned = document["timesScanned"] as! String
					let businessUid = document["businessUid"] as! String
					let pointsPerStep = document["pointsPerStep"] as! String
					let numberOfSteps = document["numberOfSteps"] as! String
					
					let step = MDStructures.LoyaltyProgramDetails(businessName: businessName, points: customerPoints, timesUsed: timesScanned, dateJoined: dateJoined, currentStep: currentStep, businessUid: businessUid, pointsPerStep: pointsPerStep, numberOfSteps: numberOfSteps)
					
					upcomingProgress.append(step)
				}
			}
			completion(true, upcomingProgress)
			
		})
	}
	
	 func fetchUpComingRewardsDetails(programs: [MDStructures.LoyaltyProgramDetails], completion: @escaping (Bool, [MDStructures.LPStep]) -> ()) {
		
		var steps = [MDStructures.LPStep]()
		
		
		if steps.count == 0 {
			completion(false, steps)
		}
		let group = DispatchGroup()
		for p in programs {
			group.enter()
			fetchCurrentLoyaltyProgram(uid: p.businessUid, completion: {(status, program) in
				
				for i in program.steps {
					print(i.stepNumber!, p.currentStep)
					if i.stepNumber == p.currentStep {
						var j = i
						j.business = p.businessName
						steps.append(j)
					}
				}
				group.leave()
			})
		}
		group.notify(queue: .main) {
			completion(true, steps)
		}
	}
	
	func fetchUpComingRewards(completion: @escaping (Bool, [MDStructures.LPStep])->()) {
		fetchAllUpComingRewards(completion: {(status, programs) in
			
			self.fetchUpComingRewardsDetails(programs: programs, completion: {(status, upComingRewards) in
				
				completion(true, upComingRewards)
				
			})
		})
	}
	
	func fetchEarnedRewards(completion: @escaping (Bool, [MDStructures.EarnedReward]) -> ()) {
		
		var earnedRewards = [MDStructures.EarnedReward]()
		
		LCons.AccountDetailsRef.collection("EarnedRewards").getDocuments(completion: {(snap, err) in
			
			if let err = err {
				print("Error getting documents for user information: \(err)")
				completion(false, earnedRewards)
			} else {
				
				for document in snap!.documents {
					
					let rewardNumber = document["rewardNumber"] as! String
					let businessUid = document["businessUid"] as! String
					let rewardId = document["rewardId"] as! String
					let businessName = document["businessName"] as! String
					
					
					let reward = MDStructures.EarnedReward(rewardName: "", businessName: businessName, rewardId: rewardId, rewardNumber: rewardNumber, businessUid: businessUid, value: "")
					
					earnedRewards.append(reward)
				}
			}
			completion(true, earnedRewards)
			
		})
	}
	
	func fetchEarnedRewardsDetails(rewards: [MDStructures.EarnedReward],completion: @escaping (Bool, [MDStructures.EarnedReward]) -> ()) {
		
		var earnedR = [MDStructures.EarnedReward]()
		
		if rewards.count == 0 {
			completion(false, earnedR)
		}
		let group = DispatchGroup()
		for r in rewards {
			group.enter()
			fetchCurrentLoyaltyProgram(uid: r.businessUid, completion: {(status, program) in
				for i in program.steps {
					var modRew = MDStructures.EarnedReward(rewardName: "", businessName: "", rewardId: "", rewardNumber: "", businessUid: "", value: "")
					if i.stepNumber == r.rewardNumber {
						
						modRew.rewardName = i.rewardName
						modRew.businessUid = r.businessUid
						modRew.rewardId = r.rewardId
						modRew.businessName = r.businessName
						modRew.rewardNumber = r.rewardNumber
						modRew.value = i.value
						earnedR.append(modRew)
					}
				}
				
				group.leave()
			})
		}
		group.notify(queue: .main) {
			completion(true, earnedR)
		}
	}
	
}
