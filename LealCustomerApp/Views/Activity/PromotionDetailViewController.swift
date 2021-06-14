//
//  PromotionDetailViewController.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 3/1/21.
//

import UIKit

class PromotionDetailViewController: UIViewController {
	
	@IBOutlet weak var businessLogo: UIImageView!
	@IBOutlet weak var bName: UILabel!
	@IBOutlet weak var releasedDate: UILabel!
	@IBOutlet weak var quantity: UILabel!
	@IBOutlet weak var discount: UILabel!
	
	@IBOutlet weak var activity: UIActivityIndicatorView!
	@IBOutlet weak var saveButton: UIButton!
	
	@IBOutlet weak var descriptionLabel: UILabel!
	
	@IBOutlet weak var stack: UIStackView!
	
	
	var tappedPromotion: MDStructures.Discount!
	var networking : PromotionNetworking!
	var saved: Bool!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		overrideUserInterfaceStyle = .dark
		activity.startAnimating()
		networking = PromotionNetworking()
		
		businessLogo.image = tappedPromotion.profileImage
		businessLogo.layer.cornerRadius = 60
		bName.text = tappedPromotion.businessName
		releasedDate.text = "Duration: \(getTimeLeft(endDate: tappedPromotion.endDate))"
		quantity.text = "Quantity: \(tappedPromotion.quantity)"
		discount.text = "Promotion: \(tappedPromotion.discount)"
		descriptionLabel.text = tappedPromotion.description
		
		//descriptionLabel.layer.borderWidth = 1.5
		//descriptionLabel.layer.borderColor = UIColor.secondarySystemBackground.cgColor
		
		stack.layer.borderWidth = 1.5
		stack.layer.borderColor = UIColor.tertiarySystemBackground.cgColor
		networking.checkIfSaved(postUid: tappedPromotion.postUid, completion: {(isSaved) in
			self.saved = isSaved
			
			if isSaved == true{
				
				self.saveButton.setTitle("Already Saved!", for: .normal)
				self.saveButton.setTitleColor(UIColor.systemPurple, for: .normal)
				self.saveButton.isEnabled = false
				
			} else {
				
			}
			self.activity.stopAnimating()
			self.activity.isHidden = true
		})
	}
	
	func getTimeLeft(endDate: String) -> String{
		let form = DateFormatter()
		form.timeStyle = .short
		form.dateStyle = .short
		
		let date = Date()
		
		
		
		let endD = form.date(from: endDate)
		
		
		let diffComponents = Calendar.current.dateComponents([.hour, .minute], from: date, to: endD ?? date)
		
		let hours = diffComponents.hour
		let minutes = diffComponents.minute
		
		if hours! > 24 {
			var days = Double(hours!) / 24
			days.round()
			return "\(Int(days)) Days"
		}
		
		if hours! > 0 && hours! < 24 {
			if hours == 1 {
				return "1 hour"
			}
			return "\(hours!) Hours"
		}
		if hours! < 0 && minutes! < 0 {
			return "Expired"
		}
		return "\(hours!) Hours"
	}
	
	@IBAction func addToWalletPressed(_ sender: Any) {
		
		if !saved {
			networking.savePromotion(postUid: tappedPromotion.postUid, post: tappedPromotion)
			saveButton.setTitle("Already Saved!", for: .normal)
			saveButton.setTitleColor(UIColor.systemPurple, for: .normal)
			saveButton.isEnabled = false
		}
	}
	
	
}
