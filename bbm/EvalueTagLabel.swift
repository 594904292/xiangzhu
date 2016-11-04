//
//  EvalueTagLabel.swift
//  bbm
//
//  Created by songgc on 16/8/24.
//  Copyright © 2016年 sprin. All rights reserved.
//
protocol EvalueTagLabelDelegate:NSObjectProtocol{
    func xztapedTagLabel(_ labTag:NSInteger , labelText:String , tapedView:UIView);
}


let Evalue_HORIZONTAL_PADDING:CGFloat = 13.0;//Label的宽
let Evalue_VERTICAL_PADDING:CGFloat =  3.0;//Label的高
let Evalue_LABEL_MARGIN:CGFloat = 5.0;//Label的间距
let Evalue_BOTTOM_MARGIN:CGFloat = 5.0;//底部的间距
let Evalue_BACKGROUND_COLOR:UIColor = UIColor(colorLiteralRed: 232/255.0, green: 103/255.0, blue: 98/255.0, alpha: 1);//Label的背景色

class EvalueTagLabel: UIView {
    
    var totalHeight:CGFloat?;//总的高度
    var textArray:NSArray?;//标签的文字内容
    var delegate:EvalueTagLabelDelegate!;//标签的代理
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
            
            
            textRect.size.width = CGFloat(textRect.size.width + Evalue_HORIZONTAL_PADDING * 2);
            textRect.size.height = CGFloat(textRect.size.height + Evalue_VERTICAL_PADDING * 2);
            
            var label:UILabel?;
            
            if(!gotPreviousFrame){
                label = UILabel(frame: CGRect(x: 0, y: 0, width: textRect.width, height: textRect.height));
                totalHeight = textRect.height;
            }else{
                var newRect:CGRect = CGRect.zero;
                
                let aa:Float = Float(previousFrame.origin.x)
                    + Float(previousFrame.size.width) +
                    Float(textRect.width) +
                    Float(Evalue_LABEL_MARGIN)
                
                if(aa  > Float(self.frame.size.width)){
                    newRect.origin = CGPoint(x: 0, y: CGFloat(previousFrame.origin.y + textRect.height + Evalue_BOTTOM_MARGIN));
                    totalHeight = CGFloat(totalHeight! + textRect.size.height + Evalue_BOTTOM_MARGIN);
                }else{
                    newRect.origin = CGPoint(x: CGFloat(previousFrame.origin.x + previousFrame.size.width + Evalue_LABEL_MARGIN), y: CGFloat(previousFrame.origin.y));
                }
                
                newRect.size = textRect.size;
                label = UILabel(frame:newRect);
                
            }
            
            self.addSubview(label!);
            
            
            previousFrame = label!.frame;
            gotPreviousFrame = true;
            
            label?.font = UIFont.systemFont(ofSize: 12);
            label?.backgroundColor = Evalue_BACKGROUND_COLOR;
            label?.textColor = UIColor.white
            
            label?.text = text;
            label?.textAlignment = NSTextAlignment.center;
            label?.layer.masksToBounds = true;
            
            label?.layer.cornerRadius = 3.0;
            label?.layer.borderColor = Evalue_BACKGROUND_COLOR.cgColor;
            label?.layer.borderWidth = 0.8;
            
            label?.numberOfLines = 0;
            label?.lineBreakMode = NSLineBreakMode.byCharWrapping;
            
            label?.tag = index;
            label?.isUserInteractionEnabled = true;
            
            let tap = UITapGestureRecognizer(target:self, action:#selector(EvalueTagLabel.tapLabel(_:)));
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
            delegate.xztapedTagLabel(tapTag, labelText:labelString, tapedView: labelView);
            
            //            for var index = 0; index < allLabelArray?.count; ++index{
            //
            //                let tempLabel = allLabelArray?.objectAtIndex(index) as? UILabel;
            //
            //                if(tempLabel?.tag == tapTag){
            //                    tempLabel?.backgroundColor = UIColor.greenColor();
            //                }else{
            //                    tempLabel?.backgroundColor = XZ_BACKGROUND_COLOR;
            //                }
            //
            //            }
            
            
            
            
            
        }
        
        
    }
    
}
