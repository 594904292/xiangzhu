//
//  ItemXiaoqu.swift
//  bbm
//
//  Created by songgc on 16/9/19.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit

class ItemXiaoqu: NSObject {
    var id:String = ""
    var code:String = ""
    var name:String = ""
     var province:String = ""
     var city:String = ""
     var district:String = ""
     var street:String = ""
    
    init(id:String,province:String,city:String,district:String,street:String,code:String,name:String)
    {
          self.id = id
          self.province = province
          self.city = city
          self.district = district
        
        self.street = street
        self.code = code
        self.name = name
    }

}
