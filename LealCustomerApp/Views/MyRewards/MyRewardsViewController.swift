//
//  MyRewardsViewController.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/20/21.
//

import UIKit
import Firebase

class MyRewardsViewController: UIViewController {
	
	
	@IBOutlet weak var collectionView: UICollectionView!
	
	@IBOutlet weak var activity: UIActivityIndicatorView!
	
	var myPromotions: [MDStructures.Discount]!
	let redeemPromoSegue = "RedeemPromo"
	
	var selectedPromo: MDStructures.Discount!
	var listener: ListenerRegistration!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		overrideUserInterfaceStyle = .dark
		setCollectionView()
		getData()
		addSnapShotListeners()
	}
	
	func addSnapShotListeners() {
		listener = LCons.AccountDetailsRef.collection("Wallet").addSnapshotListener { querySnapshot, error in
			guard let snapshot = querySnapshot else {
				print("Error fetching snapshots: \(error!)")
				return
			}
			snapshot.documentChanges.forEach { diff in
				if (diff.type == .added) {
					print("New city: \(diff.document.data())")
					self.getData()
				}
				if (diff.type == .modified) {
					print("Modified city: \(diff.document.data())")
				}
				if (diff.type == .removed) {
					print("Removed city: \(diff.document.data())")
					
					NotificationCenter.default.post(name: Notification.Name("RedeemedPromo"), object: nil)
					self.getData()
				}
			}
		}
	}
	
	func setCollectionView() {
		
		
		// TODO: need to setup collection view flow layout
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .vertical
		flowLayout.itemSize = CGSize(width: 175, height: 175)
		flowLayout.minimumLineSpacing = 15.0
		flowLayout.minimumInteritemSpacing = 15.0
		self.collectionView.collectionViewLayout = flowLayout
		self.collectionView.showsHorizontalScrollIndicator = false
		
		// Comment if you set Datasource and delegate in .xib
		self.collectionView.dataSource = self
		self.collectionView.delegate = self
		
		// Register the xib for collection view cell
		let cellNib = UINib(nibName: "DiscountTokenCollectionViewCell", bundle: nil)
		self.collectionView.register(cellNib, forCellWithReuseIdentifier: "DiscountToken")
	}
	
	func getData() {
		activity.startAnimating()
		PromotionNetworking().fetchSavedPromotions(completion: {(s, data) in
			self.myPromotions = data
			for p in data {
				if self.getTimeLeft(endDate: p.endDate) == "Done" {
					LCons.UserWallet.document(p.postUid).delete() { err in
						if let err = err {
							print("Error removing document: \(err)")
						} else {
							print("Document successfully removed!")
							
						}
					}
				}
			}
			self.collectionView.reloadData()
			self.activity.stopAnimating()
			self.activity.isHidden = true
			
			
		})
		
	}
	func getTimeLeft(endDate: String) -> String{
		let form = DateFormatter()
		form.timeStyle = .short
		form.dateStyle = .short
		
		let date = Date()
		
		
		
		let endD = form.date(from: endDate)
		
		
		let diffComponents = Calendar.current.dateComponents([.hour, .minute], from: date, to: endD ?? date)
		
		let hours = diffComponents.hour
		let minutes = diffComponents.minute
		
		if hours! > 24 {
			var days = Double(hours!) / 24
			days.round()
			return "\(Int(days)) Days"
		}
		
		if hours! > 0 && hours! < 24 {
			if hours == 1 {
				return "1 hour"
			}
			return "\(hours!) Hours"
		}
		if hours! < 0 && minutes! < 0 {
			return "Expired"
		}
		return "\(hours!) Hours"
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == redeemPromoSegue {
			if let redeem = segue.destination as? RedeemRewardViewController {
				
				redeem.promo = selectedPromo
			}
		}
	}
	
}

extension MyRewardsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if myPromotions != nil {
			return myPromotions.count
		}
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiscountToken", for: indexPath) as? DiscountTokenCollectionViewCell {
			
			if myPromotions != nil
			{
				let blank = MDStructures.Discount(businessName: "", discount: "", timeReleased: "", duration: "", endDate: "", description: "", quantity: "", profileUrl: "", profileImage: UIImage(), uid: "", postUid: "", type: "")
				cell.updateCell(x: blank)
				cell.updateCell(x: myPromotions[indexPath.row])
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
		selectedPromo = cell!.data
		
		performSegue(withIdentifier: redeemPromoSegue, sender: self)
	}
	
	// Add spaces at the beginning and the end of the collection view
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 20, left: 20, bottom: 0, right: 20)
	}
}



