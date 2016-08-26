//
//  Evaluate.swift
//  bbm
//
//  Created by songgc on 16/3/31.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit

class ItemEvaluate: NSObject {
    var id:String = ""
    var guid:String = ""
    var infouser:String = ""
    var username:String = ""
    var userid:String = ""
    var sex:String;
     var headface:String;
    var score:String = ""
    var evalute:String = ""
     var evalutetag:String;
    var addtime:String = ""
    
    init(id:String,guid:String,infouser:String,username:String,userid:String,sex:String,headface:String,score:String,evalute:String,evalutetag:String,addtime:String)
    {
        self.id = id
        self.guid = guid
        self.infouser = infouser
        self.username=username
        self.userid = userid
        self.sex = sex
        self.headface = headface
        self.score = score
        self.evalute = evalute
        self.evalutetag = evalutetag
        self.addtime = addtime
    }
    
}
