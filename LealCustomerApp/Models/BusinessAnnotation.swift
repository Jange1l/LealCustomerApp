//
//  BusinessAnnotation.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/9/21.
//

import Foundation
import MapKit

class BusinessAnnotation: NSObject, MKAnnotation {
	var coordinate: CLLocationCoordinate2D
	var title: String?
	var subtitle: String?
	var uid: String
	
	init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, uid: String) {
		self.coordinate = coordinate
		self.title = title
		self.subtitle = subtitle
		self.uid = uid
	}
}
