//
//  QRCodeViewController.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/21/21.
//

import UIKit

class QRCodeViewController: UIViewController {

	@IBOutlet weak var image: UIImageView!
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var memberLabel: UILabel!
	
	var blp: LoyaltyProgramManager!
	var userIsFollowing: Bool!
	
	override func viewDidLoad() {
		
        super.viewDidLoad()
		overrideUserInterfaceStyle = .dark
		setCollectionView()
		updateCollectionView()
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
		
		image.image = processedImage
	}
	
	func setNibs() {
		
		let cellNib = UINib(nibName: RewardDescriptionCollectionViewCell.name, bundle: nil)
		self.collectionView.register(cellNib, forCellWithReuseIdentifier: RewardDescriptionCollectionViewCell.identifier)
	}
	
	func setCollectionView() {
		
		// TODO: need to setup collection view flow layout
		let flowLayout = UICollectionViewFlowLayout()
		flowLayout.scrollDirection = .horizontal
		flowLayout.itemSize = CGSize(width: 150, height: 150)
		flowLayout.minimumLineSpacing = 5.0
		flowLayout.minimumInteritemSpacing = 10.0
		self.collectionView.collectionViewLayout = flowLayout
		self.collectionView.showsHorizontalScrollIndicator = false
		
		// Comment if you set Datasource and delegate in .xib
		self.collectionView.dataSource = self
		self.collectionView.delegate = self
		setNibs()
	}
	
	func updateCollectionView() {
		
		if userIsFollowing {
			let code = "lp_\(AccountDetails().getUid())"
			generateQRCode(code: code)
			
			
		} else {
			memberLabel.text = "Not a member"
			memberLabel.tintColor = UIColor.systemRed
			
			
		}
		
	}
	

}

extension QRCodeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if blp != nil {
			return blp.lp.steps.count
		}
		return 0
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RewardDescriptionCollectionViewCell.identifier, for: indexPath) as? RewardDescriptionCollectionViewCell {
			
			cell.updateCell(step: blp.lp.steps[indexPath.row])
			
			return cell
		}
		return UICollectionViewCell()
	}
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return 1
	}
	
	// Add spaces at the beginning and the end of the collection view
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
	}
}

