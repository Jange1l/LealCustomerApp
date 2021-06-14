//
//  ProfileStructureViewController.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/3/21.
//

import UIKit
import Firebase

class ProfileStructureViewController: UIViewController {
	
	@IBOutlet weak var tableView: UITableView!
	let myCardsSegue = "MyLoyaltyCards"
	let redeemRewardSegue = "RedeemReward"
	let announcementSegue = "AnnouncementSegue"
	let allAnnouncementsSegue = "AllAnnouncements"
	
	var customerProfile: MDStructures.AccountDetails!
	
	var upComingRewards: [MDStructures.LPStep]!
	
	var myLoyaltyPrograms: [MDStructures.LoyaltyProgramDetails]!
	
	var myEarnedRewards: [MDStructures.EarnedReward]!
	
	var myAnnouncements: [MDStructures.Announcement]!
	
	var tappedRewardToRedeem: MDStructures.EarnedReward!
	
	var tappedAnnouncement: MDStructures.Announcement!
	
	var listener: ListenerRegistration!
	
	var lpAndAListener: ListenerRegistration!
	var accountListener: ListenerRegistration!
	var lpListener:ListenerRegistration!
	var rewardsListener: ListenerRegistration!
	
	var accountNetworking: AccountDetailsNetworking!
	var loyaltyProgramNetworking: LoyaltyProgramNetworking!
	var businessProfileNetworking: BusinessProfileNetworking!
	var activityNetworking: ActivityNetworking!
	var accountDetails: AccountDetails!
	
