//
//  AnnouncementExpandedViewController.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 3/9/21.
//

import UIKit

class AnnouncementExpandedViewController: UIViewController {

	@IBOutlet weak var message: UILabel!
	@IBOutlet weak var businessName: UILabel!
	@IBOutlet weak var logoImage: UIImageView!
	
	@IBOutlet weak var date: UILabel!
	var announcement: MDStructures.Announcement!
	
	override func viewDidLoad() {
        super.viewDidLoad()

		logoImage.layer.cornerRadius = 60
		message.text = announcement.message
		logoImage.image = announcement.profileImage
		businessName.text = announcement.businessName
		date.text = announcement.timeReleased
    }
    

}
