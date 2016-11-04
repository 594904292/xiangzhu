
import UIKit

import Alamofire



class ChatViewController: UIViewController, ChatDataSource,UITextFieldDelegate,UINavigationControllerDelegate,XxDL {
    var alertView:UIAlertView?
    var Chats:NSMutableArray!
    var tableView:TableView!
    var from:String = "";
    var fromname:String = ""
    var fromheadface:String = ""
    var myself:String = "";
    var myselfname:String = "";
    var myselfheadface:String = "";
    var sendView:UIView!;
    var txtMsg:UITextField!
    var db: SQLiteDB!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title="私聊"
        let returnimg=UIImage(named: "xz_nav_return_icon")
        
        let item3=UIBarButtonItem(image: returnimg, style: UIBarButtonItemStyle.plain, target: self,  action: #selector(ChatViewController.backClick))
        
        item3.tintColor=UIColor.white
        
        self.navigationItem.leftBarButtonItem=item3
        
        
        
        
        let searchimg=UIImage(named: "xz_nav_icon_search")
        
        let item4=UIBarButtonItem(image: searchimg, style: UIBarButtonItemStyle.plain, target: self,  action: #selector(ChatViewController.searchClick))
        
        item4.tintColor=UIColor.white
        
        self.navigationItem.rightBarButtonItem=item4
        
        //远程同步
        db = SQLiteDB.sharedInstance
        
        
        Chats = NSMutableArray()
        let defaults = UserDefaults.standard;
        myselfname = defaults.object(forKey: "nickname") as! String;
        myselfheadface = defaults.object(forKey: "headface") as! String;
        
        loaduserinfo(from)
        loaduserinfo(myself)
        let screenw = UIScreen.main.applicationFrame.size.width
        let framewidth =  self.view.frame.size.width
        setupChatTable()
        setupSendPanel()
        getData()
        
        openxmpp()
    }
    
    
    func openxmpp() {
        zdl().xxdl = self
        zdl().connect()
    }
    
    //获取总代理
    func zdl() -> AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    
    //收到消息
    func newMsg(_ aMsg: WXMessage) {
        //对方正在输入
        if aMsg.isComposing {
            self.navigationItem.title = "对方正在输入。。。"
        }else if (aMsg.body != "") {
            //显示跟谁聊天
            //self.navigationItem.title = toBuddyName
            //加入到未读消息组
            //msgList.append(aMsg)
            let me:UserInfo! = UserInfo(name:fromname ,logo:(fromheadface))
            let thisChat =  MessageItem(body:aMsg.body as NSString, user:me, date:Date(), mtype:ChatType.someone)
            Chats.add(thisChat)
            //通知表格刷新
            self.tableView.reloadData()
            
        }
    }
    
    //    override func viewWillDisappear(animated: Bool) {
    //
    //        zdl().xxdl=nil
    //        zdl().disConnect()
    //    }
    
    
    func backClick()
    {
        NSLog("back");
        self.navigationController?.popViewController(animated: true)
    }
    
    func searchClick()
    {
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "souviewcontroller") as! SouViewController
        self.navigationController?.pushViewController(vc, animated: true)
        //var vc = SearchViewController()
        //self.navigationController?.pushViewController(vc, animated: true)
    }

    
    func loaduserinfo(_ userid:String)
        
