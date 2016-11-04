//
//  PublishViewController.swift
//  bbm
//
//  Created by ericsong on 15/9/30.
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


class PublishViewController: UIViewController,UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate{
    var cat=0;
    @IBOutlet weak var contenttip: UILabel!
    @IBOutlet weak var content: UITextView!
    
    @IBOutlet weak var ContentW: NSLayoutConstraint!
    @IBOutlet weak var ContenH: NSLayoutConstraint!
    
    var alertView:UIAlertView?
    var img = UIImage()
    var arr = [UIImageView]()
     var closearr = [UIImageView]()
    var mCurrent:Int = 0;
    var imgarr = [String]()
    
    
    var locService:BMKLocationService!
    var _search:BMKGeoCodeSearch!
    
    @IBAction func contentexit(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func controlTouchDown(_ sender: UIControl) {
        content.resignFirstResponder()
    }
    override func viewDidLayoutSubviews() {
        let w:CGFloat = UIScreen.main.bounds.width
        let h1:CGFloat = self.view.frame.height/10
        let ypos1 = CGFloat(0);
        let ypos2 = h1*CGFloat(2);
        var ypos3 = h1*CGFloat(3);
        
        print(content.frame)
        content.frame=CGRect(x:5,y:ypos1+75,width:w-10,height:h1*2)
        print(content.frame)
        
        
        let contentlayer:CALayer = content.layer
        contentlayer.borderColor=UIColor.lightGray.cgColor
        contentlayer.opacity=0.3
        contentlayer.borderWidth = 1.0;

        
        
        contenttip.frame=CGRect(x: 0+5,y: ypos2+60,width: w-10,height: h1*1)
        content.layer.layoutIfNeeded()
       
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor=UIColor.white
        
        //self.navigationItem.title="襄助"
        
        let returnimg=UIImage(named: "xz_nav_return_icon")
        let item3=UIBarButtonItem(image: returnimg, style: UIBarButtonItemStyle.plain, target: self,  action: #selector(PublishViewController.backClick))
        item3.tintColor=UIColor.white
        self.navigationItem.leftBarButtonItem=item3

        let itemadd=UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.done, target: self, action: #selector(PublishViewController.addClick))
        itemadd.tintColor=UIColor.white
        self.navigationItem.rightBarButtonItem=itemadd
        
        self.navigationItem.title="求帮助"
        var w:CGFloat = UIScreen.main.bounds.width
       let h1:CGFloat = self.view.frame.height/10
        var ypos1 = CGFloat(0);
        let ypos2 = h1*CGFloat(3);
        var ypos3 = h1*CGFloat(3)+90;


        let bw:CGFloat = UIScreen.main.bounds.width
        var index=0
        let count = 4;
             //for(j:Int, in 0 ..< 4)
            for j:Int in 0 ..< 4
            {
                let imageView:UIImageView = UIImageView();
                let sw=bw/4;
                let x:CGFloat = sw * CGFloat(j);
                imageView.frame = CGRect.init(x: x+5, y: ypos2+50, width: sw-10, height: sw-10);
                imageView.tag = index
                
                /////设置允许交互属性
                imageView.isUserInteractionEnabled = true;
                /////添加tapGuestureRecognizer手势
                let tapGR = UITapGestureRecognizer(target: self, action: #selector(PublishViewController.goImagesel(_:)))
                imageView.addGestureRecognizer(tapGR)

                //添加边框
                let layer:CALayer = imageView.layer
                layer.borderColor=UIColor.lightGray.cgColor
                layer.opacity=1
                layer.borderWidth = 1.0;
                imageView.isHidden=true
                arr.append(imageView)
                self.view.addSubview(imageView);
                
                
                let closeimageView:UIImageView = UIImageView();
                let x1:CGFloat = sw * CGFloat(j+1);
                closeimageView.frame=CGRect.init(x: x1-20, y: ypos2+50, width: 20, height: 20);                closeimageView.tag=index
                closeimageView.image=UIImage(named: "xz_quxiao_icon")
                closeimageView.isHidden=true
                /////设置允许交互属性
                closeimageView.isUserInteractionEnabled = true
                /////添加tapGuestureRecognizer手势
                let closetapGR = UITapGestureRecognizer(target: self, action: #selector(PublishViewController.goImageCancel(_:)))
                closeimageView.addGestureRecognizer(closetapGR)

                closearr.append(closeimageView)
                self.view.addSubview(closeimageView);
                
                index += 1
        }
        
        let btn:UIImageView = arr[mCurrent] as UIImageView;
        btn.image=UIImage(named: "xz_jiji_icon")
        btn.isUserInteractionEnabled = true
        btn.isHidden=false

        
        // 设置定位精确度，默认：kCLLocationAccuracyBest
        BMKLocationService.setLocationDesiredAccuracy(kCLLocationAccuracyBest)
        //指定最小距离更新(米)，默认：kCLDistanceFilterNone
        BMKLocationService.setLocationDistanceFilter(10)
        
        //初始化BMKLocationService
        locService = BMKLocationService()
        locService.delegate = self
        //启动LocationService
        locService.startUserLocationService()
        
        _search=BMKGeoCodeSearch()
        _search.delegate=self

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        _search.delegate=nil
        locService.delegate=self
        
        
    }
    

    //处理位置坐标更新
    func didUpdate(_ userLocation: BMKUserLocation!) {
        if(userLocation.location != nil)
        {
            print("经度: \(userLocation.location.coordinate.latitude)")
            print("纬度: \(userLocation.location.coordinate.longitude)")
            
            let defaults = UserDefaults.standard;
            defaults.set(String(userLocation.location.coordinate.latitude), forKey: "lat");
            defaults.set(String(userLocation.location.coordinate.longitude), forKey: "lng");
            defaults.synchronize();
            
            
            let pt:CLLocationCoordinate2D=CLLocationCoordinate2D(latitude: userLocation.location.coordinate.latitude, longitude: userLocation.location.coordinate.longitude)
            
            let option:BMKReverseGeoCodeOption=BMKReverseGeoCodeOption();
            option.reverseGeoPoint=pt;
            _search.reverseGeoCode(option)
            locService.stopUserLocationService()
            let _userid = defaults.object(forKey: "userid") as! NSString;
            if(defaults.object(forKey: "token") != nil)
            {
                let _token = defaults.object(forKey: "token") as! NSString;
                
                Alamofire.request("http://api.bbxiaoqu.com/updatechannelid.php", method:HTTPMethod.post, parameters:["_userId" : _userid,"_channelId":_token])
                    .responseJSON { response in
                        print(response.request)  // original URL request
                        print(response.response) // URL response
                        print(response.data)     // server data
                        print(response.result)   // result of response serialization
                        print(response.result.value)
                }
 
                Alamofire.request("http://api.bbxiaoqu.com/updatelocation.php", method:HTTPMethod.post, parameters:["_userId" : _userid,"_lat":String(userLocation.location.coordinate.latitude),"_lng":String(userLocation.location.coordinate.longitude),"_os":"ios"])
                    .responseJSON { response in
                        print(response.request)  // original URL request
                        print(response.response) // URL response
                        print(response.data)     // server data
                        print(response.result)   // result of response serialization
                        print(response.result.value)
                        
                }
            }
        }else{
            NSLog("userLocation.location is nil")
        }
    }
    
    
    func onGetReverseGeoCodeResult(_ searcher:BMKGeoCodeSearch, result:BMKReverseGeoCodeResult,  errorCode:BMKSearchErrorCode)
    {
        if(errorCode.rawValue==0)
        {
            
            print("province: \(result.addressDetail.province)")
            print("city: \(result.addressDetail.city)")
            print("district: \(result.addressDetail.district)")
            print("streetName: \(result.addressDetail.streetName)")
            print("streetNumber: \(result.addressDetail.streetNumber)")
            
            
            
            print("address: \(result.address)")
            let defaults = UserDefaults.standard;
            defaults.set(result.addressDetail.province, forKey: "province");//省直辖市
            defaults.set(result.addressDetail.city , forKey: "city");//城市
            defaults.set(result.addressDetail.district , forKey: "sublocality");//区县
            defaults.set(result.addressDetail.streetName, forKey: "thoroughfare");//街道
            defaults.set(result.address  , forKey: "address");
            defaults.synchronize();
            
        }else
        {
            let defaults = UserDefaults.standard;
            let a:String = "";
            defaults.set("", forKey: "province");//省直辖市
            defaults.set(a, forKey: "city");//城市
            defaults.set(a, forKey: "sublocality");//区县
            defaults.set(a, forKey: "thoroughfare");//街道
            defaults.set(a, forKey: "address");
            defaults.synchronize();
            
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
    
    
  
    func uploadImg(_ image: String,filename: String){
        //设定路径
        let furl: URL = URL(fileURLWithPath: image)
        /** 把UIImage转化成NSData */
        let imageData = try? Data(contentsOf: furl)
        if (imageData != nil) {
        
        /** 设置上传图片的URL和参数 */
        let defaults = UserDefaults.standard;
        let user_id = defaults.string(forKey: "userid")
        let url = "http://api.bbxiaoqu.com/upload.php?user=\(user_id!)"
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
    
    func addClick()
    {
        
        if(content.text?.characters.count==0)
        {
            self.alertView = UIAlertView()
            self.alertView!.title = "提示"
            self.alertView!.message = "消息为空"
            self.alertView!.addButton(withTitle: "关闭")
            Timer.scheduledTimer(timeInterval: 1, target:self, selector:#selector(PublishViewController.dismiss(_:)), userInfo:self.alertView!, repeats:false)
            self.alertView!.show()
            return;
        }
        let alertView = UIAlertView()
        alertView.title = "系统提示"
        alertView.message = "您确定发布信息吗？"
        alertView.addButton(withTitle: "取消")
        alertView.addButton(withTitle: "确定")
        alertView.cancelButtonIndex=0
        alertView.delegate=self;
        alertView.show()
    }
    
    func dismiss(_ timer:Timer){
        alertView!.dismiss(withClickedButtonIndex: 0, animated:true)
    }
    
    func alertView(_ alertView:UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        if(buttonIndex==alertView.cancelButtonIndex){
            print("点击了取消")
        }
        else
        {
            NSLog("add")
            
            let mess:String = content.text!
            Alamofire.request( "http://api.bbxiaoqu.com/words/isbadword.php",method:HTTPMethod.post, parameters:["mess" : mess])
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
                                self.contenttip.text=("内容不能包含:" + wwwstr) + "等敏感词信息"
                                self.contenttip.textColor=UIColor.red
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
        var uuid:CFUUID
        var guid:String
        uuid = CFUUIDCreate(nil)
        guid = CFUUIDCreateString(nil, uuid) as String;
        let defaults = UserDefaults.standard;
        let userid = defaults.object(forKey: "userid") as! String;
        let lat = defaults.object(forKey: "lat") as! String;
        let lng = defaults.object(forKey: "lng") as! String;
        
        var photo:String = "";
        print(self.imgarr.count)

        //for(i:Int, in 0 ..< self.imgarr.count )
        for i:Int in 0 ..< self.imgarr.count
        {
             NSLog("for")
            
            let path:String = self.imgarr[i] as String
            
            let date = Date()
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "yyyMMddHHmmss"
            let strNowTime = timeFormatter.string(from: date) as String
            
           // let spath:String = userid.stringByAppendingString("/").stringByAppendingString(strNowTime).stringByAppendingString("_").stringByAppendingString(String(i)).stringByAppendingString(".jpg")
            
            let spath:String = userid.appending("/").appending(strNowTime).appending("_").appending(String(i)).appending(".jpg")
            
            let fname:String = ((strNowTime + "_") + String(i)) + ".jpg"
            
            photo = photo + spath
            if(i<imgarr.count-1)
            {
                photo = photo+","
            }
            uploadImg(path,filename: fname)
        }
        
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        let strNowTime = timeFormatter.string(from: date) as String
        
        
        let mess:String = content.text!
        let country:String = "";
//        
//        if(defaults.objectIsForcedForKey("country"))
//        {
//            var country = defaults.objectForKey("country") as! String;
//        }else
//        {
//            var country = "";
//        }
        
        var province:String = "";
        if(defaults.object(forKey: "province") != nil)
        {
            province = (defaults.object(forKey: "province") as? String)!;
        }
        
        var city:String = "";
         if(defaults.object(forKey: "city") != nil)
         {
                 city = (defaults.object(forKey: "city") as? String)!;
        }
        
         var sublocality:String = "";
        if(defaults.object(forKey: "sublocality") != nil)
        {
             sublocality = (defaults.object(forKey: "sublocality") as? String)!;
        }
       
        var thoroughfare:String = "";
        if(defaults.object(forKey: "thoroughfare") != nil)
        {
             thoroughfare = (defaults.object(forKey: "thoroughfare") as? String)!;
        }
        
        let address:String = (defaults.object(forKey: "address") as? String)!;

        
        var  dic:Dictionary<String,String> = ["content" : mess, "guid": guid]
        dic["title"]="";
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
        
        Alamofire.request("http://api.bbxiaoqu.com/send_test.php",method:HTTPMethod.post, parameters: dic)
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
                self.navigationController?.popViewController(animated: true)
        }
    }
    
    func goImageCancel(_ recognizer:UITapGestureRecognizer){
        let labelView:UIView = recognizer.view!;
        let rpos:NSInteger = labelView.tag;
        //var arr = [UIImageView]()
        //var closearr = [UIImageView]()
        print(rpos)
       // for(i:Int, in 0 ..< 4)
        for i:Int in 0 ..< 4
        {
            if(i>=rpos)
            {
                if(i==rpos)
                {
                    let imgview:UIImageView=arr[i]
                    imgview.image=UIImage(named: "xz_jiji_icon")
                    imgview.isUserInteractionEnabled = true
                    imgview.isHidden=false
                }else
                {
                    let imgview:UIImageView=arr[i]
                    imgview.image=UIImage(named: "xz_jiji_icon")
                    imgview.isHidden=true

                }
            }
        }
        
        for i:Int in 0 ..< 4
        {
            let perspos=rpos-1
            if(perspos==i)
            {
                let imgview:UIImageView=closearr[i]
                imgview.isHidden=false

            }else
            {
                let imgview:UIImageView=closearr[i]
                imgview.isHidden=true
            }
        }
        mCurrent=mCurrent-1
        imgarr.remove(at: mCurrent)
        print("------");
        print("------");
        
    }

    
    func goImagesel(_ recognizer:UITapGestureRecognizer)
    {
        let labelView:UIView = recognizer.view!;
        let tapTag:NSInteger = labelView.tag;
        print(tapTag)
        
        print("------");
        print("------");
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
    
    
    //选择好照片后choose后执行的方法
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        //获取照片的原图
        img = info[UIImagePickerControllerEditedImage] as! UIImage
        let btn:UIImageView = arr[mCurrent] as UIImageView;
        /////设置允许交互属性
        btn.isUserInteractionEnabled = false
        //btn.setImage(img, forState:UIControlState.Normal)
        //btn.enabled=false;
        btn.image=img
        btn.isHidden=false;
        let pos:String = String(mCurrent)
        let iconImageFileName=pos + ".jpg"
        //保存图片至沙盒
        //self.saveImage(img, newSize: CGSize(width: 256, height: 256), percent: 0.5, imageName: imgname)
        if(img.size.width>600)
        {
            let rate = 600/img.size.width;
            let ww:CGFloat = CGFloat(600);
            let hh = img.size.height*rate;
            self.saveImage(img, newSize: CGSize(width: ww, height: hh), percent: 0.7,imageName: iconImageFileName)
        }else
        {
            let ww = img.size.width;
            let hh = img.size.height;
             self.saveImage(img, newSize: CGSize(width: ww, height: hh), percent: 0.7,imageName: iconImageFileName)
        }
       
        
        //let fullPath: String = NSHomeDirectory().stringByAppendingString("/").stringByAppendingString("Documents").stringByAppendingString("/").stringByAppendingString(pos).stringByAppendingString(".png")
       let fullPath = ((NSHomeDirectory() as NSString).appendingPathComponent("Documents") as NSString).appendingPathComponent(iconImageFileName)
        
        print("fullPath=\(fullPath)")
        imgarr.append(fullPath);
        
        print("pos\(imgarr.count)")

        
        
        if(mCurrent<3)
        {
            let nextmCurrent=mCurrent+1;
            let addbtn:UIImageView = arr[nextmCurrent] as UIImageView;
           // addbtn.setTitle("添加", forState:UIControlState.Normal)
            //addbtn.enabled=true
            //addbtn.setImage(UIImage(named:"ic_add_picture"), forState:UIControlState.Normal)
            addbtn.image=UIImage(named: "xz_jiji_icon")
            /////设置允许交互属性
            addbtn.isUserInteractionEnabled = true
            addbtn.isHidden=false
            
        }
        for index in 0...3 {
            print("\(index) times 5 is \(index * 5)")
            if(index==mCurrent)
            {
                let close:UIImageView = closearr[index] as UIImageView;
                close.isHidden=false

            }else
            {
                let close:UIImageView = closearr[index] as UIImageView;
                close.isHidden=true
            }
        }
        mCurrent=mCurrent+1;
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
        let fullPath = ((NSHomeDirectory() as NSString).appendingPathComponent("Documents") as NSString).appendingPathComponent(imageName)
        // 将图片写入文件
        try? imageData.write(to: URL(fileURLWithPath: fullPath), options: [])
    }

    //cancel后执行的方法
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        //println("cancel--------->>")
        picker.dismiss(animated: true, completion: nil)
        
    }

}
