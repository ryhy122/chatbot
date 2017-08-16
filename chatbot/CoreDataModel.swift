//
//  CoreDataModel.swift
//  chatbot
//
//  Created by 新井崚平 on 2017/07/15.
//  Copyright © 2017年 新井崚平. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class CoreDataModel : NSObject {
    
    static let sharedInstance = CoreDataModel()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var vocabulary = [Vocabulary]()
    
    func add(word: String, definition: String?, example: String?) {
        let vocabulary = Vocabulary(context: context)
        vocabulary.word = word
        
        if definition != nil {
            vocabulary.definiition = definition
        }
        if example != nil {
            vocabulary.example = example
        }
        try! context.save()
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func remove(history: History) {
        let request = NSFetchRequest<Vocabulary>(entityName: "Vocabulary")
        do {
            let searchResults = try context.fetch(request)
            for _ in searchResults {
                context.delete(history)
            }
        } catch {
            print("Error with request: \(error)")
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func editTask() {
        let request = NSFetchRequest<Vocabulary>(entityName: "Vocabulary")
        do {
            let searchResults = try context.fetch(request)
            for task in searchResults {
            }
        } catch {
            print("Error with request: \(error)")
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func getData() -> [Vocabulary] {
        do {
            vocabulary = try context.fetch(Vocabulary.fetchRequest())
        }catch {
            print("Error fetching data from CoreData")
        }
        return vocabulary
    }
    

}
