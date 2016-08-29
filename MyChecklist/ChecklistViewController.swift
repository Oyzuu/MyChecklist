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
    
    @IBAction func addItem() {
        let checklist = Checklist(title: "nouvelle action")
        dataModel.append(checklist)
        let indexPath = NSIndexPath(forRow: dataModel.count - 1, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
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
    
    override func tableView(tableView: UITableView,
                            commitEditingStyle editingStyle: UITableViewCellEditingStyle,
                            forRowAtIndexPath indexPath: NSIndexPath) {
        dataModel.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
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

