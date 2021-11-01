//
//  DetailsTableViewController.swift
//  RssAppleFeed
//
//  Created by Oleg on 01.11.2021.
//  Copyright © 2017 Oleg. All rights reserved.
//

import UIKit

final class DetailsViewController: UIViewController {
    
    @IBOutlet weak var tbData: UITableView!
    
    var titleForDetailsTVC: String?
    var dateForDetailsTVC: String?
    var descriptionLabelForDetailsTVC: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tbData.estimatedRowHeight = 100.0
        tbData.rowHeight = UITableView.automaticDimension
        
        title = "Apple News"
        
        tbData?.separatorStyle = .none
        
    }
}
