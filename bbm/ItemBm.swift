//
//  ItemBm.swift
//  bbm
//
//  Created by songgc on 16/3/30.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit

class ItemBm: NSObject {
    var id:String = ""
    var userid:String = ""
    var senduserid:String = ""
    var username:String = ""
    var telphone:String = ""
    var headface:String = ""
    var sex:String = ""
    var guid:String = ""
    var infoid:String = ""
    var type:String = ""
    var content:String = ""
    var contentid:String = ""
    var status:String = ""
    
    
    init(id:String,userid:String,senduserid:String,username:String,telphone:String,headface:String,sex:String,guid:String,infoid:String,type:String,content:String,contentid:String,status:String)
    {
         self.id = id
         self.userid = userid
         self.senduserid = senduserid
         self.username = username
         self.telphone = telphone
         self.headface = headface
         self.sex = sex
         self.guid = guid
         self.infoid = infoid
         self.type = type
         self.content = content
         self.contentid = contentid
         self.status = status

    }
    
}
