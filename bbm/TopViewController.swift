//
//  TopViewController.swift
//  bbm
//
//  Created by songgc on 16/3/29.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit
import Alamofire
class TopViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    
    @IBOutlet weak var myheadface: UIImageView!
    
    @IBOutlet weak var myusername: UILabel!
    
    @IBOutlet weak var mysex: UIImageView!
    
    @IBOutlet weak var order: UILabel!
    
    @IBOutlet weak var txt_order_desc: UILabel!
    
    @IBOutlet weak var _tableview: UITableView!
    var items:[itemTop]=[]
    @IBOutlet weak var topnum: UILabel!
    @IBOutlet weak var topnumdesc: UILabel!
    
    
    @IBOutlet weak var headscoretxt: UILabel!
    
    @IBOutlet weak var headnumtxt: UILabel!
    
    
    
    @IBOutlet weak var topbgimg: UIImageView!
    
    
    override func viewDidLayoutSubviews() {
        var w:CGFloat = UIScreen.mainScreen().bounds.width
        var h1:CGFloat = self.view.frame.height/10
        var namestr:String=myusername.text!
        let options:NSStringDrawingOptions = .UsesLineFragmentOrigin
        let boundingRect = namestr.boundingRectWithSize(CGSizeMake(w, 0), options: options, attributes:[NSFontAttributeName:myusername.font], context: nil)
    
        var pox=boundingRect.size.width+56+10
        mysex.frame = CGRectMake(pox, 20, 10, 15)
        
        
        self.myheadface.layer.cornerRadius = myheadface.frame.width / 2
        // image还需要加上这一句, 不然无效
        self.myheadface.layer.masksToBounds = true

        
        
    }
    var activityIndicatorView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

              // Do any additional setup after loading the view.
        self.navigationItem.title="排行榜"
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: "backClick")
        self.automaticallyAdjustsScrollViewInsets=false
        
        
        //给TableView添加表头页眉        
        _tableview.delegate=self
        _tableview.dataSource=self
        loadrate();
        // 定义一个 activityIndicatorView
        
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        activityIndicatorView.frame = CGRectMake(self.view.frame.size.width/2 - 50, 250, 100, 100)
        
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = UIColor.blackColor()
        self.view.addSubview(activityIndicatorView)
        
        
        
        
        let bw:CGFloat = UIScreen.mainScreen().bounds.width
        var pox=bw/3
        headscoretxt.frame=CGRectMake(pox, 13, 34, 21)
        
        headnumtxt.frame=CGRectMake(pox*2, 13, 34, 21)
        
        
        headnumtxt.textColor=UIColor(red: 204/255, green: 0, blue: 0, alpha: 1)
        

        headscoretxt.userInteractionEnabled=true
        //点击事件
        let tap = UITapGestureRecognizer.init(target: self, action: Selector.init("tapscoreLabel"))
        //绑定tap
        headscoretxt.addGestureRecognizer(tap)
        
        headnumtxt.userInteractionEnabled=true

        let tapnum = UITapGestureRecognizer.init(target: self, action: Selector.init("tapnumLabel"))
        //绑定tap
        headnumtxt.addGestureRecognizer(tapnum)
         querydata();
        
    }
    
    var ordermethon=1;
    //定义方法，mLabel点击后调用此方法
    func tapscoreLabel(){
        
        headscoretxt.textColor=UIColor(red: 204/255, green: 0, blue: 0, alpha: 1)
        headnumtxt.textColor=UIColor.grayColor()
        ordermethon=0
        querydata();

        
    }
    
    func tapnumLabel(){
        
        headnumtxt.textColor=UIColor(red: 204/255, green: 0, blue: 0, alpha: 1)
        headscoretxt.textColor=UIColor.grayColor()
        ordermethon=1
        querydata();


    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backClick()
    {
        NSLog("back");
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    func loadrate()
    {
        let defaults = NSUserDefaults.standardUserDefaults();
        let userid = defaults.objectForKey("userid") as! String;
        var url:String="http://api.bbxiaoqu.com/myrank_v1.php?userid=".stringByAppendingString(userid);
        print("url: \(url)")
        Alamofire.request(.GET, url, parameters: nil)
            .responseJSON { response in
            if(response.result.isSuccess)
            {
                if let data = response.result.value as? NSDictionary{
                     print("data: \(data)")
                    var userid:String = data.valueForKey("userid") as! String;
                    var username:String = data.valueForKey("username") as! String;
                    self.myusername.text = username;
                    
                    
                    var head = "http://api.bbxiaoqu.com/uploads/".stringByAppendingString(data.valueForKey("headface") as! String)
                    
                    Alamofire.request(.GET, head).response { (_, _, data, _) -> Void in
                        if let d = data as? NSData!
                        {
                            self.myheadface.image=UIImage(data: d)
                        }
                    }

                    
                    var sex:String = data.valueForKey("sex") as! String;

                   if sex=="0"
                   {
                        self.mysex.image=UIImage(named: "xz_nan_icon");
                   }else
                   {
                        self.mysex.image=UIImage(named: "xz_nv_icon");
                    }
                    
                    var pos:NSNumber = data.valueForKey("pos") as! NSNumber;
                    self.order.text = pos.stringValue
                    self.txt_order_desc.text="你排名第".stringByAppendingString(pos.stringValue).stringByAppendingString("位")
                }
                
            }else
            {
                self.successNotice("网络请求错误")
                print("网络请求错误")
            }
        }

    }
    
    
    func querydata()
    {
        var url:String="";
        if(ordermethon==1)
        {
            url="http://api.bbxiaoqu.com/rank_v1.php?order=num";

        }
        else
        {
         url="http://api.bbxiaoqu.com/rank_v1.php?order=score";
        }
        print("url: \(url)")
         activityIndicatorView.startAnimating()
        self.items.removeAll()
        Alamofire.request(.GET, url, parameters: nil)
            .responseJSON { response in
                if(response.result.isSuccess)
                {
                    if let jsonItem = response.result.value as? NSArray{
                        for data in jsonItem{
                            print("data: \(data)")
                            let order:String = data.objectForKey("order") as! String;
                            let userid:String = data.objectForKey("username") as! String;
                            let nickname:String = data.objectForKey("nickname") as! String;

                            let score:String = data.objectForKey("score") as! String;
                            let nums:String = data.objectForKey("nums") as! String;
                             let headface:String = data.objectForKey("headface") as! String;
                             let sex:String = data.objectForKey("sex") as! String;
                            self.loaduserinfo(userid);
//                            let usericon = sqlitehelp.shareInstance().loadheadface(userid)
//                            let nickname = sqlitehelp.shareInstance().loadusername(userid)
                            
                            //let item_obj:itemTop = itemTop(order: order, userid: userid, score: score, nums: nums)
                            let item_obj:itemTop = itemTop(order: order, userid: userid, username: nickname, sex: sex, headface: headface, score: score, nums: nums)
                            self.items.append(item_obj)
                            
                        }
                        self._tableview.reloadData()
                        self._tableview.doneRefresh()
                        self.activityIndicatorView.stopAnimating()
                        
                    }
                }else
                {
                    self.activityIndicatorView.stopAnimating()
                    self.successNotice("网络请求错误")
                    print("网络请求错误")
                }
        }
        
    }

    
    
    func loaduserinfo(userid:String)
        
    {
        
        Alamofire.request(.GET, "http://api.bbxiaoqu.com/getuserinfo.php?userid="+userid, parameters: nil)
            .responseJSON { response in
                if(response.result.isSuccess)
                {
                    if let jsonItem = response.result.value as? NSArray{
                        for data in jsonItem{
                            //print("data: \(data)")
                            
                            var name:String = data.objectForKey("username") as! String;
                            var headface:String = data.objectForKey("headface") as! String;
                            
                            if(!sqlitehelp.shareInstance().isexituser(userid))
                            {//缓存用户数据
                                sqlitehelp.shareInstance().addusers(userid, nickname: name, usericon: headface)
                                //更新聊天记录
                            }
                        }
                    }
                }else
                {
                    self.successNotice("网络请求错误")
                    print("网络请求错误")
                }
        }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 0.0001;
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 0.0001;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return self.items.count;
        
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cellId="topcell"
            var cell:TopTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as! TopTableViewCell?
            if(cell == nil)
            {
                cell = TopTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellId)
            }
            cell?.order.text="第".stringByAppendingString((items[indexPath.row] as itemTop).order).stringByAppendingString("名")
            cell?.username.text=(items[indexPath.row] as itemTop).username
            cell?.nums.text=(items[indexPath.row] as itemTop).nums
            var sex:String=(items[indexPath.row] as itemTop).sex
            if sex=="0"
            {
                cell?.seximg.image=UIImage(named: "xz_nan_icon");
            }else
            {
                cell?.seximg.image=UIImage(named: "xz_nv_icon");
            }
        
        
        
        
        
            var f  =  CGFloat ( ( (items[indexPath.row] as itemTop).score as NSString).floatValue)
            cell?.score.rating = f
            cell?.score.isIndicator=true
        
            let bw:CGFloat = UIScreen.mainScreen().bounds.width
            var pox=bw/3
            cell?.score.frame=CGRectMake(pox, 20, pox, 21)
        
        
        
            var avatar:String = (self.items[indexPath.row] as itemTop).headface
            if(avatar.characters.count>0)
            {
                var head = "http://api.bbxiaoqu.com/uploads/".stringByAppendingString(avatar)
                
                Alamofire.request(.GET, head).response { (_, _, data, _) -> Void in
                    if let d = data as? NSData!
                    {
                        cell?.headface.image=UIImage(data: d)
                    }
                }
            }else
            {
                cell?.headface.image=UIImage(named: "logo")
                
            }
        
            cell?.headface.layer.cornerRadius = (cell?.headface.frame.width)! / 2
            cell?.headface.layer.masksToBounds = true
            return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        NSLog("select \(indexPath.row)")
        //NSLog("select \(items[indexPath.row])")
        let sb = UIStoryboard(name:"Main", bundle: nil)

        let vc = sb.instantiateViewControllerWithIdentifier("userinfoviewcontroller") as! UserInfoViewController
        //创建导航控制器
        vc.userid=(items[indexPath.row] as itemTop).userid
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
        
    }

    

}
