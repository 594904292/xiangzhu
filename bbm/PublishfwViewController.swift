//
//  PublishViewController.swift
//  bbm
//
//  Created by ericsong on 15/9/30.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit
import Alamofire

class PublishfwViewController: UIViewController,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate {
    var cat=0;
    
    @IBOutlet weak var titlename: UITextField!
    @IBOutlet weak var content: UITextField!
    @IBOutlet weak var contenttip: UILabel!
    
    @IBOutlet weak var picdiv: UIView!
    var alertView:UIAlertView?
    var img = UIImage()
    var arr = [UIButton]()
    var mCurrent:Int = 0;
    var imgarr = [String]()
    
    @IBAction func contentexit(sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func controlTouchDown(sender: UIControl) {
        content.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title="发布"
        //(UIApplication.sharedApplication().delegate as! AppDelegate).apnsdelegate = self
        //告诉apnsdelegate我在这个里面实现
        
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: "backClick")
        self.navigationItem.rightBarButtonItem=UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.Done, target: self, action: "addClick")

        
        if(cat==0)
        {
             self.navigationItem.title="求帮助"
            content.placeholder="请输入你的求助信息"
        }else if(cat==3)
        {
             self.navigationItem.title="能帮助"
            content.placeholder="请输入你的能帮助信息"
        }

        
        let bw:CGFloat = self.view.frame.width
        var index=0
        let count = 6;
        let rowCount=(count+2)/3;
        for(var i:Int=0;i<rowCount;i++)
        {
            for(var j:Int=0;j<3;j++)
            {
                let button:UIButton = UIButton();
                //设置按钮位置和大小
                let x=CGFloat(100 * j);
                let y=CGFloat((i+1)*100)+140;
                let sw=bw/3;
                button.frame=CGRectMake(x+5, y, sw-10, 98);
                //let strVal:String = String(j)
                
                button.tag = index
                //设置按钮文字
                //button.setTitle("按钮", forState:UIControlState.Normal)
                button.addTarget(self, action: "goImagesel", forControlEvents: UIControlEvents.TouchUpInside)
                button.enabled=false;
                arr.append(button)
                
                self.view.addSubview(button);
                index++
            }
        }
        
        let btn:UIButton = arr[mCurrent] as UIButton;

        btn.setImage(UIImage(named:"ic_add_picture"), forState:UIControlState.Normal)
        btn.setTitle("添加", forState:UIControlState.Normal)
        btn.enabled=true
        
    }
