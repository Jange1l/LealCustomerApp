//
//  ActivityViewController.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/11/21.
//

import UIKit

class ActivityViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	
	let showBusinessSegue = "ShowBusiness"
	let promotionDetailSegue = "PromotionDetail"
	let announcementSegue = "AnnouncementSegue"
	
	var networking: ActivityNetworking!
	
	var tappedBusiness: MDStructures.BusinessAccountDetails!
	var tappedPromotion: MDStructures.Discount!
	// MARK: Data
	
	var nearbyBusinesses: [MDStructures.BusinessAccountDetails]!
	
	var discounts: [MDStructures.Discount]!
	var bundle: [MDStructures.Discount]!
	var trending: [MDStructures.Discount]!
	var runningLow: [MDStructures.Discount]!
	
	var announcements: [MDStructures.Announcement]!
	
	var rcon = UIRefreshControl()
	
	@IBOutlet weak var activity: UIActivityIndicatorView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		overrideUserInterfaceStyle = .dark
		if #available(iOS 10.0, *) {
			tableView.refreshControl = rcon
		} else {
			tableView.addSubview(rcon)
		}
		
		rcon.addTarget(self, action: #selector(getData(_:)), for: .valueChanged)
		
		networking = ActivityNetworking()
		
		setNibs()
		getData(self)
	}
	
	
	
	@objc func getData(_ sender: Any) {
		activity.startAnimating()
		nearbyBusinesses = [MDStructures.BusinessAccountDetails]()
		networking.fetchNearbyBusinesses(completion: {(status, businesses) in
			
			self.networking.getPicture(bArray: businesses, completion: {(status, bp) in
				
				self.nearbyBusinesses = bp
				
				self.networking.fetchDiscounts(completion: {(s, ds) in
					
					self.networking.getPictureForDiscount(dArray: ds, completion: {(s, dsp) in
						
						if s != false {
							self.discounts = dsp
						
						} else {
							self.discounts = []
						}
						
						self.sortBundlesPromotions(d: dsp)
						
						self.tableView.reloadData()
						self.activity.stopAnimating()
						self.activity.isHidden = true
						self.rcon.endRefreshing()
						
						
					})
					
					
					
				})
				
				
			})
			
		})
		
		
	}
	func setNibs() {
		let cellNib = UINib(nibName: "ActivityHeaderTableViewCell", bundle: nil)
		self.tableView.register(cellNib, forCellReuseIdentifier: "ActivityHeaderCell")
		
		let cellNib2 = UINib(nibName: NearbyBusinessesTableViewCell.name, bundle: nil)
		self.tableView.register(cellNib2, forCellReuseIdentifier: NearbyBusinessesTableViewCell.identifier)
		
		let cellNib3 = UINib(nibName: TrendingTableViewCell.name, bundle: nil)
		self.tableView.register(cellNib3, forCellReuseIdentifier: TrendingTableViewCell.identifier)
		
		let cellNib4 = UINib(nibName: RunningLowTableViewCell.name, bundle: nil)
		self.tableView.register(cellNib4, forCellReuseIdentifier: RunningLowTableViewCell.identifier)
		
		let DiscountsCell = UINib(nibName: DiscountsTableViewCell.name, bundle: nil)
		self.tableView.register(DiscountsCell, forCellReuseIdentifier: DiscountsTableViewCell.identifier)
		
		let bundleNib = UINib(nibName: BundlesTableViewCell.name, bundle: nil)
		self.tableView.register(bundleNib, forCellReuseIdentifier: BundlesTableViewCell.identifier)
	}
	
	func sortBundlesPromotions(d: [MDStructures.Discount]) {
//		var trending = [MDStructures.Discount]()
//		var low = [MDStructures.Discount]()
		
		var bundle = [MDStructures.Discount]()
		var discount = [MDStructures.Discount]()
		
		print("Discounts and bundles -> ",d)
		let date = Date()
		let form = DateFormatter()
		form.timeStyle = .short
		form.dateStyle = .short
		
		
		for i in d {
			
			let endDate = i.endDate
			let endD = form.date(from: endDate)
			let diffComponents = Calendar.current.dateComponents([.hour, .minute], from: date, to: endD ?? date)
			let hours = diffComponents.hour
			let minutes = diffComponents.minute
			// hours! > 0 || minutes! > 0
			if hours! > 0 || minutes! > 0 {
				
//				if Int(i.quantity)! > 50 {
//					trending.append(i)
//				}
//				if Int(i.quantity)! < 15 {
//					low.append(i)
//				}
				
				if i.type == "bundle" {
					bundle.append(i)
				} else {
					discount.append(i)
				}
			}
			
		}
		self.discounts = discount
		self.bundle = bundle
//		self.trending = trending
//		self.runningLow = low
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == showBusinessSegue {
			if let businessProfile = segue.destination as? BusinessProfileViewController {
				businessProfile.businessUid = tappedBusiness.uid
			}
		}
		
		if segue.identifier == promotionDetailSegue {
			if let promoTionDetail = segue.destination as? PromotionDetailViewController {
				promoTionDetail.tappedPromotion = self.tappedPromotion
			}
		}
	}
	
	func showAlert() {
		let generator = UIImpactFeedbackGenerator(style: .heavy)
		generator.impactOccurred()
		
		let alert = UIAlertController(title: "Sorry", message: "No additional categories at the moment.", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
			NSLog("The \"OK\" alert occured.")
			
			
			let gen = UINotificationFeedbackGenerator()
			gen.notificationOccurred(.warning)
		}))
		
		self.present(alert, animated: true, completion: nil)
	}
}

