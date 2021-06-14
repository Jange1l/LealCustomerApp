//
//  Utilities.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/2/21.
//

import Foundation


class Utilities {
	
	static func isPasswordValid(_ password : String) -> Bool {
		
		let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{5,}")
		return passwordTest.evaluate(with: password)
	}
}
