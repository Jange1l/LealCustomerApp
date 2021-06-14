//
//  MyCardsTableViewCell.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/20/21.
//

import UIKit

class MyCardsTableViewCell: UITableViewCell {

	
	@IBOutlet weak var hintLabel: UILabel!
	static let name = "MyCardsTableViewCell"
	static let identifier = "MyCards"
	
	@IBOutlet weak var bView: UIView!
	
	@IBOutlet weak var cellTittleLabel: UILabel!
	
	override func prepareForReuse() {
		super.prepareForReuse()
		bView.layer.borderWidth = 0
		hintLabel.text = ""
	}
	override func awakeFromNib() {
        super.awakeFromNib()
		cellTittleLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 26.0)
		bView.layer.cornerRadius = 10
		self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
	}
}
