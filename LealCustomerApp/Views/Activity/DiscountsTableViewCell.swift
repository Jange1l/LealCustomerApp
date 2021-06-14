//
//  DiscountsTableViewCell.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/21/21.
//

import UIKit
protocol DiscountsDelegate: class {
	func collectionView(collectionviewcell: DiscountV2TokenCollectionViewCell?, index: Int, didTappedInTableViewCell: DiscountsTableViewCell)
}
class DiscountsTableViewCell: UITableViewCell {

	
	static let name = "DiscountsTableViewCell"
	static let identifier = "DiscountsCell"
	
	weak var cellDelegate: DiscountsDelegate!
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	var discounts: [MDStructures.Discount]!
	
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
		flowLayout.itemSize = CGSize(width: 300, height: 180)
		flowLayout.minimumLineSpacing = 15.0
		flowLayout.minimumInteritemSpacing = 15.0
		self.collectionView.collectionViewLayout = flowLayout
		self.collectionView.showsHorizontalScrollIndicator = false
		
		// Comment if you set Datasource and delegate in .xib
		self.collectionView.dataSource = self
		self.collectionView.delegate = self
		
		// Register the xib for collection view cell
		let cellNib = UINib(nibName: DiscountV2TokenCollectionViewCell.name, bundle: nil)
		self.collectionView.register(cellNib, forCellWithReuseIdentifier: DiscountV2TokenCollectionViewCell.identifier)
	}
	
	func updateCell(x:[MDStructures.Discount]) {
		discounts = x
		
		collectionView.reloadData()
	}
}

extension DiscountsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if discounts != nil {
			return discounts.count
		}
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiscountV2TokenCollectionViewCell.identifier, for: indexPath) as? DiscountV2TokenCollectionViewCell {
			
			if discounts != nil {
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
		let cell = collectionView.cellForItem(at: indexPath) as? DiscountV2TokenCollectionViewCell
		
		if cell?.isDone != true {
			self.cellDelegate?.collectionView(collectionviewcell: cell, index: indexPath.item, didTappedInTableViewCell: self)
		}
	}
	// Add spaces at the beginning and the end of the collection view
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
	}
}



