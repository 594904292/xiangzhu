//
//  RoyTagLabel.swift
//  RoySwiftTools
//
//  Created by RoyGuo on 15/4/21.
//  Copyright (c) 2015年 RoyGuo. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}



//protocol FaceDelegate:NSObjectProtocol{
//    func selectedFaceImgAction(text:String)
//}
//
protocol RoyTagLabelDelegate:NSObjectProtocol{
    func roytapedTagLabel(_ labTag:NSInteger , labelText:String , tapedView:UIView);
}


let Roy_HORIZONTAL_PADDING:CGFloat = 13.0;//Label的宽
let Roy_VERTICAL_PADDING:CGFloat =  3.0;//Label的高
let Roy_LABEL_MARGIN:CGFloat = 5.0;//Label的间距
let Roy_BOTTOM_MARGIN:CGFloat = 5.0;//底部的间距
//let Roy_BACKGROUND_COLOR:UIColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.0);//Label的背景色
let Roy_BACKGROUND_COLOR:UIColor = UIColor(colorLiteralRed: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1);//Label的背景色

class RoyTagLabel: UIView {
    
    var totalHeight:CGFloat?;//总的高度
    var textArray:NSArray?;//标签的文字内容
    var delegate:RoyTagLabelDelegate!;//标签的代理
    var sizeFit:CGSize?
    
    var allLabelArray:NSMutableArray?;
    
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        allLabelArray = NSMutableArray();
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    func setTags(_ tagsArray:NSArray){
        textArray = tagsArray;
        sizeFit = CGSize.zero;
        self.display();
    }
    
    
    func display(){
        
        for subLabel in self.subviews {
            subLabel.removeFromSuperview();
        }
        
        allLabelArray?.removeAllObjects();
        
        
        
        totalHeight = 0;
        
        var previousFrame:CGRect = CGRect.zero;
        var gotPreviousFrame:Bool = false;
        
        
        for index:Int in 0 ..< (textArray?.count)!
        {
        
            print("index is \(index)")
            
            
            let text:String = textArray?.object(at: index) as! String;
            
            let tagSize = CGSize(width: self.frame.size.width ,height: 10000.0);
            //根据文字获取其占用的尺寸
            let font:UIFont  = UIFont.systemFont(ofSize: 12);
            
            var textRect:CGRect = text.boundingRect(with: tagSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName:font], context: nil);
            
            
            textRect.size.width = CGFloat(textRect.size.width + Roy_HORIZONTAL_PADDING * 2);
            textRect.size.height = CGFloat(textRect.size.height + Roy_VERTICAL_PADDING * 2);
            
            var label:UILabel?;
            
            if(!gotPreviousFrame){
                label = UILabel(frame: CGRect(x: 0, y: 0, width: textRect.width, height: textRect.height));
                totalHeight = textRect.height;
            }else{
                var newRect:CGRect = CGRect.zero;
                
                let aa:Float = Float(previousFrame.origin.x)
                    + Float(previousFrame.size.width) +
                    Float(textRect.width) +
                    Float(Roy_LABEL_MARGIN)
                
                if(aa  > Float(self.frame.size.width)){
                    newRect.origin = CGPoint(x: 0, y: CGFloat(previousFrame.origin.y + textRect.height + Roy_BOTTOM_MARGIN));
                    totalHeight = CGFloat(totalHeight! + textRect.size.height + Roy_BOTTOM_MARGIN);
                }else{
                    newRect.origin = CGPoint(x: CGFloat(previousFrame.origin.x + previousFrame.size.width + Roy_LABEL_MARGIN), y: CGFloat(previousFrame.origin.y));
                }
                
                newRect.size = textRect.size;
                label = UILabel(frame:newRect);
                
            }
            
            self.addSubview(label!);
            
            
            previousFrame = label!.frame;
            gotPreviousFrame = true;
            
            label?.font = UIFont.systemFont(ofSize: 12);
            label?.backgroundColor = Roy_BACKGROUND_COLOR;
            label?.textColor = UIColor.gray;
            
            label?.text = text;
            label?.textAlignment = NSTextAlignment.center;
            label?.layer.masksToBounds = true;
            
            label?.layer.cornerRadius = 3.0;
            label?.layer.borderColor = UIColor.lightGray.cgColor;
            label?.layer.borderWidth = 0.8;
            
            label?.numberOfLines = 0;
            label?.lineBreakMode = NSLineBreakMode.byCharWrapping;
            
            label?.tag = index;
            label?.isUserInteractionEnabled = true;
            
            let tap = UITapGestureRecognizer(target:self, action:#selector(RoyTagLabel.tapLabel(_:)));
            label?.addGestureRecognizer(tap);
            
            
            allLabelArray?.add(label!);
            
        }
        
        sizeFit = CGSize(width: self.frame.size.width, height: totalHeight!+1.0);
        
        let selfFrame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.size.width, height: totalHeight!);
        
        self.frame = selfFrame;
        
    }
    
    func fittedSize()->CGSize
    {
        return sizeFit!;
    }
    
    func tapLabel(_ recognizer:UITapGestureRecognizer){
        let labelView:UIView = recognizer.view!;
        let tapTag:NSInteger = labelView.tag;
        
        let labelString:String = textArray?.object(at: tapTag) as! String;
        
        if(delegate != nil){
            delegate.roytapedTagLabel(tapTag, labelText:labelString, tapedView: labelView);
            
            for index:Int in 0 ..< (allLabelArray?.count)!
            {
        
                
                let tempLabel = allLabelArray?.object(at: index) as? UILabel;
                
                if(tempLabel?.tag == tapTag){
                    tempLabel?.backgroundColor = UIColor.green;
                }else{
                    tempLabel?.backgroundColor = Roy_BACKGROUND_COLOR;
                }
                
            }
            
            
            
            
            
        }
        
        
    }
    
}
