//
//  DiscountTokenCollectionViewCell.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/18/21.
//

import UIKit

class DiscountTokenCollectionViewCell: UICollectionViewCell {

	@IBOutlet weak var token: UIView!
	
	@IBOutlet weak var bTitle: UILabel!
	@IBOutlet weak var bView: UIView!
	@IBOutlet weak var duration: UILabel!
	
	@IBOutlet weak var discountLabel: UILabel!
	
	var data: MDStructures.Discount!
		
	var isDone: Bool!
	
	override func awakeFromNib() {
        super.awakeFromNib()
		
		//token.color = UIColor.white
		
		bView.layer.borderWidth = 1
		bView.layer.borderColor = UIColor.white.cgColor
		bView.layer.cornerRadius = 50
		token.layer.cornerRadius = 125/2
		
    }
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
		data = nil
		discountLabel.text = nil
		duration.textColor = nil
		duration.text = nil
		bTitle.text = nil
		
		//token = CircularText()
	}
	
	func updateCell(x: MDStructures.Discount) {
		
		isDone = false
		data = x
		let tokens = x.businessName.components(separatedBy: " ")
		if tokens.count >= 2 {
			bTitle.text = "\(tokens[0]) \(tokens[1])"
		} else {
			bTitle.text = x.businessName
		}
		
		discountLabel.text = x.discount
		duration.text = getTimeLeft(endDate: x.endDate)
		
		
		//token.date = getTimeLeft(endDate: x.endDate)
		
	}
	
	func getTimeLeft(endDate: String) -> String{
		let form = DateFormatter()
		form.timeStyle = .short
		form.dateStyle = .short
		
		let date = Date()
		
		let timeReleased = form.string(from: date)
		
		let endD = form.date(from: endDate)
		
		
		let diffComponents = Calendar.current.dateComponents([.hour, .minute], from: date, to: endD ?? date)
		
		let hours = diffComponents.hour
		let minutes = diffComponents.minute
		
		
		if hours! > 24 {
			duration.textColor = UIColor.systemTeal
			var days = Double(hours!) / 24
			print("HOUS AND DAYS DISCOUNT TOKEN -> ",hours, days)
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
