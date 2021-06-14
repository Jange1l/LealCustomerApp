//
//  BusinessProfileViewController.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/9/21.
//

import UIKit
import MapKit

class BusinessProfileViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var activity: UIActivityIndicatorView!
	
	let loyaltyCardSegue = "LoyaltyCard"
	let promotionDetailSegue = "PMD"
	let allAnnouncementsSegue = "AllAnnouncements"
	
	let announcementSegue = "AnnouncementSegue"
	
	var sections: Int!
	
	var networking: BusinessProfileNetworking!
	
	var businessUid: String!
	
	var data: MDStructures.BusinessAccountDetails!
	
	var lpManager: LoyaltyProgramManager!
	var customerLp: MDStructures.LoyaltyProgramDetails!
	
	var discounts: [MDStructures.Discount]!
	var bundle: [MDStructures.Discount]!
	var announcements: [MDStructures.Announcement]!
	
	var tappedPromotion: MDStructures.Discount!
	
	var tappedAnnouncement: MDStructures.Announcement!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		overrideUserInterfaceStyle = .dark
		setNibs()
		getBusinessAccountData(completion: {(status) in
			print("BUSINESS PROFILE INSTANTIADE",self.businessUid!)
		})
	}
	
	func openMapForPlace() {

		LCons.LocationRef.document(businessUid).getDocument(completion: {(snap, err) in
			if let err = err {
				print("Error getting documents for user information: \(err)")
				
			} else {
				if let document = snap, document.exists {
					
					let data = document.data()!
					
					let latitude: CLLocationDegrees = CLLocationDegrees(data["Lat"] as! String)!
					let longitude: CLLocationDegrees = CLLocationDegrees(data["Long"] as! String)!

					let regionDistance:CLLocationDistance = 1000
					let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
					let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
					let options = [
						MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
						MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
					]
					let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
					let mapItem = MKMapItem(placemark: placemark)
					mapItem.name = data["Name"] as! String
					mapItem.openInMaps(launchOptions: options)
					
				}
			}
		})
			
		}
	
	func setNibs() {
		sections = 6
		
		let cellNib = UINib(nibName: "HeaderTableViewCell", bundle: nil)
		self.tableView.register(cellNib, forCellReuseIdentifier: "HeaderCell")
		
		let loyaltyNib = UINib(nibName: "LoyaltyCardTableViewCell", bundle: nil)
		self.tableView.register(loyaltyNib, forCellReuseIdentifier: "LoyaltyCard")
		
		let contactNib = UINib(nibName: "ContactAndLocationTableViewCell", bundle: nil)
		self.tableView.register(contactNib, forCellReuseIdentifier: "ContactCell")
		
		let DiscountsCell = UINib(nibName: DiscountsTableViewCell.name, bundle: nil)
		self.tableView.register(DiscountsCell, forCellReuseIdentifier: DiscountsTableViewCell.identifier)
		
		let bundleNib = UINib(nibName: BundlesTableViewCell.name, bundle: nil)
		self.tableView.register(bundleNib, forCellReuseIdentifier: BundlesTableViewCell.identifier)
		
		let announcements = UINib(nibName: "AnnouncementsTableViewCell", bundle: nil)
		self.tableView.register(announcements, forCellReuseIdentifier: "AnnounCell")
	}
	
	func getBusinessAccountData(completion: @escaping (Bool) ->()) {
		
		networking = BusinessProfileNetworking()
		lpManager = LoyaltyProgramManager()
		activity.startAnimating()
		
		networking.fetchBusinessProfileWithUid(uid: businessUid, completion: {(status, business) in
			self.data = business
			self.networking.isFollowed(uid: business.uid, completion: {(status) in
				
				self.data.isFollowed = status
				// If following business/in lp program
				if status {
					
					self.lpManager.getCustomerLoyaltyProgramProgress(uid: self.data.uid, completion: {(s, clp) in
						
						self.customerLp = clp
						print("Following the business, customer lp progress = ", clp)
						self.lpManager.getCurrentLoyaltyProgram(uid: business.uid, completion: {(s, lp) in
						})
					})
					// If not following the business
				} else {
					self.lpManager.getCurrentLoyaltyProgram(uid: business.uid, completion: {(s, lp) in
					})
				}
				self.networking.getBusinessPostData(businessUid: self.data.uid, completion: {(ds, anouns, dis) in
					
					self.sortBundlesPromotions(d: dis)
					self.addPicture(anouns: anouns)
					
					self.activity.stopAnimating()
					self.activity.isHidden = true
					self.tableView.reloadData()
				})
			})
		})
	}
	
	func sortBundlesPromotions(d: [MDStructures.Discount]) {
		
		var bundle = [MDStructures.Discount]()
		var discount = [MDStructures.Discount]()
		
		for i in d {
			var di = i
			di.profileImage = data.testImage
			if i.type == "bundle" {
				bundle.append(di)
			} else {
				discount.append(di)
			}
		}
		self.discounts = discount
		self.bundle = bundle
	}
	func addPicture(anouns: [MDStructures.Announcement]) {
		var withImage = [MDStructures.Announcement]()
		for a in anouns {
			var ai = a
			ai.profileImage = data.testImage
			print("",ai)
			withImage.append(ai)
		}
		//self.announcements = sortAnnouncements(x: withImage)
		self.announcements = withImage
	}
	func sortAnnouncements(x: [MDStructures.Announcement]) -> [MDStructures.Announcement]{
		let inputX = x
		var anWithDate = [MDStructures.AnnouncementWithDate]()
		let form = DateFormatter()
		form.timeStyle = .short
		form.dateStyle = .short
		
		for an in inputX {
			let timeReleased = form.date(from: an.timeReleased) ?? Date()
			let businessName = an.businessName
			let message = an.message
			let profileUrl = an.profileUrl
			let profileImage = an.profileImage
			let uid = an.uid
			let postUid = an.postUid
			
			let awd = MDStructures.AnnouncementWithDate(businessName: businessName, message: message, timeReleased: timeReleased, profileUrl: profileUrl, profileImage: profileImage, uid: uid, postUid: postUid)
			
			anWithDate.append(awd)
			
		}
		
		anWithDate = anWithDate.sorted(by: {$0.timeReleased.compare($1.timeReleased) == .orderedDescending})
		
		
		
		var announcements = [MDStructures.Announcement]()
		
		for i in anWithDate {
			let date = "\(i.timeReleased)"
			let a = MDStructures.Announcement(businessName: i.businessName, message: i.message, timeReleased: date, profileUrl: i.profileUrl, profileImage: i.profileImage, uid: i.uid, postUid: i.postUid)
			print(a)
			announcements.append(a)
		}
		return announcements
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		print("SEGUE TRIGGERED -> ", segue.identifier, tappedPromotion)
		
		if segue.identifier == loyaltyCardSegue {
			
			if let loyaltyCardDetails = segue.destination as? QRCodeViewController {
				loyaltyCardDetails.userIsFollowing = data.isFollowed
				loyaltyCardDetails.blp = lpManager
				
			}
			
		}
		
		if segue.identifier == promotionDetailSegue {
			
			if let promoTionDetail = segue.destination as? PromotionDetailViewController {
				
				promoTionDetail.tappedPromotion = tappedPromotion
			}
		}
		
		
		if segue.identifier == announcementSegue {
			if let announcementView = segue.destination as? AnnouncementExpandedViewController {
				announcementView.announcement = tappedAnnouncement
			}
		}
		
		if segue.identifier == allAnnouncementsSegue {
			if let allAnnouncementsView = segue.destination as? AllAnnouncementsViewController {
				allAnnouncementsView.announcements = announcements
			}
		}
	}
	
	
	
}

