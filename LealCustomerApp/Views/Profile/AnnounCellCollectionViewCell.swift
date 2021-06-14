//
//  AnnounCellCollectionViewCell.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/10/21.
//

import UIKit

class AnnounCellCollectionViewCell: UICollectionViewCell {

	@IBOutlet weak var bView: UIView!
	@IBOutlet weak var announcementText: UILabel!
	@IBOutlet weak var businessName: UILabel!
	@IBOutlet weak var logoImage: UIImageView!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		setView()
    }
	
	func setView() {
		bView.layer.cornerRadius = 10
		bView.layer.borderWidth = 1
		bView.layer.borderColor = UIColor.systemGray.cgColor
		logoImage.layer.cornerRadius = 30
		
		self.layer.shadowColor = UIColor.systemGray.cgColor
		self.layer.shadowOffset = CGSize(width: 5, height: 5)
		self.layer.shadowRadius = 3
		self.layer.shadowOpacity = 0.2
		self.layer.masksToBounds = false
	}
	
	func updateCell(x: MDStructures.Announcement) {
		businessName.text = x.businessName
		announcementText.text = x.message
		logoImage.image = x.profileImage
	}

}
