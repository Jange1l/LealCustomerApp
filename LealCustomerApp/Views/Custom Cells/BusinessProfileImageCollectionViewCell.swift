//
//  BusinessProfileImageCollectionViewCell.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/18/21.
//

import UIKit
import Firebase


class BusinessProfileImageCollectionViewCell: UICollectionViewCell {
	
	static let name = "BusinessProfileImageCollectionViewCell"
	static let identifier = "BusinessProfileCell"
	@IBOutlet weak var image: UIImageView!
	
	var bAccount: MDStructures.BusinessAccountDetails!
	let storage = Storage.storage().reference()
	
	override func awakeFromNib() {
		super.awakeFromNib()
		image.layer.borderWidth = 1
		image.layer.borderColor = UIColor.white.cgColor
		image.layer.cornerRadius = 50
	}
	
	func upDateCell(b: MDStructures.BusinessAccountDetails) {
		self.bAccount = b
		image.image = b.testImage
		//setPicture()
	}
	
	func setPicture() {
		if bAccount.profileImageUrl != nil {
			// Download image
			let storage = Storage.storage().reference()
			let profileImagesRef = storage.child("ProfileImages")
			let p = profileImagesRef.child(bAccount.uid)
			
			p.getData(maxSize: 1 * 1024 * 1024) { data, error in
				if let error = error {
					// Uh-oh, an error occurred!
				} else {
					
					let image = UIImage(data: data!)
					self.image.image = image
					
				}
			}
		} else {
			// Set default profile with no picture
			
		}
		
	}
	
}
