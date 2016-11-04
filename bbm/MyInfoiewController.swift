//
//  SubscribeCommunityViewController.swift
//  bbm
//
//  Created by ericsong on 15/10/13.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit
import Alamofire
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

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class MyInfoViewController: UIViewController ,UINavigationControllerDelegate ,UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource,UIImagePickerControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate,UITextViewDelegate{
    
    var fullPath:String = "";
    var xiaoquid:String = "";
    var xiaoquname:String = "";
    var xiaoqulat:String = "";
    var xiaoqulng:String = "";
    var brithday:String="";
    var agenum:String="";
    
    
    @IBOutlet weak var headface: UIImageView!
    @IBOutlet weak var nickname: UITextField!
    //@IBOutlet weak var age: UITextField!
    //@IBOutlet weak var xiaoqu: UITextField!
    @IBOutlet weak var tel: UITextField!
    @IBOutlet weak var sex: UIPickerView!
    
    @IBOutlet weak var brithdate: UIDatePicker!
    
    @IBOutlet weak var introduce: UITextView!
    @IBOutlet weak var weixin_textfield: UITextField!
    
    @IBOutlet var myview: UIControl!
    @IBAction func calcage(_ sender: UIDatePicker) {
        //需要转换的字符串
        //var dateString:NSString="2015-06-26";
        //设置转换格式
        let formatter:DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        
        brithday = formatter.string(from: sender.date)
        
        NSLog("now:\(brithday)")
        
        let todayDate: Date = Date()
       // let second =todayDate.timeIntervalSinceDate(<#T##anotherDate: NSDate##NSDate#>)
        let second = todayDate.timeIntervalSince(sender.date)
        let year=Int(second/(60*60*24*365))
        NSLog("second:\(second)")
        NSLog("year:\(year)")
        //age.text=String(year);
        agenum=String(year);
        
    }
    
    var img = UIImage()
    @IBAction func controlTouchdown(_ sender: UIControl) {
        nickname.resignFirstResponder()
        //age.resignFirstResponder()
        //xiaoqu.resignFirstResponder()
        tel.resignFirstResponder()
        sex.resignFirstResponder()
        introduce.resignFirstResponder()
        weixin_textfield.resignFirstResponder()
    }

    @IBAction func nicknameexit(_ sender: AnyObject) {
        sender.resignFirstResponder()
    }
    
    @IBAction func ageexit(_ sender: AnyObject) {
        sender.resignFirstResponder()
    }
    
    @IBAction func xiaoquexit(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func telexit(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func weixinexit(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
//    func changeWord(controller:XiaoquTableViewController,xqname:String,xqid:String,xqlat:String,xqlng:String){
//        //qzLabel!.text = string
//        xiaoqu.text=xqname
//        xiaoquid=xqid;
//        xiaoquname=xqname;
//        xiaoqulat=xqlat;
//        xiaoqulng=xqlng;
//    }
    
    
    @IBAction func savemyinfo(_ sender: UIButton) {
       
        NSLog("add")
        let defaults = UserDefaults.standard;
        let userid = defaults.object(forKey: "userid") as! String;
        
         var  dica:Dictionary<String,String> = ["_userid" : userid]
        dica["_username"]=nickname.text;
        NSLog(String(dica.count))
        Alamofire.request("http://api.bbxiaoqu.com/isexitusername.php",method:HTTPMethod.post, parameters: dica).response { response in
            print("Request: \(response.request)")
            print("Response: \(response.response)")
            print("Error: \(response.error)")

            if(response.error==nil)
            {
                let str:NSString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)!
                
                print(str)
                print(str)
                if str == "0"
                {
                    self.saveinfo();
                }else
                {
                   self.nickname.text = ""
                  self.successNotice("用户已存在")
                }
            }
        }
      }
    
    
    func saveinfo() {
        NSLog("add")
        //
        let defaults = UserDefaults.standard;
        let userid = defaults.object(forKey: "userid") as! String;
        let lat = defaults.object(forKey: "lat") as! String;
        let lng = defaults.object(forKey: "lng") as! String;
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyMMddHHmmss"
        let strNowTime = timeFormatter.string(from: date) as String
        let fname:String = ((userid + "_") + strNowTime) + ".jpg"
        // NSLog(fullPath)
        
        print("savemyinfo fullPath=\(fullPath)")
        print("savemyinfo fname=\(fname)")
        var  dic:Dictionary<String,String> = ["userid" : userid]
        
        if(fullPath.characters.count>0)
        {
            uploadImg(fullPath,filename: fname)
            dic["headface"]=fname;
        }else
        {
            dic["headface"]="";
        }
        
        dic["username"]=nickname.text;
        dic["age"] = agenum;
        dic["brithday"] = brithday;
        if(selsexpicker=="男")
        {
            dic["sex"] = "1"
        }else
        {
            dic["sex"] = "0"
        }
        dic["telphone"] = tel.text;
        dic["community"] = xiaoquname;
        dic["community_id"] = xiaoquid;
        dic["community_lat"] = xiaoqulat;
        dic["community_lng"] = xiaoqulng;
        dic["introduce"] = introduce.text;
        dic["weixin"] = weixin_textfield.text;
        Alamofire.request("http://api.bbxiaoqu.com/saveuserinfo.php", method:HTTPMethod.post,parameters: dic)
            .responseJSON { response in
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                print(response.result.value)
                self.successNotice("更新成功")
        }

    }
    
    var selsexpicker:String="男";
    var arr = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        arr = ["男","女"]
        self.navigationItem.title="个人资料"
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.done, target: self, action: #selector(MyInfoViewController.backClick))
        // Do any additional setup after loading the view.
        sex.delegate = self
        sex.dataSource = self
        headface.isUserInteractionEnabled = true
        let singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyInfoViewController.goImagesel))
        headface .addGestureRecognizer(singleTap)
        
        
        let layer:CALayer = headface.layer
        layer.borderColor=UIColor.lightGray.cgColor
        layer.borderWidth = 1.0;

         //headface.addTarget(self, action: "goImagesel", forControlEvents: UIControlEvents.TouchUpInside)
        let layer1:CALayer = introduce.layer
        layer1.borderColor=UIColor.lightGray.cgColor
        layer1.borderWidth = 1.0;

        
        let defaults = UserDefaults.standard;
        let userid = defaults.object(forKey: "userid") as! NSString;
        loaduserinfo(userid as String)
      
        
        self.weixin_textfield.delegate = self
        self.nickname.delegate = self
        self.tel.delegate=self
        
     }
    
    func keyBoardWillShow(_ note:Notification)
        
    {
        
        let userInfo  = note.userInfo as! NSDictionary
        
        let  keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        
        
        var keyBoardBoundsRect = self.view.convert(keyBoardBounds, to:nil)
        
        
        
        var keyBaoardViewFrame = myview.frame
        
        let deltaY = keyBoardBounds.size.height
        
        
        
        let animations:(() -> Void) = {
            
            
            
            self.myview.transform = CGAffineTransform(translationX: 0,y: -deltaY)
            
        }
        
        
        
        if duration > 0 {
            
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            
            
            
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
            
            
            
            
            
        }else{
            
            
            
            animations()
            
        }
        
        
        
        
        
    }
    
    
    
    func keyBoardWillHide(_ note:Notification)
        
    {
        
        
        
        let userInfo  = note.userInfo as! NSDictionary
        
        
        
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        
        
        
        
        let animations:(() -> Void) = {
            
            
            
            self.myview.transform = CGAffineTransform.identity
            
            
            
        }
        
        
        
        if duration > 0 {
            
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            
            
            
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
            
            
            
            
            
        }else{
            
            
            
            animations()
            
        }
        
        
        
        
        
        
        
        
        
    }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func backClick()
    {
        NSLog("back");
        self.navigationController?.popViewController(animated: true)
        
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    
    func loaduserinfo(_ userid:String)
    {
         let url_str:String = "http://api.bbxiaoqu.com/getuserinfo.php?userid=" + userid
        Alamofire.request(url_str,method:HTTPMethod.post, parameters:nil)
            .responseJSON { response in
                //                print(response.request)  // original URL request
                //                print(response.response) // URL response
                //                print(response.data)     // server data
                //                print(response.result)   // result of response serialization
                                print(response.result.value)
                if let JSON:NSArray = response.result.value as! NSArray {
                    print("JSON1: \(JSON.count)")
                    if(JSON.count==0)
                    {
                        
                       
                        
                    }else
                    {
                        
                        let telphone:String = (JSON[0] as! NSDictionary).object(forKey: "telphone") as! String;
                        let headfaceurl:String = (JSON[0] as! NSDictionary).object(forKey: "headface") as! String;
                        let username:String = (JSON[0] as! NSDictionary).object(forKey: "username") as! String;
                        var age:String;
                        if((JSON[0] as! NSDictionary).object(forKey: "age")==nil)
                        {
                            age="";
                        }else
                        {
                            age = (JSON[0] as! NSDictionary).object(forKey: "age") as! String;
                        }
                        
                        var usersex:String;
                        if((JSON[0] as! NSDictionary).object(forKey: "sex")==nil)
                        {
                            usersex="1";
                        }else
                        {
                            usersex = (JSON[0] as! NSDictionary).object(forKey: "sex") as! String;
                        }
                        
                        var weixin:String;
                        if((JSON[0] as! NSDictionary).object(forKey: "weixin")==nil)
                        {
                            weixin="";
                        }else
                        {
                            weixin = (JSON[0] as! NSDictionary).object(forKey: "weixin") as! String;
                        }

                        
                       self.weixin_textfield.text=weixin
                        
                        self.nickname.text=username;
                        self.tel.text=telphone;
                        //self.xiaoqu.text=community;
                       // self.age.text=age;
                        self.agenum=age
                        //print("JSON1: \(self.sex?.selectedRowInComponent(0))")
                        if(usersex=="1")
                        {//男
                            self.sex.selectRow(0, inComponent: 0, animated: true)
                        }else
                        {//女
                            self.sex.selectRow(1, inComponent: 0, animated: true)
                        }
                        
                        self.nickname.text=username;
                        self.tel.text=telphone;
                        //self.xiaoqu.text=community;
                        //self.age.text=age;
                        
                        //print("JSON1: \(self.sex?.selectedRowInComponent(0))")
                        if(usersex=="1")
                        {//男
                            self.sex.selectRow(0, inComponent: 0, animated: true)
                        }else
                        {//女
                            self.sex.selectRow(1, inComponent: 0, animated: true)
                        }
                        if((JSON[0] as! NSDictionary).object(forKey: "brithday")==nil)
                        {
                            self.brithday="1970-01-01";
                        }else
                        {
                            self.brithday = (JSON[0] as! NSDictionary).object(forKey: "brithday") as! String;
                            if(self.brithday.characters.count<10)
                            {
                            self.brithday="1970-01-01";
                            }
                        }

                        
                        //需要转换的字符串
                        //var dateString:NSString="2015-06-26";
                        //设置转换格式
                        let formatter:DateFormatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd"
                        
                        var now = Date()
                        now = formatter.date(from: self.brithday as String)!
                        
                        
                        self.brithdate.setDate(now, animated: true)
                        
                        if(headfaceurl.characters.count>0)
                        {
                            let url="http://api.bbxiaoqu.com/uploads/"+headfaceurl;
                            Util.loadheadface(self.headface, url: url)
                        }else
                        {
                            self.headface?.image = UIImage(named: "logo")
                        }
                    }

                    
                }
        }
    }
    
    
    // 设置列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
   
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arr.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
       if(component == 0){
            return arr[row]
        }
        return nil
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //NSLog(arr[row])
        selsexpicker=arr[row];
    }
    
    
    
    
    
    func uploadImg(_ image: String,filename: String){
        //设定路径
        let furl: URL = URL(fileURLWithPath: image)
        /** 把UIImage转化成NSData */
        let imageData = try? Data(contentsOf: furl)
        if (imageData != nil) {
            
            /** 设置上传图片的URL和参数 */
            let defaults = UserDefaults.standard;
            let user_id = defaults.string(forKey: "userid")
            let url = "http://api.bbxiaoqu.com/upload.php"
            let request = NSMutableURLRequest(url: URL(string:url)!)
            
            /** 设定上传方法为Post */
            request.httpMethod = "POST"
            let boundary = NSString(format: "---------------------------14737809831466499882746641449")
            
            /** 上传文件必须设置 */
            let contentType = NSString(format: "multipart/form-data; boundary=%@",boundary)
            request.addValue(contentType as String, forHTTPHeaderField: "Content-Type")
            
            /** 设置上传Image图片属性 */
            let body = NSMutableData()
            body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
            
            body.append(NSString(format:"Content-Disposition: form-data; name=\"uploadfile\"; filename=\"%@\"\r\n",filename).data(using: String.Encoding.utf8.rawValue)!)
            
            body.append(NSString(format: "Content-Type: application/octet-stream\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
            body.append(imageData! )
            
            body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
            request.httpBody = body as Data
            
            NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main, completionHandler: { (response, data, error) -> Void in
                
                if (error == nil && data?.count > 0) {
                    
                    /** 设置解码方式 */
                    let returnString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    let returnData = returnString?.data(using: String.Encoding.utf8.rawValue)
                    
                    print("returnString----\(returnString)")
                }
            })
        }
    }
    
    func goImagesel()
    {
        let actionSheet = UIActionSheet(title: "图片来源", delegate: self, cancelButtonTitle: "照片", destructiveButtonTitle: "相机")
        actionSheet.show(in: self.view)
    }
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
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
        var sourceType = UIImagePickerControllerSourceType.camera
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            sourceType = UIImagePickerControllerSourceType.photoLibrary
        }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true//设置可编辑
        picker.sourceType = sourceType
        self.present(picker, animated: true, completion: nil)//进入照相界面
    }
    
    
    //打开相册
    func goImage(){
        let pickerImage = UIImagePickerController()
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary){
            pickerImage.sourceType = UIImagePickerControllerSourceType.photoLibrary
            pickerImage.mediaTypes = UIImagePickerController.availableMediaTypes(for: pickerImage.sourceType)!
        }
        pickerImage.delegate = self
        pickerImage.allowsEditing = true
        self.present(pickerImage, animated: true, completion: nil)
        
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        //获取照片的原图
        img = info[UIImagePickerControllerEditedImage] as! UIImage
        headface.image=img
        
        let defaults = UserDefaults.standard;
        let userid = defaults.object(forKey: "userid") as! NSString;
        
        
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyMMddHHmmss"
        let strNowTime = timeFormatter.string(from: date) as String

        
       let iconImageFileName=(userid.appending("_") + strNowTime) + ".jpg"
