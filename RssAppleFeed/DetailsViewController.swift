//
//  DetailsTableViewController.swift
//  RssAppleFeed
//
//  Created by Oleg on 4/22/17.
//  Copyright © 2017 Oleg. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tbData: UITableView!
    
    var titleForDetailsTVC: String?
    var dateForDetailsTVC: String?
    var descriptionLabelForDetailsTVC: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Color navigationItem "Back
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        tbData.estimatedRowHeight = 100.0
        tbData.rowHeight = UITableViewAutomaticDimension
        
        title = "Apple News"
        
        tbData?.separatorStyle = .none
    
    }

    
    // MARK: Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }

    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellDetails", for: indexPath) as! DetailsTableViewCell

        // Configure the cell...
        cell.title?.text = titleForDetailsTVC 
        cell.date?.text = dateForDetailsTVC
        cell.descriptionLabel?.text = descriptionLabelForDetailsTVC

        return cell
    }
}

// MARK: Class DetailsTableViewCel
class DetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var thubnail: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        thubnail?.layer.cornerRadius = 30
        thubnail?.layer.masksToBounds = true
    }
}
