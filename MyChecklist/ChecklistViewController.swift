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
        
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Segue preparation of doom
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addItemSegue" {
            if let navigationController = segue.destinationViewController as? UINavigationController {
                if let addItemViewController = navigationController.topViewController as? AddItemViewController {
                    addItemViewController.delegate = self
                }
            }
        }
        else if segue.identifier == "editItemSegue" {
            if let navigationController = segue.destinationViewController as? UINavigationController {
                if let addItemViewController = navigationController.topViewController as? AddItemViewController {
                    if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                        addItemViewController.checklistToEdit = dataModel[indexPath.row]
                        addItemViewController.delegate = self
                    }
                }
            }
        }
    }
    
    func addItem(item: Checklist) {
        dataModel.append(item)
        let indexPath = NSIndexPath(forRow: dataModel.count - 1, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
    }
}

// MARK: AddItemViewControllerDelegate
extension ChecklistViewController: AddItemViewControllerDelegate {
    func addItemViewController(controller: AddItemViewController, didFinishAddingItem: Checklist) {
        addItem(didFinishAddingItem)
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addItemViewController(controller: AddItemViewController, didFinishEditingItem: Checklist) {        
        if let index = dataModel.indexOf({
            checklist in return checklist === didFinishEditingItem
        }) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        }
        
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addItemViewControllerDidCancel(controller: AddItemViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: data source
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
        // cell.accessoryType = checklist.done ? .Checkmark : .None
        
        return cell
    }
    
    override func tableView(tableView: UITableView,
                            commitEditingStyle editingStyle: UITableViewCellEditingStyle,
                            forRowAtIndexPath indexPath: NSIndexPath) {
        dataModel.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
}

// MARK: Delegate
extension ChecklistViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let checklist  = dataModel[indexPath.row]
        checklist.done = !checklist.done
        
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
}

