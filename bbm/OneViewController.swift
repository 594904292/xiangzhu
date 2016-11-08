//
//  OneViewController.swift
//  bbm
//
//  Created by ericsong on 15/9/28.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit
import Alamofire

class OneViewController: UIViewController,UITabBarDelegate,UITableViewDataSource,UITableViewDelegate,ApnsDelegate ,UINavigationControllerDelegate{

    var start:Int = 0
    var limit:Int = 10
   
    var items:[itemMess]=[]
    var fwitems:[itemfwMess]=[]
     @IBOutlet weak var _tableView: UITableView!
    func NewMessage(_ string:String){
        if(selectedSegmentval==0)
        {
            
            querydata(0)
        }else if(selectedSegmentval==1)
        {
            
            querydata(1)
        }else if(selectedSegmentval==2)
        {
            
            querydata(2)
        }
        

    }
    
    //添加Tab Bar控件
    var tabBar:UITabBar!
    //Tab Bar Item的名称数组
    var tabs = ["待解决","全部","我的"]
    //Tab Bar上方的容器
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title="我能帮"
        let item1 = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.done, target: self, action: #selector(OneViewController.backClick))
        item1.tintColor=UIColor.white
        self.navigationItem.leftBarButtonItem=item1
        
        let item2 = UIBarButtonItem(title: "添加", style: UIBarButtonItemStyle.done, target: self, action: #selector(OneViewController.addClick))
        item2.tintColor=UIColor.white
        self.navigationItem.rightBarButtonItem=item2

        _tableView!.delegate=self
        _tableView!.dataSource=self
  
//        self._tableView.headerView = XWRefreshNormalHeader(target: self, action: "upPullLoadData")
//        self._tableView.headerView?.beginRefreshing()
//        self._tableView.headerView?.endRefreshing()
//        self._tableView.footerView = XWRefreshAutoNormalFooter(target: self, action: "downPlullLoadData")
        
        self._tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(OneViewController.headerRefresh))
        
        //普通带文字上拉加载的定义
        
