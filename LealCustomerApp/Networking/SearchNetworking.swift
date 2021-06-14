//
//  SearchNetworking.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/9/21.
//

import Foundation
import Firebase
import CoreLocation

class SearchNetworking {
	
	func getBusinesses(completion: @escaping (Bool, [BusinessAnnotation]) ->()) {
		
		var points = [BusinessAnnotation]()
		
		LCons.LocationRef.getDocuments() { (snap,err) in
			if let err = err {
				print("Error getting douemnts: \(err)")
				completion(false, points)
			} else {
				for document in snap!.documents {
					let dt = document.data()
					
					let name = dt["Name"] as! String
					var lat = 00.0
					var long = 0.0
					let uid = dt["Uid"] as! String
					
					if let la = dt["Lat"] {
						lat = Double(la as! String)!
					}
					
					if let lg = dt["Long"] {
						long = Double(lg as! String)!
					}
					let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
					let point = BusinessAnnotation(coordinate: coordinate, title: name, subtitle: "", uid: uid)
					points.append(point)
				}
			}
			completion(true, points)
		}
	}
	
	
}
