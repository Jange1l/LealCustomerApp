//
//  RewardDescriptionCollectionViewCell.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/26/21.
//

import UIKit

class RewardDescriptionCollectionViewCell: UICollectionViewCell {

	static let name = "RewardDescriptionCollectionViewCell"
	static let identifier = "RewardDescription"
	@IBOutlet weak var rewardName: UILabel!
	
	@IBOutlet weak var rewardDescription: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		self.layer.cornerRadius = 15
    }
	
	func updateCell(step: MDStructures.LPStep) {
		rewardName.text = step.rewardName
		rewardDescription.text = step.rewardDescription
	}

}
