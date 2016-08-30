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
    let doneKey  = "done"
    
    var title: String = ""
    var done:  Bool   = false
    
    init(title: String) {
        self.title = title
        self.done  = false
    }
    
    // constructeur lié à NSCoding, nécessaire à la désérialisation
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.title = aDecoder.decodeObjectForKey(titleKey) as! String
        self.done  = aDecoder.decodeBoolForKey(doneKey)
    }
    
    // méthode de sérialisation des attributs de la classe
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: titleKey)
        aCoder.encodeBool  (done,  forKey: doneKey)
    }
}