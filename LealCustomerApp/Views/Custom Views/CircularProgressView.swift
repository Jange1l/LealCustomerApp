//
//  CircularProgressView.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/11/21.
//

import UIKit

class CircularProgressView: UIView {
	
	var progressLyr = CAShapeLayer()
	var trackLyr = CAShapeLayer()
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		makeCircularPath()
	}
	var progressClr = UIColor.white {
		didSet {
			progressLyr.strokeColor = progressClr.cgColor
		}
	}
	var trackClr = UIColor.white {
		didSet {
			trackLyr.strokeColor = trackClr.cgColor
		}
	}
	func makeCircularPath() {
		self.backgroundColor = UIColor.clear
		self.layer.cornerRadius = self.frame.size.width/2
		let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), radius: (frame.size.width - 1.5)/2, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)
		let circlePathRounded = UIBezierPath(arcCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), radius: (frame.size.width - 1.5)/2, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)
		trackLyr.path = circlePath.cgPath
		trackLyr.fillColor = UIColor.clear.cgColor
		trackLyr.strokeColor = trackClr.cgColor
		trackLyr.lineWidth = 5.0
		trackLyr.strokeEnd = 1.0
		layer.addSublayer(trackLyr)
		progressLyr.path = circlePathRounded.cgPath
		progressLyr.fillColor = UIColor.clear.cgColor
		progressLyr.strokeColor = progressClr.cgColor
		progressLyr.lineWidth = 10.0
		progressLyr.strokeEnd = 0.0
		progressLyr.lineCap = .round
		layer.addSublayer(progressLyr)
	}
	func setProgressWithAnimation(duration: TimeInterval, value: Float) {
		let animation = CABasicAnimation(keyPath: "strokeEnd")
		animation.duration = duration
		animation.fromValue = 0
		animation.toValue = value
		animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
		progressLyr.strokeEnd = CGFloat(value)
		progressLyr.add(animation, forKey: "animateprogress")
	}
	
}