	@IBOutlet weak var activity: UIActivityIndicatorView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		accountNetworking = AccountDetailsNetworking()
		loyaltyProgramNetworking = LoyaltyProgramNetworking()
		businessProfileNetworking = BusinessProfileNetworking()
		activityNetworking = ActivityNetworking()
		accountDetails = AccountDetails()
		overrideUserInterfaceStyle = .dark
		setNibs()
		setFCMToken()
		getData()
		addSnapShotListeners()
		
	}
	func addSnapShotListeners() {
		
		accountListener = LCons.AccountDetailsRef.addSnapshotListener({(snap, err) in
			guard snap != nil else {
				print("Error fetching snapshots: \(err!)")
				return
			}
			if self.customerProfile != nil {
				self.updateProfile()
			}
			
		})
		
		lpListener = LCons.AccountDetailsRef.collection("LoyaltyPrograms").addSnapshotListener { querySnapshot, error in
			guard let snapshot = querySnapshot else {
				print("Error fetching snapshots: \(error!)")
				return
			}
			snapshot.documentChanges.forEach { diff in
				if (diff.type == .added) {
					print("New loyalty program: \(diff.document.data())")
					if self.myLoyaltyPrograms != nil {
						self.updateLoyaltyPrograms()
						
					}
					
				}
				if (diff.type == .modified) {
					print("Modified loyalty program: \(diff.document.data())")
					if self.myLoyaltyPrograms != nil {
						self.updateLoyaltyPrograms()
					}
				}
				if (diff.type == .removed) {
					print("Removed loyalty program: \(diff.document.data())")
					
					if self.myLoyaltyPrograms != nil {
						self.updateLoyaltyPrograms()
						
					}
					
					
				}
			}
		}
		
		rewardsListener = LCons.AccountDetailsRef.collection("EarnedRewards").addSnapshotListener { querySnapshot, error in
			guard let snapshot = querySnapshot else {
				print("Error fetching snapshots: \(error!)")
				return
			}
			snapshot.documentChanges.forEach { diff in
				let data = diff.document.data()
				
				if (diff.type == .added) {
					print("New EARNED REWARD: \(data)")
					if self.myEarnedRewards != nil {
						self.addEarnedReward()
					}
					
				}
				if (diff.type == .modified) {
					
				}
				if (diff.type == .removed) {
					
					print("Removed reward: \(diff.document.data())")
					print("REMOVED REWARD DOCUMENT!! **********************")
					
					let removedRewardId = data["rewardId"] as! String
					let businessId = data["businessUid"] as! String
					let rewardNumber = data["rewardNumber"] as! String
					
					if self.myEarnedRewards != nil {
						let index = self.myEarnedRewards.firstIndex{ $0.rewardId == removedRewardId}
						self.addValue(businessId: businessId, rewardNumber: rewardNumber)
						self.myEarnedRewards.remove(at: index!)
					}
					
					NotificationCenter.default.post(name: Notification.Name("RedeemReward"), object: nil)
					self.tableView.reloadData()
				}
			}
		}
	}
	
	func addValue(businessId:String, rewardNumber: String) {
		// get value of reward
		var value = ""
		loyaltyProgramNetworking.fetchCurrentLoyaltyProgram(uid: businessId, completion: {(status, program) in
			for i in program.steps {
				if i.stepNumber == rewardNumber {
					value = i.value
				}
			}
			
			LCons.AccountDetailsRef.getDocument { (document, err) in
				var totalSaved = 0.0
				if let err = err {
					print("Error getting documents for user information: \(err)")
					
				} else {
					if let document = document, document.exists {
						
						let data = document.data()
						let currentSaved = data!["TotalSaved"] as! String
						totalSaved = Double(currentSaved)! + Double(value)!
						
					}
				}
				//let newTotal = Double(totalSaved)! + Double(x)!
				LCons.AccountDetailsRef.updateData([
					"TotalSaved" : "\(totalSaved)"
				]){ err in
					if let err = err {
						print("Error updating document: \(err)")
					} else {
						print("Document successfully updated")
						self.updateProfile()
					}
				}
			}
		})
		
	}
	
	func addEarnedReward() {
		loyaltyProgramNetworking.fetchEarnedRewards(completion: {(s, earnedRewards) in
			
			self.loyaltyProgramNetworking.fetchEarnedRewardsDetails(rewards: earnedRewards, completion: {(s, earnedRewardDetails) in
				
				if s != false {
					self.myEarnedRewards = earnedRewardDetails
				} else {
					self.myEarnedRewards = []
				}
				self.tableView.reloadData()
			})
			
		})
		
	}
	
	func updateLoyaltyPrograms() {
		print("UPDATE LOYALTY PROGRAM TRIGGERED")
		loyaltyProgramNetworking.fetchAllUpComingRewards(completion: {(status, programs) in
			
			self.myLoyaltyPrograms = programs
			
			self.loyaltyProgramNetworking.fetchUpComingRewardsDetails(programs: programs, completion: {(status, steps) in
				
				if status != false {
					self.upComingRewards = steps
					
				} else {
					self.upComingRewards = []
				}
				
				self.businessProfileNetworking.fetchAnnouncements(completion: {(ans, announ) in
					print("Tier 6")
					self.activityNetworking.getPictureForAnnouncement(dArray: announ, completion: {(ansp, anounp) in
						
						print("Tier 7")
						
						if ansp != false {
							
							self.myAnnouncements = anounp
						} else {
							self.myAnnouncements = []
						}
						self.tableView.reloadData()
					})
				})
				
			})
			
		})
		
	}
	func updateProfile() {
		
		accountNetworking.getAccountDocument(completion: {(s,p) in
			self.customerProfile = p
			self.tableView.reloadData()
		})
		
	}
	
	func updateAnnouncements() {
		businessProfileNetworking.fetchAnnouncements(completion: {(ans, announ) in
			print("Tier 6")
			self.activityNetworking.getPictureForAnnouncement(dArray: announ, completion: {(ansp, anounp) in
				
				print("Tier 7")
				
				if ansp != false {
					
					self.myAnnouncements = anounp
				} else {
					self.myAnnouncements = []
				}
				self.tableView.reloadData()
			})
		})
		
	}
	
	@objc func appMovedToBackground() {
		accountListener.remove()
		lpListener.remove()
		rewardsListener.remove()
	}
	
	func setNibs() {
		
		let header = UINib(nibName: "CHeaderTableViewCell", bundle: nil)
		self.tableView.register(header, forCellReuseIdentifier: "CHeaderCell")
		
		let announcements = UINib(nibName: "AnnouncementsTableViewCell", bundle: nil)
		self.tableView.register(announcements, forCellReuseIdentifier: "AnnounCell")
		
		let nextRewards = UINib(nibName: "UPComingRewardsTableViewCell", bundle: nil)
		self.tableView.register(nextRewards, forCellReuseIdentifier: "UPComingCell")
		
		let loyaltyCard = UINib(nibName: TotalSavedTableViewCell.name, bundle: nil)
		self.tableView.register(loyaltyCard, forCellReuseIdentifier: TotalSavedTableViewCell.identifier)
		
		let myCards = UINib(nibName: MyCardsTableViewCell.name, bundle: nil)
		self.tableView.register(myCards, forCellReuseIdentifier: MyCardsTableViewCell.identifier)
		
		let earnedRewards = UINib(nibName: EarnedRewardsTableViewCell.name, bundle: nil)
		self.tableView.register(earnedRewards, forCellReuseIdentifier: EarnedRewardsTableViewCell.identifier)
	}
	
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if segue.identifier == myCardsSegue {
			if let myCardsViewController = segue.destination as? MyLoyaltyCardsViewController {
				myCardsViewController.myCards = myLoyaltyPrograms
			}
		}
		if segue.identifier == redeemRewardSegue {
			if let redeemEarnedReward = segue.destination as? RedeemRewardViewController {
				redeemEarnedReward.reward = tappedRewardToRedeem
			}
		}
		
		if segue.identifier == announcementSegue {
			
			if let announcementView = segue.destination as? AnnouncementExpandedViewController {
				announcementView.announcement = tappedAnnouncement
			}
		}
		
		if segue.identifier == allAnnouncementsSegue {
			if let allAnnouncementsView = segue.destination as? AllAnnouncementsViewController {
				allAnnouncementsView.announcements = myAnnouncements
			}
		}
	}
	
	func setFCMToken() {
		InstanceID.instanceID().instanceID {(result, error) in
			if let error = error {
				print("Error fetching remote instange ID: \(error)")
			} else if let result = result {
				// Updating the toke in the database for the user
				
				self.accountDetails.setNotificationToken(notifToken: result.token)
				self.accountNetworking.updateUserFCMToken()
				
				print("Remote instance ID token: \(result.token)")
			}
		}
	}
	
	func getData() {
		activity.startAnimating()
		accountNetworking.getAccountDocument(completion: {(status, profile) in
			self.customerProfile = profile
			print("Tier 1")
			self.loyaltyProgramNetworking.fetchAllUpComingRewards(completion: {(status, programs) in
				print("Tier 2")
				self.myLoyaltyPrograms = programs
				
				self.loyaltyProgramNetworking.fetchUpComingRewardsDetails(programs: programs, completion: {(status, steps) in
					print("Tier 3")
					if status != false {
						self.upComingRewards = steps
						
					} else {
						self.upComingRewards = []
					}
					
					self.loyaltyProgramNetworking.fetchEarnedRewards(completion: {(s, earnedRewards) in
						print("Tier 4")
						self.loyaltyProgramNetworking.fetchEarnedRewardsDetails(rewards: earnedRewards, completion: {(s, earnedRewardDetails) in
							print("Tier 5")
							
							if s != false {
								self.myEarnedRewards =  earnedRewardDetails
							} else {
								self.myEarnedRewards = []
							}
							
							self.businessProfileNetworking.fetchAnnouncements(completion: {(ans, announ) in
								print("Tier 6")
								self.activityNetworking.getPictureForAnnouncement(dArray: announ, completion: {(ansp, anounp) in
									
									print("Tier 7")
									
									if ansp != false {
										//self.myAnnouncements = self.sortAnnouncements(x: anounp)
										self.myAnnouncements = anounp
										
									} else {
										self.myAnnouncements = []
									}
									
									self.activity.stopAnimating()
									self.activity.isHidden = true
									self.tableView.reloadData()
								})
							})
						})
					})
					
				})
			})
			
		})
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
			
			announcements.append(a)
		}
		return announcements
	}
	
	func showAlert() {
		let generator = UIImpactFeedbackGenerator(style: .heavy)
		generator.impactOccurred()
		
		let alert = UIAlertController(title: "Total Saved", message: "This shows how much you saved by using your loyalty cards!", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
			NSLog("The \"OK\" alert occured.")
			
			let gen = UINotificationFeedbackGenerator()
			gen.notificationOccurred(.warning)
		}))
		
		self.present(alert, animated: true, completion: nil)
	}
}

