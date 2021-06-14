//
//  RunningLowTableViewCell.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/20/21.
//

import UIKit

protocol RunningLowDelegate: class {
	func collectionView(collectionviewcell: DiscountTokenCollectionViewCell?, index: Int, didTappedInTableViewCell: RunningLowTableViewCell)
}

class RunningLowTableViewCell: UITableViewCell {
	
	static let identifier = "RunningLowCell"
	static let name = "RunningLowTableViewCell"
	
	weak var cellDelegate: RunningLowDelegate!
	
	@IBOutlet weak var titleText: UILabel!
	@IBOutlet weak var collectionView: UICollectionView!
	
	var low: [MDStructures.Discount]!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		setCollectionView()
		self.selectionStyle = .none
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
		flowLayout.itemSize = CGSize(width: 175, height: 175)
		flowLayout.minimumLineSpacing = 5.0
		flowLayout.minimumInteritemSpacing = 5.0
		self.collectionView.collectionViewLayout = flowLayout
		self.collectionView.showsHorizontalScrollIndicator = false
		
		// Comment if you set Datasource and delegate in .xib
		self.collectionView.dataSource = self
		self.collectionView.delegate = self
		
		// Register the xib for collection view cell
		let cellNib = UINib(nibName: "DiscountTokenCollectionViewCell", bundle: nil)
		self.collectionView.register(cellNib, forCellWithReuseIdentifier: "DiscountToken")
	}
	
	func updateCell(x: [MDStructures.Discount]) {
		low = x
		collectionView.reloadData()
	}
}


extension RunningLowTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if low != nil {
			return low.count
		}
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscountToken", for: indexPath) as? DiscountTokenCollectionViewCell {
			if low != nil {
				cell.updateCell(x: low[indexPath.row])
			}
			return cell
		}
		return UICollectionViewCell()
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let cell = collectionView.cellForItem(at: indexPath) as? DiscountTokenCollectionViewCell
		
		self.cellDelegate?.collectionView(collectionviewcell: cell, index: indexPath.item, didTappedInTableViewCell: self)
	}
	
	// Add spaces at the beginning and the end of the collection view
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
	}
}


