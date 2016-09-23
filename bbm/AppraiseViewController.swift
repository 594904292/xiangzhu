//
//  AppraiseViewController.swift
//  bbm
//
//  Created by songgc on 16/8/19.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit
import Alamofire
class AppraiseViewController: UIViewController,XzaTagLabelDelegate,XzTagLabelDelegate,UITextViewDelegate{

     var id:String = "";
     var guid:String = "";
     var infoid:String = "";
     var username:String = "";
     var headface:String = "";
     var senduserid:String = "";//志愿意者
     var type:String = "";
     var content:String = "";
     var contentid:String = "";
    @IBOutlet weak var topgood: UILabel!
    @IBOutlet weak var headfaceimg: UIImageView!
    @IBOutlet weak var username_lbl: UILabel!
    @IBOutlet weak var time_lbl: UILabel!
    @IBOutlet weak var score_ratingbar: RatingBar!
    @IBOutlet weak var content_tv: UITextView!
    
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    
    @IBOutlet weak var line3: UIView!
    
    @IBAction func controltouchdown(sender: UIControl) {
         self.view.endEditing(true)
    }
    
    @IBAction func controltouchdown1(sender: UIControl) {
         self.view.endEditing(true)
    }
    
    @IBOutlet weak var tag1view: UIView!
    @IBOutlet weak var tag2view: UIView!
    
     @IBAction func save(sender: UIButton) {
        
        //xzArray
        if(content_tv.text?.characters.count==0)
        {
            self.successNotice("评价不能为空")
            return;
        }
        let date = NSDate()
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        let strNowTime = timeFormatter.stringFromDate(date) as String
        
        let defaults = NSUserDefaults.standardUserDefaults();
        var myuserid = defaults.objectForKey("userid") as! String;
        let evaluatetag = xzArray.joinWithSeparator("|")
        print(evaluatetag) //"1,2,3"
        headface = defaults.objectForKey("headface") as! String;
        let  dic:Dictionary<String,String> = ["_guid" : guid,
                                              "_fromuser" : senduserid,
                                              "_userid" : myuserid,
                                              "_status" : "2",
                                              "_rating" : String(score_ratingbar.rating),
                                              "_content" : content_tv.text,
                                              "_evaluatetag":evaluatetag
                                              ]
        let url_str:String = "http://api.bbxiaoqu.com/genfinshorder_v1.php";
        Alamofire.request(.POST,url_str, parameters:dic)
            .responseString{ response in
                if(response.result.isSuccess)
                {
                    if let ret = response.result.value  {
                        //if String(ret)=="1"
                        //{
                        self.successNotice("发送成功")
                        //}
                    }
                }else
                {
                    self.successNotice("网络请求错误")
                    print("网络请求错误")
                }
        }

        savesolution()
    }
    
    
    
    func savesolution(){
        var date = NSDate()
        var timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        var strNowTime = timeFormatter.stringFromDate(date) as String
        var  dic:Dictionary<String,String> = [ "_guid": guid]
        if(type=="pl")
        {
        dic["_solutiontype"] = "1"
        }else{
        dic["_solutiontype"] = "1"
        }
        
        dic["_solutionpostion"] = contentid
        dic["_solutionuserid"] = senduserid
        dic["_solutiontime"] = strNowTime
        Alamofire.request(.POST, "http://api.bbxiaoqu.com/solution.php", parameters: dic)
            .responseJSON { response in
                if(response.result.isSuccess)
                {
                    self.successNotice("已解决")
                    print("已解决")
                    
                    
                }else
                {
                    self.successNotice("网络请求错误")
                    print("网络请求错误")
                }
                
        }
        
        
        
        
    }

//    (void)textViewDidBeginEditing:(UITextView *)textView {
//    if ([textView.text isEqualToString:@"想说的话"]) {
//    textView.text = @"";
//    }
//    }
//    3.在结束编辑的代理方法中进行如下操作
//    - (void)textViewDidEndEditing:(UITextView *)textView {
//    if (textView.text.length<1) {
//    textView.text = @"想说的话";
//    }
//    }
    
    
    var allTag:XzaTagLabel=XzaTagLabel()
    var xzTag:XzTagLabel = XzTagLabel()
    var allArray:[String] = ["80后","暖男","大叔","雷锋","百事通"];
    var xzArray:[String] = ["大好人"];//已选中
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initnavbar("评价")
        
       
        self.topgood.layer.cornerRadius = 5.0
        self.topgood.layer.masksToBounds = true
        self.line1.backgroundColor=UIColor(colorLiteralRed: 212/255.0, green: 212/255.0, blue: 212/255.0, alpha: 1)
        self.line2.backgroundColor=UIColor(colorLiteralRed: 212/255.0, green: 212/255.0, blue: 212/255.0, alpha: 1)
        self.line3.backgroundColor=UIColor(colorLiteralRed: 212/255.0, green: 212/255.0, blue: 212/255.0, alpha: 1)

        

        
        content_tv.delegate = self;
        //content_tv.borderStyle = UITextBorderStyle.RoundedRect
        content_tv.textColor=UIColor(colorLiteralRed: 182/255.0, green: 182/255.0, blue: 182/255.0, alpha: 1)
        

        loadheadface(headface)
        username_lbl.text=username
        
        
        
        var f  =  CGFloat ( 3)
        score_ratingbar.rating = f
        
        
        let screenWidth = UIScreen.mainScreen().bounds.size;
        
        
        allTag.frame = CGRectMake(10, 0, screenWidth.width-20, 60)
        allTag.delegate = self;
        allTag.setTags(allArray);
        
        
        xzTag.frame = CGRectMake(10, 0, screenWidth.width-20, 60)
        xzTag.delegate = self;
        xzTag.setTags(xzArray);
        
