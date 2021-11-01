//
//  InitialViewController + Ext.swift
//  RssAppleFeed
//
//  Created by Oleg Granchenko on 01.11.2021.
//  Copyright © 2021 Oleg. All rights reserved.
//

import UIKit

extension InitialViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : FeedTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CellFeed", for: indexPath) as! FeedTableViewCell
        
        if(cell.isEqual(NSNull.self)) {
            cell = Bundle.main.loadNibNamed("CellFeed",
                                            owner: self, 
                                            options: nil)?[0] as! UITableViewCell as! FeedTableViewCell
        }
        
        cell.title?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "title")  as? String
        cell.descriptionLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "desc") as? String
        cell.date?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "date") as? String
        
        // AccessoryType
        cell.accessoryType = .detailDisclosureButton
        let cellButton = UIButton(type: .custom)
        cellButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        cellButton.setImage(UIImage(named: "forward"), for: .normal)
        cellButton.contentMode = .scaleAspectFit
        cellButton.isUserInteractionEnabled = false
        cell.accessoryView = cellButton as UIView
        
        return cell as UITableViewCell
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}

extension InitialViewController: XMLParserDelegate {
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String]) {
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
    
    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {
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
            initialVCVM.storeData(date: date as String,
                                  description: description1 as String,
                                  title: title1 as String)
        }
    }
    
    func parser(_ parser: XMLParser,
                foundCharacters string: String) {
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
}