extension ProfileStructureViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 6
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		switch indexPath.row {
			case 0:
				if let cell = tableView.dequeueReusableCell(withIdentifier: "CHeaderCell") as? CHeaderTableViewCell {
					
					cell.clicked = {
						value in
						self.performSegue(withIdentifier: "Settings", sender: nil)
						//fatalError()
					}
					
					if customerProfile != nil {
						cell.updateCell(profile: customerProfile)
					}
					
					return cell
				}
			case 1:
				
				if upComingRewards != nil {
					
					if upComingRewards.isEmpty == false {
						if let cell = tableView.dequeueReusableCell(withIdentifier: "UPComingCell") as? UPComingRewardsTableViewCell {
							
							
							cell.updateCell(steps: upComingRewards, myPrograms: myLoyaltyPrograms)
							
							
							return cell
						}
					} else {
						if let cell = tableView.dequeueReusableCell(withIdentifier: MyCardsTableViewCell.identifier) as? MyCardsTableViewCell {
							cell.cellTittleLabel.text = "Follow businesses in the home page to start earning rewards 😎"
							cell.hintLabel.text = "Hint!"
							cell.cellTittleLabel.textColor = UIColor.black
							cell.bView.backgroundColor = #colorLiteral(red: 0.5289696455, green: 0.7367745042, blue: 0.6367554069, alpha: 1)
							return cell
						}
					}
				}
				
				
			case 2:
				
				if myEarnedRewards != nil {
					print(myEarnedRewards.isEmpty)
					if myEarnedRewards.isEmpty == false {
						if let cell = tableView.dequeueReusableCell(withIdentifier: EarnedRewardsTableViewCell.identifier) as? EarnedRewardsTableViewCell {
							
							if myEarnedRewards != nil {
								cell.updateCell(x: myEarnedRewards)
								cell.cellDelegate = self
							}
							
							return cell
						}
					} else {
						if let cell = tableView.dequeueReusableCell(withIdentifier: MyCardsTableViewCell.identifier) as? MyCardsTableViewCell {
							cell.cellTittleLabel.text = "Use your loyalty cards below to unlock rewards! 🎉"
							cell.hintLabel.text = "Hint!"
							cell.cellTittleLabel.textColor = UIColor.white
							cell.bView.backgroundColor = #colorLiteral(red: 0.1787385941, green: 0.1939829588, blue: 0.2979035676, alpha: 1)
							
							return cell
						}
					}
				}
				
				
				
			case 3 :
				
				if let cell = tableView.dequeueReusableCell(withIdentifier: MyCardsTableViewCell.identifier) as? MyCardsTableViewCell {
					cell.cellTittleLabel.text = "My Loyalty Cards"
					
					cell.cellTittleLabel.textColor = UIColor.white
					cell.bView.backgroundColor = UIColor.systemPurple
					cell.bView.layer.borderColor = UIColor.white.cgColor
					cell.bView.layer.borderWidth = 2
					return cell
				}
				
			case 4:
				if let cell = tableView.dequeueReusableCell(withIdentifier: TotalSavedTableViewCell.identifier) as? TotalSavedTableViewCell {
					
					if customerProfile != nil {
						cell.updateCell(x: customerProfile)
					}
					return cell
				}
			case 5:
				if let cell = tableView.dequeueReusableCell(withIdentifier: "AnnounCell") as? AnnouncementsTableViewCell {
					
					if myAnnouncements != nil {
						cell.updateCell(x: myAnnouncements)
						cell.cellDelegate = self
					}
					cell.viewAll = {
						value in
						self.performSegue(withIdentifier: self.allAnnouncementsSegue, sender: self)
					}
					return cell
				}
			default:
				return UITableViewCell()
		}
		
		return UITableViewCell()
		
	}
	
	
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch indexPath.row {
			case 0:
				return 214
			case 1:
				return 210
			case 2:
				return 210
			case 3:
				return 200
			case 5:
				// if count % 2 -> count * 200
				// if count % 3 -> count * 300
				return 540
			default:
				return 200
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.row == 3 {
			performSegue(withIdentifier: myCardsSegue, sender: nil)
		}
		if indexPath.row == 4 {
			showAlert()
		}
		
		
	}
	
}

extension ProfileStructureViewController: EarnedRewardCellDelegate {
	func collectionView(collectionviewcell: RewardCollectionViewCell?, index: Int, didTappedInTableViewCell: EarnedRewardsTableViewCell) {
		print("Tapped registered")
		if let rewards = didTappedInTableViewCell.earnedRewards {
			self.tappedRewardToRedeem = rewards[index]
			performSegue(withIdentifier: redeemRewardSegue, sender: self)
		}
	}
	
	
}


extension ProfileStructureViewController: AnnouncementCellDelegate {
	
	func collectionView(collectionviewcell: AnnounCellCollectionViewCell?, index: Int, didTappedInTableViewCell: AnnouncementsTableViewCell) {
		print("Tapped element")
		if let rewards = didTappedInTableViewCell.announcements {
			self.tappedAnnouncement = rewards[index]
			performSegue(withIdentifier: announcementSegue, sender: self)
		}
	}
	
	
}
