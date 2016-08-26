//
//  ItemNotice.swift
//  bbm
//
//  Created by songgc on 16/8/18.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit

class ItemNotice: NSObject {
    var catagory:String = ""
    var content:String = ""
    var time:String = ""
    var senduser:String = ""
    var username:String = ""
    var relation:String = ""
    var readed:String = ""
    
    
    init(catagory:String,content:String,time:String,senduser:String,username:String,relation:String,readed:String)
    {
        self.catagory = catagory
        self.content = content
        self.time = time
        self.senduser = senduser
        self.username = username
        self.relation = relation
        self.readed = readed
        
        
    }

}
