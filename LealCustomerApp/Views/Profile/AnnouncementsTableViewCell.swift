//
//  AnnouncementsTableViewCell.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/10/21.
//

import UIKit

protocol AnnouncementCellDelegate: class {
	func collectionView(collectionviewcell: AnnounCellCollectionViewCell?, index: Int, didTappedInTableViewCell: AnnouncementsTableViewCell)
}

class AnnouncementsTableViewCell: UITableViewCell {

	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var subCategoryLabel: UILabel!
	
	var announcements: [MDStructures.Announcement]!
	
	weak var cellDelegate: AnnouncementCellDelegate?
	var viewAll: ((_ value: String) -> ())?
	
	override func awakeFromNib() {
        super.awakeFromNib()
        
		setCollectionView()
		self.selectionStyle = .none
		//configureCollectionView()
		
		setNibs()
    }

	@IBAction func viewAllPressed(_ sender: Any) {
		viewAll?("Pressed")
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func updateCell(x: [MDStructures.Announcement]) {
		announcements = Array(x.prefix(4))
		collectionView.reloadData()
	}
	
	func setCollectionView() {
		backgroundColor = UIColor.clear
		
		// TODO: need to setup collection view flow layout
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .vertical
		flowLayout.itemSize = CGSize(width: 340, height: 100)
		flowLayout.minimumLineSpacing = 10.0
		flowLayout.minimumInteritemSpacing = 10.0
		
		self.collectionView.collectionViewLayout = flowLayout
		self.collectionView.showsHorizontalScrollIndicator = false
		
		// Comment if you set Datasource and delegate in .xib
		self.collectionView.dataSource = self
		self.collectionView.delegate = self
	}
	
//	func configureCollectionView() {
//		self.collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//		self.collectionView.collectionViewLayout = generateLayout()
//		backgroundColor = UIColor.clear
//
//		self.collectionView.showsHorizontalScrollIndicator = false
//
//		// Comment if you set Datasource and delegate in .xib
//		self.collectionView.dataSource = self
//		self.collectionView.delegate = self
//	}
	
	
	
	func setNibs() {
		// Register the xib for collection view cell
		let cellNib = UINib(nibName: "AnnounCellCollectionViewCell", bundle: nil)
		self.collectionView.register(cellNib, forCellWithReuseIdentifier: "AnnounCell")
	}
	
	
    
//	func generateLayout() -> UICollectionViewLayout {
//	  // We have three row styles
//	  // Style 1: 'Full'
//	  // A full width photo
//	  // Style 2: 'Main with pair'
//	  // A 2/3 width photo with two 1/3 width photos stacked vertically
//	  // Style 3: 'Triplet'
//	  // Three 1/3 width photos stacked horizontally
//
//	  // Full
//	  let fullPhotoItem = NSCollectionLayoutItem(
//		layoutSize: NSCollectionLayoutSize(
//		  widthDimension: .fractionalWidth(2/5),
//		  heightDimension: .fractionalWidth(4/9)))
//	  fullPhotoItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
//
//	  // Main with pair
//	  let mainItem = NSCollectionLayoutItem(
//		layoutSize: NSCollectionLayoutSize(
//		  widthDimension: .fractionalWidth(3/5),
//		  heightDimension: .fractionalHeight(1.0)))
//	  mainItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
//
//	  let mainWithPairGroup = NSCollectionLayoutGroup.horizontal(
//		layoutSize: NSCollectionLayoutSize(
//		  widthDimension: .fractionalWidth(1.0),
//		  heightDimension: .fractionalWidth(4/9)),
//		subitems: [mainItem, fullPhotoItem])
//
//	  // Wide Short
//	  let wideShort = NSCollectionLayoutItem(
//		layoutSize: NSCollectionLayoutSize(
//			widthDimension: .fractionalWidth(1.0),
//			heightDimension: .fractionalHeight(1.0)))
//	  wideShort.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
//
//	  let tripletGroup = NSCollectionLayoutGroup.horizontal(
//		layoutSize: NSCollectionLayoutSize(
//		  widthDimension: .fractionalWidth(1.0),
//		  heightDimension: .fractionalWidth(2/9)),
//		subitems: [wideShort])
//
//	  // Reversed main with pair
//	  let mainWithPairReversedGroup = NSCollectionLayoutGroup.horizontal(
//		layoutSize: NSCollectionLayoutSize(
//		  widthDimension: .fractionalWidth(1.0),
//		  heightDimension: .fractionalWidth(4/9)),
//		subitems: [fullPhotoItem, mainItem])
//
//	  let nestedGroup = NSCollectionLayoutGroup.vertical(
//		layoutSize: NSCollectionLayoutSize(
//		  widthDimension: .fractionalWidth(1.0),
//		  heightDimension: .fractionalWidth(16/9)),
//		subitems: [mainWithPairGroup, tripletGroup, mainWithPairReversedGroup])
//
//	  let section = NSCollectionLayoutSection(group: nestedGroup)
//	  let layout = UICollectionViewCompositionalLayout(section: section)
//	  return layout
//	}
	
}

extension AnnouncementsTableViewCell:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if announcements != nil {
			return announcements.count
		}
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AnnounCell", for: indexPath) as? AnnounCellCollectionViewCell {
			
			if announcements != nil {
				cell.updateCell(x: announcements[indexPath.row])
			}
			return cell
		}
		return UICollectionViewCell()
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("cell tapped announcement")
		let cell = collectionView.cellForItem(at: indexPath) as? AnnounCellCollectionViewCell
		self.cellDelegate?.collectionView(collectionviewcell: cell, index: indexPath.item, didTappedInTableViewCell: self)
	}
	
	// Add spaces at the beginning and the end of the collection view
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
	}
}
