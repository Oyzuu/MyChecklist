//
//  Checklist.swift
//  MyChecklist
//
//  Created by BT-Training on 26/08/16.
//  Copyright © 2016 BT-Training. All rights reserved.
//

import Foundation

class Checklist : NSObject, NSCoding {
    let titleKey = "title"
    let todosKey = "todos"
    
    var title = ""
    var todos = [Todo]()
    var checkedTodosCount: Int {
        var count = 0
        for item in todos {
            if item.done {
                count += 1
            }
        }
        
        return count
    }
    
    init(title: String) {
        self.title = title
    }
    
    // constructeur lié à NSCoding, nécessaire à la désérialisation
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.title = aDecoder.decodeObjectForKey(titleKey) as! String
        self.todos = aDecoder.decodeObjectForKey(todosKey) as! [Todo]
    }
    
    // méthode de sérialisation des attributs de la classe
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: titleKey)
        aCoder.encodeObject(todos, forKey: todosKey)
    }
}