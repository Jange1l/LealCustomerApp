//
//  CHeaderTableViewCell.swift
//  LealCustomerApp
//
//  Created by Juan escobar on 2/10/21.
//

import UIKit
import Firebase

class CHeaderTableViewCell: UITableViewCell, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	@IBOutlet weak var logoImage: UIImageView!
	
	var clicked: ((_ value: String) -> ())?
	
	@IBOutlet weak var followingCount: UILabel!
	
	@IBOutlet weak var nameLabel: UILabel!
	
	let storage = Storage.storage().reference()
	
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		self.selectionStyle = .none
		logoImage.layer.cornerRadius = 45
		logoImage.layer.borderWidth = 2
		logoImage.layer.borderColor = UIColor.systemGray6.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
	@IBAction func settingsPressed(_ sender: Any) {
		clicked?("Clicked")
	}
	
	
	func updateCell(profile: MDStructures.AccountDetails) {
		followingCount.text = profile.followersCount
		nameLabel.text = profile.name
		
		if profile.profileImageUrl != "" {
			logoImage.image = profile.profileImage
		
		}
		
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		
		if let possibleImage = info[.editedImage] as? UIImage {
			logoImage.image = possibleImage
			saveChanges()
			print("EDITED IMAGE")
		} else if let possibleImage = info[.originalImage] as? UIImage {
			logoImage.image = possibleImage
			print("ORIGINAL IMAGE")
		} else {
			return
		}
		
		
		// do something interesting here
		self.window?.rootViewController?.dismiss(animated: true)
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		self.window?.rootViewController?.dismiss(animated: true, completion: nil)
	}
	
	
	@IBAction func changeImagePressed(_ sender: Any) {
		
		let picker = UIImagePickerController()
		picker.sourceType = .photoLibrary
		picker.delegate = self
		picker.allowsEditing = true
		self.window?.rootViewController?.present(picker, animated: true)
	}
	
	func saveChanges() {
		guard let imageData = logoImage.image?.jpegData(compressionQuality: 0.5) else {
			return
		}
		let storage = Storage.storage().reference()
		let profileImagesRef = storage.child("CustomerProfileImages")
		let profile = profileImagesRef.child(AccountDetails().getUid())
		
		let metaData = StorageMetadata()
		metaData.contentType = "image/jpg"
		
		profile.putData(imageData, metadata: metaData, completion: {(storageMetaData, error) in
			if error != nil {
				print(error?.localizedDescription)
				return
			}
			
			profile.downloadURL(completion: {(url, error) in
				if let metaImgeUrl = url?.absoluteString {
					
					
					if self.logoImage.image != nil {
						LCons.AccountDetailsRef.updateData(
							[
								"ProfileUrl" : "\(metaImgeUrl)"
							])
						
						AccountDetails().setProfilePUrl(profileUr: metaImgeUrl)
					}
					
					
					
					
				}
			})
			
		})
	}
	
}
