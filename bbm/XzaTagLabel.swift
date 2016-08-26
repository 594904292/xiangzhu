

import UIKit


//protocol FaceDelegate:NSObjectProtocol{
//    func (text:String)
//}
//
protocol XzaTagLabelDelegate:NSObjectProtocol{
    func xzatapedTagLabel(labTag:NSInteger , labelText:String , tapedView:UIView);
}


let XZA_HORIZONTAL_PADDING:CGFloat = 13.0;//Label的宽
let XZA_VERTICAL_PADDING:CGFloat =  3.0;//Label的高
let XZA_LABEL_MARGIN:CGFloat = 5.0;//Label的间距
let XZA_BOTTOM_MARGIN:CGFloat = 5.0;//底部的间距
let XZA_BACKGROUND_COLOR:UIColor = UIColor(colorLiteralRed: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1);//Label的背景色

class XzaTagLabel: UIView {
    
    var totalHeight:CGFloat?;//总的高度
    var textArray:NSArray?;//标签的文字内容
    var delegate:XzaTagLabelDelegate!;//标签的代理
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
    
    
    
    
    
    func setTags(tagsArray:NSArray){
        textArray = tagsArray;
        sizeFit = CGSizeZero;
        self.display();
    }
    
    
    func display(){
        
        for subLabel in self.subviews {
            subLabel.removeFromSuperview();
        }
        
        allLabelArray?.removeAllObjects();
        
        
        
        totalHeight = 0;
        
        var previousFrame:CGRect = CGRectZero;
        var gotPreviousFrame:Bool = false;
        
        
        for var index = 0; index < textArray?.count; index += 1 {
            print("index is \(index)")
            
            
            var text:String = textArray?.objectAtIndex(index) as! String;
            
            var tagSize = CGSize(width: self.frame.size.width ,height: 10000.0);
            //根据文字获取其占用的尺寸
            var font:UIFont  = UIFont.systemFontOfSize(12);
            
            var textRect:CGRect = text.boundingRectWithSize(tagSize, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:font], context: nil);
            
            
            textRect.size.width = CGFloat(textRect.size.width + XZA_HORIZONTAL_PADDING * 2);
            textRect.size.height = CGFloat(textRect.size.height + XZA_VERTICAL_PADDING * 2);
            
            var label:UILabel?;
            
            if(!gotPreviousFrame){
                label = UILabel(frame: CGRectMake(0, 0, textRect.width, textRect.height));
                totalHeight = textRect.height;
            }else{
                var newRect:CGRect = CGRectZero;
                
                var aa:Float = Float(previousFrame.origin.x)
                    + Float(previousFrame.size.width) +
                    Float(textRect.width) +
                    Float(XZA_LABEL_MARGIN)
                
                if(aa  > Float(self.frame.size.width)){
                    newRect.origin = CGPointMake(0, CGFloat(previousFrame.origin.y + textRect.height + XZA_BOTTOM_MARGIN));
                    totalHeight = CGFloat(totalHeight! + textRect.size.height + XZA_BOTTOM_MARGIN);
                }else{
                    newRect.origin = CGPointMake(CGFloat(previousFrame.origin.x + previousFrame.size.width + XZA_LABEL_MARGIN), CGFloat(previousFrame.origin.y));
                }
                
                newRect.size = textRect.size;
                label = UILabel(frame:newRect);
                
            }
            
            self.addSubview(label!);
            
            
            previousFrame = label!.frame;
            gotPreviousFrame = true;
            
            label?.font = UIFont.systemFontOfSize(12);
            label?.backgroundColor = XZA_BACKGROUND_COLOR;
            label?.textColor = UIColor.grayColor();
            
            label?.text = text;
            label?.textAlignment = NSTextAlignment.Center;
            label?.layer.masksToBounds = true;
            
            label?.layer.cornerRadius = 3.0;
            label?.layer.borderColor = UIColor.lightGrayColor().CGColor;
            label?.layer.borderWidth = 0.8;
            
            label?.numberOfLines = 0;
            label?.lineBreakMode = NSLineBreakMode.ByCharWrapping;
            
            label?.tag = index;
            label?.userInteractionEnabled = true;
            
            var tap = UITapGestureRecognizer(target:self, action:"tapLabel:");
            label?.addGestureRecognizer(tap);
            
            
            allLabelArray?.addObject(label!);
            
        }
        
        sizeFit = CGSizeMake(self.frame.size.width, totalHeight!+1.0);
        
        var selfFrame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, totalHeight!);
        
        self.frame = selfFrame;
        
    }
    
    func fittedSize()->CGSize
    {
        return sizeFit!;
    }
    
    func tapLabel(recognizer:UITapGestureRecognizer){
        let labelView:UIView = recognizer.view!;
        let tapTag:NSInteger = labelView.tag;
        
        let labelString:String = textArray?.objectAtIndex(tapTag) as! String;
        
        if(delegate != nil){
            delegate.xzatapedTagLabel(tapTag, labelText:labelString, tapedView: labelView);
            
//            for var index = 0; index < allLabelArray?.count; ++index{
//                
//                let tempLabel = allLabelArray?.objectAtIndex(index) as? UILabel;
//                
//                if(tempLabel?.tag == tapTag){
//                    tempLabel?.backgroundColor = UIColor.greenColor();
//                }else{
//                    tempLabel?.backgroundColor = XZA_BACKGROUND_COLOR;
//                }
//                
//            }
            
            
            
            
            
        }
        
        
    }
    
}
