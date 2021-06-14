//
//  AllAnnouncementsViewController.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 3/17/21.
//

import UIKit

class AllAnnouncementsViewController: UIViewController {

	@IBOutlet weak var collectionView: UICollectionView!
	var announcements: [MDStructures.Announcement]!
	
	let announcementSegue = "AnnouncementSegue"
	
	var tappedAnnouncement: MDStructures.Announcement!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		overrideUserInterfaceStyle = .dark
       setCollectionView()
		setNibs()
    }
    

	func setCollectionView() {
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
	
	func setNibs() {
		// Register the xib for collection view cell
		let cellNib = UINib(nibName: "AnnounCellCollectionViewCell", bundle: nil)
		self.collectionView.register(cellNib, forCellWithReuseIdentifier: "AnnounCell")
	}
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == announcementSegue {
			if let announcementView = segue.destination as? AnnouncementExpandedViewController {
				announcementView.announcement = tappedAnnouncement
			}
		}
	}
}

extension AllAnnouncementsViewController:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
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
		
		tappedAnnouncement = announcements[indexPath.row]
		performSegue(withIdentifier: announcementSegue, sender: self)
	}
	
	// Add spaces at the beginning and the end of the collection view
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
	}
}
