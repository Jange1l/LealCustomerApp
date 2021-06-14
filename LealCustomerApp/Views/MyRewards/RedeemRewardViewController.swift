//
//  RedeemRewardViewController.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/28/21.
//

import UIKit

class RedeemRewardViewController: UIViewController {
	
	@IBOutlet weak var qrCode: UIImageView!
	@IBOutlet weak var descriptionLabel: UILabel!
	
	var code: String!
	var reward: MDStructures.EarnedReward!
	
	var promo: MDStructures.Discount!
	
	lazy var confettiTypes: [ConfettiType] = {
		let confettiColors = [
			(r:149,g:58,b:255), (r:255,g:195,b:41), (r:255,g:101,b:26),
			(r:123,g:92,b:255), (r:76,g:126,b:255), (r:71,g:192,b:255),
			(r:255,g:47,b:39), (r:255,g:91,b:134), (r:233,g:122,b:208)
		].map { UIColor(red: $0.r / 255.0, green: $0.g / 255.0, blue: $0.b / 255.0, alpha: 1) }
		
		// For each position x shape x color, construct an image
		return [ConfettiPosition.foreground, ConfettiPosition.background].flatMap { position in
			return [ConfettiShape.rectangle, ConfettiShape.circle].flatMap { shape in
				return confettiColors.map { color in
					return ConfettiType(color: color, shape: shape, position: position)
				}
			}
		}
	}()
	
	lazy var confettiLayer: CAEmitterLayer = {
		let emitterLayer = CAEmitterLayer()
		
		emitterLayer.birthRate = 0
		emitterLayer.emitterCells = confettiCells
		emitterLayer.emitterPosition = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
		emitterLayer.emitterSize = CGSize(width: 100, height: 100)
		emitterLayer.emitterShape = .sphere
		emitterLayer.frame = view.bounds
		
		emitterLayer.beginTime = CACurrentMediaTime()
		return emitterLayer
	}()
	
	lazy var confettiCells: [CAEmitterCell] = {
		return confettiTypes.map { confettiType in
			let cell = CAEmitterCell()
			
			cell.beginTime = 0.1
			cell.birthRate = 100
			cell.contents = confettiType.image.cgImage
			cell.emissionRange = CGFloat(Double.pi)
			cell.lifetime = 5
			cell.spin = 4
			cell.spinRange = 8
			cell.velocityRange = 0
			cell.yAcceleration = 0
			
			// Step 3: A _New_ Spin On Things
			
			cell.setValue("plane", forKey: "particleType")
			cell.setValue(Double.pi, forKey: "orientationRange")
			cell.setValue(Double.pi / 2, forKey: "orientationLongitude")
			cell.setValue(Double.pi / 2, forKey: "orientationLatitude")
			
			return cell
		}
	}()
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		overrideUserInterfaceStyle = .dark
		
		NotificationCenter.default.addObserver(self, selector: #selector(functionName), name: Notification.Name("RedeemReward"), object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(functionName), name: Notification.Name("RedeemedPromo"), object: nil)
		
		if reward != nil {
			descriptionLabel.text = reward.rewardName
		}
		
		if promo != nil {
			descriptionLabel.text = promo.description
		}
		setQrCode()
		
	}
	override func viewDidAppear(_ animated: Bool) {
		
	}
	
	@objc func functionName (notification: NSNotification){
		view.layer.addSublayer(confettiLayer)
		addBehaviors()
		addAnimations()
	}
	
	func createBehavior(type: String) -> NSObject {
		let behaviorClass = NSClassFromString("CAEmitterBehavior") as! NSObject.Type
		let behaviorWithType = behaviorClass.method(for: NSSelectorFromString("behaviorWithType:"))!
		let castedBehaviorWithType = unsafeBitCast(behaviorWithType, to:(@convention(c)(Any?, Selector, Any?) -> NSObject).self)
		return castedBehaviorWithType(behaviorClass, NSSelectorFromString("behaviorWithType:"), type)
	}
	
	func horizontalWaveBehavior() -> Any {
		let behavior = createBehavior(type: "wave")
		behavior.setValue([100, 0, 0], forKeyPath: "force")
		behavior.setValue(0.5, forKeyPath: "frequency")
		return behavior
	}
	
	func verticalWaveBehavior() -> Any {
		let behavior = createBehavior(type: "wave")
		behavior.setValue([0, 500, 0], forKeyPath: "force")
		behavior.setValue(3, forKeyPath: "frequency")
		return behavior
	}
	
	func attractorBehavior(for emitterLayer: CAEmitterLayer) -> Any {
		let behavior = createBehavior(type: "attractor")
		
		// Attractiveness
		behavior.setValue(-290, forKeyPath: "falloff")
		behavior.setValue(300, forKeyPath: "radius")
		behavior.setValue(10, forKeyPath: "stiffness")
		
		// Position
		behavior.setValue(CGPoint(x: emitterLayer.emitterPosition.x,
								  y: emitterLayer.emitterPosition.y + 20),
						  forKeyPath: "position")
		behavior.setValue(-70, forKeyPath: "zPosition")
		behavior.setValue("attractor", forKeyPath: "name")
		return behavior
	}
	func addAttractorAnimation(to layer: CALayer) {
		let animation = CAKeyframeAnimation()
		animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
		animation.duration = 3
		animation.keyTimes = [0, 0.4]
		animation.values = [80, 5]
		
		layer.add(animation, forKey: "emitterBehaviors.attractor.stiffness")
	}
	
	func addBirthrateAnimation(to layer: CALayer) {
		let animation = CABasicAnimation()
		animation.duration = 1
		animation.fromValue = 1
		animation.toValue = 0
		
		layer.add(animation, forKey: "birthRate")
	}
	
	func addAnimations() {
		addAttractorAnimation(to: confettiLayer)
		addBirthrateAnimation(to: confettiLayer)
		let generator = UIImpactFeedbackGenerator(style: .heavy)
		generator.impactOccurred()
	}
	func addBehaviors() {
		confettiLayer.setValue([
			horizontalWaveBehavior(),
			verticalWaveBehavior(),
			attractorBehavior(for: confettiLayer)
		], forKey: "emitterBehaviors")
	}
	
	// MARK: QRCode logic
	
	func setQrCode() {
		var code = ""
		if reward != nil {
			code = "Rw_\(AccountDetails().getUid())_\(reward.rewardId)"
		}
		
		if promo != nil {
			code = "Pr_\(AccountDetails().getUid())_\(promo.postUid)"
		}
		generateQRCode(code: code)
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
		guard let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return }
		let processedImage = UIImage(cgImage: cgImage)
		
		qrCode.image = processedImage
	}
	
	
}