        self._tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(OneViewController.footerRefresh))
        
  
        
        _tableView.frame=CGRect(x: 0,y: 44,width: self.view.frame.size.width,height: self.view.frame.size.height)
        addtabbar()
        let w:CGFloat = UIScreen.main.bounds.width
        let posx=w/CGFloat(3);
        addline(posx);
        addline(posx*2);
        tabBar.selectedItem=tabBar.items![0] 
        selectedSegmentval=0
        querydata(0)

    }
    
    
    
    

    func addtabbar()
    {
        //在底部创建Tab Bar
        tabBar = UITabBar(frame:
            CGRect(x: 0,y: 60,width: self.view.bounds.width,height: 30))
        let tabItem1 = UITabBarItem(title: tabs[0], image: nil, tag: 0)
        let tabItem2 = UITabBarItem(title: tabs[1], image: nil, tag: 1)
        let tabItem3 = UITabBarItem(title: tabs[2], image: nil, tag: 2)
        let attributes =  [NSForegroundColorAttributeName: UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0),
                           NSFontAttributeName: UIFont(name: "Heiti SC", size: 18.0)!]
        let selattributes =  [NSForegroundColorAttributeName: UIColor(red: 255/255.0, green: 0/255.0, blue: 0/255.0, alpha: 1.0),NSFontAttributeName: UIFont(name: "Heiti SC", size: 18.0)!]
        
        tabItem1.setTitleTextAttributes(attributes , for: UIControlState.selected)
        tabItem1.setTitleTextAttributes(attributes , for: UIControlState())
        tabItem1.setTitleTextAttributes(selattributes , for: UIControlState.highlighted)
        
        tabItem2.setTitleTextAttributes(attributes , for: UIControlState.selected)
        tabItem2.setTitleTextAttributes(attributes , for: UIControlState())
        tabItem2.setTitleTextAttributes(selattributes , for: UIControlState.highlighted)
        
        tabItem3.setTitleTextAttributes(attributes , for: UIControlState.selected)
        tabItem3.setTitleTextAttributes(attributes , for: UIControlState())
        tabItem3.setTitleTextAttributes(selattributes , for: UIControlState.highlighted)
        let items:[UITabBarItem] = [tabItem1,tabItem2,tabItem3]
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
        
        
        
        self.view.addSubview(tabBar);
    }
    
    func addline(_ posx:CGFloat)
    {
        
        let posy=CGFloat(tabBar.frame.origin.y+15);
        let customView = UIView(frame: CGRect(x: posx, y: posy, width:1, height: tabBar.frame.size.height))
        let imageView=UIImageView(image:UIImage(named:"xz_xi_icon"))
        imageView.frame=CGRect(x: 0,y: 0,width: 1,height: 30)
        customView.addSubview(imageView)
        self.view.addSubview(customView)
    }
    
    // UITabBarDelegate协议的方法，在用户选择不同的标签页时调用
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //通过tag查询到上方容器的label，并设置为当前选择的标签页的名称
        //print( item.title);
        self.items.removeAll()
        self.fwitems.removeAll()
        if(item.title=="待解决")
        {
            selectedSegmentval=0
            self.items.removeAll()
            
            
           
            querydata(0)
        }else if(item.title=="全部")
        {
            selectedSegmentval=1
             self.items.removeAll()
            querydata(1)
        }else if(item.title=="我的")
        {
            selectedSegmentval=2
            self.items.removeAll()
            querydata(2)
        }
        self._tableView.reloadData()
        
    }
    var selectedSegmentval:Int=0;

    func backClick()
    {
        NSLog("back");
        self.navigationController!.popViewController(animated: true)
        
    }
    
    
    func addClick()
    {
        NSLog("addClick");
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "publishController") as! PublishViewController
        vc.cat=0
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    //MARK: 加载数据
    func headerRefresh(){
        
        //延迟执行 模拟网络延迟，实际开发中去掉
       // xwDelay(1) { () -> Void in
            self.start=0;
            if(self.selectedSegmentval==0)
            {
                self.querydata(0)
            }else if(self.selectedSegmentval==1)
            {
                self.querydata(1)
            }else if(self.selectedSegmentval==2)
            {
                self.querydata(2)
            }
            self._tableView.reloadData()
            self._tableView.mj_header.endRefreshing()
        //}
    }
    
    func footerRefresh(){
        
        //xwDelay(1) { () -> Void in
            self.start=self.limit;
            if(self.selectedSegmentval==0)
            {
                
                self.querydata(0)
            }else if(self.selectedSegmentval==1)
            {
                
                self.querydata(1)
            }else if(self.selectedSegmentval==2)
            {
                
                self.querydata(2)
            }
            self._tableView.reloadData()
            self._tableView.mj_footer.endRefreshing()
        //}
        
    }

    
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            NSLog("indexPath is = %i",self.selectedSegmentval);

            
            if(self.selectedSegmentval==3)
            {
                return self.fwitems.count;
            }else
            {
                return self.items.count;
            }
        }
    
            func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
                //var ppp:String = (items[indexPath.row] as itemMess).photo;
            
                    let cellId="mycell1"
                    var cell:InfopicTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellId) as! InfopicTableViewCell?
                    if(cell == nil)
                    {
                        cell = InfopicTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellId)
                    }
                    
                    cell?.senduser.text=(items[indexPath.row] as itemMess).username
                    let mess=(items[indexPath.row] as itemMess).content
                    var messcontent:String;
                    if mess.characters.count>80
                    {
                        messcontent=(mess as NSString).substring(to: 80) + "..."
                    }else
                    {
                        messcontent=mess;
                    }
                    cell?.message.text=messcontent
                    
                    cell?.sendtime.text=(items[indexPath.row] as itemMess).time
                    cell?.sendaddress.text=(items[indexPath.row] as itemMess).address
                    cell?.gz.text="关:"+(items[indexPath.row] as itemMess).visnum;
                    cell?.pl.text="评:"+(items[indexPath.row] as itemMess).plnum;
                    return cell!
                
            
        }
    

    
    
 
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        NSLog("select \(indexPath.row)")
        //NSLog("select \(items[indexPath.row])")
        
            
            
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
    
    
    func querydata(_ Category:Int)
    {
        var url:String="";
        let defaults = UserDefaults.standard;
        let userid = defaults.object(forKey: "userid") as! String;
        //let lat = defaults.objectForKey("lat") as! String;
        //let lng = defaults.objectForKey("lng") as! String;
        let lat = String(39.974385);
        let lng = String(116.34777)
        if(Category==0)
        {
            url=(((((((("http://api.bbxiaoqu.com/getinfos.php?userid=" + userid) + "&latitude=") + lat) + "&longitude=") + lng) + "&rang=xiaoqu&status=0&start=") + String(self.start)) + "&limit=") + String(self.limit);

        
        }else if(Category==1)
        {
            url=(((((((("http://api.bbxiaoqu.com/getinfos.php?userid=" + userid) + "&latitude=") + lat) + "&longitude=") + lng) + "&rang=xiaoqu&status=1&start=") + String(self.start)) + "&limit=") + String(self.limit);

        }else if(Category==2)
        {
            url=(((((((("http://api.bbxiaoqu.com/getinfos.php?userid=" + userid) + "&latitude=") + lat) + "&longitude=") + lng) + "&rang=self&status=1&start=") + String(self.start)) + "&limit=") + String(self.limit);

        }
            print("url: \(url)")
            Alamofire.request( url)
                .responseJSON { response in
                    if(response.result.isSuccess)
                    {
                        
                        if let jsonItem = response.result.value as? NSArray{
                            for tempdata in jsonItem{
                                //print("data: \(data)")
                            let data = tempdata as!  NSDictionary
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
                            let lng:String = data.object(forKey: "lng") as! String;
                            let lat:String = data.object(forKey: "lat") as! String;
                            let lat_1=(lat as NSString).doubleValue;
                            let lng_1=(lng as NSString).doubleValue;
                            let defaults = UserDefaults.standard;
                            //let userid = defaults.object(forKey: "userid") as! String;
                            let mylat = defaults.object(forKey: "lat") as! String;
                            let mylng = defaults.object(forKey: "lng") as! String;
                            let lat_2=(mylat as NSString).doubleValue;
                            let lng_2=(mylng as NSString).doubleValue;
                            var address:String="";
     
                                
                                    let p1:BMKMapPoint = BMKMapPointForCoordinate(CLLocationCoordinate2D(latitude: lat_1, longitude: lng_1))
                                    let p2:BMKMapPoint = BMKMapPointForCoordinate(CLLocationCoordinate2D(latitude: lat_2, longitude: lng_2))
                                     let distance:CLLocationDistance = BMKMetersBetweenMapPoints(p1, p2);
                                    let one:UInt32 = UInt32(distance)
                                      address = ("\(one)米");
                                
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
                    }
                    }else
                    {
                        self.successNotice("网络请求错误")
                        print("网络请求错误")
                    }

             }
        
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    
    
}