extension BusinessProfileViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return sections
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch indexPath.row {
			case 0:
				return 348
			case 1:
				return 200
			default:
				return 300
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		
		switch indexPath.row {
			case 0:
				if let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as? HeaderTableViewCell {
					
					if data != nil {
						cell.updateCell(profile: data)
					}
					
					cell.clicked = {
						value in
						self.getBusinessAccountData(completion: {(status) in })
						
					}
					
					cell.selectionStyle = .none
					return cell
				}
				
			case 1:
				if let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as? ContactAndLocationTableViewCell {
					
					cell.mapClicked = {
						value in
						self.openMapForPlace()
					}
					if data != nil {
						cell.updateCell(profile: data)
					}
					cell.selectionStyle = .none
					return cell
				}
				
			case 2:
				if let cell = tableView.dequeueReusableCell(withIdentifier: "LoyaltyCard", for: indexPath) as? LoyaltyCardTableViewCell {
					
					if data != nil && customerLp != nil {
						cell.updateCell(profile: data, blp: lpManager.lp, clp: customerLp)
					}
					if data != nil {
						cell.bNameLabel.text = data.businessName
					}
					cell.selectionStyle = .none
					return cell
				}
			case 3:
				// Announcements
				if let cell = tableView.dequeueReusableCell(withIdentifier: "AnnounCell") as? AnnouncementsTableViewCell {
					
					if announcements != nil {
						let reducedData = Array(announcements.prefix(2))
						cell.updateCell(x: reducedData)
						cell.cellDelegate = self
					}
					cell.viewAll = {
						value in
						self.performSegue(withIdentifier: self.allAnnouncementsSegue, sender: self)
					}
					
					return cell
				}
			case 4:
				// Discounts
				if let cell = tableView.dequeueReusableCell(withIdentifier: DiscountsTableViewCell.identifier) as? DiscountsTableViewCell {
					
					if discounts != nil {
						cell.updateCell(x: discounts)
						cell.cellDelegate = self
					}
					return cell
				}
			case 5:
				// Bundles
				if let cell = tableView.dequeueReusableCell(withIdentifier: BundlesTableViewCell.identifier) as? BundlesTableViewCell {
					
					if bundle != nil {
						cell.updateCell(x: bundle)
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
		if indexPath.row == 2 {
			performSegue(withIdentifier: loyaltyCardSegue, sender: nil)
		}
	}
	
	
}

extension BusinessProfileViewController: DiscountsDelegate {
	func collectionView(collectionviewcell: DiscountV2TokenCollectionViewCell?, index: Int, didTappedInTableViewCell: DiscountsTableViewCell) {
		
		if let t = didTappedInTableViewCell.discounts {
			self.tappedPromotion = t[index]
			performSegue(withIdentifier: promotionDetailSegue, sender: self)
		}
	}
}

extension BusinessProfileViewController: BundlesDelegate {
	func collectionView(collectionviewcell: DiscountV2TokenCollectionViewCell?, index: Int, didTappedInTableViewCell: BundlesTableViewCell) {
		if let t = didTappedInTableViewCell.bundles {
			self.tappedPromotion = t[index]
			performSegue(withIdentifier: promotionDetailSegue, sender: self)
		}
	}
}

extension BusinessProfileViewController: AnnouncementCellDelegate {
	func collectionView(collectionviewcell: AnnounCellCollectionViewCell?, index: Int, didTappedInTableViewCell: AnnouncementsTableViewCell) {
		print("Tapped element")
		if let rewards = didTappedInTableViewCell.announcements {
			self.tappedAnnouncement = rewards[index]
			performSegue(withIdentifier: announcementSegue, sender: self)
		}
	}
}
