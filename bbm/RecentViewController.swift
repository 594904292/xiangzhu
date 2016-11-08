//
//  RecentViewController.swift
//  bbm
//
//  Created by songgc on 16/8/25.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit
import Alamofire
class RecentViewController: UIViewController,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,XxRecentDL{

    @IBOutlet weak var _tableview: UITableView!
    var dataSource = NSMutableArray()
    var currentIndexPath: IndexPath?
    var items:[itemRecent]=[]
    var db: SQLiteDB!

//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = UIRectEdge()
        self.automaticallyAdjustsScrollViewInsets=false
        _tableview.delegate=self
        _tableview.dataSource=self
               
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        db = SQLiteDB.sharedInstance
        querydata()
        
        //self.view.contentInset=UIEdgeInsetsMake(0, 0, 150, 0)
        //self.view.frame=CGRectMake(0,200,self.view.frame.size.width,self.view.frame.size.height-200)
        let customView2 = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 45))
        
        let head_label:UILabel = UILabel(frame:CGRect(x: 10, y: 8, width: self.view.frame.width, height: 30))
        head_label.text = "最近联系"
        head_label.textColor = UIColor.black
        head_label.textAlignment = NSTextAlignment.left
        //tel2_label.font = UIFont(name: "Bobz Type", size: 10)
        head_label.font = UIFont.systemFont(ofSize: 15)
        
        let lineview = UIView(frame: CGRect(x: 0, y: 44, width: self.view.frame.width, height: 1))
        lineview.backgroundColor=UIColor(colorLiteralRed: 212/255.0, green: 212/255.0, blue: 212/255.0, alpha: 1)
        
        
        
        customView2.addSubview(head_label)
        customView2.addSubview(lineview)
        
        
        self._tableview.tableHeaderView=customView2
        
        
        
        zdl().xxrecentdl = self
        
        
    }

    //获取总代理
    func zdl() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    
    //收到消息
    func newRecentMsg(_ aMsg: WXMessage) {
        db = SQLiteDB.sharedInstance
        querydata()
        
        
    }
    
    
    
    
    func backClick()
    {
        NSLog("back");
        self.navigationController!.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    func querydata()
    {
        //let sql="select userid,nickname,usericon,lastinfo,lasttime,messnu,lastnickname　from friend";
        if self.items.count>0
        {
            self.items.removeAll()
        }
        
        let sql="select * from friend order by lasttime desc";
        NSLog(sql)
        let mess = db.query(sql: sql)
        
         NSLog("\(mess.count)")
        if mess.count > 0 {
            //获取最后一行数据显示
            for i in 0..<mess.count
            {
                let item = mess[i]
                let userid = item["userid"] as! String
                //let nickname = item["nickname"]!.asString()
                //let usericon = item["usericon"]!.asString()
                
                let usericon = sqlitehelp.shareInstance().loadheadface(userid)
                let nickname = sqlitehelp.shareInstance().loadusername(userid)
                
                let lastinfo = item["lastinfo"] as! String
                var lasttime = item["lasttime"] as! String
                
                
                let date:Date = Date()
                let formatter:DateFormatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let dateString = formatter.string(from: date)
                
                if(lasttime.contains(dateString))
                {
                    lasttime = lasttime.subString(start: 11)
                    
                }else
                {
                    
                    lasttime = (lasttime as NSString).substring(with: NSRange(location: 0,length: 10))
                }
                
                let messnum = item["messnum"] as! String
                var lastnickname = item["lastuserid"] as! String
                if(loadusername(item["lastuserid"] as! String).characters.count>0)
                {
                    lastnickname=loadusername(item["lastuserid"] as! String)
                }
                let item_obj:itemRecent=itemRecent(userid: userid, username: nickname, usericon: usericon, lastinfo: lastinfo, lastchattimer: lasttime, messnum: messnum, lastnickname: lastnickname)
                self.items.append(item_obj)
            }
            self._tableview.reloadData();
        }else
        {   self.successNotice("会话列表为空")
            print("会话列表为空")
            return;
            
            
        }
        
        
    }
    
    
    func loadusername(_ userid:String)->String
    {
        let db: SQLiteDB! = SQLiteDB.sharedInstance
        let sql="select * from users where userid='"+userid+"'";
        NSLog(sql)
        let mess = db.query(sql: sql)
        if( mess.count>0)
        {
            NSLog("ok")
            let item = mess[0]
            return item["nickname"] as! String
        }
        else
        {
            NSLog("fail")
            
            return ""
        }
    }
    
    
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.items.count;
    }
    
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        
    {
        
        
        
        let cellId = "recentcellnew"
        
        //无需强制转换
        
        var cell:RecentTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellId) as? RecentTableViewCell
        
        if(cell == nil)
            
        {
            
            cell = RecentTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellId)
            
        }
        cell?.name!.text = (self.items[indexPath.row] as itemRecent).username
        
        
        cell?.content!.text = ((self.items[indexPath.row] as itemRecent).lastnickname + ":") + (self.items[indexPath.row] as itemRecent).lastinfo
        
        
        cell?.lasttime!.text = (self.items[indexPath.row] as itemRecent).lastchattimer
        
        
        let avatar:String = (self.items[indexPath.row] as itemRecent).usericon
        
        if(avatar.characters.count>0)
        {
            let head = "http://api.bbxiaoqu.com/uploads/" + avatar
            
            cell?.lastuericon.af_setImage(withURL: URL(string:head)!)
            //Alamofire.request(.GET, head).response { (_, _, data, _) -> Void in
              //  if let d = data as? Data!
              //  {
             //       cell?.lastuericon.image=UIImage(data: d)
             //   }
            //}
        }else
        {
            cell?.lastuericon.image=UIImage(named: "logo")
            
        }
        
        cell?.lastuericon.layer.cornerRadius = (cell?.lastuericon.frame.width)! / 2
        cell?.lastuericon.layer.masksToBounds = true
        
        
        
        //cell?.messnum.value=(self.items[indexPath.row] as itemRecent).messnum
        let anum:String = (self.items[indexPath.row] as itemRecent).messnum
        
        let aanum:Int = Int(anum)!
        cell?.messnum.value=aanum
        if aanum>0
        {
            cell?.messnum.isHidden=false;
        }else
        {
            cell?.messnum.isHidden=true;
        }
        
        //messnum: BadgeView!
        return cell!
        
        
        
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        NSLog("select \(indexPath.row)")
        
        let defaults = UserDefaults.standard;
        let senduserid = defaults.object(forKey: "userid") as! String;
        let seluserid:String = (self.items[indexPath.row] as itemRecent).userid
        
        let sql = "update friend set messnum=0 where userid='\(seluserid)'"
         db.execute(sql: sql)
        let sql1 = "update chat set readed=1 where senduserid='\(seluserid)' or touserid='\(seluserid)'"
         db.execute(sql: sql1)
        (self.items[indexPath.row] as itemRecent).messnum = "0";
        self._tableview.reloadData()
        
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "chatviewController") as! ChatViewController
        //创建导航控制器
        vc.from=(self.items[indexPath.row] as itemRecent).userid
        vc.myself=senduserid;
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}
