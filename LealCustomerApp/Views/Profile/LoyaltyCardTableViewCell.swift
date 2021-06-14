//
//  LoyaltyCardTableViewCell.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/3/21.
//

import UIKit

class LoyaltyCardTableViewCell: UITableViewCell {
	
	@IBOutlet weak var bgView: UIView!
	
	@IBOutlet weak var bgImage: UIImageView!
	
	@IBOutlet weak var miniQr: UIImageView!
	
	static let identifier = "LoyaltyCard"
	static let name = "LoyaltyCardTableViewCell"
	
	var networking = BusinessProfileNetworking()
	var profile: MDStructures.BusinessAccountDetails!
	
	var lp: MDStructures.LoyaltyProgram!
	var clp: MDStructures.LoyaltyProgramDetails!
	
	@IBOutlet weak var pointsCircle: CircularProgressView!
	
	@IBOutlet weak var bNameLabel: UILabel!
	@IBOutlet weak var cNameLabel: UILabel!
	@IBOutlet weak var joinedLabel: UILabel!
	@IBOutlet weak var currentPointsLabel: UILabel!
	@IBOutlet weak var levelLabel: UILabel!
	@IBOutlet weak var qrButtonLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
		self.selectionStyle = .none
	}
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
	}
	
	
	func generateQRCode(code: String) {
		// Get define string to encode
		let myString = code
		// Get data from the string
		let data = myString.data(using: String.Encoding.ascii)
		// Get a QR CIFilter
		guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return }
		// Input the data
		qrFilter.setValue(data, forKey: "inputMessage")
		// Get the output image
		guard let qrImage = qrFilter.outputImage else { return }
		// Scale the image
		let transform = CGAffineTransform(scaleX: 10, y: 10)
		let scaledQrImage = qrImage.transformed(by: transform)
		// Invert the colors
		guard let colorInvertFilter = CIFilter(name: "CIColorInvert") else { return }
		colorInvertFilter.setValue(scaledQrImage, forKey: "inputImage")
		guard let outputInvertedImage = colorInvertFilter.outputImage else { return }
		// Replace the black with transparency
		guard let maskToAlphaFilter = CIFilter(name: "CIMaskToAlpha") else { return }
		maskToAlphaFilter.setValue(outputInvertedImage, forKey: "inputImage")
		guard let outputCIImage = maskToAlphaFilter.outputImage else { return }
		// Do some processing to get the UIImage
		let context = CIContext()
		guard let cgm = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return }
		let processedImage = UIImage(cgImage: cgm)
		
		miniQr.image = processedImage
		
	}
	
	func updateCell(profile: MDStructures.BusinessAccountDetails, blp: MDStructures.LoyaltyProgram, clp: MDStructures.LoyaltyProgramDetails) {
		
		self.profile = profile
		print("Business name in business profile view -> ",profile.businessName)
		self.lp = blp
		self.clp = clp
		print("LOYALTY PROGRAMS INFO -> ",clp, blp)
		setLoyaltyProgram(lp: blp)
	
	}
	
	func updateMyCards(x: MDStructures.LoyaltyProgramDetails) {
		clp = x
		bNameLabel.text = x.businessName
		cNameLabel.text = AccountDetails().getCustomerName()
		joinedLabel.text = "2021"
		levelLabel.text = "Level \(x.currentStep) of \(x.numberOfSteps)"
		currentPointsLabel.text = x.points
		qrButtonLabel.text = "Tap To View"
		
		self.generateQRCode(code: "lp_\(AccountDetails().getUid())")
		self.pointsCircle.trackClr = UIColor.white
		self.pointsCircle.progressClr = UIColor.green
		
		self.bgView.layer.cornerRadius = 15
		self.bgImage.layer.cornerRadius = 15
		
		let percent = Float(x.points)! /  Float(x.pointsPerStep)!
		
		self.pointsCircle.setProgressWithAnimation(duration: 3, value: Float(percent))
	}
	
	
	
	func setLoyaltyProgram(lp: MDStructures.LoyaltyProgram) {
		
		if profile.isFollowed {
			
			bNameLabel.text = profile.businessName
			cNameLabel.text = AccountDetails().getCustomerName()
			joinedLabel.text = "2021"
			levelLabel.text = "Level \(clp.currentStep) of \(lp.numberOfSteps!)"
			currentPointsLabel.text = clp.points
			qrButtonLabel.text = "Tap To View"
			
			self.generateQRCode(code: "lp_\(AccountDetails().getUid())")
			self.pointsCircle.trackClr = UIColor.white
			self.pointsCircle.progressClr = UIColor.green
			
			self.bgView.layer.cornerRadius = 15
			self.bgImage.layer.cornerRadius = 15
			
			let percent = Float(clp.points)! /  Float(lp.pointsPerStep)!
			
			self.pointsCircle.setProgressWithAnimation(duration: 3, value: Float(percent))
		} else {
			bNameLabel.text = profile.businessName
			cNameLabel.text = AccountDetails().getCustomerName()
			joinedLabel.text = "Not Joined"
			levelLabel.text = "Level 1 of \(lp.numberOfSteps!)"
			currentPointsLabel.text = lp.pointsPerStep
			qrButtonLabel.text = "Join Today!"
			
			self.pointsCircle.trackClr = UIColor.white
			self.pointsCircle.progressClr = UIColor.green
			
			self.bgView.layer.cornerRadius = 15
			self.bgImage.layer.cornerRadius = 15
			self.pointsCircle.setProgressWithAnimation(duration: 3, value: 0)
		}
		
	}
	
}
