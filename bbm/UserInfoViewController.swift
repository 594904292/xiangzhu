//
//  UserInfoViewController.swift
//  bbm
//
//  Created by songgc on 16/4/1.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit
import Alamofire
class UserInfoViewController: UIViewController ,UITabBarDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate{

    
    @IBOutlet weak var headface: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var telphone: UILabel!
    
    @IBOutlet weak var gz_btn: UIButton!
    @IBOutlet weak var _tableview: UITableView!
    var userid:String = "";
    var start:Int = 0
    var limit:Int = 10
    

    
    @IBOutlet weak var navcontain: UIView!
    
    //////////////
    var tabBar:UITabBar!
    //Tab Bar Item的名称数组
    var tabs = ["收到的感谢","求助"]
    
    func addtabbar()
    {
        //在底部创建Tab Bar
        tabBar = UITabBar(frame:
            CGRect(x: 0,y: 0,width: self.view.bounds.width,height: 50))
        let tabItem1 = UITabBarItem(title: tabs[0], image: nil, tag: 0)
        let tabItem2 = UITabBarItem(title: tabs[1], image: nil, tag: 1)
        let attributes =  [NSForegroundColorAttributeName: UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0),NSFontAttributeName: UIFont(name: "Heiti SC", size: 18.0)!]
        let selattributes =  [NSForegroundColorAttributeName: UIColor(red: 255/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0),NSFontAttributeName: UIFont(name: "Heiti SC", size: 18.0)!]
        tabItem1.setTitleTextAttributes(attributes , for: UIControlState.selected)
        tabItem1.setTitleTextAttributes(attributes , for: UIControlState())
        tabItem1.setTitleTextAttributes(selattributes , for: UIControlState.highlighted)
        tabItem1.titlePositionAdjustment=UIOffset(horizontal: 0,vertical: -10)
        tabItem2.setTitleTextAttributes(attributes , for: UIControlState.selected)
        tabItem2.setTitleTextAttributes(attributes , for: UIControlState())
        tabItem2.setTitleTextAttributes(selattributes , for: UIControlState.highlighted)
        tabItem2.titlePositionAdjustment=UIOffset(horizontal: 0,vertical: -10)
        
         let items:[UITabBarItem] = [tabItem1,tabItem2]
        tabBar.tintColor=UIColor.red
        
