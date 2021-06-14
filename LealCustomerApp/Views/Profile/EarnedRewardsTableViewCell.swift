//
//  EarnedRewardsTableViewCell.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/28/21.
//

import UIKit

protocol EarnedRewardCellDelegate: class {
	func collectionView(collectionviewcell: RewardCollectionViewCell?, index: Int, didTappedInTableViewCell: EarnedRewardsTableViewCell)
}
class EarnedRewardsTableViewCell: UITableViewCell {
	
	static let name = "EarnedRewardsTableViewCell"
	static let identifier = "EarnedRewards"
	
	weak var cellDelegate: EarnedRewardCellDelegate?
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	var earnedRewards: [MDStructures.EarnedReward]!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.selectionStyle = .none
		setCollectionView()
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
	func setCollectionView() {
		backgroundColor = UIColor.clear
		
		
		// TODO: need to setup collection view flow layout
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .horizontal
		flowLayout.itemSize = CGSize(width: 160, height: 160)
		flowLayout.minimumLineSpacing = 5.0
		flowLayout.minimumInteritemSpacing = 10.0
		self.collectionView.collectionViewLayout = flowLayout
		self.collectionView.showsHorizontalScrollIndicator = false
		
		// Comment if you set Datasource and delegate in .xib
		self.collectionView.dataSource = self
		self.collectionView.delegate = self
		
		// Register the xib for collection view cell
		let cellNib = UINib(nibName: "RewardCollectionViewCell", bundle: nil)
		self.collectionView.register(cellNib, forCellWithReuseIdentifier: "RewardCell")
	}
	
	func updateCell(x: [MDStructures.EarnedReward]) {
		earnedRewards = x
		collectionView.reloadData()
	}
}
extension EarnedRewardsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if earnedRewards != nil {
			return earnedRewards.count
		}
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RewardCell", for: indexPath) as? RewardCollectionViewCell {
			
			if earnedRewards != nil {
				cell.rewardName.text = earnedRewards[indexPath.row].rewardName
				cell.businessName.text = earnedRewards[indexPath.row].businessName
				cell.earnedRewardInfo = earnedRewards[indexPath.row]
				
				cell.circularProgress.progressClr = UIColor.systemTeal
				cell.percent = 1.0
				cell.circularProgress.setProgressWithAnimation(duration: 1, value: 1.0)
				
				
			}
			
			cell.percent = 0
			
			return cell
		}
		return UICollectionViewCell()
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let cell = collectionView.cellForItem(at: indexPath) as? RewardCollectionViewCell
		
		print("Cell tapped \(indexPath.item)")
		self.cellDelegate?.collectionView(collectionviewcell: cell, index: indexPath.item, didTappedInTableViewCell: self)
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	// Add spaces at the beginning and the end of the collection view
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
	}
}

