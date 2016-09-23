//
//  Util.swift
//  bbm
//
//  Created by songgc on 16/8/26.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit
import Alamofire

class Util{
    
    class func hiddentelphonechartacter(telphone:String)->String
    {
        var ns1=(telphone as NSString).substringToIndex(3)
        
        var ns2=(telphone as NSString).substringFromIndex(7)
        var ns3=ns1.stringByAppendingString("****").stringByAppendingString(ns2)
        return ns3
        //self.telphone.text=ns3;
    }
    
    
    class func loadheadface(singleimageView:UIImageView,url:String)
    {
        //var imgurl = "http://api.bbxiaoqu.com/uploads/".stringByAppendingString(picname)
        //            let nsd = NSData(contentsOfURL:NSURL(string: imgurl)!)
        //            singleimageView=UIImage(data: nsd!);
        singleimageView.image = UIImage(named: "logo")
        Alamofire.request(.GET, url).response { (_, _, data, _) -> Void in
            if let d = data as? NSData!
            {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    singleimageView.image = UIImage(data: d)
                    
                })
            }
        }
        
    }

    
    class func loadpic(singleimageView:UIImageView,url:String)
    {
        //var imgurl = "http://api.bbxiaoqu.com/uploads/".stringByAppendingString(picname)
        //            let nsd = NSData(contentsOfURL:NSURL(string: imgurl)!)
        //            singleimageView=UIImage(data: nsd!);
        
//        Alamofire.request(.GET, url).response { (_, _, data, _) -> Void in
//            if let d = data as? NSData!
//            {
//                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    singleimageView.image = UIImage(data: d)
//                    
//                })
//            }
//        }
        
        
        Alamofire.request(.GET, url)
            .response { request, response, data, error in
                
                if(error==nil)
                {
                    if let d = data as? NSData!
                               {
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        singleimageView.image = UIImage(data: d)
                                    
                                    })
                                }

                }else
                {
                    singleimageView.image = UIImage(named: "xz_pic_loaderr")

                }
        }
        
        
    }

}