//
//  itemMess.swift
//  bbm
//
//  Created by ericsong on 15/10/15.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit

class itemMess: NSObject {
    var userid: String = ""
    var headface: String = ""
    var sex: String = ""
    var username: String = ""
    var time: String = ""
    var city: String = ""
    var street: String = ""
    var address: String = ""
    var content: String = ""
    var community: String = ""
    var lng: String = ""
    var lat: String = ""
    var guid: String = ""
    var infocatagory: String = ""
    var photo: String = ""
    var status: String = ""
    var visnum: String = ""
    var plnum: String = ""
    
    
    var name:String
    {
        get{
            return username;
        }
    }
    
    init(userid:String,headface:String,sex:String,vname: String,vtime: String,city: String,street: String,vaddress: String,vcontent: String,vcommunity:String,vlng:String,vlat:String,vguid:String,vinfocatagory:String,vphoto:String,status:String,visnum:String,plnum:String) {
        self.userid=userid
        self.headface=headface
         self.sex=sex
        self.username = vname
        self.time = vtime
        self.city = city

        self.street = street

        self.address = vaddress
        self.content = vcontent
        self.community = vcommunity
        self.lng = vlng
        self.lat = vlat
        self.guid = vguid
        self.infocatagory = vinfocatagory
        self.photo = vphoto
        self.status=status
        self.visnum = visnum
        self.plnum = plnum
    }
    
}