//var images=["movie_home","icon_cinema","start_top250","msg_new"]
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func backClick()
    {
        NSLog("back");
        self.navigationController?.popViewControllerAnimated(true)

    }
    
    
  
    func uploadImg(image: String,filename: String){
        //设定路径
        var furl: NSURL = NSURL(fileURLWithPath: image)
        /** 把UIImage转化成NSData */
        let imageData = NSData(contentsOfURL: furl)
        if (imageData != nil) {
        
        /** 设置上传图片的URL和参数 */
        let defaults = NSUserDefaults.standardUserDefaults();
        let user_id = defaults.stringForKey("userid")
        let url = "http://api.bbxiaoqu.com/upload.php?user=\(user_id!)"
        let request = NSMutableURLRequest(URL: NSURL(string:url)!)
        
        /** 设定上传方法为Post */
        request.HTTPMethod = "POST"
        let boundary = NSString(format: "---------------------------14737809831466499882746641449")
        
        /** 上传文件必须设置 */
        let contentType = NSString(format: "multipart/form-data; boundary=%@",boundary)
        request.addValue(contentType as String, forHTTPHeaderField: "Content-Type")
        
        /** 设置上传Image图片属性 */
        let body = NSMutableData()
        body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
        
        body.appendData(NSString(format:"Content-Disposition: form-data; name=\"uploadfile\"; filename=\"%@\"\r\n",filename).dataUsingEncoding(NSUTF8StringEncoding)!)
        
        body.appendData(NSString(format: "Content-Type: application/octet-stream\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(imageData! as! NSData)
        
        body.appendData(NSString(format: "\r\n--%@\r\n", boundary).dataUsingEncoding(NSUTF8StringEncoding)!)
        request.HTTPBody = body
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: { (response, data, error) -> Void in
        
        if (error == nil && data?.length > 0) {
        
        /** 设置解码方式 */
        let returnString = NSString(data: data!, encoding: NSUTF8StringEncoding)
        let returnData = returnString?.dataUsingEncoding(NSUTF8StringEncoding)
       
            print("returnString----\(returnString)")
        }
        })
        }
    }
    
    func addClick()
    {
        
        if(content.text?.characters.count==0)
        {
            self.alertView = UIAlertView()
            self.alertView!.title = "提示"
            self.alertView!.message = "消息为空"
            self.alertView!.addButtonWithTitle("关闭")
            NSTimer.scheduledTimerWithTimeInterval(1, target:self, selector:"dismiss:", userInfo:self.alertView!, repeats:false)
            self.alertView!.show()
            return;
        }
        var alertView = UIAlertView()
        alertView.title = "系统提示"
        alertView.message = "您确定发布信息吗？"
        alertView.addButtonWithTitle("取消")
        alertView.addButtonWithTitle("确定")
        alertView.cancelButtonIndex=0
        alertView.delegate=self;
        alertView.show()
    }
    
    func dismiss(timer:NSTimer){
        alertView!.dismissWithClickedButtonIndex(0, animated:true)
    }
    
    func alertView(alertView:UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        if(buttonIndex==alertView.cancelButtonIndex){
            print("点击了取消")
        }
        else
        {
            NSLog("add")
            
            let mess:String = content.text!
            Alamofire.request(.POST, "http://api.bbxiaoqu.com/words/isbadword.php", parameters:["mess" : mess])
                .responseJSON { response in
                    if(response.result.isSuccess)
                    {
                        if let jsonItem = response.result.value as? NSArray{
                            if(jsonItem.count==0)
                            {
                                self.savedb();
                            }else
                            {
                                var wwwstr:String="";
                                for data in jsonItem{
                                    wwwstr=wwwstr+(data as! String)+","
                                    
                                }
                                self.contenttip.text="内容不能包含:".stringByAppendingString(wwwstr).stringByAppendingString("等敏感词信息")
                                self.contenttip.textColor=UIColor.redColor()
                                self.errorNotice("有敏感词")
                            }
                        }
                    }else
                    {
                        self.successNotice("网络请求错误")
                        print("网络请求错误")
                    }
            }
        }
    }
    
    func savedb()
    {
        NSLog("add")
        var uuid:CFUUIDRef
        var guid:String
        uuid = CFUUIDCreate(nil)
        guid = CFUUIDCreateString(nil, uuid) as String;
        let defaults = NSUserDefaults.standardUserDefaults();
        let userid = defaults.objectForKey("userid") as! String;
        let lat = defaults.objectForKey("lat") as! String;
        let lng = defaults.objectForKey("lng") as! String;
        var photo:String = "";
        print(self.imgarr.count)

        for(var i:Int = 0;i<self.imgarr.count;i++ )
        {
             NSLog("for")
            
            var path:String = self.imgarr[i] as String
            
            var date = NSDate()
            var timeFormatter = NSDateFormatter()
            timeFormatter.dateFormat = "yyyMMddHHmmss"
            var strNowTime = timeFormatter.stringFromDate(date) as String
            
            var spath:String = userid.stringByAppendingString("/").stringByAppendingString(strNowTime).stringByAppendingString("_").stringByAppendingString(String(i)).stringByAppendingString(".jpg")
            
            var fname:String = strNowTime.stringByAppendingString("_").stringByAppendingString(String(i)).stringByAppendingString(".jpg")
            
            photo = photo.stringByAppendingString(spath)
            if(i<imgarr.count-1)
            {
                photo = photo+","
            }
            uploadImg(path,filename: fname)
        }
        
        var date = NSDate()
        var timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        var strNowTime = timeFormatter.stringFromDate(date) as String
        
        
        let mess:String = content.text!
        let title:String = titlename.text!
        var country:String = "";
        if(defaults.objectIsForcedForKey("country"))
        {
            var country = defaults.objectForKey("country") as! String;
        }else
        {
            var country = "";
        }
        
        var province:String = "";

        if(defaults.objectIsForcedForKey("province"))
        {
            var province = defaults.objectForKey("province") as! String;
        }else
        {
            var province = "";
        }
        
        var city:String = "";

        if(defaults.objectIsForcedForKey("city"))
        {
            var city = defaults.objectForKey("city") as! String;
        }else
        {
            var city = "";
        }
        
         var sublocality:String = "";
        if(defaults.objectIsForcedForKey("sublocality"))
        {
            var sublocality = defaults.objectForKey("sublocality") as! String;
        }else
        {
            var sublocality = "";
        }
        
        var thoroughfare:String = "";
        if(defaults.objectIsForcedForKey("thoroughfare"))
        {
            var thoroughfare = defaults.objectForKey("thoroughfare") as! String;
        }else
        {
            var thoroughfare = "";
        }
        
        
        var address:String = "";
        if(defaults.objectIsForcedForKey("address"))
        {
            var address = defaults.objectForKey("address") as! String;
        }else
        {
            var address = "";
        }
        
        var  dic:Dictionary<String,String> = ["content" : mess, "guid": guid]
        dic["title"]=title;
        dic["congetn"] = mess;
        dic["senduser"] = userid as String;
        dic["lat"] = lat as String;
        dic["lng"] = lng as String;
        dic["country"] = country
        dic["province"] = province
        dic["city"] = city
        dic["citecode"] = city
        dic["district"]=sublocality
        dic["street"]=thoroughfare;
        dic["guid"] = guid;
        
        dic["photo"] = photo;
        dic["village"] = thoroughfare;
        dic["address"] = address;
        dic["sendtime"] = strNowTime;
        
        dic["networklocationtype"] = "";
        dic["operators"] = "";
        dic["catagory"] = String(cat) ;
        dic["streetnumber"] = "-1";
        dic["floor"] = "-1";
        dic["infocatagroy"] = String(cat) ;
        dic["direction"] = "-1";
        dic["radius"] = "-1";
        dic["speed"] = "-1";
        
        Alamofire.request(.POST, "http://api.bbxiaoqu.com/send_test.php", parameters: dic)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                print(response.result.value)
                //                if let JSON = response.result.value {
                //                    print("JSON: \(JSON)")
                //                }
                
                self.successNotice("发布成功")
                self.navigationController?.popViewControllerAnimated(true)
        }
    }
    func goImagesel()
    {
        let actionSheet = UIActionSheet(title: "图片来源", delegate: self, cancelButtonTitle: "照片", destructiveButtonTitle: "相机")
        actionSheet.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if(buttonIndex==0)
        {
            goCamera()
        }else
        {
            goImage()
        }
    }
    //打开相机
    func goCamera(){
        //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
        var sourceType = UIImagePickerControllerSourceType.Camera
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true//设置可编辑
        picker.sourceType = sourceType
        self.presentViewController(picker, animated: true, completion: nil)//进入照相界面
    }
    
    
    //打开相册
    func goImage(){
        let pickerImage = UIImagePickerController()
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            pickerImage.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            pickerImage.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(pickerImage.sourceType)!
        }
        pickerImage.delegate = self
        pickerImage.allowsEditing = true
        self.presentViewController(pickerImage, animated: true, completion: nil)
        
    }
    
    
    //UIImagePicker回调方法
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//        //获取照片的原图
//        //let image = (info as NSDictionary).objectForKey(UIImagePickerControllerOriginalImage)
//        //获得编辑后的图片
//        let image = (info as NSDictionary).objectForKey(UIImagePickerControllerEditedImage)
//        //保存图片至沙盒
//        self.saveImage(image as! UIImage, imageName: iconImageFileName)
//        let fullPath = ((NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents") as NSString).stringByAppendingPathComponent(iconImageFileName)
//        //存储后拿出更新头像
//        let savedImage = UIImage(contentsOfFile: fullPath)
//        self.icon.image=savedImage
//        picker.dismissViewControllerAnimated(true, completion: nil)
//    }
    
    //选择好照片后choose后执行的方法
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        //获取照片的原图
        img = info[UIImagePickerControllerEditedImage] as! UIImage
         let btn:UIButton = arr[mCurrent] as UIButton;
        btn.setImage(img, forState:UIControlState.Normal)
        btn.enabled=false;
        let pos:String = String(mCurrent)
        var iconImageFileName=pos.stringByAppendingString(".jpg")
        //保存图片至沙盒
        //self.saveImage(img, newSize: CGSize(width: 256, height: 256), percent: 0.5, imageName: imgname)
       //self.saveImage(img, newSize: CGSize(width: 256, height: 256), percent: 0.5,imageName: iconImageFileName)
        if(img.size.width>600)
        {
            var rate = 600/img.size.width;
            var ww:CGFloat = CGFloat(600);
            var hh = img.size.height*rate;
            self.saveImage(img, newSize: CGSize(width: ww, height: hh), percent: 0.7,imageName: iconImageFileName)
        }else
        {
            var ww = img.size.width;
            var hh = img.size.height;
            self.saveImage(img, newSize: CGSize(width: ww, height: hh), percent: 0.7,imageName: iconImageFileName)
        }

        //let fullPath: String = NSHomeDirectory().stringByAppendingString("/").stringByAppendingString("Documents").stringByAppendingString("/").stringByAppendingString(pos).stringByAppendingString(".png")
       let fullPath = ((NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents") as NSString).stringByAppendingPathComponent(iconImageFileName)
        
        print("fullPath=\(fullPath)")
        imgarr.append(fullPath);
        
        print("pos\(imgarr.count)")

        
        
        if(mCurrent<5)
        {
            mCurrent=mCurrent+1;
            let addbtn:UIButton = arr[mCurrent] as UIButton;
            addbtn.setTitle("添加", forState:UIControlState.Normal)
            addbtn.enabled=true
            addbtn.setImage(UIImage(named:"ic_add_picture"), forState:UIControlState.Normal)
            
        }

        picker.dismissViewControllerAnimated(true, completion: nil)

    }
    
    
    
    //MARK: - 保存图片至沙盒
    func saveImage(currentImage:UIImage,newSize: CGSize, percent: CGFloat,imageName:String){
        
        UIGraphicsBeginImageContext(newSize)
         currentImage.drawInRect(CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
         let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
          UIGraphicsEndImageContext()
        let imageData: NSData = UIImageJPEGRepresentation(newImage, percent)!

        
        //var imageData = NSData()
        //imageData = UIImageJPEGRepresentation(currentImage, 0.5)!
        // 获取沙盒目录
        let fullPath = ((NSHomeDirectory() as NSString).stringByAppendingPathComponent("Documents") as NSString).stringByAppendingPathComponent(imageName)
        // 将图片写入文件
        imageData.writeToFile(fullPath, atomically: false)
    }
    
//    func saveImage(currentImage: UIImage, newSize: CGSize, percent: CGFloat, imageName: String){
//                 //压缩图片尺寸
//                 UIGraphicsBeginImageContext(newSize)
//                  currentImage.drawInRect(CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
//                 let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
//                 UIGraphicsEndImageContext()
//                  //高保真压缩图片质量
//                  //UIImageJPEGRepresentation此方法可将图片压缩，但是图片质量基本不变，第二个参数即图片质量参数。
//                 let imageData: NSData = UIImageJPEGRepresentation(newImage, percent)!
//                  // 获取沙盒目录,这里将图片放在沙盒的documents文件夹中
//                  //应用程序目录的路径
//                  let fullPath: String = NSHomeDirectory().stringByAppendingString("/").stringByAppendingString(imageName)
//                 // 将图片写入文件
//                 imageData.writeToFile(fullPath, atomically: false)
//              }
    
    
    //cancel后执行的方法
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        //println("cancel--------->>")
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }

}
