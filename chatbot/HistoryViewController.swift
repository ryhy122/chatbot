//
//  ViewController.swift
//  chatbot
//
//  Created by 新井崚平 on 2017/07/14.
//  Copyright © 2017年 新井崚平. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var userCutamizedFolders = [History]()
    var newestHistory = [History]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setUI()
        fertchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setUI() {
        self.tabBarController?.navigationItem.title = "History"
    }
    
    func fertchData() {
        DispatchQueue.main.async {
            let data = HistoryCoreModel.sharedInstance.getData()
            self.userCutamizedFolders = data.reversed()
            self.tableView.reloadData()
        }
    }
    
    func instanciateView() {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let view = sb.instantiateViewController(withIdentifier: "")
        self.navigationController?.pushViewController(view, animated: true)
    }
}

extension HistoryViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return userCutamizedFolders.filter {$0.word != nil}.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VocabularyTableViewCell
        
        let word = userCutamizedFolders.filter {$0.word != nil}
        cell.word.text = word[indexPath.row].word
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteButton = UITableViewRowAction(style: .normal, title: "delete") { (action: UITableViewRowAction, idx: IndexPath) in
            
            let history = self.userCutamizedFolders[indexPath.row]
            CoreDataModel.sharedInstance.remove(history: history)
            self.userCutamizedFolders.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()

        }
        
        let addButton = UITableViewRowAction(style: .normal, title: "add") { (action: UITableViewRowAction, idx: IndexPath) in
            guard let word = self.userCutamizedFolders[indexPath.row].word else {
                print("Word could not be found!!")
                return
            }
            
            let alert = UIAlertController(title: "Category", message: "You can categorize words", preferredStyle: .alert)
            alert.addTextField(configurationHandler: self.configurationTextField)
            
            let ok = UIAlertAction(title: "Done", style: .default, handler: { (_) in
                let text = alert.textFields?[0]
                let voca = VocabularyModel(word: word, category: text?.text, image: nil, label: nil)
                UserVocabularyModel.sharedInstance.add(vocabulary: voca)
            })
            
            let onlyWord = UIAlertAction(title: "Only word", style: .default, handler: { (_) in
                let voca = VocabularyModel(word: word, category: nil, image: nil, label: nil)
                UserVocabularyModel.sharedInstance.add(vocabulary: voca)
            })
            
            let select = UIAlertAction(title: "Select", style: .default, handler: { (_) in
                let text = alert.textFields?[0]
                let voca = VocabularyModel(word: word, category: text?.text, image: nil, label:  nil)
                UserVocabularyModel.sharedInstance.add(vocabulary: voca)
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            
            alert.addAction(ok)
            alert.addAction(onlyWord)
            alert.addAction(select)
            alert.addAction(cancel)
            
            self.present(alert, animated: true, completion: nil)
            print("word \(word) was added!")
        }
    
        addButton.backgroundColor = UIColor.red
        
        return [addButton, deleteButton]
    }
    
    func configurationTextField(textField: UITextField!){
        textField.text = "Add category"
        textField.textColor = UIColor.lightGray
    }
    

    
}

extension HistoryViewController {
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        
//    }
//    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        switch section {
////        case 0: return "Wordds you searched before"
//        case 0: return "History"
//        default: break;
//        }
//        return nil
//    }
//    
}

