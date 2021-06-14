//
//  ActivityNetworking.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/25/21.
//

import Foundation
import UIKit
import Firebase

class ActivityNetworking {
	
	let storage = Storage.storage().reference()
	
	func fetchNearbyBusinesses(completion: @escaping (Bool, [MDStructures.BusinessAccountDetails]) -> ()) {
		
		var businesses = [MDStructures.BusinessAccountDetails]()
		
		LCons.BusinessAccountDetailsRef.getDocuments(completion: {(snap,err) in
			if let err = err {
				print("Error getting douemnts: \(err)")
				completion(false, businesses)
			} else {
				
				for document in snap!.documents {
					
					var account = MDStructures.BusinessAccountDetails(businessName: "", businessEmail: "", businessPhoneNumber: "", profileImageUrl: "", businessType: "", businessBio: "",promotionsPostedCount: "", followersCount: "", testImage: UIImage(), isFollowed: false, uid: "")
					
					let dt = document.data()
					account.businessName = dt[LCons.f_bName] as! String
					account.businessEmail = dt[LCons.f_bEmail] as! String
					account.businessPhoneNumber = dt[LCons.f_bPhoneNumber] as! String
					account.businessBio = dt[LCons.f_bBusinessBio] as! String
					account.businessType = dt[LCons.f_bBusinessType] as! String
					account.profileImageUrl = dt[LCons.f_bProfileImageURL] as! String
					account.promotionsPostedCount = dt[LCons.f_bPromotionsPostedCount] as! String
					account.followersCount = dt[LCons.f_bFollowersCount] as! String
					account.uid = dt[LCons.f_bUid] as! String
					
					businesses.append(account)
				}
			}
			completion(true, businesses)
		})
	}
	
	func getPicture(bArray: [MDStructures.BusinessAccountDetails], completion: @escaping (Bool, [MDStructures.BusinessAccountDetails]) -> ())  {
		
		var businesses = [MDStructures.BusinessAccountDetails]()
		
		if businesses.count == 0 {
			completion(false, businesses)
		}
		let group = DispatchGroup()
		for b in bArray {
			group.enter()
			var bCopy = b
			if b.profileImageUrl != "" {
				
				// Download image
				let storage = Storage.storage().reference()
				let profileImagesRef = storage.child("ProfileImages")
				let p = profileImagesRef.child(b.uid)
				
				p.getData(maxSize: 1 * 1024 * 1024) { data, error in
					if error != nil {
						// Uh-oh, an error occurred!
					} else {
						
						let image = UIImage(data: data!)
						bCopy.testImage = image!
						businesses.append(bCopy)
						
						group.leave()
					}
				}
			} else {
				// Set default profile with no picture
				group.leave()
			}
		}
		group.notify(queue: .main) {
			completion(true, businesses)
		}
		
	}
	
	func getPictureForDiscount(dArray: [MDStructures.Discount], completion: @escaping (Bool, [MDStructures.Discount]) -> ())  {
		
		var businesses = [MDStructures.Discount]()
		var count = 0
		if businesses.count == 0 {
			completion(false, businesses)
		}
		
		let group = DispatchGroup()
		for b in dArray {
			group.enter()
			var bCopy = b
			
			if b.profileUrl != "" {
				
				// Download image
				let storage = Storage.storage().reference()
				let profileImagesRef = storage.child("ProfileImages")
				let p = profileImagesRef.child(b.uid)
				
				p.getData(maxSize: 1 * 1024 * 1024) { data, error in
					if error != nil {
						// Uh-oh, an error occurred!
					} else {
						
						let image = UIImage(data: data!)
						bCopy.profileImage = image!
						businesses.append(bCopy)
						group.leave()
					}
				}
			} else {
				// Set default profile with no picture
				group.leave()
			}
		}
		group.notify(queue: .main) {
			completion(true, businesses)
		}
		
	}
	
