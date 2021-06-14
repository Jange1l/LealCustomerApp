//
//  HeaderTableViewCell.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/9/21.
//

import UIKit
import Firebase

class HeaderTableViewCell: UITableViewCell {
	
	@IBOutlet weak var businessNameLabel: UILabel!
	@IBOutlet weak var logoImage: UIImageView!
	
	@IBOutlet weak var numberOfPromotionsLabel: UILabel!
	@IBOutlet weak var numberOfFollowersLabel: UILabel!
	
	@IBOutlet weak var followButton: UIButton!
	
	var profile: MDStructures.BusinessAccountDetails!
	let storage = Storage.storage().reference()
	
	var networking = BusinessProfileNetworking()
	
	var clicked: ((_ value: String) -> ())?
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
		setView()
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
	}
	
	func updateCell(profile: MDStructures.BusinessAccountDetails) {
		self.profile = profile
		
		logoImage.image = profile.testImage
		
		businessNameLabel.text = profile.businessName
		//numberOfPromotionsLabel.text = profile.promotionsPostedCount
		numberOfFollowersLabel.text =  profile.followersCount
		isFollowed()
		
	}
	
	
	func isFollowed() {
		if profile.isFollowed {
			self.profile.isFollowed = true
			self.followButton.setTitle("Unfollow", for: .normal)
			self.followButton.setTitleColor(UIColor.red, for: .normal)
			
		} else {
			self.profile.isFollowed = false
			self.followButton.setTitle("Follow", for: .normal)
			self.followButton.setTitleColor(UIColor.link, for: .normal)
		}
	}
	
	func setView() {
		logoImage.layer.cornerRadius = 64
		followButton.layer.borderWidth = 1
		followButton.layer.cornerRadius = 5
		followButton.layer.borderColor = UIColor.link.cgColor
		followButton.layer.borderWidth = 1
		followButton.layer.cornerRadius = 10
		followButton.layer.borderColor = UIColor.link.cgColor
		
	}
	
	@IBAction func followButtonPressed(_ sender: Any) {
		clicked?("follow")
		
		if profile.isFollowed == false {
			// Follow
			profile.isFollowed = true
			followButton.setTitle("Unfollow", for: .normal)
			followButton.setTitleColor(UIColor.red, for: .normal)
			
			followButton.isEnabled = false
			networking.followBusinessWithUid(business: profile, uid: profile.uid, followers: Int(profile.followersCount)!, completion: {(s) in
				self.followButton.isEnabled = true
			})
		} else {
			// Unfollow
			profile.isFollowed = false
			followButton.setTitle("Follow", for: .normal)
			followButton.setTitleColor(UIColor.link, for: .normal)
			
			followButton.isEnabled = false
			networking.unfollowBusinessWithUid(uid: profile.uid, followers: Int(profile.followersCount)!, completion: {(s) in
				self.followButton.isEnabled = true
			})
			
		}
		
	}
	
	
}
