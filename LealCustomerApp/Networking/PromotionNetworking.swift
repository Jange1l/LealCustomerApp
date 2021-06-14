//
//  PromotionNetworking.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 3/1/21.
//

import Foundation
import UIKit

class PromotionNetworking {
	
	
	func savePromotion(postUid: String, post: MDStructures.Discount) {
		
		LCons.UserWallet.document(postUid).setData(
			[
				"businessName": post.businessName,
				"discount": post.discount,
				"timeReleased": post.timeReleased,
				"duration": post.duration,
				"endDate": post.endDate,
				"description": post.description,
				"quantity" : post.quantity,
				"profileUrl" : post.profileUrl,
				"uid" : post.uid,
				"postUid" : postUid
			])
		
	}
	
	func checkIfSaved(postUid: String, completion: @escaping (Bool)->()) {
		
		LCons.UserWallet.document(postUid).getDocument(completion: {(snap, err) in
			
			if let err = err {
				print("Error getting documents for user information: \(err)")
				
			} else {
				if let document = snap, document.exists {
					completion(true)
				} else {
					completion(false)
				}
				
			}
		})
	}
	
	// Get Ids and pull documetns from Discounts branch
	
	func fetchSavedPromotions(completion: @escaping (Bool, [MDStructures.Discount])->()) {
		
		LCons.UserWallet.getDocuments(completion: {(snap, err) in
			var promotions = [MDStructures.Discount]()
			
			if let err = err {
				print("Error getting douemnts: \(err)")
				completion(false, promotions)
			} else {
				
				
				for document in snap!.documents {
					
					let data = document.data()
					
					var promo = MDStructures.Discount(businessName: "", discount: "", timeReleased: "", duration: "", endDate: "", description: "", quantity: "", profileUrl: "", profileImage: UIImage(), uid: "", postUid: "", type: "")

					promo.uid = data["uid"] as! String
					promo.postUid = data["postUid"] as! String
					
					promotions.append(promo)
				}
			}
			
			var count = 0
			print("My rewards -> ",promotions.count, promotions)
			if promotions.count == 0 {
				completion(false, promotions)
			}
			// Get update version of the promotion that was saved by the user
			
			var updatedPromotions = [MDStructures.Discount]()
			
			for p in promotions {
				
				LCons.DiscountsRef.document(p.postUid).getDocument(completion: {(document, err) in
					count += 1
					if let err = err {
						print("Error getting douemnts: \(err)")
						
						
					} else {
						
						if let document = document, document.exists {
							
							let data = document.data()!
							
							var promo = MDStructures.Discount(businessName: "", discount: "", timeReleased: "", duration: "", endDate: "", description: "", quantity: "", profileUrl: "", profileImage: UIImage(), uid: "", postUid: "", type: "")
							
							promo.businessName = data["businessName"] as! String
							promo.discount = data["discount"] as! String
							promo.timeReleased = data["timeReleased"] as! String
							promo.duration = data["duration"] as! String
							promo.endDate = data["endDate"] as! String
							promo.description = data["description"] as! String
							promo.quantity = data["quantity"] as! String
							promo.profileUrl = data["profileUrl"] as! String
							promo.uid = data["uid"] as! String
							promo.postUid = data["postUid"] as! String
							promo.type = data["type"] as! String
							updatedPromotions.append(promo)
							
							
							
							if count == promotions.count {
								completion(true, updatedPromotions)
							}
							
						}
					}
				})
				
				
			}
			
		})
	}
	
	
	
}
