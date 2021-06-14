//
//  SettingsTableViewCell.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 3/16/21.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

	static let name = "SettingsTableViewCell"
	static let identifier = "SettingsCell"
	
	
	@IBOutlet weak var firstNameTextField: UITextField!
	@IBOutlet weak var lastNameTextField: UITextField!
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var phoneNumberTextField: UITextField!
	
	var signout: ((_ value: String) -> ())?
	var save: ((_ value: MDStructures.AccountDetails) -> ())?
	
	
	var profile: MDStructures.AccountDetails!
	
	override func awakeFromNib() {
        super.awakeFromNib()
		selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
	
	func updateCell(x: MDStructures.AccountDetails) {
		profile = x
		let first = x.name.components(separatedBy: " ")[0]
		let last = x.name.components(separatedBy: " ")[1]
		firstNameTextField.text = first
		lastNameTextField.text = last
		emailTextField.text = profile.email
		phoneNumberTextField.text = profile.phoneNumber
	}
    
	@IBAction func signoutPressed(_ sender: Any) {
		signout?("SIGNOUT")
		
	}
	@IBAction func saveButtonPressed(_ sender: Any) {
		
		profile.name = "\(firstNameTextField.text!) \(lastNameTextField.text!)"
		profile.email = "\(emailTextField.text ?? "")"
		profile.phoneNumber = "\(phoneNumberTextField.text ?? "")"
		
		save?(profile)
	}
	
	
}
