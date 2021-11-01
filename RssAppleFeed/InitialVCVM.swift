//
//  InitialVCVM.swift
//  RssAppleFeed
//
//  Created by Oleg Granchenko on 01.11.2021.
//  Copyright © 2021 Oleg. All rights reserved.
//

import UIKit
import CoreData

protocol RssApp {
    func getData () -> [Feed]
    func storeData (date: String,
                    description: String,
                    title: String)
}

final class InitialVCVM: RssApp {
    
    func getData () -> [Feed] {
        let fetchRequest: NSFetchRequest<Feed> = Feed.fetchRequest()
        var searchResults = [Feed]()
        
        do {
            searchResults = try getContext().fetch(fetchRequest)
        } catch {
            print("Error with request: \(error)")
        }
        
        return searchResults
    }
}

extension InitialVCVM {
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
    func storeData (date: String,
                    description: String,
                    title: String) {
        let context = getContext()
        
        //retrieve the entity that we just created
        let entity =  NSEntityDescription.entity(forEntityName: "Feed", in: context)
        
        let contextObj = NSManagedObject(entity: entity!, insertInto: context)
        
        //set the entity values
        contextObj.setValue(date, forKey: "date")
        contextObj.setValue(description, forKey: "desc")
        contextObj.setValue(title, forKey: "title")
        
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }
    
}
