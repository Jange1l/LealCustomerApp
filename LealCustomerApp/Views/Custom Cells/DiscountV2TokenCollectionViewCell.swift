//
//  DiscountV2TokenCollectionViewCell.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/21/21.
//

import UIKit

class DiscountV2TokenCollectionViewCell: UICollectionViewCell {

	
	static let name = "DiscountV2TokenCollectionViewCell"
	static let identifier = "DiscountTokenV2"
	
	
	
	@IBOutlet weak var bView: UIView!
	
	@IBOutlet weak var logoImage: UIImageView!
	@IBOutlet weak var bName: UILabel!
	@IBOutlet weak var discount: UILabel!
	@IBOutlet weak var duration: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	
	@IBOutlet weak var mainBGV: UIView!
	
	var isDone: Bool!
	
	override func awakeFromNib() {
        super.awakeFromNib()
		self.layer.shadowColor = UIColor.gray.cgColor
		self.layer.shadowOffset = .zero
		self.layer.shadowRadius = 6
		self.layer.shadowOpacity = 0.35
		self.layer.masksToBounds = false
		mainBGV.layer.cornerRadius = 10
		bView.layer.cornerRadius = 40
		logoImage.layer.cornerRadius = 40
		
    }

	override func prepareForReuse() {
		super.prepareForReuse()
		
		logoImage.image = nil
		bName.text = nil
		discount.text = nil
		duration.text = nil
		duration.textColor = nil
		isDone = false
	}
	
	func updateCell(x: MDStructures.Discount) {
		isDone = false
		let tokens = x.businessName.components(separatedBy: " ")
		if tokens.count >= 2 {
			bName.text = "\(tokens[0]) \(tokens[1])"
		} else {
			bName.text = x.businessName
		}
		discount.text = x.discount
		duration.text = getTimeLeft(endDate: x.endDate)
		logoImage.image = x.profileImage
		descriptionLabel.text = x.description
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
			duration.textColor = UIColor.systemTeal
			var days = Double(hours!) / 24
			
			days.round()
			return "\(Int(days)) Days"
		}
	
		if hours! > 0 && hours! < 24 {
			duration.textColor = UIColor.systemTeal
			if hours == 1 {
				duration.textColor = UIColor.systemTeal
				return "1 hour"
			}
			return "\(hours!) Hours"
		}
		
		if hours! < 0 && minutes! < 0 {
			duration.textColor = UIColor.yellow
			isDone = true
			return "Expired"
		}
		
		
		duration.textColor = UIColor.systemTeal
		return "\(hours!) Hours"
	}
}
