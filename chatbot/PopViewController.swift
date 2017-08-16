//
//  PopViewController.swift
//  chatbot
//
//  Created by 新井崚平 on 2017/07/21.
//  Copyright © 2017年 新井崚平. All rights reserved.
//

import UIKit

class PopViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var originalView: UITextView!
    @IBOutlet weak var translatedView: UITextView!
    
    @IBOutlet weak var backgroundVIew: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBAction func backPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    var text = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetting()
        translate()
    }
    
    func translate() {
        self.originalView.text = text
        GoogleTranslationAPI().trasnlate("en", to: "ja", text: self.originalView.text) { (translated) in
            DispatchQueue.main.async {
                self.translatedView.text = translated
            }
        }
    }
    
    func initialSetting() {
        originalView.delegate = self
        translatedView.delegate = self
        self.view.backgroundColor = .clear
        self.view.isOpaque = false
        backgroundVIew.layer.cornerRadius = 15
        originalView.layer.cornerRadius = 15
        translatedView.layer.cornerRadius = 15
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