        let image = UIImage(named: "xz_you_icon")!.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 10, 0, 40), resizingMode: UIImageResizingMode.stretch)
        tabBar.selectionIndicatorImage=image
        let meiimage1 = UIImage(named: "xz_mei_icon")!.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 10, 0, 40), resizingMode: UIImageResizingMode.stretch)
        
        tabBar.backgroundImage=meiimage1
        //设置Tab Bar的标签页
        tabBar.setItems(items, animated: true)
        //本类实现UITabBarDelegate代理，切换标签页时能响应事件
        tabBar.delegate = self
        //代码添加到界面上来
        
       
        self.navcontain.addSubview(tabBar);
    }
    
    // UITabBarDelegate协议的方法，在用户选择不同的标签页时调用
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //通过tag查询到上方容器的label，并设置为当前选择的标签页的名称
        if(item.title=="收到的感谢")
        {
            currentpage=0
            queryevaluatedata();
           
        }else if(item.title=="求助")
        {
            currentpage=1
            queryhelpdata();
        }
        //print( item.title);
        
        
    }

     override func viewDidLayoutSubviews() {
        headface.layer.cornerRadius = (headface.frame.width) / 2
        headface.layer.masksToBounds = true
    }
    
    var currentpage:Int=0;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title="好友信息"
        self.view.backgroundColor=UIColor.white
        let item1 = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.done, target: self, action: #selector(UserInfoViewController.backClick))
        item1.tintColor=UIColor.white
        self.navigationItem.leftBarButtonItem=item1
 
        _tableview.delegate=self
        _tableview.dataSource=self
        loaduserinfo(userid);
        
        loadisfriend(userid);
        
        addtabbar()
        tabBar.selectedItem=tabBar.items![currentpage] 
        self._tableview.register(OneTableViewCell.self, forCellReuseIdentifier: "helpcell")//注册自定义cell
        queryevaluatedata();


    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backClick()
    {
        NSLog("back");
        self.navigationController!.popViewController(animated: true)
        
    }

    @IBAction func gz_btn_action(_ sender: UIButton) {
        //var sqlitehelpInstance1=sqlitehelp.shareInstance()
        let defaults = UserDefaults.standard;
        let myuserid = defaults.object(forKey: "userid") as! String;
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        let strNowTime = timeFormatter.string(from: date) as String
        var  dic:Dictionary<String,String> =  ["mid1":myuserid,"mid2":userid]
        
        dic["addtime"] = strNowTime
        if(sender.tag==1)
        {
            dic["action"] = "del"
        }else
        {
            dic["action"] = "add"
        }
        
        Alamofire.request("http://api.bbxiaoqu.com/addfriends.php",method:HTTPMethod.post, parameters: dic).response { response in
            print("Request: \(response.request)")
            print("Response: \(response.response)")
            print("Error: \(response.error)")
            
            if let data = response.data, let tn = String(data: data, encoding: .utf8)
            {
                print("Data: \(tn)")
                
                    if(sender.tag==1)
                    {
                        
                        self.successNotice("取消成功")
                        self.gz_btn.setTitle("关注", for: UIControlState())
                        self.gz_btn.tag=0
                        
                    }else
                    {
                        self.successNotice("关注成功")
                        self.gz_btn.setTitle("取消关注", for: UIControlState())
                        self.gz_btn.tag=1
                        
                    }
            }

        }
    }
    
    @IBAction func chat(_ sender: UIButton) {
        //var sqlitehelpInstance1=sqlitehelp.shareInstance()
        
        let defaults = UserDefaults.standard;
        let myuserid = defaults.object(forKey: "userid") as! String;
        
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "chatviewController") as! ChatViewController
        vc.from=userid
        vc.myself=myuserid;
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
    
    
    func loaduserinfo(_ userid:String)
    {
        let url_str:String = "http://api.bbxiaoqu.com/getuserinfo.php?userid=" + userid
        Alamofire.request(url_str,method:HTTPMethod.post, parameters:nil)
            .responseJSON { response in
                if let JSON:NSArray = response.result.value as! NSArray {
                    print("JSON1: \(JSON.count)")
                    if(JSON.count>0)
                    {
                        let data:NSDictionary = JSON[0] as! NSDictionary;

                        let telphone:String = data.object(forKey: "telphone") as! String;
                       
                        let username:String = data.object(forKey: "username") as! String;
                        self.username.text=username;
                        if(telphone.characters.count>10)
                        {
                             self.telphone.text=Util.hiddentelphonechartacter(telphone);

                        }else
                        {
                            self.telphone.text=telphone;
                        }
                        let headfaceurl:String = data.object(forKey: "headface") as! String;
                        if(headfaceurl.characters.count>0)
                        {
                            let url="http://api.bbxiaoqu.com/uploads/"+headfaceurl;
                            Util.loadheadface(self.headface, url: url)
                        }else
                        {
                            DispatchQueue.main.async(execute: { () -> Void in
                                 self.headface?.image = UIImage(named: "logo")
                            })
                        }
                        self.headface?.layer.cornerRadius = 5.0
                        self.headface?.layer.masksToBounds = true
                    }
                    
                    
                }
        }
    }
    
    func loadisfriend(_ userid:String)
    {
        let defaults = UserDefaults.standard;
        let myuserid = defaults.object(forKey: "userid") as! String;
        let url_str:String = (("http://api.bbxiaoqu.com/getisfriends.php?mid1=" + myuserid) + "&mid2=") + userid
        Alamofire.request(url_str,method:HTTPMethod.post, parameters:nil)
            .responseJSON { response in
                if let JSON:NSDictionary = response.result.value as! NSDictionary {
                    print("JSON1: \(JSON.count)")
                    if(JSON.count>0)
                    {
                        let isfriend:String = JSON.object(forKey: "isfriend") as! String;
                        print("JSisfriendON1: \(isfriend)")

                        if(isfriend=="yes")
                        {
                            self.gz_btn.setTitle("取消关注", for: UIControlState())
                            self.gz_btn.tag=1
                        }else
                        {
                            self.gz_btn.setTitle("关注", for: UIControlState())
                            self.gz_btn.tag=0
                        }
                        
                    }
                    
                    
                }
        }
    }


    var evaluateitems:[ItemEvaluate]=[]
    var items:[itemMess]=[]
    func queryevaluatedata()
    {
        let url:String="http://api.bbxiaoqu.com/getmemberevaluates_v1.php?userid=" + userid;
        print("url: \(url)")
        Alamofire.request(url).responseJSON
            { response in
                if(response.result.isSuccess)
                {
                    if let jsonItem = response.result.value as? NSArray{
                        for tempdata in jsonItem{
                            print("data: \(tempdata)")
                            let data:NSDictionary = tempdata as! NSDictionary;

                            let id:String = data.object(forKey: "id") as! String;
                            let guid:String = data.object(forKey: "guid") as! String;
                            let infouser:String = data.object(forKey: "infouser") as! String;
                            let username:String = data.object(forKey: "username") as! String;
                            let userid:String = data.object(forKey: "userid") as! String;
                            let sex:String = data.object(forKey: "sex") as! String;
                            let headface:String = data.object(forKey: "headface") as! String;
                            let score:String = data.object(forKey: "score") as! String;
                            var evaluatetag:String = "";
                           // if((data.objectForKey("evaluatetag")) != NSNull)
                            //{
                             evaluatetag = data.object(forKey: "evaluatetag") as! String;
                           // }
                            let evaluate:String = data.object(forKey: "evaluate") as! String;

                            let addtime:String = data.object(forKey: "addtime") as! String;
                            
                            let item_obj:ItemEvaluate = ItemEvaluate(id: id, guid: guid, infouser: infouser,username:username,userid: userid, sex:sex,headface:headface,score: score, evalute: evaluate, evalutetag:evaluatetag,addtime: addtime)
                            self.evaluateitems.append(item_obj)
                            
                        }
                        self._tableview.reloadData()
                        //self._tableview.doneRefresh()
                        
                    }
                }else
                {
                    self.successNotice("网络请求错误")
                    print("网络请求错误")
                }
        }
        
    }
    
    
    func queryhelpdata()
    {

        let defaults = UserDefaults.standard;
        let lat = defaults.object(forKey: "lat") as! String;
        let lng = defaults.object(forKey: "lng") as! String;
        
       // var url:String="http://api.bbxiaoqu.com/getgzinfo.php?guid=".stringByAppendingString(guids);
        let url:String=(((((((("http://api.bbxiaoqu.com/getinfos.php?userid=" + userid) + "&latitude=") + lat) + "&longitude=") + lng) + "&rang=self&status=1&start=") + String(self.start)) + "&limit=") + String(self.limit);

        
        print("url: \(url)")
        Alamofire.request( url)
            .responseJSON { response in
                if(response.result.isSuccess)
                {
                    if let jsonItem = response.result.value as? NSArray{
                        for tempdata in jsonItem{
                            //print("data: \(data)")
                            let data:NSDictionary = tempdata as! NSDictionary;

                            let content:String = data.object(forKey: "content") as! String;
                            let senduserid:String = data.object(forKey: "senduser") as! String;
                            
                            var sendnickname:String = "";
                            if(data.object(forKey: "username")==nil)
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
                            _ = defaults.object(forKey: "userid") as! String;
                            //                            let mylat = defaults.objectForKey("lat") as! String;
                            //                            let mylng = defaults.objectForKey("lng") as! String;
                            
                            
                            let lat_2=(lat as NSString).doubleValue;
                            let lng_2=(lng as NSString).doubleValue;
                            var address:String="";
                            
                          
                                let p1:BMKMapPoint = BMKMapPointForCoordinate(CLLocationCoordinate2D(latitude: lat_1, longitude: lng_1))
                                let p2:BMKMapPoint = BMKMapPointForCoordinate(CLLocationCoordinate2D(latitude: lat_2, longitude: lng_2))
                                //var a2:BMKMapPoint = CLLocationCoordinate2D(latitude: lat_2, longitude: lng_2)
                                
                                let distance:CLLocationDistance = BMKMetersBetweenMapPoints(p1, p2);
                                let one:UInt32 = UInt32(distance)
                                if(one>1000)
                                {
                                    address = ("\(self.roundoff(Double(one)/1000))千米");
                                }else
                                {
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

                            let item_obj:itemMess = itemMess(userid: senduserid,headface:headface,sex:sex, vname: sendnickname, vtime: sendtime, city: city,street: street,vaddress: address, vcontent: content, vcommunity: community, vlng: lng, vlat: lat, vguid: guid, vinfocatagory: infocatagroy, vphoto: photo, status: status, visnum: visit, plnum: plnum)
                            self.items.append(item_obj)
                            
                        }
                        self._tableview.reloadData()
                        //self._tableview.doneRefresh()
                        
                    }
                }else
                {
                    self.successNotice("网络请求错误")
                    print("网络请求错误")
                }
        }
        
    }
    func roundoff(_ x:Double)->Int
    {
        let a:Int = Int(x)
        let b:Double = Double(a)+0.5
        if(x>b)
        { return a+1 }
        else
        { return a}
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath:IndexPath) -> CGFloat
    {
        //计算行高，返回，textview根据数据计算高度
        if(currentpage==0)
        {
            let fixedWidth:CGFloat = 260;
            let contextLab:UITextView=UITextView()
            contextLab.text=(evaluateitems[indexPath.row] as ItemEvaluate).evalute
            let newSize:CGSize = contextLab.sizeThatFits(CGSize(width: fixedWidth, height: 123));
            let height=(newSize.height)
            print("height---\(height)")
            return height+120
        }else
        {
            return 250;
        }
    }
    
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var rownum:Int=0
        if(currentpage==0)
        {
            rownum = self.evaluateitems.count;
        }else
        {
            rownum = self.items.count;
        }
        return rownum
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if(currentpage==0)
        {
            //var ppp:String = (items[indexPath.row] as itemMess).photo;
            let cellId="evaluatecell"
            var cell:EvaluateTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellId) as! EvaluateTableViewCell?
            if(cell == nil)
            {
                cell = EvaluateTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellId)
            }
            //cell?.infouser.text=(items[indexPath.row] as ItemEvaluate).infouser
            
            let myhead:String="http://api.bbxiaoqu.com/uploads/" + (evaluateitems[indexPath.row] as ItemEvaluate).headface
            
            cell!.headface.layer.cornerRadius = (cell!.headface.frame.width) / 2
            cell!.headface.layer.masksToBounds = true
            Util.loadpic(cell!.headface, url: myhead)

            
            cell?.infouser.text=(evaluateitems[indexPath.row] as ItemEvaluate).username
            

            
            let f  =  CGFloat ( ( (evaluateitems[indexPath.row] as ItemEvaluate).score as NSString).floatValue)
            
            cell?.ratingbar.rating = f
             cell?.ratingbar.isIndicator=true
            cell?.eveluate.text=(evaluateitems[indexPath.row] as ItemEvaluate).evalute
            cell?.addtime.text=(evaluateitems[indexPath.row] as ItemEvaluate).addtime
            
            let tags=(evaluateitems[indexPath.row] as ItemEvaluate).evalutetag
            if(tags.characters.count>0)
            {
                let screenWidth = UIScreen.main.bounds.size;
                
                let evalueTag = EvalueTagLabel(frame: CGRect(x: 10, y: 64, width: screenWidth.width-20, height: 60));
                
                
                

                          //let tempArray = ["2016","天气","风景"];
                let tempArray = tags.components(separatedBy: "|")
                //let tempArray = tags.characters.split($0=="|").map(String.init())
                
                evalueTag.setTags(tempArray as NSArray);
                
                
                evalueTag.frame = CGRect(x: 10, y: 0, width: screenWidth.width/2, height: evalueTag.totalHeight!);
                
                
                
                cell?.tagsview.addSubview(evalueTag)
            }
            
            
            return cell!
        }else
        {
            let str:String = "helpcell"
            
            
            var cell:OneTableViewCell = tableView.dequeueReusableCell(withIdentifier: str, for: indexPath) as! OneTableViewCell
            
            if cell.isEqual(nil) {
                cell = OneTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: str)
            }
            //var senduser=(items[indexPath.row] as itemMess).username
            let namestr:String=(items[indexPath.row] as itemMess).username
            
            cell.username.text = namestr//array[indexPath.row]//(items[indexPath.row] as itemMess).username
            
            
            let options:NSStringDrawingOptions = .usesLineFragmentOrigin
            //let options:NSStringDrawingOptions = .UsesLineFragmentOrigin
            
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
            }
            let bw:CGFloat = UIScreen.main.bounds.width-20
            var photoArr:[String] = (items[indexPath.row] as itemMess).photo.characters.split{$0 == ","}.map{String($0)}
            
            
            var picnum=photoArr.count
            if(picnum>4)
            {
                picnum=4
            }
            
            _ = 4;
            for j:Int in 0 ..< picnum
            {
                let imageView:UIImageView = UIImageView();
                let sw=bw/4;
                let x:CGFloat = sw * CGFloat(j);
                imageView.frame = CGRect.init(x: x+5, y: 5, width: sw-10, height: sw-10);

                imageView.tag=indexPath.row*100+j
                let picname:String = photoArr[j]
                let imgurl = "http://api.bbxiaoqu.com/uploads/".appending(picname)
                //添加边框
                let layer:CALayer = imageView.layer
                layer.borderColor=UIColor.lightGray.cgColor
                layer.opacity=1
                layer.borderWidth = 1.0;
                imageView.image=UIImage(named: "xz_pic_text_loading")
                Util.loadpic(imageView,url: imgurl);

                cell.imgview.addSubview(imageView);
            }
            cell.delimg.isHidden=true
            cell.clickBtn.tag = indexPath.row
            cell.clickBtn.isHidden = true
            //let tap = UITapGestureRecognizer.init(target: self, action: Selector.init("tapped:"))
            //cell.clickBtn.addGestureRecognizer(tap)
            
            
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
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("clicked at \(indexPath.row)")
        
        let time: TimeInterval = 2.0
        let delay = DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC); DispatchQueue.main.asyncAfter(deadline: delay) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        if(currentpage==0)
        {
//            let sb = UIStoryboard(name:"Main", bundle: nil)
//            
//            let vc = sb.instantiateViewControllerWithIdentifier("userinfoviewcontroller") as! UserInfoViewController
//            //创建导航控制器var evaluateitems:[ItemEvaluate]=[]
//
//            vc.userid=(evaluateitems[indexPath.row] as ItemEvaluate).userid
//            self.navigationController?.pushViewController(vc, animated: true)
            

        }else
        {
            NSLog("select \(indexPath.row)")
            
            let aa:itemMess=items[indexPath.row] as itemMess;
            
            let sb = UIStoryboard(name:"Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "contentviewController") as! ContentViewController
               vc.guid=aa.guid
            vc.infoid=aa.guid
              self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }

//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
//    {
//        NSLog("select \(indexPath.row)")
//        //NSLog("select \(items[indexPath.row])")
//        
//    }


}
