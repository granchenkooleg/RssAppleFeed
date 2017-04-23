//
//  ViewController.swift
//  RssAppleFeed
//
//  Created by Oleg on 4/20/17.
//  Copyright © 2017 Oleg. All rights reserved.
//

import UIKit
import CoreData

class InitialViewController: UIViewController, XMLParserDelegate
{
    @IBOutlet var tbData : UITableView?
    
    var parser = XMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var title1 = NSMutableString()
    var description1 = NSMutableString()
    var date = NSMutableString()
    
    // We need this to get the managed object context that allows us to use core data
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    // Create a function to save the data
    func storeData (date: String, description: String, title: String) {
        let context = getContext()
        
        //retrieve the entity that we just created
        let entity =  NSEntityDescription.entity(forEntityName: "Feed", in: context)
        
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        
        //set the entity values
        transc.setValue(date, forKey: "date")
        transc.setValue(description, forKey: "desc")
        transc.setValue(title, forKey: "title")
        
        //save the object
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }
    
    // Create a function to retrieve the data
    func getData () -> [Feed] {
        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<Feed> = Feed.fetchRequest()
        var searchResults = [Feed]()
        
        do {
            //go get the results
            searchResults = try getContext().fetch(fetchRequest)
            
            //check the size of the returned results!
            print ("num of results = \(searchResults.count)")
        } catch {
            print("Error with request: \(error)")
        }
        
        return searchResults
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let results = getData()
        if results.count == 0  {
            self.beginParsing()
        } else {
            posts = results as! NSMutableArray
            tbData!.reloadData()
        }
        
        tbData?.separatorColor = Constants.colorLigthGreen
    }
    
    // MARK: Parsing
    func beginParsing() {
        posts = []
        parser = XMLParser(contentsOf:(URL(string: Constants.baseUrlString))!)!
        parser.delegate = self
        parser.parse()
        
        tbData!.reloadData()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element = elementName as NSString
        if (elementName as NSString).isEqual(to: "item")
        {
            elements = NSMutableDictionary()
            elements = [:]
            title1 = NSMutableString()
            title1 = ""
            description1 = NSMutableString()
            description1 = ""
            date = NSMutableString()
            date = ""
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqual(to: "item") {
            if !title1.isEqual(nil) {
                elements.setObject(title1, forKey: "title" as NSCopying)
            }
            if !description1.isEqual(nil) {
                elements.setObject(description1, forKey: "desc" as NSCopying)
            }
            if !date.isEqual(nil) {
                elements.setObject(date, forKey: "date" as NSCopying)
            }
            
            posts.add(elements)
            storeData(date: date as String, description: description1 as String, title: title1 as String)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        // Remove \n from String
        let string = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if element.isEqual(to: "title") {
            title1.append(string)
        }
        else if element.isEqual(to: "description") {
            description1.append(string)
        }
        else if element.isEqual(to: "pubDate") {
            date.append(string)
        }
    }
    
    // MARK: Tableview methods
    
    // TitleForHeaderInSection
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> NSString? {
        let date = (getData().last?.date)! as NSString
        let titleForHeaderInSection = date.substring(with: NSMakeRange(0, (date.length) - 18))
        
        return titleForHeaderInSection as NSString?
    }
    // ColorForHeaderInSection
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(colorLiteralRed: 0.008, green: 0.310, blue: 0.569, alpha: 1.00)
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = Constants.colorLigthGreen
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        var cell : FeedTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CellFeed", for: indexPath) as! FeedTableViewCell
        
        if(cell.isEqual(NSNull.self)) {
            cell = Bundle.main.loadNibNamed("CellFeed", owner: self, options: nil)?[0] as! UITableViewCell as! FeedTableViewCell;
        }
        
        cell.title?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "title")  as? String
        cell.descriptionLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "desc") as? String
        cell.date?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "date") as? String
        
        // AccessoryType
        cell.accessoryType = .detailDisclosureButton
        let cellButton = UIButton(type: .custom)
        cellButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        cellButton.setImage(UIImage(named: "Forward Filled-50.png"), for: .normal)
        cellButton.contentMode = .scaleAspectFit
        // Spetial for user touch
        cellButton.isUserInteractionEnabled = false
        cell.accessoryView = cellButton as UIView
        
        return cell as UITableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any!)  {
        // Button "Back"
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        // Segue
        if segue.identifier == "viewpost" {
            let selectedRow = tbData?.indexPathForSelectedRow?.row
            let detailsScene = posts[selectedRow!]
            let viewController = segue.destination as! DetailsViewController
            viewController.titleForDetailsTVC = (detailsScene as AnyObject).value(forKey: "title") as? String
            viewController.dateForDetailsTVC = (detailsScene as AnyObject).value(forKey: "date") as? String
            viewController.descriptionLabelForDetailsTVC = (detailsScene as AnyObject).value(forKey: "desc") as? String
        }
    }
}

// MARK: Class TableViewCell
class FeedTableViewCell : UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var date: UILabel!
    
}



