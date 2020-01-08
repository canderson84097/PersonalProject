//
//  PhotoSelectorViewController.swift
//  MediaSearch
//
//  Created by Chris Anderson on 1/6/20.
//  Copyright © 2020 Renaissance Apps. All rights reserved.
//

protocol PhotoSelectorDelegate: class {
    func photoSelectorVCSelected(image: UIImage)
}

import UIKit

class PhotoSelectorViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var selectPhotoButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    // MARK: - Properties
    
    weak var delegate: PhotoSelectorDelegate?
    
    // MARK: - Life Cycle Methods

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // MARK: - Actions
    
    @IBAction func selectPhotoButtonPressed(_ sender: Any) {
        presentImagePickerActionSheet()
    }
}

extension PhotoSelectorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectPhotoButton.setTitle("", for: .normal)
            profileImage.image = photo
            delegate?.photoSelectorVCSelected(image: photo)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func presentImagePickerActionSheet() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let actionSheet = UIAlertController(title: "Choose A Photo", message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            actionSheet.addAction(UIAlertAction(title: "Photos", style: .default, handler: { (_) in
                imagePickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
                self.present(imagePickerController, animated: true, completion: nil)
            }))
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
                imagePickerController.sourceType = UIImagePickerController.SourceType.camera
                self.present(imagePickerController, animated: true, completion: nil)
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
}