//        //保存图片至沙盒
//        //self.saveImage(img, newSize: CGSize(width: 256, height: 256), percent: 0.5, imageName: imgname)
        self.saveImage(img, newSize: CGSize(width: 256, height: 256), percent: 0.5,imageName: iconImageFileName)
//        
//        //let fullPath: String = NSHomeDirectory().stringByAppendingString("/").stringByAppendingString("Documents").stringByAppendingString("/").stringByAppendingString(pos).stringByAppendingString(".png")
        fullPath = ((NSHomeDirectory() as NSString).appendingPathComponent("Documents") as NSString).appendingPathComponent(iconImageFileName)
//        
        print("imagePickerController fullPath=\(fullPath)")
//        imgarr.append(fullPath);
//        
//        print("pos\(imgarr.count)")
//        
//        
//        
//        if(mCurrent<5)
//        {
//            mCurrent=mCurrent+1;
//            let addbtn:UIButton = arr[mCurrent] as UIButton;
//            addbtn.setTitle("添加", forState:UIControlState.Normal)
//            addbtn.enabled=true
//            addbtn.setImage(UIImage(named:"ic_add_picture"), forState:UIControlState.Normal)
//            
//        }
//        
        picker.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    //MARK: - 保存图片至沙盒
    func saveImage(_ currentImage:UIImage,newSize: CGSize, percent: CGFloat,imageName:String){
        
        UIGraphicsBeginImageContext(newSize)
        currentImage.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let imageData: Data = UIImageJPEGRepresentation(newImage, percent)!
        
        
        //var imageData = NSData()
        //imageData = UIImageJPEGRepresentation(currentImage, 0.5)!
        // 获取沙盒目录
        fullPath = ((NSHomeDirectory() as NSString).appendingPathComponent("Documents") as NSString).appendingPathComponent(imageName)
        print("saveImage fullPath=\(fullPath)")

        // 将图片写入文件
        try? imageData.write(to: URL(fileURLWithPath: fullPath), options: [])
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
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        //println("cancel--------->>")
        picker.dismiss(animated: true, completion: nil)
        
    }

    
    /**
     解决textview遮挡键盘代码
     
     :param: textView textView description
     */
    func textViewDidBeginEditing(_ textView: UITextView) {
        let frame:CGRect = textView.frame
        let offset:CGFloat = frame.origin.y + 100 - (self.view.frame.size.height-330)
        
        if offset > 0  {
            
            self.view.frame = CGRect(x: 0.0, y: -offset, width: self.view.frame.size.width, height: self.view.frame.size.height)
        }
        
    }
    
    
    /**
     恢复视图
     
     :param: textView textView description
     */
    func textViewDidEndEditing(_ textView: UITextView) {
        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
    }
    
    
    /**
     
     解决textField遮挡键盘代码
     :param: textField textField description
     */
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //
        let frame:CGRect = textField.frame
        let offset:CGFloat = frame.origin.y + 100 - (self.view.frame.size.height-216)
        
        if offset > 0  {
            
            self.view.frame = CGRect(x: 0.0, y: -offset, width: self.view.frame.size.width, height: self.view.frame.size.height)
        }
    }
    
    /**
     恢复视图
     
     :param: textField textField description
     */
    func textFieldDidEndEditing(_ textField: UITextField) {
        //
        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
    }
        
}
