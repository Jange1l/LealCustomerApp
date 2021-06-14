//
//  MyLoyaltyCardsViewController.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/21/21.
//

import UIKit

class MyLoyaltyCardsViewController: UIViewController {
	
	
	static let identifier = "MyLoyaltyCards"
	
	@IBOutlet weak var tableView: UITableView!
	var myCards: [MDStructures.LoyaltyProgramDetails]!
	
	var lpManager: LoyaltyProgramManager!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		overrideUserInterfaceStyle = .dark
		setNibs()
	}
	
	func setNibs() {
		let card = UINib(nibName: LoyaltyCardTableViewCell.name, bundle: nil)
		self.tableView.register(card, forCellReuseIdentifier:LoyaltyCardTableViewCell.identifier)
	}
	
	func getData() {
		LoyaltyProgramNetworking().fetchAllUpComingRewards(completion: {(status, programs) in
			self.myCards = programs
			self.tableView.reloadData()
		})
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "QRCode" {
			if let loyaltyCardDetails = segue.destination as? QRCodeViewController {
				loyaltyCardDetails.userIsFollowing = true
				loyaltyCardDetails.blp = lpManager
			}
		}
	}
}

extension MyLoyaltyCardsViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if myCards != nil {
			return myCards.count
		}
		return 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: LoyaltyCardTableViewCell.identifier) as? LoyaltyCardTableViewCell {
			
			if myCards != nil {
				cell.updateMyCards(x: myCards[indexPath.row])
			}
			return cell
		}
		return UITableViewCell()
		
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 250
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let index = tableView.indexPathForSelectedRow!
		let cell = tableView.cellForRow(at: index) as? LoyaltyCardTableViewCell
		
		LoyaltyProgramManager().getCurrentLoyaltyProgram(uid: (cell?.clp.businessUid)!, completion: {(s, lp) in
			self.lpManager = lp
			self.performSegue(withIdentifier: "QRCode", sender: nil)
		})
	}
}
