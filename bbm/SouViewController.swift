//
//  SouViewController.swift
//  bbm
//
//  Created by songgc on 16/8/16.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit
import Alamofire
class SouViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,RoyTagLabelDelegate {

    var _tableView:UITableView!
    var items:[itemMess]=[]
    var start:Int = 0
    var limit:Int = 10
    @IBOutlet weak var sou_txtfield: UITextField!
    @IBOutlet weak var souview: UIView!
    @IBOutlet weak var searchbtn: UIButton!
    
    @IBAction func searchSubmit(sender: UIButton){
        
        if(sou_txtfield.text!.characters.count>0)
        {
            _tableView.hidden=false
            customView.hidden=true
            items.removeAll()
            let keyword:String=sou_txtfield.text!
            querydata(keyword)
        }
    }
    
    
    
    func roytapedTagLabel(labTag: NSInteger, labelText: String, tapedView: UIView) {
        print("tag:\(labTag)  text:\(labelText)");
        _tableView.hidden=false
        customView.hidden=true
        items.removeAll()
        querydata(labelText)
        sou_txtfield.text=labelText
    }
    

    var customView:UIView=UIView();
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title="襄助"
        searchbtn.backgroundColor=UIColor(colorLiteralRed: 232/255.0, green: 103/255.0, blue: 98/255.0, alpha: 1)
        
        
        let usView_search = UIView.init(frame:CGRectMake(0,0, 25,20))
        
        let userImageV_search = UIImageView()
        
        userImageV_search.image = UIImage(named: "xz_searchpage_input_lefticon")
        
        userImageV_search.frame = CGRectMake(10,0, 16,16)
        
        usView_search.addSubview(userImageV_search)
        sou_txtfield.leftView=usView_search
        sou_txtfield.leftViewMode = UITextFieldViewMode.Always
        
        var returnimg=UIImage(named: "xz_nav_return_icon")
        
