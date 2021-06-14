//
//  ActivityHeaderTableViewCell.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/18/21.
//

import UIKit

class ActivityHeaderTableViewCell: UITableViewCell {

	@IBOutlet weak var category1: UIView!
	@IBOutlet weak var category2: UIView!
	@IBOutlet weak var category3: UIView!
	@IBOutlet weak var category4: UIView!
	
	
	
	override func awakeFromNib() {
        super.awakeFromNib()
        setView()
		self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	
	func setView() {
		category1.layer.cornerRadius = 10
		category2.layer.cornerRadius = 10
		category3.layer.cornerRadius = 10
		category4.layer.cornerRadius = 10
		
		category4.layer.borderWidth = 1
		category4.layer.borderColor = UIColor.white.cgColor
	}
    
}