	func fetchDiscounts(completion: @escaping (Bool, [MDStructures.Discount]) ->()) {
		LCons.DiscountsRef.getDocuments(completion: {(snap,err) in
			var discounts = [MDStructures.Discount]()
			
			if let err = err {
				print("Error getting douemnts: \(err)")
				completion(false, discounts)
			} else {
				
				
				for document in snap!.documents {
					
					let data = document.data()
					
					var discount = MDStructures.Discount(businessName: "", discount: "", timeReleased: "", duration: "", endDate: "", description: "", quantity: "", profileUrl: "", profileImage: UIImage(), uid: "", postUid: "", type: "")
					
					discount.businessName = data["businessName"] as! String
					discount.discount = data["discount"] as! String
					discount.timeReleased = data["timeReleased"] as! String
					discount.duration = data["duration"] as! String
					discount.endDate = data["endDate"] as! String
					discount.description = data["description"] as! String
					discount.quantity = data["quantity"] as! String
					discount.profileUrl = data["profileUrl"] as! String
					discount.uid = data["uid"] as! String
					discount.postUid = data["postUid"] as! String
					discount.type = data["type"] as! String
					discounts.append(discount)
				}
			}
			completion(false, discounts)
		})
	}
	
	func fetchBundle(completion: @escaping (Bool, [MDStructures.Discount])-> ()) {
		
		LCons.BundlesRef.getDocuments(completion: {(snap, err) in
			var bundles = [MDStructures.Discount]()
			
			if let err = err {
				print("Error getting douemnts: \(err)")
				completion(false, bundles)
			} else {
				
				
				for document in snap!.documents {
					
					let data = document.data()
					
					var bundle = MDStructures.Discount(businessName: "", discount: "", timeReleased: "", duration: "", endDate: "", description: "", quantity: "", profileUrl: "", profileImage: UIImage(), uid: "", postUid: "", type: "")
					
					bundle.businessName = data["businessName"] as! String
					bundle.discount = data["type"] as! String
					bundle.timeReleased = data["timeReleased"] as! String
					bundle.duration = data["duration"] as! String
					bundle.endDate = data["endDate"] as! String
					bundle.description = data["description"] as! String
					bundle.quantity = data["quantity"] as! String
					bundle.profileUrl = data["profileUrl"] as! String
					bundle.uid = data["uid"] as! String
					bundle.postUid = data["postUid"] as! String
					bundle.type = data["type"] as! String
					bundles.append(bundle)
				}
			}
			completion(false, bundles)
		})
	}
	
	func fetchAnnouncements(completion: @escaping (Bool, [MDStructures.Announcement])-> ()) {
		
		LCons.AnnouncementsRef.getDocuments(completion: {(snap, err) in
			
			var announcements = [MDStructures.Announcement]()
			
			if let err = err {
				print("Error getting douemnts: \(err)")
				completion(false, announcements)
			} else {
				
				for document in snap!.documents {
					
					let data = document.data()
					
					var anoun = MDStructures.Announcement(businessName: "", message: "", timeReleased: "", profileUrl: "", profileImage: UIImage(), uid: "", postUid: "")
					
					anoun.businessName = data["businessName"] as! String
					anoun.message = data["message"] as! String
					anoun.timeReleased = data["timeReleased"] as! String
					anoun.profileUrl = data["profileUrl"] as! String
					anoun.uid = data["uid"] as! String
					anoun.postUid = data["postUid"] as! String
					
					announcements.append(anoun)
				}
			}
			completion(false, announcements)
		})
	}
	
	func getPictureForAnnouncement(dArray: [MDStructures.Announcement], completion: @escaping (Bool, [MDStructures.Announcement]) -> ())  {
		
		var businesses = [MDStructures.Announcement]()
		
		if businesses.count == 0 {
			completion(false, businesses)
		}
		let group = DispatchGroup()
		for b in dArray {
			group.enter()
			var bCopy = b
			
			if b.profileUrl != "" {
				
				// Download image
				let storage = Storage.storage().reference()
				let profileImagesRef = storage.child("ProfileImages")
				let p = profileImagesRef.child(b.uid)
				
				p.getData(maxSize: 1 * 1024 * 1024) { data, error in
					if error != nil {
						// Uh-oh, an error occurred!
					} else {
						
						let image = UIImage(data: data!)
						bCopy.profileImage = image!
						businesses.append(bCopy)
						
						group.leave()
					}
				}
			} else {
				// Set default profile with no picture
				group.leave()
			}
		}
		group.notify(queue: .main) {
			completion(true, businesses)
		}
		
	}
	
}
