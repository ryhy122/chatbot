//
//  ImagePickerHandler.swift
//  chatbot
//
//  Created by 新井崚平 on 2017/08/04.
//  Copyright © 2017年 新井崚平. All rights reserved.
//

import Foundation
import ImagePicker

class ImagePickerHandler {
    
    class func openImagePicker(completion: @escaping ((ImagePickerController) -> Void)) {
        let imagePickerController = ImagePickerController()
        imagePickerController.imageLimit = 1
        var config = Configuration()
        config.doneButtonTitle = "Finish"
        config.noImagesTitle = "Sorry! There are no images here!"
        config.recordLocation = false
        config.allowMultiplePhotoSelection = false
        imagePickerController.configuration = config
        completion(imagePickerController)
    }
}

extension BotViewController: ImagePickerDelegate {
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        guard images.count > 0 else { return }
        
//        let lightboxImages = images.map {
//            return LightboxImage(image: $0)
//        }
//        
//        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
//        imagePicker.present(lightbox, animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
        HistoryCoreModel.sharedInstance.add(word: nil, definition: nil, example: nil, picture: nil, image: images[0], photoResponse: nil)
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
}
