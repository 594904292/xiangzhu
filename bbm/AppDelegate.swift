//
//  AppDelegate.swift
//  bbm
//
//  Created by ericsong on 15/9/24.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit
import Alamofire
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,XMPPStreamDelegate{

    var window: UIWindow?
    var mapManager: BMKMapManager?
    //var xmppStream:XMPPStream?
    //var password:String = ""
    // var isOpen:Bool = false
    //var chatDelegate:ChatDelegate?
    //var messageDelegate:MessageDelegate?
    
    
    //通道
    var xs: XMPPStream?
    //服务器是否开启
    var isOpen = false
    //密码
    var pwd = ""
    
    //状态代理
    var ztdl : ZtDL?
    
    //消息代理--针对会话
    var xxdl : XxDL?
    
    //消息代理--针对主界面
    var xxmaindl : XxMainDL?
    
    //消息代理--针对主界面
    var xxrecentdl : XxRecentDL?
        
    //收到消息
    func xmppStream(_ sender: XMPPStream!, didReceive message: XMPPMessage!) {
        //如果消息是聊天消息
        if message.isChatMessage() {
            var msg = WXMessage()
            
            //对方正在输入
            if message.forName("composing") != nil {
                msg.isComposing = true
            }
            
            //离线
            if message.forName("delay") != nil {
                msg.isDelay = true
            }
            
            //消息正文
            if let body = message.forName("body") {
                msg.body = body.stringValue()
            }
            let from = message.from().user ;
            let to = message.to().user;
            _ =  message.elementID()
            //完整用户名
            msg.from = message.from().user + "@" + message.from().domain
            
            //var touserid:String=message.to().user;
            
            
            let date = Date()
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "yyy-MM-dd HH:mm:ss" //(格式可俺按自己需求修整)
            let strNowTime = timeFormatter.string(from: date) as String
            //cleanchat()
            
            
            let sqlitehelpInstance1=sqlitehelp.shareInstance()
            
            //写一条信息到聊天记录表
            sqlitehelpInstance1.addchat(from!, touserid: to!, message: msg.body, guid: "", date: strNowTime, readed: "0")
            //修改通知记录
            if(sqlitehelpInstance1.unreadnoticenum(from!, catagory: "私信")==0)
            {
               sqlitehelpInstance1.addnotice(strNowTime, catagory: "私信", relativeid: from!, content: from! + "发送了一条私信", readed: "０")
            }else
            {
//                let unreadchatnum:String=self.unreadchatnum(from, to: to) as! String
//                self.updateusercontent(from,content: from.stringByAppendingString("发送了").stringByAppendingString(unreadchatnum).stringByAppendingString("条私信"))
            }
            
            //添加朋友联系人
            if(!sqlitehelpInstance1.isexitfriend(from!))
            {
               sqlitehelpInstance1.addfriend(from!, nickname: "", usericon: "", lastuserid: from!, lastnickname: "", lastinfo: msg.body, lasttime: strNowTime, messnum: 0)
                //更新头像和用户名
            
            }
            sqlitehelpInstance1.updatefriendlastinfo(from!, lastuserid: from!, lastinfo: msg.body, lasttime: strNowTime)
            //添加到消息代理中
            xxdl?.newMsg(msg)
            xxmaindl?.newMainMsg(msg)
            xxrecentdl?.newRecentMsg(msg)
            

        }
    }
    
    
    
    //收到状态
    func xmppStream(_ sender: XMPPStream!, didReceive presence: XMPPPresence!) {
        let myUser = sender.myJID.user
        //好友的用户名
        let user = presence.from().user
        //用户所在的域
        let domain = presence.from().domain
        //状态类型
        let pType = presence.type()
        //如果状态不是自己的
        if (user != myUser) {
            //状态保存的结构
            var zt = Zhuangtai()
            //保存了状态的完整用户名
            zt.name = user! + "@" + domain!
            //上线
            if pType == "available" {
                zt.isOnline = true
                ztdl?.isOn(zt)
            }else if pType == "unavailable"{
                ztdl?.isOff(zt)
            }
        }
    }
    
    //连接成功
    func xmppStreamDidConnect(_ sender: XMPPStream!) {
        isOpen = true
        // xs!.authenticateWithPassword(pwd, error: nil)
        do
        {
            try xs!.authenticate(withPassword: pwd)
        }catch
        {
            
        }
    }
    
    //验证成功
    func xmppStreamDidAuthenticate(_ sender: XMPPStream!) {
        //上线
        goOnline()
    }
    
    //建立通道
    func buildStream(){
        xs = XMPPStream()
        xs?.addDelegate(self, delegateQueue: DispatchQueue.main)
    }
    
    //发生上线状态
    func goOnline(){
        let p = XMPPPresence()
        xs!.send(p)
    }
    //发生下线状态
    func goOffline(){
        let p = XMPPPresence(type: "unavailabe")
        xs!.send(p)
    }
    
    
    
    var _xmpphost:String="101.200.194.1"
    var xmpphost:String {
        set {
            self._xmpphost = newValue;
        }
        get {
            return self._xmpphost
        }
    }
    
    
    var _xmppport:UInt16=5222
    var xmppport:UInt16 {
        set {
            self._xmppport = newValue;
        }
        get {
            return self._xmppport
        }
    }
    
    var _xmppdomain:String=""
    var xmppdomain:String {
        set {
            self._xmppdomain = newValue;
        }
        get {
            return self._xmppdomain
        }
    }
    
    //连接服务器（查看服务器是否可连接）
    func connect() -> Bool {
        buildStream()
        
        //通道已经连接
        if xs!.isConnected(){
            return true
        }
        let defaults = UserDefaults.standard;
        let userid:String = defaults.object(forKey: "userid") as! String;
        let pass:String = defaults.object(forKey: "password") as! String;
        
        //获取系统中保存的用户名、密码、服务器地址
        let user:String = userid + "@bbxiaoqu"
        let password:String = pass
        let hostName:String = xmpphost
        //let hostPort:UInt16 = xmppport
        
        // (user!= nil && password != nil) {
            //通道的用户名
            xs!.myJID = XMPPJID.init(string: user)
        
            xs!.hostName = "101.200.194.1"

            //xs!.hostPort = hostPort
            //密码保存备用
            pwd = password
        do
               {
                    _  = try xs!.connect(withTimeout: 5000)
               }catch let error as NSError {
                  print(error.localizedDescription)
                  print("cannot connect \(hostName)")
                  return false;
                }
                print("connect success!!!")
                return true;
        //}
        
       
    }
    //断开连接
    func disConnect(){
        if xs != nil {
            if xs!.isConnected() {
                 goOffline()
                xs!.disconnect()
            }
        }
    }
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //质量跟踪平台
        Bugly.start(withAppId: "900018226")
        
        mapManager = BMKMapManager() // 初始化 BMKMapManager
        // 如果要关注网络及授权验证事件，请设定generalDelegate参数
        let ret = mapManager?.start("uaiX1ZQ8vdbRQp6tRUBgL5Me", generalDelegate: nil)  // 注意此时 ret 为 Bool? 类型
        if !ret! {  // 如果 ret 为 false，先在后面！强制拆包，再在前面！取反
            NSLog("manager start failed!") // 这里推荐使用 NSLog，当然你使用 println 也是可以的
        }
        
        
        //微信1902119443
        WXApi.registerApp("wxe2123e88c6896750")
        
        print("\(NSHomeDirectory())")
        
        let str:NSString = UIDevice.current.systemVersion as NSString
        let version:Float = str.floatValue
        if version >= 8.0 {
            //UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound |..UIUserNotificationType.Alert | UIUserNotificationType.Badge, categories: nil))
            
            //public convenience init(forTypes types: UIUserNotificationType, categories: Set<UIUserNotificationCategory>?)
           
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))

            
            
            UIApplication.shared.registerForRemoteNotifications()
        } else {
            //UIApplication.sharedApplication().registerForRemoteNotificationTypes( UIRemoteNotificationType.Badge | UIRemoteNotificationType.Sound |UIRemoteNotificationType.Alert)
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token:String = deviceToken.description.trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
        print("token==\(token)")
        
        let defaults = UserDefaults.standard;
        defaults.set(token, forKey: "token");
        defaults.synchronize();

        //将token发送到服务器
    }


    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //let alert:UIAlertView = UIAlertView(title: "", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK")
        //alert.show()
        print("didFailToRegisterForRemoteNotificationsWithError error.localizedDescription==\(error.localizedDescription)")
    }
    
    
    //代理成员变量
    var apnsdelegate:ApnsDelegate?
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print("userInfo==\(userInfo)")
        //调用代理函数，改变Label值
        self.apnsdelegate?.NewMessage("newmess")
    }
    


}



protocol ApnsDelegate:NSObjectProtocol{
    //回调方法
    func NewMessage(_ string:String)
}

