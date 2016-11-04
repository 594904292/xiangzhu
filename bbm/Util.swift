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
    
    class func hiddentelphonechartacter(_ telphone:String)->String
    {
        let ns1=(telphone as NSString).substring(to: 3)
        
        let ns2=(telphone as NSString).substring(from: 7)
        let ns3=(ns1 + "****") + ns2
        return ns3
        //self.telphone.text=ns3;
    }
    
    
    class func loadheadface(_ singleimageView:UIImageView,url:String)
    {
         singleimageView.af_setImage(withURL: URL(string:url)!);
    }

    
    class func loadpic(_ singleimageView:UIImageView,url:String)
    {
        
        
       
        let url = URL(string: url)!
        let placeholderImage = UIImage(named: "xz_pic_loaderr")!
        
        singleimageView.af_setImage(withURL: url, placeholderImage: placeholderImage)
        
       
        
        
    }

}
