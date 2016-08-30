//
//  Todo.swift
//  MyChecklist
//
//  Created by BT-Training on 30/08/16.
//  Copyright © 2016 BT-Training. All rights reserved.
//

import Foundation

class Todo : NSObject, NSCoding {
    let titleKey = "title"
    let doneKey  = "done"
    
    var title = ""
    var done  = false
    
    init(title: String) {
        self.title = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.title = aDecoder.decodeObjectForKey(titleKey) as! String
        self.done  = aDecoder.decodeBoolForKey(doneKey)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: titleKey)
        aCoder.encodeBool  (done,  forKey: doneKey)
    }
}
