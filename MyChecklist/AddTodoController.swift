//
//  AddTodoController.swift
//  MyChecklist
//
//  Created by BT-Training on 30/08/16.
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

protocol AddTodoDelegate : class {
    func addTodo(controller: AddTodoController, didFinishAddingItem:  Todo)
    func addTodo(controller: AddTodoController, didFinishEditingItem: Todo)
}

class AddTodoController: UITableViewController {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var todoToEdit: Todo?
    
    weak var delegate: AddTodoDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let todoToEdit = self.todoToEdit {
            titleField.text = todoToEdit.title
            title = "Edit todo"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        titleField.becomeFirstResponder()
        doneButton.enabled = titleField.text!.characters.count > 0
    }
    
    @IBAction func cancel() {
        print("add todo cancel")
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func save() {
        print("add todo save")
        let title = titleField.text!.trim()
        
        if title.characters.count == 0 {
            let alert = UIAlertController(title: "Erreur", message: "Titre vide",
                                          preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
            
            alert.addAction(action)
            presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        if let delegate = self.delegate {
            if let todoToEdit = self.todoToEdit {
                todoToEdit.title = title
                delegate.addTodo(self, didFinishEditingItem: todoToEdit)
            }
            else {
                delegate.addTodo(self, didFinishAddingItem: Todo(title: title))
            }
        }
    }
}

extension AddTodoController : UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
                   replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.stringByReplacingCharactersInRange(range, withString: string)
        
        let trimmedText = newText.trim()
        
        doneButton.enabled = trimmedText.characters.count > 0
        
        return true
    }
}