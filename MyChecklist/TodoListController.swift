//
//  TodoListController.swift
//  MyChecklist
//
//  Created by BT-Training on 30/08/16.
//  Copyright © 2016 BT-Training. All rights reserved.
//

import UIKit

protocol TodoListDelegate : class {
    func addToChecklist(atIndex: Int, todo: Todo)
    func removeFromChecklist(atIndex: Int, todo: Todo)
    func editOnChecklist(atIndex: Int, checklist: Checklist)
}

class TodoListController: UITableViewController {
    
    var checklist: Checklist!
    var checklistIndex: Int?
    
    weak var delegate: TodoListDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addTodoSegue" {
            if let navigationController = segue.destinationViewController as? UINavigationController {
                if let addTodoController = navigationController.topViewController as? AddTodoController {
                    addTodoController.delegate = self
                }
            }
        }
        else if segue.identifier == "editTodoSegue" {
            if let navigationController = segue.destinationViewController as? UINavigationController {
                if let addTodoController = navigationController.topViewController as? AddTodoController {
                    if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                        addTodoController.todoToEdit = checklist.todos[indexPath.row]
                        addTodoController.delegate   = self
                    }
                }
            }
        }
    }
    
    func addItem(item: Todo) {
        delegate?.addToChecklist(checklistIndex!, todo: item)
        let indexPath = NSIndexPath(forRow: checklist.todos.count - 1, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
    }
    
    func editItem(item: Todo) {
        if let todoIndex = checklist.todos.indexOf(item) {
            checklist.todos[todoIndex] = item
        }
        delegate?.editOnChecklist(checklistIndex!, checklist: checklist)
    }
}

// MARK: - Table view data source
extension TodoListController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.todos.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell   = tableView.dequeueReusableCellWithIdentifier("TodolistItem", forIndexPath: indexPath)
        let label  = cell.viewWithTag(2000) as! UILabel
        label.text = checklist.todos[indexPath.row].title
        
        let checkLabel    = cell.viewWithTag(2001) as! UILabel
        checkLabel.hidden = !checklist.todos[indexPath.row].done
        
        return cell
    }
    
    override func tableView(tableView: UITableView,
                            commitEditingStyle editingStyle: UITableViewCellEditingStyle,
                            forRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.removeFromChecklist(checklistIndex!, todo: checklist.todos[indexPath.row])
        
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
}

// MARK: Table view delegate
extension TodoListController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        checklist.todos[indexPath.row].done = !checklist.todos[indexPath.row].done
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        delegate?.editOnChecklist(checklistIndex!, checklist: checklist)
    }
}

// MARK: addTodoDelegate
extension TodoListController: AddTodoDelegate {
    func addTodo(controller: AddTodoController, didFinishAddingItem: Todo) {
        addItem(didFinishAddingItem)
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func addTodo(controller: AddTodoController, didFinishEditingItem: Todo) {
        editItem(didFinishEditingItem)
        if let index = checklist.todos.indexOf(didFinishEditingItem) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        }
        
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}











