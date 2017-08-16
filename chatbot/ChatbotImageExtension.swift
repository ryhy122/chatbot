//
//  ChatbotImageExtension.swift
//  chatbot
//
//  Created by 新井崚平 on 2017/07/26.
//  Copyright © 2017年 新井崚平. All rights reserved.
//

import UIKit
import Photos
import JSQMessagesViewController
import Foundation

extension BotViewController {
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        selectImage()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func selectImage() {
        let alertController = UIAlertController(title: "Choose picture", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Activate Camera", style: .default) { (UIAlertAction) -> Void in
            self.selectFromCamera()
        }
        let libraryAction = UIAlertAction(title: "Choose from Cameraroll", style: .default) { (UIAlertAction) -> Void in
            self.selectFromLibrary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) -> Void in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func selectFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
        } else {
            print("カメラロール許可をしていない時の処理")
        }
//        
//        ImagePickerHandler.openImagePicker(completion: { (image) in
//            image.delegate = self
//            self.present(image, animated: true, completion: nil)
//        })
    }
    
    private func selectFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
        } else {
            print("カメラロール許可をしていない時の処理")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            showLabel(image: image)
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            showLabel(image: image)
        } else {
            print("error")
        }
        
        picker.dismiss(animated: true, completion: nil)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func showLabel(image: UIImage) {
        sendImageMessage(image: image)
        let binaryImageData = GoogleVisionAPI().base64EncodeImage(image)
        GoogleVisionAPI().createRequest(with: binaryImageData, completion: { (face, label) in
            DispatchQueue.main.async {
                self.add(sender: .bot, text: label)
                HistoryCoreModel.sharedInstance.add(word: nil, definition: nil, example: nil, picture: nil, image: image, photoResponse: label)
                let voca = VocabularyModel(word: nil, category: nil, image: image, label: label)
                UserVocabularyModel.sharedInstance.add(vocabulary: voca)
                print(voca.image ?? "nil")
                print(voca.label ?? "nil")
                print(UserVocabularyModel.sharedInstance.getData().count)
                self.collectionView.reloadData()
            }
        })
        sleep(1)
        self.add(sender: .bot, text: "Ok, this is vocabulary I could find in this picture")
    }

    private func sendImageMessage(image: UIImage) {
        add(sender: .user, image: image)
        self.finishSendingMessage(animated: true)
        self.finishReceivingMessage(animated: true)
        self.receiveAutoMessage()
        print("Did send message")
    }
    
    func imageTapped(image: UIImage) {
        let newImageView = UIImageView(image: image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
}