extension  ActivityViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 4
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		switch indexPath.row {
			case 0:
				if let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityHeaderCell") as? ActivityHeaderTableViewCell {
					
					return cell
				}
			case 1:
				if let cell = tableView.dequeueReusableCell(withIdentifier: NearbyBusinessesTableViewCell.identifier) as? NearbyBusinessesTableViewCell {
					
					if nearbyBusinesses != nil {
						cell.updateCell(x: nearbyBusinesses)
						cell.cellDelegate = self
					}
					
					
					return cell
				}
			case 2:
				if let cell = tableView.dequeueReusableCell(withIdentifier: DiscountsTableViewCell.identifier) as? DiscountsTableViewCell {
					
					if discounts != nil {
						cell.updateCell(x: discounts)
						cell.cellDelegate = self
					}
					return cell
				}
//				if let cell = tableView.dequeueReusableCell(withIdentifier: TrendingTableViewCell.identifier) as? TrendingTableViewCell {
//
//					if trending != nil {
//						print("TRENDING ")
//						cell.updateCell(x: trending)
//						cell.cellDelegate = self
//					}
//					return cell
//				}
			case 3:
				if let cell = tableView.dequeueReusableCell(withIdentifier: BundlesTableViewCell.identifier) as? BundlesTableViewCell {
					
					if bundle != nil {
						cell.updateCell(x: bundle)
						cell.cellDelegate = self
					}
					return cell
				}
//				if let cell = tableView.dequeueReusableCell(withIdentifier: DiscountsTableViewCell.identifier) as? DiscountsTableViewCell {
//
//					if discounts != nil {
//						cell.updateCell(x: discounts)
//						cell.cellDelegate = self
//					}
//					return cell
//				}
			case 4:
				if let cell = tableView.dequeueReusableCell(withIdentifier: BundlesTableViewCell.identifier) as? BundlesTableViewCell {
					
					if bundle != nil {
						cell.updateCell(x: bundle)
						cell.cellDelegate = self
					}
					return cell
				}
			case 5:
				if let cell = tableView.dequeueReusableCell(withIdentifier: RunningLowTableViewCell.identifier) as? RunningLowTableViewCell {
					
					if runningLow != nil  {
						cell.updateCell(x: runningLow)
						cell.cellDelegate = self
					}
					return cell
				}
				
			default:
				return UITableViewCell()
		}
		
		return UITableViewCell()
		
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.row == 0 {
			showAlert()
		}
		
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch indexPath.row {
			case 0:
				return 400
			case 1:
				return 200
			case 2:
				// normally 280
				return 280
			case 3:
				return 280
			default:
				return 250
		}
	}
	
	
}

extension ActivityViewController: NearbyBusinessCellDelegate {
	func collectionView(collectionviewcell: BusinessProfileImageCollectionViewCell?, index: Int, didTappedInTableViewCell: NearbyBusinessesTableViewCell) {
		
		if let business = didTappedInTableViewCell.data {
			self.tappedBusiness = business[index]
			performSegue(withIdentifier: showBusinessSegue, sender: self)
			
		}
	}
}

extension ActivityViewController: TrendingBusinessDelegate {
	func collectionView(collectionviewcell: DiscountTokenCollectionViewCell?, index: Int, didTappedInTableViewCell: TrendingTableViewCell) {
		
		if let t = didTappedInTableViewCell.discounts {
			self.tappedPromotion = t[index]
			performSegue(withIdentifier: promotionDetailSegue, sender: self)
		}
	}
}

extension ActivityViewController: RunningLowDelegate {
	func collectionView(collectionviewcell: DiscountTokenCollectionViewCell?, index: Int, didTappedInTableViewCell: RunningLowTableViewCell) {
		
		if let t = didTappedInTableViewCell.low {
			self.tappedPromotion = t[index]
			performSegue(withIdentifier: promotionDetailSegue, sender: self)
		}
	}
}


extension ActivityViewController: DiscountsDelegate {
	func collectionView(collectionviewcell: DiscountV2TokenCollectionViewCell?, index: Int, didTappedInTableViewCell: DiscountsTableViewCell) {
		if let t = didTappedInTableViewCell.discounts {
			self.tappedPromotion = t[index]
			performSegue(withIdentifier: promotionDetailSegue, sender: self)
		}
	}
}

extension ActivityViewController: BundlesDelegate {
	func collectionView(collectionviewcell: DiscountV2TokenCollectionViewCell?, index: Int, didTappedInTableViewCell: BundlesTableViewCell) {
		if let t = didTappedInTableViewCell.bundles {
			self.tappedPromotion = t[index]
			performSegue(withIdentifier: promotionDetailSegue, sender: self)
		}
	}
}
