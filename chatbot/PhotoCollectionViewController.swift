//
//  PhotoCollectionViewController.swift
//  chatbot
//
//  Created by 新井崚平 on 2017/07/23.
//  Copyright © 2017年 新井崚平. All rights reserved.
//

import TRMosaicLayout
import UIKit
import Photos
import RAReorderableLayout

private let reuseIdentifier = "Cell"

class PhotoCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, RAReorderableLayoutDelegate, RAReorderableLayoutDataSource, UIImagePickerControllerDelegate {
    
    var data : [UserVocabulary] = []
    var imageData: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        
        fetchImages()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchImages()
    }
    
    func fetchImages() {
        DispatchQueue.main.async {
            let images = UserVocabularyModel.sharedInstance.getData()
            var tempData = [UIImage]()
            images.forEach { (vocabulary) in
                if vocabulary.image != nil {
                    if let image = UIImage(data: vocabulary.image! as Data) {
                        tempData.append(image)
                    }
                }
            }
            
            self.imageData = tempData.reversed()
            self.collectionView?.reloadData()
        }
    }
    
    func fetchData() -> [UserVocabulary] {
        data = UserVocabularyModel.sharedInstance.getData()
        return data.reversed()
    }

    

    func heightForSmallMosaicCell() -> CGFloat {
        return 100
    }
    
    @IBAction func takePhoto(_ sender: UIBarButtonItem) {
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
        
        present(alertController, animated: true, completion:nil)
    }
    
    private func selectFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
            imagePickerController.allowsEditing = true
            self.present(imagePickerController, animated: true, completion: nil)
        } else {
            print("カメラ許可をしていない時の処理")
        }
    }
    
    private func selectFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
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
            self.collectionView?.reloadData()
        }
    }
    
    
    func showLabel(image: UIImage) {
        let binaryImageData = GoogleVisionAPI().base64EncodeImage(image)
        GoogleVisionAPI().createRequest(with: binaryImageData, completion: { (face, label) in
            DispatchQueue.main.async {
                HistoryCoreModel.sharedInstance.add(word: nil, definition: nil, example: nil, picture: nil, image: image, photoResponse: label)
                self.collectionView?.reloadData()
            }
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 2.0, 0)
    }
    func scrollTrigerPaddingInCollectionView(_ collectionView: UICollectionView) -> UIEdgeInsets {
        return UIEdgeInsetsMake(collectionView.contentInset.top, 0, collectionView.contentInset.bottom, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let threePiecesWidth = floor(screenWidth / 3.0 - ((2.0 / 3) * 2))
//        let twoPiecesWidth = floor(screenWidth / 2.0 - (2.0 / 2))
        return CGSize(width: threePiecesWidth, height: threePiecesWidth)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    func scrollTrigerEdgeInsetsInCollectionView(_ collectionView: UICollectionView) -> UIEdgeInsets {
        return UIEdgeInsetsMake(100.0, 100.0, 100.0, 100.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, allowMoveAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, at atIndexPath: IndexPath, didMoveTo toIndexPath: IndexPath) {
        var photo: UIImage
        photo = imageData.remove(at: (atIndexPath as NSIndexPath).item)
        imageData.insert(photo, at: (toIndexPath as NSIndexPath).item)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return imageData.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        let imageView = UIImageView(image: imageData[indexPath.row])
        imageView.frame = cell.frame
        cell.backgroundView = imageView
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedData = fetchData().filter {$0.image != nil}[indexPath.row]
        let story = UIStoryboard.init(name: "Main", bundle: nil)
        let view = story.instantiateViewController(withIdentifier: "ImageDetailViewController") as! ImageDetailViewController
        view.selectedData = selectedData
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
