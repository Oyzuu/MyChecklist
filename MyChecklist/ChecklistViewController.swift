//
//  ViewController.swift
//  MyChecklist
//
//  Created by BT-Training on 26/08/16.
//  Copyright © 2016 BT-Training. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
    var dataModel = [Checklist]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataModel.append(Checklist(title: "Promener le chien"))
        dataModel.append(Checklist(title: "Danser la gigue"))
        dataModel.append(Checklist(title: "Gagner au Scrabble"))
        dataModel.append(Checklist(title: "Parler de Dieu avec mon chat"))
        dataModel.append(Checklist(title: "Apprendre le Beer Pong"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

// data source
extension ChecklistViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.count
    }
    
    override func tableView(tableView: UITableView,
                            cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem",
                                                               forIndexPath: indexPath)
        let label          = cell.viewWithTag(1000) as! UILabel
        let checklist      = dataModel[indexPath.row]
        label.text         = checklist.title
        cell.accessoryType = checklist.done ? .Checkmark : .None
        
        return cell
    }
}

// delegate
extension ChecklistViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let checklist  = dataModel[indexPath.row]
        checklist.done = !checklist.done
        
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
}

