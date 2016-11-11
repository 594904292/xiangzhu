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
        let w:CGFloat = UIScreen.main.bounds.width
        //var h1:CGFloat = self.view.frame.height/10
        let namestr:String=myusername.text!
        let options:NSStringDrawingOptions = .usesLineFragmentOrigin
        let boundingRect = namestr.boundingRect(with: CGSize(width: w, height: 0), options: options, attributes:[NSFontAttributeName:myusername.font], context: nil)
    
        let pox=boundingRect.size.width+56+10
        mysex.frame = CGRect(x: pox, y: 20, width: 10, height: 15)
        
        
        self.myheadface.layer.cornerRadius = myheadface.frame.width / 2
        // image还需要加上这一句, 不然无效
        self.myheadface.layer.masksToBounds = true

        
        
    }
    var activityIndicatorView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

              // Do any additional setup after loading the view.
        self.navigationItem.title="排行榜"
        self.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.done, target: self, action: #selector(TopViewController.backClick))
        self.automaticallyAdjustsScrollViewInsets=false
        
        
        //给TableView添加表头页眉        
        _tableview.delegate=self
        _tableview.dataSource=self
        loadrate();
        // 定义一个 activityIndicatorView
        
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.white)
        activityIndicatorView.frame = CGRect(x: self.view.frame.size.width/2 - 50, y: 250, width: 100, height: 100)
        
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView.color = UIColor.black
        self.view.addSubview(activityIndicatorView)
        
        
        
        
        let bw:CGFloat = UIScreen.main.bounds.width
        let pox=bw/3
        headscoretxt.frame=CGRect(x: pox, y: 13, width: 34, height: 21)
        
        headnumtxt.frame=CGRect(x: pox*2, y: 13, width: 34, height: 21)
        
        
        headnumtxt.textColor=UIColor(red: 204/255, green: 0, blue: 0, alpha: 1)
        

        headscoretxt.isUserInteractionEnabled=true
        //点击事件
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(TopViewController.tapscoreLabel))
        //绑定tap
        headscoretxt.addGestureRecognizer(tap)
        
        headnumtxt.isUserInteractionEnabled=true

        let tapnum = UITapGestureRecognizer.init(target: self, action: #selector(TopViewController.tapnumLabel))
        //绑定tap
        headnumtxt.addGestureRecognizer(tapnum)
         querydata();
        
    }
    
    var ordermethon=1;
    //定义方法，mLabel点击后调用此方法
    func tapscoreLabel(){
        
        headscoretxt.textColor=UIColor(red: 204/255, green: 0, blue: 0, alpha: 1)
        headnumtxt.textColor=UIColor.gray
        ordermethon=0
        querydata();

        
    }
    
    func tapnumLabel(){
        
        headnumtxt.textColor=UIColor(red: 204/255, green: 0, blue: 0, alpha: 1)
        headscoretxt.textColor=UIColor.gray
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
        self.navigationController!.popViewController(animated: true)
    }
    
    func loadrate()
    {
        let defaults = UserDefaults.standard;
        let userid = defaults.object(forKey: "userid") as! String;
        let url:String="http://api.bbxiaoqu.com/myrank_v1.php?userid=" + userid;
        print("url: \(url)")
        Alamofire.request(url)
            .responseJSON { response in
            if(response.result.isSuccess)
            {
                if let data = response.result.value as? NSDictionary{
                     print("data: \(data)")
                    let username:String = data.value(forKey: "username") as! String;
                    if(username.characters.count>0)
                    {
                        self.myusername.text = username;
                    }else
                    {
                        self.myusername.text = Util.showend4(userid);
                    }
                    
                    let head = "http://api.bbxiaoqu.com/uploads/" + (data.value(forKey: "headface") as! String)
                    self.myheadface.af_setImage(withURL: URL(string:head)!)
                  
                    let sex:String = data.value(forKey: "sex") as! String;

                   if sex=="0"
                   {
                        self.mysex.image=UIImage(named: "xz_nan_icon");
                   }else
                   {
                        self.mysex.image=UIImage(named: "xz_nv_icon");
                    }
                    
                    let pos:String = data.value(forKey: "pos") as! String;
                    self.order.text = pos
                    self.txt_order_desc.text=("你排名第" + pos) + "位"
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
        Alamofire.request( url)
            .responseJSON { response in
                if(response.result.isSuccess)
                {
                    if let jsonItem = response.result.value as? NSArray{
                        for tempdata in jsonItem{
                            print("data: \(tempdata)")
                            let data:NSDictionary = tempdata as! NSDictionary;

                            let order:String = data.object(forKey: "order") as! String;
                            let userid:String = data.object(forKey: "username") as! String;
                            let nickname:String = data.object(forKey: "nickname") as! String;

                            let score:String = data.object(forKey: "score") as! String;
                            let nums:String = data.object(forKey: "nums") as! String;
                            let headface:String = data.object(forKey: "headface") as! String;
                            let sex:String = data.object(forKey: "sex") as! String;
                            self.loaduserinfo(userid);
                            let item_obj:itemTop = itemTop(order: order, userid: userid, username: nickname, sex: sex, headface: headface, score: score, nums: nums)
                            self.items.append(item_obj)
                            
                        }
                        self._tableview.reloadData()
                        //self._tableview.doneRefresh()
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

    
    
    func loaduserinfo(_ userid:String)
    {
        Alamofire.request( "http://api.bbxiaoqu.com/getuserinfo.php?userid="+userid)
            .responseJSON { response in
                if(response.result.isSuccess)
                {
                    if let jsonItem = response.result.value as? NSArray{
                        for tempdata in jsonItem{
                            let data:NSDictionary = tempdata as! NSDictionary;

                            let name:String = data.object(forKey: "username") as! String;
                            let headface:String = data.object(forKey: "headface") as! String;
                            
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
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 0.0001;
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 0.0001;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.items.count;
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cellId="topcell"
            var cell:TopTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellId) as! TopTableViewCell?
            if(cell == nil)
            {
                cell = TopTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellId)
            }
            cell?.order.text=("第" + (items[indexPath.row] as itemTop).order) + "名"
            cell?.username.text=(items[indexPath.row] as itemTop).username
            cell?.nums.text=(items[indexPath.row] as itemTop).nums
            let sex:String=(items[indexPath.row] as itemTop).sex
            if sex=="0"
            {
                cell?.seximg.image=UIImage(named: "xz_nan_icon");
            }else
            {
                cell?.seximg.image=UIImage(named: "xz_nv_icon");
            }
            let f  =  CGFloat ( ( (items[indexPath.row] as itemTop).score as NSString).floatValue)
            cell?.score.rating = f
            cell?.score.isIndicator=true
            let bw:CGFloat = UIScreen.main.bounds.width
            let pox=bw/3
            cell?.score.frame=CGRect(x: pox, y: 20, width: pox, height: 21)
            let avatar:String = (self.items[indexPath.row] as itemTop).headface
            if(avatar.characters.count>0)
            {
                let head = "http://api.bbxiaoqu.com/uploads/" + avatar
                
                //Alamofire.request(.GET, head).response { (_, _, data, _) -> Void in
                 //   if let d = data as? Data!
                 //   {
                        //cell?.headface.image=UIImage(data: d)
                cell?.headface.af_setImage(withURL: URL(string:head)!)
                 //   }
                //}
            }else
            {
                cell?.headface.image=UIImage(named: "logo")
                
            }
            cell?.headface.layer.cornerRadius = (cell?.headface.frame.width)! / 2
            cell?.headface.layer.masksToBounds = true
            return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        NSLog("select \(indexPath.row)")
        if(items.count>0)
        {
            let sb = UIStoryboard(name:"Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "userinfoviewcontroller") as! UserInfoViewController
            vc.userid=(items[indexPath.row] as itemTop).userid
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    

}