    {
        
        Alamofire.request("http://api.bbxiaoqu.com/getuserinfo.php?userid="+userid,method:HTTPMethod.get
            , parameters: nil)
            .responseJSON { response in
                if(response.result.isSuccess)
                {
                    if let jsonItem = response.result.value as? NSArray{
                        for data in jsonItem{
                            //print("data: \(data)")
                            if(userid==self.from)
                            {
                                self.fromname = (data as! NSDictionary).object(forKey: "username") as! String;
                                self.fromheadface = (data as! NSDictionary).object(forKey: "headface") as! String;
                                self.navigationItem.title=self.fromname;//更新标题

                            }
                            let name:String = (data as! NSDictionary).object(forKey: "username") as! String;
                            let headface:String = (data as! NSDictionary).object(forKey: "headface") as! String;
                            
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
    
    
    func getData() {
        let sql="select * from chat where (senduserid='\(from)' and  touserid='\(myself)') or (senduserid='\(myself)' and  touserid='\(from)') order by _id desc";
        NSLog(sql)
        let mess = db.query(sql: sql)
        if mess.count > 0 {
            //获取最后一行数据显示
            for i in 0...mess.count-1
            {
                let item = mess[i]
                
                let message = item["message"] as! String
                //let guid = item["guid"]!.asString()
                let date = item["date"] as! String
                let senduserid = item["senduserid"] as! String
                let touserid = item["touserid"] as! String
                let sendnickname = sqlitehelp.shareInstance().loadusername(senduserid)
                let sendusericon = sqlitehelp.shareInstance().loadheadface(senduserid)
                let tonickname = sqlitehelp.shareInstance().loadusername(touserid)
                let tousericon = sqlitehelp.shareInstance().loadheadface(touserid)
                
                let fmt:DateFormatter = DateFormatter();
                fmt.dateFormat="yyyy-MM-dd HH:mm:ss"
                let now=fmt.date(from: date)!;
                
                NSLog(senduserid)
                NSLog(self.myself)
                let defaults = UserDefaults.standard;
                let userid = defaults.object(forKey: "userid") as! NSString;
                if(senduserid == userid as String)
                {
                    let me:UserInfo! = UserInfo(name:sendnickname ,logo:(sendusericon))
                    let   itemobj =  MessageItem(body:message as NSString, user:me,  date:now, mtype:ChatType.mine)
                    Chats.insert(itemobj, at: 0)
                    
                }else
                    
                {
                    let to:UserInfo! = UserInfo(name:sendnickname ,logo:(sendusericon))
                    let itemobj =  MessageItem(body:message as NSString, user:to,  date:now, mtype:ChatType.someone)
                    Chats.insert(itemobj, at: 0)
                }
            }
            
            
            self.tableView.reloadData();
            //            if(self.Chats.count>0)
            //            {
            //                //NSLog(self.Chats.count);
            //                print("Chats count: \(self.Chats.count)")
            //
            //                var indexPath =  NSIndexPath(forRow:self.Chats.count-1,inSection:0)
            //                self.tableView.scrollToRowAtIndexPath(indexPath,atScrollPosition:UITableViewScrollPosition.Bottom,animated:true)
            //            }
            
            tableViewScrollToBottom(true)
            
        }
        
    }
    
    
    
    
    func tableViewScrollToBottom(_ animated: Bool) {
        
        let delay = 0.1 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            
            let numberOfSections = self.tableView.numberOfSections
            let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections-1)
            
            if numberOfRows > 0 {
                let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: animated)
            }
            
        })
    }
    
    
    func setupSendPanel()
    {
        
        
        
        sendView = UIView(frame:CGRect(x: 0,y: self.view.frame.size.height-56,width: self.view.frame.size.width,height: 56))
        let afg = UIView(frame:CGRect(x: 0,y: 0,width: self.view.frame.size.width,height: 1))
        afg.backgroundColor=UIColor(colorLiteralRed: 212/255.0, green: 212/255.0, blue: 212/255.0, alpha: 1)
        sendView.addSubview(afg);
        sendView.backgroundColor=UIColor.white
        sendView.alpha=1
        txtMsg = UITextField(frame:CGRect(x: 8,y: 10,width: view.frame.size.width-107,height: 36))
        txtMsg.borderStyle = UITextBorderStyle.roundedRect

        txtMsg.backgroundColor = UIColor.white
        txtMsg.textColor=UIColor.black
        txtMsg.font=UIFont.boldSystemFont(ofSize: 18)
        //txtMsg.layer.cornerRadius = 10.0
        //Set the delegate so you can respond to user input
        txtMsg.delegate=self
        txtMsg.placeholder = "输入消息内容"
        txtMsg.returnKeyType = UIReturnKeyType.send
        txtMsg.enablesReturnKeyAutomatically  = true
        sendView.addSubview(txtMsg)
        
        let sendButton = UIButton(frame:CGRect(x: self.view.frame.size.width-85,y: 10,width: 77,height: 36))
        sendButton.backgroundColor=UIColor(colorLiteralRed: 232/255.0, green: 103/255.0, blue: 98/255.0, alpha: 1)
        

        sendButton.addTarget(self, action:#selector(ChatViewController.sendMessage) ,for:UIControlEvents.touchUpInside)
        sendButton.layer.cornerRadius=6.0
        sendButton.setTitle("发送", for:UIControlState())
        sendView.addSubview(sendButton)
        self.view.addSubview(sendView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(ChatViewController.handleTouches(_:)))
        tapGestureRecognizer.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(tapGestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector:#selector(ChatViewController.keyBoardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(ChatViewController.keyBoardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    
    func textFieldShouldReturn(_ textField:UITextField) -> Bool
    {
        sendMessage()
        return true
    }
    
    
    
    func sendMessage()
    {
        let sender = txtMsg
        let sendcontent:String=sender!.text!
        let me:UserInfo! = UserInfo(name:myselfname ,logo:(myselfheadface))
        //通过通道发送XML文本
        let thisChat =  MessageItem(body:sendcontent as NSString, user:me, date:Date(), mtype:ChatType.mine)
        Chats.add(thisChat)
        self.tableView.chatDataSource = self
        self.tableView.reloadData()
        sender?.resignFirstResponder()
        sender?.text = ""
        var uuid:CFUUID
        var guid:String
        uuid = CFUUIDCreate(nil)
        guid = CFUUIDCreateString(nil, uuid) as String;
        let date = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        let strNowTime = timeFormatter.string(from: date) as String
        //添加到本地
        sqlitehelp.shareInstance().addchat(sendcontent, guid: guid, date: strNowTime, senduserid: myself, sendnickname: myselfname, sendusericon: myselfheadface, touserid: from, tousernickname: fromname, tousericon: fromheadface)
        //添加朋友
        //添加朋友联系人
        if(!sqlitehelp.shareInstance().isexitfriend(from))
        {
            sqlitehelp.shareInstance().addfriend(from, nickname: fromname, usericon: fromheadface, lastuserid: myself, lastnickname: myselfname, lastinfo: sendcontent, lasttime: strNowTime, messnum: 0)
            
        }
        sqlitehelp.shareInstance().updatefriendlastinfo(from, lastuserid: myself, lastinfo: sendcontent, lasttime: strNowTime)
        let  dic:Dictionary<String,String> = ["_catatory" : "chat","_senduserid" : myself,"_sendnickname" : myselfname,"_sednusericon" : myselfheadface,"_touserid" : from,"_tonickname" : fromname,"_tousericon" : fromheadface,"_gudi":guid,"_message":sendcontent,"_channelid":""]
        let url_str:String = "http://api.bbxiaoqu.com/chat.php";
        Alamofire.request(url_str,method:HTTPMethod.post, parameters:dic)
            .responseString{ response in
                if(response.result.isSuccess)
                {
                    if let ret = response.result.value  {
                        if String(ret)=="1"
                            
                        {
                            self.alertView = UIAlertView()
                            self.alertView!.title = "提示"
                            self.alertView!.message = "发送成功"
                            self.alertView!.addButton(withTitle: "关闭")
                            Timer.scheduledTimer(timeInterval: 1, target:self, selector:"dismiss:", userInfo:self.alertView!, repeats:false)
                            self.alertView!.show()
                        }
                    }
                }else
                {
                    self.successNotice("网络请求错误")
                    print("网络请求错误")
                }
        }
    }
    
    
    
    func setupChatTable()
    {
        let f:CGRect = CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: self.view.frame.size.height - 100)
        //self.tableView = TableView(frame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 100))
        self.tableView = TableView(frame:f);
        //创建一个重用的单元格
        
        self.tableView!.register(TableViewCell.self, forCellReuseIdentifier: "ChatCell")
        
        self.tableView.chatDataSource = self
        self.tableView.reloadData()
        self.view.addSubview(self.tableView)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    
    
    
    func rowsForChatTable(_ tableView:TableView) -> Int
    {
        return self.Chats.count
    }
    
    
    
    func chatTableView(_ tableView:TableView, dataForRow row:Int) -> MessageItem
    {
        return Chats[row] as! MessageItem
    }
    
    
    
    func keyBoardWillShow(_ note:Notification)
    {
        let userInfo  = note.userInfo as! NSDictionary
        let  keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        var keyBoardBoundsRect = self.view.convert(keyBoardBounds, to:nil)
        var keyBaoardViewFrame = sendView.frame
        let deltaY = keyBoardBounds.size.height
        let animations:(() -> Void) = {
            self.sendView.transform = CGAffineTransform(translationX: 0,y: -deltaY)
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
            self.sendView.transform = CGAffineTransform.identity
        }
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            animations()
        }
    }
    
    func handleTouches(_ sender:UITapGestureRecognizer){
        if sender.location(in: self.view).y < self.view.bounds.height - 250{
            txtMsg.resignFirstResponder()
        }
    }
    
    
}

