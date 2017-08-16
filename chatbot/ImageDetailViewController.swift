//
//  ImageDetailViewController.swift
//  chatbot
//
//  Created by 新井崚平 on 2017/07/26.
//  Copyright © 2017年 新井崚平. All rights reserved.
//

import UIKit

class ImageDetailViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var aiText: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func closeViewButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var tableView: UITableView!
    
    var selectedData : UserVocabulary?
    var parsedWords = [String]()
    var translatedWords = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
//        
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = backgroundView.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        backgroundView.insertSubview(blurEffectView, belowSubview: imageView)
//        
//        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
//        imageView.addGestureRecognizer(tap)
//        self.navigationController?.isNavigationBarHidden = false
//        self.tabBarController?.tabBar.isHidden = false
//        
        imageView.isUserInteractionEnabled = true
        print(selectedData ?? 1)

    
        
        if selectedData?.image != nil {
            imageView.image = UIImage(data: (selectedData?.image)! as Data)
            if let text = selectedData?.label {
                let replaceText = "What I can see in this picture is  "
                let newtext = text.replacingOccurrences(of: replaceText, with: "")
//                aiText.text = newtext
                parsedWords.append(contentsOf: parse(text: newtext))
                GoogleTranslationAPI().trasnlate("en", to: "ja", text: newtext, completionHandler: { (text) in
                    let parsed = self.parse(Japanese: text)
                    self.translatedWords.append(contentsOf: parsed)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                })
            }
        }
    }
    
    func parse(text: String) -> [String] {
        let noComma = text.replacingOccurrences(of: ", ", with: "::")
        let newtext = noComma.components(separatedBy: "::")
        print(newtext)
        return newtext
    }

    func parse(Japanese text: String) -> [String] {
        let noComma = text.replacingOccurrences(of: "、", with: "::")
        let newtext = noComma.components(separatedBy: "::")
        print(newtext)
        return newtext
    }
    
    func swipe(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == UISwipeGestureRecognizerDirection.right {
            print("Swipe Right")
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.left {
            print("Swipe Left")
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.up {
            print("Swipe Up")
        }
        else if gesture.direction == UISwipeGestureRecognizerDirection.down {
            print("Swipe Down")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ImageDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //errorが起こるので、obsere¥verすれば解決
        return translatedWords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "parseCell", for: indexPath)
        cell.textLabel?.text = self.parsedWords[indexPath.row]
        cell.detailTextLabel?.text = self.translatedWords[indexPath.row]
        return cell
    }
    
}


extension ImageDetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func imageTapped() {
        print("Tapped")
        imageView.frame = UIScreen.main.bounds
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()

    }
}
