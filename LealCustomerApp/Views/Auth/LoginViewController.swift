//
//  LoginViewController.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/2/21.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {

	@IBOutlet weak var loginButton: UIView!
	@IBOutlet weak var emailTextField: UITextField!
	
	@IBOutlet weak var passwordTextField: UITextField!
	
	var accountDetails: AccountDetails!
	override func viewDidLoad() {
        super.viewDidLoad()
		overrideUserInterfaceStyle = .dark
		accountDetails = AccountDetails()
        setView()
    }
    

	func setView() {
		loginButton.layer.cornerRadius = 30
		let toolbar = UIToolbar()
		toolbar.sizeToFit()
		let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
		
		toolbar.setItems([doneButton], animated: false)
		emailTextField.inputAccessoryView = toolbar
		passwordTextField.inputAccessoryView = toolbar
		
	}
	@objc func doneClicked() {
		view.endEditing(true)
	}
	
	func logUserIn() {
		// Create cleaned versions of the text field
		let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
		let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
		
		// Signing in the user
		Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
			
			if error != nil {
				
				let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
					NSLog("The \"OK\" alert occured.")
				}))
				self.present(alert, animated: true, completion: nil)
			}
			else {
				print("Log In was successful")
				
				// Set user default Account Details
				
				
				self.accountDetails.save_AtLogin_LocalAccountDetails(completion: {(completed) in

					//Transition to other view controller
					let homeViewController = self.storyboard?.instantiateViewController(identifier: "HomeVC") as? UITabBarController

					self.view.window?.rootViewController = homeViewController
					self.view.window?.makeKeyAndVisible()
				})
				
			}
		}
	}
	
	
	@IBAction func loginButtonPressed(_ sender: Any) {
		logUserIn()
	}
	
}
