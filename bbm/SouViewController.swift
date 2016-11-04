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
    
    @IBAction func searchSubmit(_ sender: UIButton){
        
        if(sou_txtfield.text!.characters.count>0)
        {
            _tableView.isHidden=false
            customView.isHidden=true
            items.removeAll()
            let keyword:String=sou_txtfield.text!
            querydata(keyword)
        }
    }
    
    
    
    func roytapedTagLabel(_ labTag: NSInteger, labelText: String, tapedView: UIView) {
        print("tag:\(labTag)  text:\(labelText)");
        _tableView.isHidden=false
        customView.isHidden=true
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
        
        
        let usView_search = UIView.init(frame:CGRect(x: 0,y: 0, width: 25,height: 20))
        
        let userImageV_search = UIImageView()
        
        userImageV_search.image = UIImage(named: "xz_searchpage_input_lefticon")
        
        userImageV_search.frame = CGRect(x: 10,y: 0, width: 16,height: 16)
        
        usView_search.addSubview(userImageV_search)
        sou_txtfield.leftView=usView_search
        sou_txtfield.leftViewMode = UITextFieldViewMode.always
        
        let returnimg=UIImage(named: "xz_nav_return_icon")
        
        let item1=UIBarButtonItem(image: returnimg, style: UIBarButtonItemStyle.plain, target: self,  action: #selector(SouViewController.backClick))
        
        item1.tintColor=UIColor.white
        
        self.navigationItem.leftBarButtonItem=item1

//        
//        var item1 = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: #selector(SouViewController.backClick))
//        item1.tintColor=UIColor.whiteColor()
//        self.navigationItem.leftBarButtonItem=item1
        
        let item2 = UIBarButtonItem(title: "添加", style: UIBarButtonItemStyle.done, target: self, action: #selector(SouViewController.addClick))
        item2.tintColor=UIColor.white
        self.navigationItem.rightBarButtonItem=item2
        let screenWidth = UIScreen.main.bounds.size;
        
        let royTag = RoyTagLabel(frame: CGRect(x: 10, y: 64, width: screenWidth.width-20, height: 60));
        royTag.delegate = self;
        
        let tempArray = ["2016","天气","风景",
                         "浪漫","风光","租房","培训" ,"2016年奥运会","世界杯","中国南海","足球"];
        
        royTag.setTags(tempArray as NSArray);
        
        
        royTag.frame = CGRect(x: 10, y: 10, width: screenWidth.width-20, height: royTag.totalHeight!);
        
        
         customView = UIView(frame: CGRect(x: 0, y: 110, width:self.view.frame.size.width, height: royTag.totalHeight!+20))
        //customView.backgroundColor=UIColor.grayColor()
        
      customView.addSubview(royTag)
        self.view.addSubview(customView)
        
        
       
        _tableView = UITableView(frame: CGRect(x: 0, y: 110, width:self.view.frame.size.width, height: self.view.frame.size.height))
        _tableView.register(OneTableViewCell.self, forCellReuseIdentifier: "cell")//注册自定义cell
        
        self.view.addSubview(_tableView)
        
        _tableView.delegate = self
        _tableView.dataSource = self
        
               
        
        _tableView.estimatedRowHeight = 250
        //setSeparatorInset:UIEdgeInsetsMake
        _tableView.rowHeight = UITableViewAutomaticDimension
        
        self._tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        //设置分割线颜色
        self._tableView.separatorColor = UIColor.red
        //设置分割线内边距
        self._tableView.separatorInset = UIEdgeInsetsMake(5, 0, 0, 0)
        _tableView.isHidden=true

    }
    
    
    func backClick()
    {
        NSLog("back");
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    func addClick()
    {
        NSLog("addClick");
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "publishController") as! PublishViewController
        vc.cat=0
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return array.count
        return self.items.count;
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let str:String = "cell\(indexPath.row)"
        let cell:OneTableViewCell = OneTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: str)
        
        let namestr:String=(items[indexPath.row] as itemMess).username
        cell.username.text = namestr//array[indexPath.row]//(items[indexPath.row] as itemMess).username
        let options:NSStringDrawingOptions = .usesLineFragmentOrigin
        let boundingRect = namestr.boundingRect(with: CGSize(width: 200, height: 0), options: options, attributes:[NSFontAttributeName:cell.username.font], context: nil)
        if((items[indexPath.row] as itemMess).sex == "0")
        {
            cell.seximg.image=UIImage(named: "xz_nan_icon")
        }else
        {
            cell.seximg.image=UIImage(named: "xz_nv_icon")
        }
        cell.seximg.frame=CGRect(x: boundingRect.width+70, y: 25, width: 10, height: 15)
        if (items[indexPath.row] as itemMess).street.characters.count > 0
        {
            cell.street.text=(items[indexPath.row] as itemMess).street
        }else
        {
            cell.street.text="未知"
        }
        let streettr:String = cell.street.text!
        let distanceboundingRect = streettr.boundingRect(with: CGSize(width: 200, height: 0), options: options, attributes:[NSFontAttributeName:cell.street.font], context: nil)
        cell.distance.frame=CGRect(x: distanceboundingRect.width+70, y: 43, width: distanceboundingRect.width*2, height: 30)
        cell.distance.text=(items[indexPath.row] as itemMess).address
        cell.timesgo.text=(items[indexPath.row] as itemMess).time
        cell.content.text=(items[indexPath.row] as itemMess).content
        if((items[indexPath.row] as itemMess).headface.characters.count>0)
        {
            let myhead:String="http://api.bbxiaoqu.com/uploads/" + (items[indexPath.row] as itemMess).headface
            
            
            
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
        let bw:CGFloat = UIScreen.main.bounds.width-20
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
        
        for j:Int in 0 ..< picnum

        {
            let imageView:UIImageView = UIImageView();
            let x:CGFloat = sw * CGFloat(j);
            imageView.frame=CGRect.init(x: x+5, y: 5, width: sw-10, height: sw-10);

            imageView.tag=indexPath.row*100+j
            let picname:String = photoArr[j]
            let imgurl = "http://api.bbxiaoqu.com/uploads/".appending(picname)
            let layer:CALayer = imageView.layer
            layer.borderColor=UIColor.lightGray.cgColor
            layer.opacity=1
            layer.borderWidth = 1.0;
            imageView.image=UIImage(named: "xz_pic_text_loading")
            Util.loadpic(imageView,url: imgurl);
            //cell.imageView!.image = UIImage(named :"logo")
            cell.imgview.contentMode = UIViewContentMode.scaleAspectFit
            cell.imgview.addSubview(imageView);
        }
        
        let defaults = UserDefaults.standard;
        
        var userid = defaults.object(forKey: "userid") as! String;
                    cell.delimg.isHidden=true
            cell.clickBtn.isHidden = true
        
        
        
        cell.tag1.text=("浏览:" + (items[indexPath.row] as itemMess).visnum) + "次"
        cell.tag2.text=("评论:" + (items[indexPath.row] as itemMess).plnum) + "次"
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("clicked at \(indexPath.row)")
        let aa:itemMess=items[indexPath.row] as itemMess;
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "contentviewController") as! ContentViewController
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

    
    func roundoff(_ x:Double)->Int
    {
        let a:Int = Int(x)
        let b:Double = Double(a)+0.5
        if(x>b)
        { return a+1 }
        else
        { return a}
    }

    func querydata(_ keyword:String)
    {
        let akeyword:String = keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!

        var url:String="";
        let defaults = UserDefaults.standard;
        let userid = defaults.object(forKey: "userid") as! String;
        let lat = defaults.object(forKey: "lat") as! String;
        let lng = defaults.object(forKey: "lng") as! String;
        //let lat = String(39.974385);
        //let lng = String(116.34777)
            url=(((((((((("http://api.bbxiaoqu.com/getinfos.php?userid=" + userid) + "&latitude=") + lat) + "&longitude=") + lng) + "&rang=xiaoqu&keyword=") + akeyword) + "&start=") + String(self.start)) + "&limit=") + String(self.limit);
            
            
  
        print("url: \(url)")
        Alamofire.request(url).responseJSON { response in
                if(response.result.isSuccess)
                {
                    
                    
                    if let jsonItem = response.result.value as? NSArray{
                        for tempdata in jsonItem{
                            //print("data: \(data)")
                            let data:NSDictionary = tempdata as! NSDictionary;

                            let content:String = data.object(forKey: "content") as! String;
                            let senduserid:String = data.object(forKey: "senduser") as! String;
                            
                            var sendnickname:String = "";
                            if(data.object(forKey: "username") == nil)
                            {
                                sendnickname="";
                            }else
                            {
                                sendnickname   = data.object(forKey: "username") as! String;
                                
                            }
                            let guid:String = data.object(forKey: "guid") as! String;
                            let sendtime:String;
                            let temptime:String=data.object(forKey: "sendtime") as! String;
                            
                            
                            
                            //temptime	String	"2016-04-06 13:40:11"
                            
                            let date:Date = Date()
                            let formatter:DateFormatter = DateFormatter()
                            formatter.dateFormat = "yyyy-MM-dd"
                            let dateString = formatter.string(from: date)
                            
                            if(temptime.contains(dateString))
                            {
                                sendtime = temptime.subString(start: 11)
                                
                            }else
                            {
                                
                                sendtime = (temptime as NSString).substring(with: NSRange(location: 0,length: 10))
                            }
                            
                            
                            
                            //let address:String = data.objectForKey("address") as! String;
                            
                            let lng:String = data.object(forKey: "lng") as! String;
                            let lat:String = data.object(forKey: "lat") as! String;
                            
                            
                            let lat_1=(lat as NSString).doubleValue;
                            let lng_1=(lng as NSString).doubleValue;
                            
                            let defaults = UserDefaults.standard;
                            let userid = defaults.object(forKey: "userid") as! String;
                            //                            let mylat = defaults.objectForKey("lat") as! String;
                            //                            let mylng = defaults.objectForKey("lng") as! String;
                            
                            
                            let lat_2=(lat as NSString).doubleValue;
                            let lng_2=(lng as NSString).doubleValue;
                            var address:String="";
                            
                            if(false)
                            {
                                let currentLocation:CLLocation = CLLocation(latitude:lat_1,longitude:lng_1);
                                let targetLocation:CLLocation = CLLocation(latitude:lat_2,longitude:lng_2);
                                
                                
                                let distance:CLLocationDistance=currentLocation.distance(from: targetLocation);
                                address = ("\(distance)米");
                            }else
                            {
                                let p1:BMKMapPoint = BMKMapPointForCoordinate(CLLocationCoordinate2D(latitude: lat_1, longitude: lng_1))
                                let p2:BMKMapPoint = BMKMapPointForCoordinate(CLLocationCoordinate2D(latitude: lat_2, longitude: lng_2))
                                //var a2:BMKMapPoint = CLLocationCoordinate2D(latitude: lat_2, longitude: lng_2)
                                
                                let distance:CLLocationDistance = BMKMetersBetweenMapPoints(p1, p2);
                                
                                
                                let one:UInt32 = UInt32(distance)
                                if(one>1000)
                                {
                                    address = ("\(self.roundoff(Double(one)/1000))千米");
                                }
                                address = ("\(one)米");
                            }
                            
                            
                            
                            let city:String = data.object(forKey: "city") as! String;
                            let street:String = data.object(forKey: "street") as! String;
                            let photo:String = data.object(forKey: "photo") as! String;
                            var community:String = ""
                            if(data.object(forKey: "community")==nil)
                            {
                                community = "";
                            }else
                            {
                                community = data.object(forKey: "community") as! String;
                                
                            }
                            let infocatagroy:String = data.object(forKey: "infocatagroy") as! String;
                            let status:String = data.object(forKey: "status") as! String;
                            let visit:String = data.object(forKey: "visit") as! String;
                            let plnum:String = data.object(forKey: "plnum") as! String;
                            let headface:String = data.object(forKey: "headface") as! String;
                            let sex:String = data.object(forKey: "sex") as! String;

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
