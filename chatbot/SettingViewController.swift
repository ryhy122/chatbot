//
//  SettingViewController.swift
//  chatbot
//
//  Created by 新井崚平 on 2017/07/17.
//  Copyright © 2017年 新井崚平. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    enum Section : Int {
        case vocabularyTag = 0, phraseTag, voiceAvailability
    }
    
    var userCutamizedFolders = [History]()
    var translateArray = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tabBarController?.navigationItem.title = "Chatbot Setting"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fertchData()
    }
    func fertchData() {
        
        DispatchQueue.main.async {
            let data = HistoryCoreModel.sharedInstance.getData()
            self.userCutamizedFolders = data.filter {$0.word != nil}
//            if self.userCutamizedFolders.count >= 1 {
//                self.userCutamizedFolders.forEach({ (history) in
//                    GoogleTranslationAPI().trasnlate("en", to: "ja", text: history.word!) { (word) in
//                        self.translateArray.append(word)
//                    }
//                })
//            }
            self.tableView.reloadData()
        }
    }
}


extension SettingViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}

extension SettingViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userCutamizedFolders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "setting", for: indexPath)
        cell.textLabel?.text = userCutamizedFolders[indexPath.row].word
//        cell.detailTextLabel?.text = translateArray[indexPath.row]
//        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Hisotry"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.section == 0 {
            let alert = UIAlertController(title: "Change hashtagName for vocabulary", message: nil, preferredStyle: .alert)
            alert.addTextField(configurationHandler: configurationTextField(textField:))
            let done = UIAlertAction(title: "Done", style: .default, handler: { (_) in
                let text = alert.textFields?[0]
                if !(text?.text?.contains("#"))! {
                    print("error")
                } else {
                    DataManager.sharedInstance.saveVocabulary(tag: (text?.text!)!)
                }
            })
            let cancel = UIAlertAction(title: "Canlel", style: .default, handler: nil)
            alert.addAction(done)
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func configurationTextField(textField: UITextField!){
        textField.text = "Hashtag"
        textField.textColor = UIColor.lightGray
    }
    
    
}
