//
//  UPComingRewardsTableViewCell.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/10/21.
//

import UIKit

class UPComingRewardsTableViewCell: UITableViewCell {
	
	
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var subCategoryLabel: UILabel!
	
	var upComingRewards: [(MDStructures.LPStep,MDStructures.LoyaltyProgramDetails)]!
	var myPrograms: [MDStructures.LoyaltyProgramDetails]!
	
	override func prepareForReuse() {
		super.prepareForReuse()
		
	}
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
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
	
	func updateCell(steps: [MDStructures.LPStep], myPrograms: [MDStructures.LoyaltyProgramDetails]) {
		upComingRewards = [(MDStructures.LPStep,MDStructures.LoyaltyProgramDetails)]()
		for i in myPrograms {
			for j in steps {
				if i.businessName == j.business {
					let pair = (j,i)
					upComingRewards.append(pair)
				}
			}
		}
		collectionView.reloadData()
	}
}

extension UPComingRewardsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if upComingRewards != nil {
			return upComingRewards.count
		}
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RewardCell", for: indexPath) as? RewardCollectionViewCell {
			
			if upComingRewards != nil {
				let x = upComingRewards[indexPath.row]
				let nameParts = x.0.business.components(separatedBy: " ")
				cell.rewardName.text = x.0.rewardName
				if nameParts.count >= 2 {
					cell.businessName.text = "\(nameParts[0]) \(nameParts[1])"
				} else {
					cell.businessName.text = "\(nameParts[0])"
				}
				
				let percent = Float(x.1.points)! / Float(x.1.pointsPerStep)! + 0.01
				print("CUSTOMER PERCENT POINTS -> ",percent)
				cell.percent = percent 
				cell.circularProgress.setProgressWithAnimation(duration: 1, value: percent)
				
			}
			
			return cell
		}
		return UICollectionViewCell()
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	// Add spaces at the beginning and the end of the collection view
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
	}
}