        tag1view.addSubview(xzTag);
        tag2view.addSubview(allTag);
        
        
        
        
    }
    
    
    
    func textViewShouldBeginEditing(textView: UITextView!) -> Bool {
        if (textView.text=="请输入你要对帮助的人说些什么") {
          textView.text = "";
            content_tv.textColor=UIColor(colorLiteralRed: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1)

        }
        return true;
    }
    
    func textViewShouldEndEditing(textView: UITextView!) -> Bool {
        return true;
    }
    
    func textViewDidBeginEditing(textView: UITextView!) {
    }
    
    func textViewDidEndEditing(textView: UITextView!) {
        
        if (textView.text.characters.count<1) {
            textView.text = "请输入你要对帮助的人说些什么";
            content_tv.textColor=UIColor(colorLiteralRed: 182/255.0, green: 182/255.0, blue: 182/255.0, alpha: 1)

        }
    }
    
    func textView(textView: UITextView!, shouldChangeTextInRange range: NSRange, replacementText text: String!) -> Bool {
        if(text=="\n")
        {
            self.view.endEditing(true)
            return false;
        }
        return true;
    }
    
    func textViewDidChange(textView: UITextView!) {
    }
    
    func textViewDidChangeSelection(textView: UITextView!) {
    }
    
    func textView(textView: UITextView!, shouldInteractWithURL URL: NSURL!, inRange characterRange: NSRange) -> Bool {
        return true;
    }
    
    func textView(textView: UITextView!, shouldInteractWithTextAttachment textAttachment: NSTextAttachment!, inRange characterRange: NSRange) -> Bool {
        return true;
    }

    func xzatapedTagLabel(labTag: NSInteger, labelText: String, tapedView: UIView) {
        print("tag:\(labTag)  text:\(labelText)");
        var sel:Int = -1;
        for i in 0..<allArray.count
        {
            if(labelText == allArray[i])
            {
                sel = i
                break;
            }
        }
        if(sel > -1)
        {
             allArray.removeAtIndex(sel)
        }
        xzArray.append(labelText)
        
        xzTag.setTags(xzArray)
       allTag.setTags(allArray);
        
    }
    
    func xztapedTagLabel(labTag: NSInteger, labelText: String, tapedView: UIView) {
        print("tag:\(labTag)  text:\(labelText)");
        var sel:Int = -1;
        for i in 0..<xzArray.count
        {
            if(labelText == xzArray[i])
            {
                sel = i
                break;
            }
        }
        if(sel > -1)
        {
            xzArray.removeAtIndex(sel)
        }
        allArray.append(labelText)
        xzTag.setTags(xzArray);
        allTag.setTags(allArray);
        
    }

    @IBOutlet weak var addtag: UIButton!
    
    @IBAction func AddTabEvent(sender: UIButton) {
        var tagNameTextField: UITextField?
        // 2.
        let alertController = UIAlertController(
            title: "新建标签",
            message: "请输入新标签",
            preferredStyle: UIAlertControllerStyle.Alert)
        
        // 3.
        let addAction = UIAlertAction(
        title: "确认", style: UIAlertActionStyle.Default) {
            (action) -> Void in
            
            if let usernamestr = tagNameTextField?.text {
                print(" tag = \(usernamestr)")
                
                self.xzArray.append(usernamestr)
                self.xzTag.setTags(self.xzArray);
            } else {
                print("No tag entered")
            }
        }
        
        // 4.
        alertController.addTextFieldWithConfigurationHandler {
            (txtUsername) -> Void in
            tagNameTextField = txtUsername
            tagNameTextField!.placeholder = "新标签"
        }
        
        
        // 5.
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel,handler:nil))
        alertController.addAction(addAction)
        self.presentViewController(alertController, animated: true, completion: nil)

    }

    func loadheadface(headname:String)
    {
        if(headname.characters.count>0)
        {
            var myhead:String="http://api.bbxiaoqu.com/uploads/".stringByAppendingString(headface)
            Util.loadheadface(self.headfaceimg, url: myhead)
            self.headfaceimg.layer.cornerRadius = (self.headfaceimg.frame.width) / 2
            self.headfaceimg.layer.masksToBounds = true
        }else
        {
            self.headfaceimg?.image=UIImage(named: "logo")
            self.headfaceimg.layer.cornerRadius = 5.0
            self.headfaceimg.layer.masksToBounds = true
        }
        
    }

    
    func initnavbar(titlestr:String)
    {
        self.title=titlestr
        var returnimg=UIImage(named: "xz_nav_return_icon")
        
        let item3=UIBarButtonItem(image: returnimg, style: UIBarButtonItemStyle.Plain, target: self,  action: "backClick")
        
        item3.tintColor=UIColor.whiteColor()
        
        self.navigationItem.leftBarButtonItem=item3
        
        
        
        
        var searchimg=UIImage(named: "xz_nav_icon_search")
        
        let item4=UIBarButtonItem(image: searchimg, style: UIBarButtonItemStyle.Plain, target: self,  action: "searchClick")
        
        item4.tintColor=UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItem=item4
    }
    func backClick()
    {
        NSLog("back");
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func searchClick()
    {
        var sb = UIStoryboard(name:"Main", bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier("souviewcontroller") as! SouViewController
        self.navigationController?.pushViewController(vc, animated: true)
        //var vc = SearchViewController()
        //self.navigationController?.pushViewController(vc, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
