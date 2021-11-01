//
//  ViewController.swift
//  RssAppleFeed
//
//  Created by Oleg on 01.11.2021.
//  Copyright © 2017 Oleg. All rights reserved.
//

import UIKit
import CoreData

final class InitialViewController: UIViewController {
    
    @IBOutlet var tableView : UITableView?
    
    var initialVCVM = InitialVCVM()
    var parser = XMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var title1 = NSMutableString()
    var description1 = NSMutableString()
    var date = NSMutableString()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.dataSource = self
        tableView?.delegate = self
        
        let results = initialVCVM.getData()
        if results.count == 0  {
            self.beginParsing()
        } else {
            posts = (results as NSArray).mutableCopy() as! NSMutableArray
            tableView!.reloadData()
        }
    }
    
    // MARK: Parsing
    func beginParsing() {
        posts = []
        parser = XMLParser(contentsOf: (URL(string: Constants.baseUrlString))!)!
        parser.delegate = self
        parser.parse()
        
        tableView?.reloadData()
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue,
                          sender: Any!)  {
        // Button "Back"
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
        if segue.identifier == "viewpost" {
            let selectedRow = tableView?.indexPathForSelectedRow?.row
            let detailsScene = posts[selectedRow!]
            let viewController = segue.destination as! DetailsViewController
            viewController.titleForDetailsTVC = (detailsScene as AnyObject).value(forKey: "title") as? String
            viewController.dateForDetailsTVC = (detailsScene as AnyObject).value(forKey: "date") as? String
            viewController.descriptionLabelForDetailsTVC = (detailsScene as AnyObject).value(forKey: "desc") as? String
        }
    }
}



