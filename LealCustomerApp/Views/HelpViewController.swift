//
//  HelpViewController.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 4/12/21.
//

import UIKit

class HelpViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

	@IBAction func callPressed(_ sender: Any) {
		if let phoneCallURL = URL(string: "tel://6463016004") {
		  print("phone works?", phoneCallURL)
		  let application:UIApplication = UIApplication.shared
		  if (application.canOpenURL(phoneCallURL)) {
			  application.open(phoneCallURL, options: [:], completionHandler: nil)
		  }
		}
	}
	

}
