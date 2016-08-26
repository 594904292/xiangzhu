//
//  extensionString.swift
//  bbm
//
//  Created by songgc on 16/8/23.
//  Copyright © 2016年 sprin. All rights reserved.
//

import Foundation
extension String{
    
    //MARK:获得string内容高度
    
    func stringHeightWith(fontSize:CGFloat,width:CGFloat)->CGFloat{
        
        let font = UIFont.systemFontOfSize(fontSize)
        
        let size = CGSizeMake(width,CGFloat.max)
        
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.lineBreakMode = .ByWordWrapping;
        
        let attributes = [NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy()]
        
        let text = self as NSString
        
        let rect = text.boundingRectWithSize(size, options:.UsesLineFragmentOrigin, attributes: attributes, context:nil)
        
        return rect.size.height
        
    }//funcstringHeightWith
    
}//extension end