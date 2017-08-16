//
//  VocaDetailViewController.swift
//  chatbot
//
//  Created by 新井崚平 on 2017/07/17.
//  Copyright © 2017年 新井崚平. All rights reserved.
//

import UIKit

class VocaDetailViewController: UIViewController {

    
    @IBOutlet weak var word: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var category: UITextView!
    @IBOutlet weak var bgVIew: UIView!
    
    
    var vocaDetailData: UserVocabulary?
    var detail: History?
    
    var selectedIndex: Int?
    
    var examples = [String]()
    var definitions = [String]()
    
    @IBOutlet weak var index: UISegmentedControl!
    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            DictionaryAPI.searchDefinition(searchWord: word.text!, language: "en", completionHandler: { (targetWord, def, ex, status) in
                if status {
                    DispatchQueue.main.async {
                        self.definitions = def
                        self.examples.removeAll()
                        
                        self.tableView.reloadData()
                        print("Succeeded!")
                    }
                }
            })
        case 1:
            DictionaryAPI.searchDefinition(searchWord: word.text!, language: "en", completionHandler: { (targetWord, def, ex, status) in
                if status {
                    DispatchQueue.main.async {
                        self.definitions.removeAll()
                        self.examples = ex
                        self.tableView.reloadData()
                        print("Succeeded!")
                    }
                }
            })
        default:
            break;
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialized()
        
//        self.tabBarController?.navigationItem.title = "\(word.text!)"
    }

    func initialized() {

        self.bgVIew.dropShadow()
        category.delegate = self
        tableView.estimatedRowHeight = 140
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if let detail = detail {
            word.text = detail.word
        }
        
        if let vocaDetailData = vocaDetailData {
            word.text = vocaDetailData.word
            category.text = vocaDetailData.category
            var modifiedWord = ""
            guard let firstWord = word.text?.components(separatedBy: .whitespaces)[0] else {return}
            
            let trimmedstr = firstWord.trimmingCharacters(in: .whitespacesAndNewlines)
            if let lastchar = trimmedstr.characters.last {
                if [",", ".", "-", "?"].contains(lastchar) {
                    let newstr = String(trimmedstr.characters.dropLast())
                    modifiedWord = newstr
                } else {
                    modifiedWord = firstWord
                }
            }
            
            DictionaryAPI.searchDefinition(searchWord: modifiedWord, language: "en", completionHandler: { (targetWord, def, ex, status) in
                if status {
                    DispatchQueue.main.async {
                        self.definitions = def
                        self.tableView.reloadData()
                        print("Succeeded!")
                    }
                }
            })

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

extension VocaDetailViewController: UITextViewDelegate {
    
    // hides text views
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        print("replaced")
        if (text == "\n") {
            category.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let voca = VocabularyModel(word: self.word.text ?? "", category: self.category.text, image: nil, label: nil)
        UserVocabularyModel.sharedInstance.remove(vocabulary: UserVocabularyModel.sharedInstance.getData()[selectedIndex!])
        UserVocabularyModel.sharedInstance.add(vocabulary: voca)
    }
}


extension VocaDetailViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if index.selectedSegmentIndex == 0 {
            return definitions.count
        } else {
            return examples.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "vocaDetailedCell", for: indexPath)
        cell.sizeToFit()
        cell.textLabel?.numberOfLines = 0
        
        if index.selectedSegmentIndex == 0 {
            cell.textLabel?.text = definitions[indexPath.row]
        } else {
            cell.textLabel?.text = examples[indexPath.row]
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return nil
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if index.selectedSegmentIndex == 0 {
            return UITableViewAutomaticDimension
        } else {
            return UITableViewAutomaticDimension
        }
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if index.selectedSegmentIndex == 0 {
            return UITableViewAutomaticDimension
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Save this phrase?", message: nil, preferredStyle: .alert)
        let yes = UIAlertAction(title: "Yes", style: .default) { (_) in
            let selectedPhrase = self.examples[indexPath.row]
            MyPhraseModel.sharedInstance.add(phrase: selectedPhrase, word: self.word.text!)
            print("selectedPhrase was saved", selectedPhrase)
        }
        let no = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addAction(no)
        alert.addAction(yes)
        self.present(alert, animated: true, completion: nil)
    }
}







