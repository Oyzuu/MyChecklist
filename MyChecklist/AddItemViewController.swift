//
//  AddItemViewController.swift
//  MyChecklist
//
//  Created by BT-Training on 29/08/16.
//  Copyright © 2016 BT-Training. All rights reserved.
//

import UIKit

// MARK: MAGIC TRIM O//
/* 
 extension qui permet d'avoir un trim() plus classique pour le nettoyage des chaînes de caractères
 */
extension String {
    func trim() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
}

// MARK: Delegate protocol
protocol AddItemViewControllerDelegate: class {
    func addItemViewControllerDidCancel(controller: AddItemViewController)
    func addItemViewController(controller: AddItemViewController, didFinishAddingItem:  Checklist)
    func addItemViewController(controller: AddItemViewController, didFinishEditingItem: Checklist)
}

// MARK: Main
class AddItemViewController: UITableViewController {
    @IBOutlet weak var nameField:  UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var checklistToEdit: Checklist?
    
    weak var delegate: AddItemViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let checklistToEdit = self.checklistToEdit {
            nameField.text = checklistToEdit.title
            title = "Edit item"
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        nameField.becomeFirstResponder()
        doneButton.enabled = nameField.text!.characters.count > 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancel() {
        if let delegate = self.delegate {
            delegate.addItemViewControllerDidCancel(self)
        }
    }
    
    @IBAction func save() {
        let title = nameField.text!.trim()
        if title.characters.count == 0 {
            let alert = UIAlertController(title: "Erreur", message: "Titre vide",
                                          preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            
            alert.addAction(action)
            presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        if let delegate = self.delegate {
            if let checklistToEdit = self.checklistToEdit {
                checklistToEdit.title = nameField.text!.trim()
                delegate.addItemViewController(self, didFinishEditingItem: checklistToEdit)
            }
            else {
                let checklist = Checklist(title: title)
                delegate.addItemViewController(self, didFinishAddingItem: checklist)
            }
        }
    }
}

// MARK: Delegate
extension AddItemViewController {
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath)
        -> NSIndexPath? {
        return nil
    }
}

extension AddItemViewController : UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
                   replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.stringByReplacingCharactersInRange(range, withString: string)
        
        let trimmedText = newText.trim()
        
        doneButton.enabled = trimmedText.characters.count > 0
    
        return true
    }
}


