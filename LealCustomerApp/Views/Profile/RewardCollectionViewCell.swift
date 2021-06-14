//
//  RewardCollectionViewCell.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/10/21.
//

import UIKit

class RewardCollectionViewCell: UICollectionViewCell {
	
	@IBOutlet weak var circularProgress: CircularProgressView!
	@IBOutlet weak var businessName: UILabel!
	@IBOutlet weak var rewardName: UILabel!
	var percent: Float!
	
	var earnedRewardInfo: MDStructures.EarnedReward!
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
		
		circularProgress.trackClr = UIColor.darkGray
		circularProgress.progressClr  = UIColor.green
		
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		circularProgress.setProgressWithAnimation(duration: 0, value: percent)
	}
	
	
}
