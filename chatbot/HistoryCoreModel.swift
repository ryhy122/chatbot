//
//  HistoryCoreModel.swift
//  chatbot
//
//  Created by 新井崚平 on 2017/07/17.
//  Copyright © 2017年 新井崚平. All rights reserved.
//



import Foundation
import CoreData
import UIKit


class HistoryCoreModel : NSObject {
    
    static let sharedInstance = HistoryCoreModel()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var history = [History]()
    
    func add(word: String?, definition: String?, example: String?, picture: UIImage?, image: UIImage?, photoResponse: String?) {
        let history = History(context: context)
        
        if word != nil {
            history.word = word
        }
        if definition != nil {
            history.definition = definition
        }
        if example != nil {
            history.example = example
        }
        if picture != nil {
            history.picture = UIImagePNGRepresentation(picture!)! as NSData
        }
        if image != nil {
            history.userImage = UIImagePNGRepresentation(image!)! as NSData
        }
        
        if photoResponse != nil {
            history.photoResponse = photoResponse
        }
        
        try! context.save()
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func add(image: UIImage, photoResponse: String) {
        let history = History(context: context)
        history.photoResponse = photoResponse
        history.userImage = UIImagePNGRepresentation(image)! as NSData
        try! context.save()
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func remove(vocabulary: Vocabulary) {
        let request = NSFetchRequest<History>(entityName: "History")
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
        let request = NSFetchRequest<History>(entityName: "History")
        do {
            let searchResults = try context.fetch(request)
            for task in searchResults {
            }
        } catch {
            print("Error with request: \(error)")
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func getData() -> [History] {
        do {
            history = try context.fetch(History.fetchRequest())
        }catch {
            print("Error fetching data from CoreData")
        }
        return history
    }
    
    func sortData() -> [History] {
        let fetchRequest: NSFetchRequest<History> = History.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(History.word), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        do {
            history = try context.fetch(fetchRequest)
        } catch {
            print("Cannot fetch Expenses")
        }
        
        return history
    }
    
    
}
