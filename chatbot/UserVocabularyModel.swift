//
//  UserVocabulary.swift
//  chatbot
//
//  Created by 新井崚平 on 2017/07/17.
//  Copyright © 2017年 新井崚平. All rights reserved.
//

import Foundation

import CoreData
import UIKit


class UserVocabularyModel: NSObject {
    
    static let sharedInstance = UserVocabularyModel()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var userVoca = [UserVocabulary]()
    
    func add(vocabulary: VocabularyModel) {
        
        let userVoca = UserVocabulary(context: context)
        
        if let word = vocabulary.word {
            userVoca.word = word
        }
        if let category = vocabulary.category {
            userVoca.category = category
        }
        if let myImage = vocabulary.image {
            print("IMAGE SAVED")
            userVoca.image = UIImagePNGRepresentation(myImage)! as NSData
        }
        if let myLabel = vocabulary.label {
            userVoca.label = myLabel
        }
        
        try! context.save()
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    
    func remove(vocabulary: UserVocabulary) {
        let request = NSFetchRequest<UserVocabulary>(entityName: "UserVocabulary")
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
        let request = NSFetchRequest<UserVocabulary>(entityName: "UserVocabulary")
        do {
            let searchResults = try context.fetch(request)
            for task in searchResults {
            }
        } catch {
            print("Error with request: \(error)")
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    func getData() -> [UserVocabulary] {
        do {
            userVoca = try context.fetch(UserVocabulary.fetchRequest())
        }catch {
            print("Error fetching data from CoreData")
        }
        return userVoca
    }
    
    func sortData() -> [UserVocabulary] {
        let fetchRequest: NSFetchRequest<UserVocabulary> = UserVocabulary.fetchRequest()
        let sort = NSSortDescriptor(key: #keyPath(UserVocabulary.category), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        do {
            userVoca = try context.fetch(fetchRequest)
        } catch {
            print("Cannot fetch Expenses")
        }
        
        return userVoca
    }
    
    
}
