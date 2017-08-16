//
//  UserVocabularyViewController.swift
//  chatbot
//
//  Created by 新井崚平 on 2017/07/17.
//  Copyright © 2017年 新井崚平. All rights reserved.
//

import UIKit
import Foundation

class UserVocabularyViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var userData : [UserVocabulary] = []
    
    @IBOutlet weak var backgroundView: UIView!
    static let vocaDetail = "vocaDetail"
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var wordField: UITextField!
    
    @IBOutlet weak var subBackgroundView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        textView.delegate = self
        wordField.delegate = self
        fetchUesrVocabulary()
        subBackgroundView.dropShadow()
        
    }
    
    
    @IBAction func toTheTop(_ sender: UIBarButtonItem) {
        tableView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchUesrVocabulary()
    }
    
    func fetchUesrVocabulary() {
        DispatchQueue.main.async {
            self.userData = UserVocabularyModel.sharedInstance.getData().filter {$0.word != nil}
            self.tableView.reloadData()
        }
    }

    @IBAction func doneButton(_ sender: UIButton) {
        var alert: UIAlertController
        
        if (wordField.text?.isEmpty)! {
            alert = UIAlertController(title: "Please add a word", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: { 
                alert.removeFromParentViewController()
            })
            return
        }
        if textView.text.isEmpty {
            alert = UIAlertController(title: "Please fill something in the text box", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                alert.removeFromParentViewController()
            })
            return
        }
        
        let vocabulary = VocabularyModel(word: wordField.text!, category: textView.text, image: nil, label: nil)
        UserVocabularyModel.sharedInstance.add(vocabulary: vocabulary)
        textView.text = nil
        wordField.text = nil
        
        wordField.resignFirstResponder()
        textView.resignFirstResponder()
        fetchUesrVocabulary()
    }
    
}

extension UserVocabularyViewController :UITextViewDelegate, UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        wordField.text = ""
        wordField.textColor = UIColor.black
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        wordField.resignFirstResponder()
        textView.resignFirstResponder()
        return true
    }
    
    
    // hides text views
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if (text == "\n") {
            wordField.resignFirstResponder()
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == "" {
            textView.text = "Write phrase with the word"
            textView.textColor = UIColor.lightGray
        } else {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
    
}
    
extension UserVocabularyViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "uservoca", for: indexPath)
        let data = userData[indexPath.row]
       
        cell.textLabel?.text = data.word
        cell.detailTextLabel?.text = data.category
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteButton = UITableViewRowAction(style: .normal, title: "delete") {
            (action: UITableViewRowAction, idx: IndexPath) in
            let voca = self.userData[indexPath.row]
            UserVocabularyModel.sharedInstance.remove(vocabulary: voca)
            self.userData.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
        }
        
        let addButton = UITableViewRowAction(style: .normal, title: "add") {
            (action: UITableViewRowAction, idx: IndexPath) in
            let userVoca = self.userData[indexPath.row]
            print("Word could not be found!!")
            UserVocabularyModel.sharedInstance.remove(vocabulary: userVoca)
        }
        
        addButton.backgroundColor = UIColor.red
        return [addButton, deleteButton]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    //MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "vocaDetail" {
            if let vocaDetailViewController = segue.destination as? VocaDetailViewController {
                guard let selectedMealCell = sender as? UITableViewCell else {
                    fatalError("Unexpected sender: \(String(describing: sender))")
                }
                
                guard let indexPath = tableView.indexPath(for: selectedMealCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                
                let selectedMeal = userData[indexPath.row]
                vocaDetailViewController.vocaDetailData = selectedMeal
                vocaDetailViewController.selectedIndex = indexPath.row
            }
        }
    }
}

extension UserVocabularyViewController {
    

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "My vocabulary list"
        default: break
        }
        return nil
    }
    
}


