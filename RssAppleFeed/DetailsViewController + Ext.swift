//
//  DetailsViewController + Ext.swift
//  RssAppleFeed
//
//  Created by Oleg Granchenko on 01.11.2021.
//  Copyright © 2021 Oleg. All rights reserved.
//

import UIKit

extension DetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellDetails", for: indexPath) as! DetailsTableViewCell
        
        cell.title?.text = titleForDetailsTVC
        cell.date?.text = dateForDetailsTVC
        cell.descriptionLabel?.text = descriptionLabelForDetailsTVC
        
        return cell
    }
}

