//
//  SettingsViewController.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/25/21.
//

import UIKit

class SettingsViewController: UIViewController {

	var networking: AccountDetailsNetworking!
	var profile: MDStructures.AccountDetails!
	var updateProfile: MDStructures.AccountDetails!
	var accountDetails: AccountDetails!
	
	@IBOutlet weak var tableView: UITableView!
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		overrideUserInterfaceStyle = .dark
		networking = AccountDetailsNetworking()
		accountDetails = AccountDetails()
		setNibs()
		getData()
    }
    

	func setNibs() {
		let header = UINib(nibName: SettingsTableViewCell.name, bundle: nil)
		self.tableView.register(header, forCellReuseIdentifier: SettingsTableViewCell.identifier)
	}
	
	func getData() {
		// get accoutn data and display current info
		networking.getAccountDocument(completion: {(s, account) in
			self.profile = account
			
			self.tableView.reloadData()
		})
	}
	
	func saveChanges(x: MDStructures.AccountDetails) {
		//print("SAVE CHAGES TRIGGERED", x, profile)
		if x != profile! {
			// save changes
			let alert = UIAlertController(title: "Wait", message: "Are you sure you want to save the changes", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .cancel, handler: { _ in
				
			}))
			
			alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
				
				let generator = UIImpactFeedbackGenerator(style: .heavy)
				generator.impactOccurred()
				// network call to save changes in database
				self.networking.updateAccountDetails(account: x)
				// save changes locally
				self.accountDetails.updateLocalAccountDetails(account: x)
			}))
			
			self.present(alert, animated: true, completion: nil)
		} else {
			// show error -> nothing to change
			let alert = UIAlertController(title: "Hey", message: "It looks like there is nothing to change", preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
				NSLog("The \"OK\" alert occured.")
				let generator = UIImpactFeedbackGenerator(style: .heavy)
				generator.impactOccurred()
			}))
			self.present(alert, animated: true, completion: nil)
		}
	}
	
}
extension SettingsViewController:  UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier) as? SettingsTableViewCell {
			
			if profile != nil {
				cell.updateCell(x: profile)
			}
			
			cell.signout = {
				value in
				self.networking.signOut(completion: {(status) in })
			}
			cell.save = {
				value in
				self.saveChanges(x: value)
			}
			
			return cell
		}
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 400
	}
	
	
}
