//
//  ViewController.swift
//  MyChecklist
//
//  Created by BT-Training on 26/08/16.
//  Copyright © 2016 BT-Training. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
    let checklistsKey = "checklists"
    var dataModel     = [Checklist]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadChecklists()
        
        // ajout d'une vue vide comme footer pour éviter les cellules vides
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Segue preparation of doom
    /*
     Préparation du contrôleur en fonction du segue qui est appelé pour définir le comportement
     du contrôleur cible en fonction du type d'action (add / edit) et assignation d'un delegate
     */
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
                        addItemViewController.delegate        = self
                    }
                }
            }
        }
        else if segue.identifier == "toTodoSegue" {
            if let destination = segue.destinationViewController as? TodoListController {
                if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                    destination.checklist      = dataModel[indexPath.row]
                    destination.checklistIndex = indexPath.row
                    destination.delegate       = self
                }
            }
        }
    }
    
    /*
     Ajout d'item dans la liste de Checklist avec rafraichissement de la Table View,
     scrollToRowAtIndexPath force le scrolling sur le dernier élément ajouté si la taille de la
     liste dépasse celle de l'écran
     */
    func addItem(item: Checklist) {
        dataModel.append(item)
        let indexPath = NSIndexPath(forRow: dataModel.count - 1, inSection: 0)
        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Left)
        tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
    }
    
    /*
     Récupère le chemin du dossier Documents propre à l'application
     */
    func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths[0]
    }
    
    /*
     Récupère le chemin du fichier qui servira à la sauvegarde par ajout de la chaine au chemin d'accès
     par la méthode stringByAppendingPathComponent de NSString formatte le tout convenablement
     */
    func dataFilePath() -> String {
        return (documentsDirectory() as NSString).stringByAppendingPathComponent("Checklists.plist")
    }
    
    /*
     Sauvegarde des données par instanciation d'un archiveur sur un objet NSMutableData dans lequel
     nous voulons écrire des données encodées par l'archiveur.
     Les données sont endodées dans un XML par paires clé / valeur.
     
     Voir Checklist.swift pour le protocole NSCoding et les méthodes à implémenter pour la
     sérialisation.
     */
    func saveChecklists() {
        let data     = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(dataModel, forKey: checklistsKey)
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }
    
    /* 
     Décodage des données récupérées dans le fichier.
     
     Voir Checklist.swift pour le protocole NSCoding et les méthodes à implémenter pour la 
     sérialisation.
     */
    func loadChecklists() {
        let path = dataFilePath()
        
        guard NSFileManager.defaultManager().fileExistsAtPath(path) else { return }
        
        if let data = NSData(contentsOfFile: path) {
            let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
            defer {
                unarchiver.finishDecoding()
            }
            self.dataModel = unarchiver.decodeObjectForKey(checklistsKey) as! [Checklist]
        }
    }
}

// MARK: AddItemViewControllerDelegate
/* 
 Implémentation du delegate AddItemViewControllerDelegate déclaré dans AddItemViewController.
 Sert de canal de communication entre le délégué et le contrôleur cible -> Similaire au callback
 
 Voir AddItemViewController pour plus d'infos
 */
extension ChecklistViewController: AddItemViewControllerDelegate {
    func addItemViewController(controller: AddItemViewController, didFinishAddingItem: Checklist) {
        addItem(didFinishAddingItem)
        controller.dismissViewControllerAnimated(true, completion: nil)
        saveChecklists()
    }
    
    func addItemViewController(controller: AddItemViewController, didFinishEditingItem: Checklist) {        
        if let index = dataModel.indexOf(didFinishEditingItem) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
        }
        
        controller.dismissViewControllerAnimated(true, completion: nil)
        saveChecklists()
    }
    
    func addItemViewControllerDidCancel(controller: AddItemViewController) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: TodoListDelegate
extension ChecklistViewController: TodoListDelegate {
    func addToChecklist(atIndex: Int, todo: Todo) {
        dataModel[atIndex].todos.append(todo)
        saveChecklists()
    }
    
    func removeFromChecklist(atIndex: Int, todo: Todo) {
        if let todoIndex = dataModel[atIndex].todos.indexOf(todo) {
            print(todoIndex)
            dataModel[atIndex].todos.removeAtIndex(todoIndex)
        }
        saveChecklists()
    }
    
    func editOnChecklist(atIndex: Int, checklist: Checklist) {
        dataModel[atIndex] = checklist
        saveChecklists()
    }
}

// MARK: Data source
extension ChecklistViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.count
    }
    
    override func tableView(tableView: UITableView,
                            cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem",
                                                               forIndexPath: indexPath)
        let label      = cell.viewWithTag(1000) as! UILabel
        let countLabel = cell.viewWithTag(1001) as! UILabel
        
        let checklist = dataModel[indexPath.row]
        label.text    = checklist.title
        
        if checklist.todos.count == 0 {
            countLabel.text = "empty"
        }
        else if checklist.todos.count == checklist.checkedTodosCount {
            countLabel.text = "Done !"
        }
        else if checklist.todos.count > 0 {
            let listCount   = checklist.todos.count - checklist.checkedTodosCount
            countLabel.text = "\(listCount) item(s) left"
        }
        
        return cell
    }
    
    // Permet d'ajouter un swipe left et delete aux cellules de la liste
    override func tableView(tableView: UITableView,
                            commitEditingStyle editingStyle: UITableViewCellEditingStyle,
                            forRowAtIndexPath indexPath: NSIndexPath) {
        dataModel.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        saveChecklists()
    }
}

