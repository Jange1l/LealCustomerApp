//
//  InitialViewController.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/2/21.
//

import UIKit
import Firebase

class InitialViewController: UIViewController {

	
	@IBOutlet weak var loginButton: UIButton!
	
	@IBOutlet weak var signupButton: UIButton!
	
	var networking: AccountDetailsNetworking!
	
	override func viewDidLoad() {
        super.viewDidLoad()
//		networking = AccountDetailsNetworking()
//		networking.signOut(completion: {(status) in
//			self.setUpUi()
//		})
		overrideUserInterfaceStyle = .dark
		setUpUi()
        
    }
	override func viewDidAppear(_ animated: Bool) {
		authenticateUser()
	}
	func setUpUi() {
		signupButton.layer.cornerRadius = 10
		
		loginButton.layer.borderWidth = 1
		loginButton.layer.borderColor = UIColor.systemPurple.cgColor
		loginButton.layer.cornerRadius = 10
	}
	
	func authenticateUser() {
		if Auth.auth().currentUser == nil {
			
		} else {
			let home = self.storyboard?.instantiateViewController(identifier: "HomeVC") as? UITabBarController
			
			self.view.window?.rootViewController = home
			self.view.window?.makeKeyAndVisible()
		}
	}
    

}
