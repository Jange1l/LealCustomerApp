//
//  TrendingTableViewCell.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/18/21.
//

import UIKit

protocol TrendingBusinessDelegate: class {
	func collectionView(collectionviewcell: DiscountTokenCollectionViewCell?, index: Int, didTappedInTableViewCell: TrendingTableViewCell)
}
class TrendingTableViewCell: UITableViewCell {
	
	static let identifier = "TrendingCell"
	static let name = "TrendingTableViewCell"
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	var discounts: [MDStructures.Discount]!
	
	weak var cellDelegate: TrendingBusinessDelegate!
	
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
		//FOR REGULAR DISCOUNT flowLayout.itemSize = CGSize(width: 175, height: 175)
		//FOR V2 DISCOUNT
		flowLayout.itemSize = CGSize(width: 300, height: 180)
		flowLayout.minimumLineSpacing = 15.0
		flowLayout.minimumInteritemSpacing = 15.0
		self.collectionView.collectionViewLayout = flowLayout
		self.collectionView.showsHorizontalScrollIndicator = false
		
		// Comment if you set Datasource and delegate in .xib
		self.collectionView.dataSource = self
		self.collectionView.delegate = self
		
		// Register the xib for collection view cell
		
//		let cellNib = UINib(nibName: "DiscountTokenCollectionViewCell", bundle: nil)
//		self.collectionView.register(cellNib, forCellWithReuseIdentifier: "DiscountToken")
		let cellNib = UINib(nibName: DiscountV2TokenCollectionViewCell.name, bundle: nil)
		self.collectionView.register(cellNib, forCellWithReuseIdentifier: DiscountV2TokenCollectionViewCell.identifier)
	}
	
	func updateCell(x: [MDStructures.Discount]) {
		discounts = x
		collectionView.reloadData()
	}
}

extension TrendingTableViewCell:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if discounts != nil {
			return discounts.count
		}
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier:DiscountV2TokenCollectionViewCell.identifier, for: indexPath) as? DiscountV2TokenCollectionViewCell {
			
			if discounts != nil {
//				cell.updateCell(x: discounts[indexPath.row])
//				cell.discountLabel.textColor = UIColor.white
				cell.updateCell(x: discounts[indexPath.row])
				
			}
			return cell
		}
		return UICollectionViewCell()
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("Discount tapped")
		let cell = collectionView.cellForItem(at: indexPath) as? DiscountTokenCollectionViewCell
		
		self.cellDelegate?.collectionView(collectionviewcell: cell, index: indexPath.item, didTappedInTableViewCell: self)
	}
	
	// Add spaces at the beginning and the end of the collection view
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
	}
}

