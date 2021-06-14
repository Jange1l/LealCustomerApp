//
//  LoyaltyProgramManager.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/9/21.
//

import Foundation

class LoyaltyProgramManager {
	
	
	private var defaults: AccountDetails!
	private var networking: LoyaltyProgramNetworking!
	
	var lp: MDStructures.LoyaltyProgram!
	
	init() {
		lp = MDStructures.LoyaltyProgram(businessName: "", numberOfSteps:" ", pointsPerStep: "", steps: [MDStructures.LPStep]())
		
		self.lp.businessName = ""
		self.lp.numberOfSteps = "0"
		self.lp.pointsPerStep = "0"
		self.lp.steps = [MDStructures.LPStep]()
		
		defaults = AccountDetails()
		networking = LoyaltyProgramNetworking()
	}
	
	private init(businessName: String, numberOfSteps: String, pointsPerStep: String, steps:[MDStructures.LPStep]) {
		defaults = AccountDetails()
		networking = LoyaltyProgramNetworking()
		
		self.lp = MDStructures.LoyaltyProgram(businessName: businessName, numberOfSteps:numberOfSteps, pointsPerStep: pointsPerStep, steps: steps)
		

	}
	
	

	func getCurrentLoyaltyProgram(uid: String,completion: @escaping (Bool, LoyaltyProgramManager) -> ()) {
		
		networking.fetchCurrentLoyaltyProgram(uid: uid, completion: {(completed, program) in
			
			let lpm = LoyaltyProgramManager(businessName: program.businessName, numberOfSteps: program.numberOfSteps, pointsPerStep: program.pointsPerStep, steps: program.steps)
			
			self.lp = lpm.lp
			
			completion(completed, lpm)
		})
	}
	
	func getCustomerLoyaltyProgramProgress(uid: String, completion: @escaping (Bool, MDStructures.LoyaltyProgramDetails) -> ()) {
		networking.fetchCustomerLoyaltyProgramProgress(uid: uid, completion: {(status, customerLp) in
			
			completion(status, customerLp)
		})
	}
	
	
}
