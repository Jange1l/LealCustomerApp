//
//  TotalSavedTableViewCell.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/18/21.
//

import UIKit

class TotalSavedTableViewCell: UITableViewCell {
	
	static let name = "TotalSavedTableViewCell"
	static let identifier = "TotalSavedCell"
	
	@IBOutlet weak var savedAmountLabel: UILabel!
	@IBOutlet weak var bView: UIView!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		self.selectionStyle = .none
		bView.layer.cornerRadius = 10
		bView.layer.borderWidth = 1
		bView.layer.borderColor = UIColor.systemGray6.cgColor
		
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func updateCell(x: MDStructures.AccountDetails) {
		savedAmountLabel.text = "$\(x.totalSaved)"
	}
    
}
