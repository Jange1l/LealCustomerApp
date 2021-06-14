//
//  ContactAndLocationTableViewCell.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/10/21.
//

import UIKit

class ContactAndLocationTableViewCell: UITableViewCell {

	
	@IBOutlet weak var callNowButton: UIButton!
	@IBOutlet weak var sendEmailButton: UIButton!
	@IBOutlet weak var seeOnMapButton: UIButton!
	
	var profile: MDStructures.BusinessAccountDetails!
	var phoneNumber: String!
	
	var mapClicked: ((_ value: String) -> ())?
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
	func updateCell(profile: MDStructures.BusinessAccountDetails) {
		self.profile = profile
		seeOnMapButton.layer.cornerRadius = 15
		self.phoneNumber = profile.businessPhoneNumber
	}
	
	
	@IBAction func callButtonPressed(_ sender: Any) {
		
		callNumber(phoneNumber: phoneNumber)
	}
	
	private func callNumber(phoneNumber:String) {
	  if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
		print("phone works?", phoneCallURL)
		let application:UIApplication = UIApplication.shared
		if (application.canOpenURL(phoneCallURL)) {
			application.open(phoneCallURL, options: [:], completionHandler: nil)
		}
	  }
		
	}
	
	@IBAction func seeOnMap(_ sender: Any) {
		mapClicked?("True")
	}
	
	
}
