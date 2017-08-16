//
//  MyPhraseModel.swift
//  chatbot
//
//  Created by 新井崚平 on 2017/07/17.
//  Copyright © 2017年 新井崚平. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class MyPhraseModel : NSObject {
    
    static let sharedInstance = MyPhraseModel()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var phrase = [Phrase]()
    
    func add(phrase: String, word: String) {
        let _phrase = Phrase(context: context)
        _phrase.phrase = phrase
        _phrase.word = word
        try! context.save()
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func remove(vocabulary: Phrase) {
        let request = NSFetchRequest<Phrase>(entityName: "Phrase")
        do {
            let searchResults = try context.fetch(request)
            for _ in searchResults {
                context.delete(vocabulary)
            }
        } catch {
            print("Error with request: \(error)")
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func editTask() {
        let request = NSFetchRequest<Phrase>(entityName: "Phrase")
        do {
            let searchResults = try context.fetch(request)
            for _ in searchResults {
            }
        } catch {
            print("Error with request: \(error)")
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func getData() -> [Phrase] {
        do {
            phrase = try context.fetch(Phrase.fetchRequest())
        }catch {
            print("Error fetching data from CoreData")
        }
        return phrase
    }
    
    func sortData() -> [Phrase] {
        let fetchRequest: NSFetchRequest<Phrase> = Phrase.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(History.word), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        do {
            phrase = try context.fetch(fetchRequest)
        } catch {
            print("Cannot fetch Expenses")
        }
        
        return phrase
    }
    
    
}