        let item1=UIBarButtonItem(image: returnimg, style: UIBarButtonItemStyle.Plain, target: self,  action: #selector(SouViewController.backClick))
        
        item1.tintColor=UIColor.whiteColor()
        
        self.navigationItem.leftBarButtonItem=item1

//        
//        var item1 = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: #selector(SouViewController.backClick))
//        item1.tintColor=UIColor.whiteColor()
//        self.navigationItem.leftBarButtonItem=item1
        
        var item2 = UIBarButtonItem(title: "添加", style: UIBarButtonItemStyle.Done, target: self, action: "addClick")
        item2.tintColor=UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem=item2
        let screenWidth = UIScreen.mainScreen().bounds.size;
        
        let royTag = RoyTagLabel(frame: CGRectMake(10, 64, screenWidth.width-20, 60));
        royTag.delegate = self;
        
        let tempArray = ["2016","天气","风景",
                         "浪漫","风光","租房","培训" ,"2016年奥运会","世界杯","中国南海","足球"];
        
        royTag.setTags(tempArray);
        
        
        royTag.frame = CGRectMake(10, 10, screenWidth.width-20, royTag.totalHeight!);
        
        
         customView = UIView(frame: CGRect(x: 0, y: 110, width:self.view.frame.size.width, height: royTag.totalHeight!+20))
        //customView.backgroundColor=UIColor.grayColor()
        
      customView.addSubview(royTag)
        self.view.addSubview(customView)
        
        
       
        _tableView = UITableView(frame: CGRect(x: 0, y: 110, width:self.view.frame.size.width, height: self.view.frame.size.height))
        _tableView.registerClass(OneTableViewCell.self, forCellReuseIdentifier: "cell")//注册自定义cell
        
        self.view.addSubview(_tableView)
        
        _tableView.delegate = self
        _tableView.dataSource = self
        
               
        
        _tableView.estimatedRowHeight = 250
        //setSeparatorInset:UIEdgeInsetsMake
        _tableView.rowHeight = UITableViewAutomaticDimension
        
        self._tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        //设置分割线颜色
        self._tableView.separatorColor = UIColor.redColor()
        //设置分割线内边距
        self._tableView.separatorInset = UIEdgeInsetsMake(5, 0, 0, 0)
        _tableView.hidden=true

    }
    
    
    func backClick()
    {
        NSLog("back");
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    
    func addClick()
    {
        NSLog("addClick");
        var sb = UIStoryboard(name:"Main", bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier("publishController") as! PublishViewController
        vc.cat=0
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 240;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return array.count
        return self.items.count;
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var str:String = "cell\(indexPath.row)"
        var cell:OneTableViewCell = OneTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: str)
        
        var namestr:String=(items[indexPath.row] as itemMess).username
        cell.username.text = namestr//array[indexPath.row]//(items[indexPath.row] as itemMess).username
        let options:NSStringDrawingOptions = .UsesLineFragmentOrigin
        let boundingRect = namestr.boundingRectWithSize(CGSizeMake(200, 0), options: options, attributes:[NSFontAttributeName:cell.username.font], context: nil)
        if((items[indexPath.row] as itemMess).sex == "0")
        {
            cell.seximg.image=UIImage(named: "xz_nan_icon")
        }else
        {
            cell.seximg.image=UIImage(named: "xz_nv_icon")
        }
        cell.seximg.frame=CGRectMake(boundingRect.width+70, 25, 10, 15)
        if (items[indexPath.row] as itemMess).street.characters.count > 0
        {
            cell.street.text=(items[indexPath.row] as itemMess).street
        }else
        {
            cell.street.text="未知"
        }
        let streettr:String = cell.street.text!
        let distanceboundingRect = streettr.boundingRectWithSize(CGSizeMake(200, 0), options: options, attributes:[NSFontAttributeName:cell.street.font], context: nil)
        cell.distance.frame=CGRectMake(distanceboundingRect.width+70, 43, distanceboundingRect.width*2, 30)
        cell.distance.text=(items[indexPath.row] as itemMess).address
        cell.timesgo.text=(items[indexPath.row] as itemMess).time
        cell.content.text=(items[indexPath.row] as itemMess).content
        if((items[indexPath.row] as itemMess).headface.characters.count>0)
        {
            var myhead:String="http://api.bbxiaoqu.com/uploads/".stringByAppendingString((items[indexPath.row] as itemMess).headface)
            
            
            
            Util.loadpic(cell.headface, url: myhead)
            cell.headface.layer.cornerRadius = cell.headface.frame.width / 2
            // image还需要加上这一句, 不然无效
            cell.headface.layer.masksToBounds = true
        }else
        {
            cell.headface.image=UIImage(named: "xz_wo_icon")
            cell.headface.layer.cornerRadius = cell.headface.frame.width / 2
            // image还需要加上这一句, 不然无效
            cell.headface.layer.masksToBounds = true
            
            
        }
        let bw:CGFloat = UIScreen.mainScreen().bounds.width-20
        let sw=bw/4;
        var index=0
        var photoArr:[String] = (items[indexPath.row] as itemMess).photo.characters.split{$0 == ","}.map{String($0)}
        var picnum=photoArr.count
        if(picnum>4)
        {
            picnum=4
        }
        let count = 4;
        //cell.imgview.subviews.removeAll()
        
        for(var j:Int=0;j<picnum;j++)
        {
            let imageView:UIImageView = UIImageView();
            var x:CGFloat = sw * CGFloat(j);
            imageView.frame=CGRectMake(x+5, 5, sw-10, sw-10);
            imageView.tag=indexPath.row*100+j
            let picname:String = photoArr[j]
            var imgurl = "http://api.bbxiaoqu.com/uploads/".stringByAppendingString(picname)
            var layer:CALayer = imageView.layer
            layer.borderColor=UIColor.lightGrayColor().CGColor
            layer.opacity=1
            layer.borderWidth = 1.0;
            imageView.image=UIImage(named: "xz_pic_text_loading")
            Util.loadpic(imageView,url: imgurl);
            //cell.imageView!.image = UIImage(named :"logo")
            cell.imgview.contentMode = UIViewContentMode.ScaleAspectFit
            cell.imgview.addSubview(imageView);
        }
        
        let defaults = NSUserDefaults.standardUserDefaults();
        
        var userid = defaults.objectForKey("userid") as! String;
                    cell.delimg.hidden=true
            cell.clickBtn.hidden = true
        
        
        
        cell.tag1.text="浏览:".stringByAppendingString((items[indexPath.row] as itemMess).visnum).stringByAppendingString("次")
        cell.tag2.text="评论:".stringByAppendingString((items[indexPath.row] as itemMess).plnum).stringByAppendingString("次")
        
        if ((items[indexPath.row] as itemMess).status == "0")
        {
            cell.statusimg.image =  UIImage(named: "xz_qiuzhu_icon")
        }else if ((items[indexPath.row] as itemMess).status == "1")
        {
            cell.statusimg.image = UIImage(named: "xz_qiuzhu_icon")
        }else if ((items[indexPath.row] as itemMess).status == "2")
        {
            cell.statusimg.image = UIImage(named: "xz_yijiejue_icon")
        }
        
        
        
        
        return cell
    }
    //    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    //        if editingStyle == UITableViewCellEditingStyle.Delete  {
    //            array.removeAtIndex(indexPath.row)
    //            _tableView.reloadData()
    //        }
    //    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("clicked at \(indexPath.row)")
        let aa:itemMess=items[indexPath.row] as itemMess;
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("contentviewController") as! ContentViewController
        //创建导航控制器
        //vc.message = aa.content;
        vc.guid=aa.guid
        vc.infoid=aa.guid
        //设置根视图
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    func roundoff(x:Double)->Int
    {
        var a:Int = Int(x)
        var b:Double = Double(a)+0.5
        if(x>b)
        { return a+1 }
        else
        { return a}
    }

    func querydata(keyword:String)
    {
        var akeyword:String = keyword.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!

        var url:String="";
        let defaults = NSUserDefaults.standardUserDefaults();
        let userid = defaults.objectForKey("userid") as! String;
        //let lat = defaults.objectForKey("lat") as! String;
        //let lng = defaults.objectForKey("lng") as! String;
        let lat = String(39.974385);
        let lng = String(116.34777)
            url="http://api.bbxiaoqu.com/getinfos.php?userid=".stringByAppendingString(userid).stringByAppendingString("&latitude=").stringByAppendingString(lat).stringByAppendingString("&longitude=").stringByAppendingString(lng).stringByAppendingString("&rang=xiaoqu&keyword=").stringByAppendingString(akeyword).stringByAppendingString("&start=").stringByAppendingString(String(self.start)).stringByAppendingString("&limit=").stringByAppendingString(String(self.limit));
            
            
  
        print("url: \(url)")
        Alamofire.request(.GET, url, parameters: nil)
            .responseJSON { response in
                if(response.result.isSuccess)
                {
                    
                    
                    if let jsonItem = response.result.value as? NSArray{
                        for data in jsonItem{
                            //print("data: \(data)")
                            
                            let content:String = data.objectForKey("content") as! String;
                            let senduserid:String = data.objectForKey("senduser") as! String;
                            
                            var sendnickname:String = "";
                            if(data.objectForKey("username")!.isKindOfClass(NSNull))
                            {
                                sendnickname="";
                            }else
                            {
                                sendnickname   = data.objectForKey("username") as! String;
                                
                            }
                            let guid:String = data.objectForKey("guid") as! String;
                            let sendtime:String;
                            var temptime:String=data.objectForKey("sendtime") as! String;
                            
                            
                            
                            //temptime	String	"2016-04-06 13:40:11"
                            
                            var date:NSDate = NSDate()
                            var formatter:NSDateFormatter = NSDateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd"
                            var dateString = formatter.stringFromDate(date)
                            
                            if(temptime.containsString(dateString))
                            {
                                sendtime = temptime.subStringFrom(11)
                                
                            }else
                            {
                                
                                sendtime = (temptime as NSString).substringWithRange(NSRange(location: 0,length: 10))
                            }
                            
                            
                            
                            //let address:String = data.objectForKey("address") as! String;
                            
                            let lng:String = data.objectForKey("lng") as! String;
                            let lat:String = data.objectForKey("lat") as! String;
                            
                            
                            var lat_1=(lat as NSString).doubleValue;
                            var lng_1=(lng as NSString).doubleValue;
                            
                            let defaults = NSUserDefaults.standardUserDefaults();
                            let userid = defaults.objectForKey("userid") as! String;
                            //                            let mylat = defaults.objectForKey("lat") as! String;
                            //                            let mylng = defaults.objectForKey("lng") as! String;
                            
                            
                            var lat_2=(lat as NSString).doubleValue;
                            var lng_2=(lng as NSString).doubleValue;
                            var address:String="";
                            
                            if(false)
                            {
                                var currentLocation:CLLocation = CLLocation(latitude:lat_1,longitude:lng_1);
                                var targetLocation:CLLocation = CLLocation(latitude:lat_2,longitude:lng_2);
                                
                                
                                var distance:CLLocationDistance=currentLocation.distanceFromLocation(targetLocation);
                                address = ("\(distance)米");
                            }else
                            {
                                var p1:BMKMapPoint = BMKMapPointForCoordinate(CLLocationCoordinate2D(latitude: lat_1, longitude: lng_1))
                                var p2:BMKMapPoint = BMKMapPointForCoordinate(CLLocationCoordinate2D(latitude: lat_2, longitude: lng_2))
                                //var a2:BMKMapPoint = CLLocationCoordinate2D(latitude: lat_2, longitude: lng_2)
                                
                                var distance:CLLocationDistance = BMKMetersBetweenMapPoints(p1, p2);
                                
                                
                                var one:UInt32 = UInt32(distance)
                                if(one>1000)
                                {
                                    address = ("\(self.roundoff(Double(one)/1000))千米");
                                }
                                address = ("\(one)米");
                            }
                            
                            
                            
                            let city:String = data.objectForKey("city") as! String;
                            let street:String = data.objectForKey("street") as! String;
                            let photo:String = data.objectForKey("photo") as! String;
                            var community:String = ""
                            if(data.objectForKey("community")!.isKindOfClass(NSNull))
                            {
                                community = "";
                            }else
                            {
                                community = data.objectForKey("community") as! String;
                                
                            }
                            let infocatagroy:String = data.objectForKey("infocatagroy") as! String;
                            let status:String = data.objectForKey("status") as! String;
                            let visit:String = data.objectForKey("visit") as! String;
                            let plnum:String = data.objectForKey("plnum") as! String;
                            let headface:String = data.objectForKey("headface") as! String;
                            let sex:String = data.objectForKey("sex") as! String;

                            let item_obj:itemMess = itemMess(userid: senduserid, headface:headface,sex:sex,vname: sendnickname, vtime: sendtime, city: city,street: street,vaddress: address, vcontent: content, vcommunity: community, vlng: lng, vlat: lat, vguid: guid, vinfocatagory: infocatagroy, vphoto: photo, status: status, visnum: visit, plnum: plnum)
                            self.items.append(item_obj)
                            
                        }
                        self._tableView.reloadData()
                        //self._tableView.doneRefresh()
                        
                    }
                }else
                {
                    self.successNotice("网络请求错误")
                    print("网络请求错误")
                }
                
        }
        
    }

}
