//
//  SearchViewController.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/4/21.
//

import UIKit
import MapKit

class SearchViewController: UIViewController, CLLocationManagerDelegate {
	
	@IBOutlet weak var mapView: MKMapView!
	
	var networking: SearchNetworking!
	var locationData: [BusinessAnnotation]!
	
	var locationManager: CLLocationManager!
	
	let regionInMeters: Double = 1000
	var userLocation: CLLocation?
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		overrideUserInterfaceStyle = .dark
		setView()
		populateMap()
		getCurrentLocation()
		
	}
	
	
	func setView() {
		networking = SearchNetworking()
		
	}
	
	func getCurrentLocation()
	{
		if (CLLocationManager.locationServicesEnabled())
		{
			print("starting location manager")
			locationManager = CLLocationManager()
			locationManager.delegate = self
			locationManager.desiredAccuracy = kCLLocationAccuracyBest
			locationManager.requestAlwaysAuthorization()
			locationManager.startUpdatingLocation()
			mapView.showsUserLocation  = true
			centerViewOnUserLocation()
		}
	}
	
	func centerViewOnUserLocation () {
		if let location = locationManager.location?.coordinate {
			let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
			mapView.setRegion(region, animated: true)
		}
	}
	
	func populateMap() {
		networking.getBusinesses(completion: {(status, points) in
			
			self.mapView.addAnnotations(points)
		})
	}
	
}

extension SearchViewController: MKMapViewDelegate {
	func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
		self.userLocation = userLocation.location
	}
	
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		let anot = view.annotation!.coordinate
		
		if let user = userLocation {
			if anot.longitude !=  user.coordinate.longitude && anot.latitude != user.coordinate.latitude {
				let anot = view.annotation as! BusinessAnnotation
				print("Annotation tapped", anot.uid)
				let storyboard = UIStoryboard(name: "Main", bundle: nil)
				let secondVC = storyboard.instantiateViewController(identifier: "businessProfile") as! BusinessProfileViewController
				
				secondVC.businessUid = anot.uid
				
				secondVC.modalPresentationStyle = .popover
				secondVC.modalTransitionStyle = .coverVertical
				
				present(secondVC, animated: true, completion: nil)
			}
		}
		
		
	}
}

