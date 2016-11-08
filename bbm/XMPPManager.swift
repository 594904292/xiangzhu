//
//  XMPPManager.swift
//  bbm
//
//  Created by ericsong on 15/12/21.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit

class XMPPManager: NSObject ,XMPPStreamDelegate {
//    fileprivate static var __once: () = { () -> Void in
//            StaticStruct.xmppManager = XMPPManager;
//            StaticStruct.xmppManager?.manageStreamAndRoster();
//        }()
    //定义通讯通道
    var stream:XMPPStream = XMPPStream()
    //定义花名册
    var roster:XMPPRoster?
    var password:String?
    class func shareWithXMPPManager()->XMPPManager {
        struct StaticStruct{
            static var predicate:Int = 0;
            static var xmppManager:XMPPManager? = nil;
        }
        //_ = XMPPManager.__once;
        
        return StaticStruct.xmppManager!;
    }
    func manageStreamAndRoster(){
        self.stream.hostName = "101.200.194.1";
        self.stream.hostPort = UInt16(5222);
        self.stream.addDelegate(self, delegateQueue: DispatchQueue.main);
        
        let rosterStorage111:XMPPRosterCoreDataStorage = XMPPRosterCoreDataStorage.sharedInstance();
        self.roster = XMPPRoster(rosterStorage: rosterStorage111, dispatchQueue: DispatchQueue.main);
        self.roster!.addDelegate(self, delegateQueue: DispatchQueue.main);
    }
    //设置登录操作
    func loginWithUserNameAndPassword(_ userName:String,password:String){
        self.password = password;
       // var jid:XMPPJID = XMPPJID.jidWithUser(userName, domain: Domine, resource: Resource) as XMPPJID;
//        let jid:XMPPJID = XMPPJID.withUser(userName as String, domain: "bbxiaoqu", resource: "ios") as XMPPJID;
        let jid:XMPPJID  = XMPPJID.init(user: userName, domain: "bbxiaoqu", resource: "ios")
        self.stream.myJID = jid;
        self.connectToServer();
    }
    //设置与服务器的连接
    func connectToServer(){
        if self.stream.isConnecting() || self.stream.isConnected(){
            self.disconnectWithServer();
        }
        do {
            try self.stream.connect(withTimeout: 5000)
        } catch {
            
        }
    }
    //断开与服务器的连接
    func disconnectWithServer(){
        let presence:XMPPPresence = XMPPPresence(type: "available");
        self.stream.send(presence);
        self.stream.disconnect();
    }
    
    func xmppStreamDidAuthenticate(_ sender: XMPPStream!) {
        let haveLogin:NSNumber = UserDefaults.standard.object(forKey: "haveLogin") as! NSNumber;
        if !haveLogin.boolValue{
            return;
        }
        let presence:XMPPPresence = XMPPPresence(type: "available");
        self.stream.send(presence);
    }
    func xmppStreamDidConnect(_ sender: XMPPStream!) {
        do {
            try self.stream.authenticate(withPassword: self.password)
        } catch {
           
        }
    }
    
    func xmppStream(_ sender: XMPPStream!, didNotAuthenticate error: DDXMLElement!) {
        //let alter:UIAlertView = UIAlertView(title: "提示", message: "密码验证失败!", delegate: nil, cancelButtonTitle: "取消");
        //alter.show();
        
        NSLog("密码验证失败!")

    }
    func xmppStreamConnectDidTimeout(_ sender: XMPPStream!) {
        //let alter:UIAlertView = UIAlertView(title: "对不起", message: "连接超时!", delegate: nil, cancelButtonTitle: "取消");
        //alter.show();
        NSLog("连接超时!")
    }
    
    func unreadnum(_ userid:String,catagory:String)->Int
    {
         let db: SQLiteDB! = SQLiteDB.sharedInstance
        let sql="select * from notice where relativeid='"+userid+"' and readed=0 and catagory='"+catagory+"'";
        NSLog(sql)
        let mess = db.query(sql: sql)
        return mess.count
     }
    
    func xmppStream(_ sender:XMPPStream ,didReceive message:XMPPMessage? ){
                if message != nil {
                    NSLog("message:\(message)")
                    
                    
                    //let defaults = UserDefaults.standard;
                    //let touserid = defaults.string(forKey: "userid")
                    //let tonickname = defaults.object(forKey: "nickname") as! String;
                    //let tousericon = defaults.object(forKey: "headface") as! String;
                    
                    //let cont:String = message!.forName("body").stringValue();
                    //let from:String = message!.attribute(forName: "from").stringValue();
        
                    //let date = Date()
                    //let timeFormatter = DateFormatter()
                    //timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss.SSS" //(格式可俺按自己需求修整)
                    //let strNowTime = timeFormatter.string(from: date) as String
        
                    //var msg:Message = Message(content:cont,sender:from,ctime:strNowTime)
                    //var db: SQLiteDB!
                    //db = SQLiteDB.sharedInstance
                    //_ = "insert into chat(message,guid,date,senduserid,sendnickname,sendusericon,touserid,tonickname,tousericon) values('\(cont)','','\(date)','\(from)','\(from)','\(from)','\(touserid)','\(tonickname)','\(tousericon)')";
                    //私信
                    
                    //通知
                    
                    //朋友
                    
        
                    //消息委托(这个后面讲)
                    //send("369",to: "18600888703",mess: "11111");
                }
    }
    
    
//    func send(send:String,to:String,mess:String)
//        {
//    
//                //XMPPFramework主要是通过KissXML来生成XML文件
//                //生成<body>文档
//                let body:DDXMLElement = DDXMLElement.elementWithName("body") as! DDXMLElement
//                body.setStringValue(mess)
//    
//                //生成XML消息文档
//                let mes:DDXMLElement = DDXMLElement.elementWithName("message") as! DDXMLElement
//                //消息类型
//                mes.addAttributeWithName("type",stringValue:"chat")
//                //发送给谁
//                mes.addAttributeWithName("to" ,stringValue:"369@bbxiaoqu")
//                //由谁发送
//                mes.addAttributeWithName("from" ,stringValue:"888@bbxiaoqu")
//                //组合
//                mes.addChild(body)
//    
//    
//                print(mes)
//                //发送消息
//                self.stream.sendElement(mes)
//            
//            
//        }


}
