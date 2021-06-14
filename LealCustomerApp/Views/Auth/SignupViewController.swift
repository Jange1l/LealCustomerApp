//
//  SignupViewController.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/2/21.
//

import UIKit
import Firebase

class SignupViewController: UIViewController, UITextFieldDelegate {
	
	@IBOutlet weak var signUpButton: UIView!
	
	@IBOutlet weak var nameTextField: UITextField!
	@IBOutlet weak var lastNameTextField: UITextField!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var confirmPasswordTextField: UITextField!
	
	
	var currentTextField: UITextField!
	var accountDetails: AccountDetails!
	//	var lt_program: LoyaltyProgramNetworking!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		overrideUserInterfaceStyle = .dark
		accountDetails = AccountDetails()
		setView()
	}
	
	
	func setView() {
		signUpButton.layer.cornerRadius = 30
		let toolbar = UIToolbar()
		toolbar.sizeToFit()
		let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.doneClicked))
		
		toolbar.setItems([doneButton], animated: false)
		nameTextField.inputAccessoryView = toolbar
		lastNameTextField.inputAccessoryView = toolbar
		emailTextField.inputAccessoryView = toolbar
		passwordTextField.inputAccessoryView = toolbar
		confirmPasswordTextField.inputAccessoryView = toolbar
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
		
		nameTextField.delegate = self
		emailTextField.delegate = self
		passwordTextField.delegate = self
		confirmPasswordTextField.delegate = self
	}
	
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		currentTextField = textField
		return true
	}
	
	@objc func keyboardWillShow(notification: NSNotification) {
		
		if currentTextField == confirmPasswordTextField || currentTextField == passwordTextField || currentTextField == emailTextField {
			if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
				if self.view.frame.origin.y == 0 {
					self.view.frame.origin.y -= keyboardSize.height - 59
				}
			}
		}
	}
	
	@objc func keyboardWillHide(notification: NSNotification) {
		if self.view.frame.origin.y != 0 {
			self.view.frame.origin.y = 0
		}
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	@objc func doneClicked() {
		view.endEditing(true)
	}
	
	func showError(_ message:String) {
		let alert = UIAlertController(title: "Oops", message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
			NSLog("The \"OK\" alert occured.")
		}))
		self.present(alert, animated: true, completion: nil)
	}
	
	func validateFields() -> String? {
		// Check that all the fields are filled in
		if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
			return "Please fill in all text fields"
		}
		
		// Check that the password is valid and equal
		let trimmedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
		if Utilities.isPasswordValid(trimmedPassword) == false {
			return "Please make sure your password has at least 5 characters, contains at least one special character and contains at least one number"
		}
		
		if passwordTextField.text != confirmPasswordTextField.text {
			return "Please make sure the passwords match"
		}
		
		return nil
	}
	
	func logUserIn() {
		// Create cleaned versions of the text field
		let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
		let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
		
		// Signing in the user
		Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
			
			if error != nil {
				//                // Couldn't sign in
				//                self.errorLabel.text = error!.localizedDescription
				//                self.errorLabel.alpha = 1
				let alert = UIAlertController(title: "Error", message: error!.localizedDescription, preferredStyle: .alert)
				alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
					NSLog("The \"OK\" alert occured.")
				}))
				self.present(alert, animated: true, completion: nil)
			}
			else {
				print("Log In was successful")
				//Transition to other view controller
				
				let homeViewController = self.storyboard?.instantiateViewController(identifier: "HomeVC") as? UITabBarController
				
				self.view.window?.rootViewController = homeViewController
				self.view.window?.makeKeyAndVisible()
			}
		}
	}
	
	
	@IBAction func signUpButtonPressed(_ sender: Any) {
		
		// Validate all fields
		let error = validateFields()
		
		if error != nil {
			showError(error!)
		} else {
			
			let customerName = "\(nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)) \(lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines))"
			let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
			let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
			
			// Create the user
			Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
				
				// Check for errors
				if err != nil {
					
					// There was an error creating the user
					self.showError("Error creating user")
				}
				else {
					
					// User was created successfully, now store the first name and last name
					let db = Firestore.firestore()
					
					let userRef = db.collection("CustomerUsers").document(result!.user.uid)
					userRef.setData([
						
						LCons.f_cName: "\(self.nameTextField.text!) \(self.lastNameTextField.text!)",
						LCons.f_cEmail: self.emailTextField.text!,
						LCons.f_cPhoneNumber: "",
						LCons.f_cProfileUrl: "",
						LCons.f_cUid: Auth.auth().currentUser!.uid as String,
						"FollowingCount" : "0",
						"TotalSaved" : "0"
					]) { err in
						if let err = err {
							print("Error writing document: \(err)")
						} else {
							print("Document successfully written!")
							
							
							// Save all Account data locally
							self.accountDetails.setCustomerName(name: customerName)
							self.accountDetails.setCustomerEmail(email: email)
							self.accountDetails.setUid(uid: Auth.auth().currentUser!.uid as String)
							self.accountDetails.setFCMToken()
							
						}
					}
					
					
					
					// Transition to the home screen
					self.logUserIn()
				}
				
				
			}
		}
	}
	
	
}
