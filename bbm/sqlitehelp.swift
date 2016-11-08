//
//  sqlitehelp.swift
//  bbm
//
//  Created by ericsong on 16/1/6.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit

class sqlitehelp: NSObject {

    
    static let instance = sqlitehelp()
    //对外提供创建单例对象的接口
    class func shareInstance() -> sqlitehelp {
        return instance
    }
    
    /*朋友*/
    
    func isexitfriend(_ userid:String)->Bool
    {
        let db: SQLiteDB! = SQLiteDB.sharedInstance
        let sql="select * from friend where userid='"+userid+"'";
        NSLog(sql)
        let mess = db.query(sql: sql)
        if( mess.count>0)
        {
            return true
        }
        else
        {
            return false
        }
    }

    
    func addfriend(_ userid:String,nickname:String,usericon:String,lastuserid:String,lastnickname:String,lastinfo:String,lasttime:String,messnum:Int)
    {
        let db: SQLiteDB! = SQLiteDB.sharedInstance
        let sql = "insert into friend(userid,nickname,usericon,lastuserid,lastnickname,lastinfo,lasttime,messnum) values('\(userid )','\(nickname)','\(usericon)','\(lastuserid)','\(lastnickname)','\(lastinfo)','\(lasttime)','\(messnum)')";
       _ = db.execute(sql: sql)
        
    }

    
    
    func updatefriendlastinfo(_ userid:String, lastuserid:String, lastinfo:String, lasttime:String)
    {
        let db: SQLiteDB! = SQLiteDB.sharedInstance
        let sql = "update friend set lastuserid='\(lastuserid)',lastinfo='\(lastinfo)',lasttime='\(lasttime)' ,messnum=messnum+1 where userid='\(userid)'";
        _ = db.execute(sql: sql)
        
    }
    /*通知*/
       
    func addnotice(_ date:String, catagory:String, relativeid:String, content:String, readed:String)
    {
        let db: SQLiteDB! = SQLiteDB.sharedInstance
        let sql = "insert into notice(date,catagory,relativeid,content,readed) values('\(date)','\(catagory)','\(relativeid)','\(content)','\(readed)')";
        _ = db.execute(sql: sql)
        
        
    }
    
    func updatenoticebyuserid( _ userid:String,  content:String)
    {
        let db: SQLiteDB! = SQLiteDB.sharedInstance
        let sql = "update notice  set content='\(content)' where relativeid='\(userid)'";
        _ = db.execute(sql: sql)
        
        
    }
    
    
    
    func unreadnoticenum(_ userid:String,catagory:String)->Int
    {
        let db: SQLiteDB! = SQLiteDB.sharedInstance
        let sql="select * from notice where relativeid='\(userid)' and readed=0 and catagory='\(catagory)'";
        NSLog(sql)
        let mess = db.query(sql: sql)
        return mess.count
        
    }

    
    /*聊天*/

    func addchat(_ senduserid:String,touserid:String,message:String,guid:String,date:String,readed:String)
    {
        let sendnickname:String=loadusername(senduserid)
        //var sendusericon:String=loadheadface(senduserid)
        
        let tonickname:String=loadusername(touserid)
        let tousericon:String=loadheadface(touserid)
        
        
        let db: SQLiteDB! = SQLiteDB.sharedInstance
        let sql = "insert into chat(senduserid,sendnickname,sendusericon,touserid,tonickname,tousericon,message,guid,date,readed) values('\(senduserid)','\(sendnickname)','\(sendnickname)','\(touserid)','\(tonickname)','\(tousericon)','\(message)','','\(date)','0')";
        _ = db.execute(sql: sql)
    }

    
    func addchat(_ messae:String,guid:String,date:String,senduserid:String,sendnickname:String,sendusericon:String,touserid:String,tousernickname:String,tousericon:String)
    {
        let db: SQLiteDB! = SQLiteDB.sharedInstance
        let sql = "insert into chat(message,guid,date,senduserid,sendnickname,sendusericon,touserid,tonickname,tousericon) values('\(messae)','\(guid)','\(date)','\(senduserid)','\(sendnickname)','\(sendusericon)','\(touserid)','\(tousernickname)','\(tousericon)')";
        
        NSLog("sql: \(sql)")
        _ = db.execute(sql: sql)
    }

    
    func unreadchatnum(_ from:String,to:String)->Int
    {
        let db: SQLiteDB! = SQLiteDB.sharedInstance
        let sql="select * from chat where senduserid='\(from)' and touserid='\(to)' and readed=0";
        NSLog(sql)
        let mess = db.query(sql: sql)
        return mess.count
        
    }
    
    
    
    func unreadnumchat(_ from:String,to:String)->Int
    {
        let db: SQLiteDB! = SQLiteDB.sharedInstance
        let sql="select count(*) as num1 from chat where senduserid='\(from)' and readed=0 and touserid='\(to)'";
        //NSLog(sql)
        let mess = db.query(sql: sql)
        let item = mess[0]
        let num1 = item["num1"] as! Int
        return num1;
    }
    
    /*用户*/

     func loadusername(_ userid:String)->String
    {
        let db: SQLiteDB! = SQLiteDB.sharedInstance
        let sql="select * from users where userid='"+userid+"'";
        //NSLog(sql)
        let mess = db.query(sql: sql)
        if( mess.count>0)
        {
            let item = mess[0]
            return item["nickname"] as! String
        }
        else
        {
            return ""
        }
    }
    
    func loadheadface(_ userid:String)->String
    {
        let db: SQLiteDB! = SQLiteDB.sharedInstance
        let sql="select * from users where userid='"+userid+"'";
        //NSLog(sql)
        let mess = db.query(sql: sql)
        if( mess.count>0)
        {
            let item = mess[0]
            return item["usericon"] as! String
        }
        else
        {
            return ""
        }
    }
    
    func isexituser(_ userid:String)->Bool
    {
        let db: SQLiteDB! = SQLiteDB.sharedInstance
        let sql="select * from users where userid='"+userid+"'";
        //NSLog(sql)
        let mess = db.query(sql: sql)
        if( mess.count>0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    
    
    func addusers(_ userid:String,nickname:String,usericon:String)
    {
        let db: SQLiteDB! = SQLiteDB.sharedInstance
        let sql = "insert into users(userid,nickname,usericon) values('\(userid )','\(nickname)','\(usericon)')"
        print("sql: \(sql)")
        //通过封装的方法执行sql
        let result = db.execute(sql: sql)
        
        print(result)
        NSLog(sql)
        
    }

    /*关注*/
    func removeallgz()->Bool
    {
        let db: SQLiteDB! = SQLiteDB.sharedInstance
        let sql="delete from messagegz ";
        _ = db.execute(sql: sql)
        return true
    }

    func getguids(_ userid:String)->String
    {
        let db: SQLiteDB! = SQLiteDB.sharedInstance
        let sql="select * from messagegz where userid='"+userid+"'";
        //NSLog(sql)
        let mess = db.query(sql: sql)
        
        var guids:String="";
        if(mess.count>0)
        {
            for i in 0...mess.count-1
            {
                let item = mess[i]
                let infoid = item["infoid"] as! String
                guids += ("'" + infoid) + "'"
                if(i<mess.count-1)
                {
                   guids += ","
                }
                
            }
        }
        return guids;
    }
    
    
    func addgz(_ infoid:String,userid:String)
    {
        let db: SQLiteDB! = SQLiteDB.sharedInstance
        let sql = "insert into messagegz(infoid,userid) values('\(infoid )','\(userid)')"
        print("sql: \(sql)")
        //通过封装的方法执行sql
        let result = db.execute(sql: sql)
        
        print(result)
        NSLog(sql)
        
    }
    
    func removegz(_ infoid:String,userid:String)->Bool
    {
        let db: SQLiteDB! = SQLiteDB.sharedInstance
        let sql="delete from messagegz where infoid='"+infoid+"' and userid='"+userid+"'";
        _ = db.execute(sql: sql)
        return true
   }

    func isexitgz(_ infoid:String,userid:String)->Bool
    {
        let db: SQLiteDB! = SQLiteDB.sharedInstance
        let sql="select * from messagegz where infoid='"+infoid+"' and userid='"+userid+"'";
        //NSLog(sql)
        let mess = db.query(sql: sql)
        if( mess.count>0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    
    func addzan(_ infoid:String,userid:String)
    {
        let db: SQLiteDB! = SQLiteDB.sharedInstance
        let sql = "insert into messagezan(infoid,userid) values('\(infoid )','\(userid)')"
        print("sql: \(sql)")
        //通过封装的方法执行sql
        let result = db.execute(sql: sql)
        
        print(result)
        NSLog(sql)
        
    }
    
    func removezan(_ infoid:String,userid:String)->Bool
    {
        let db: SQLiteDB! = SQLiteDB.sharedInstance
        let sql="delete from messagezan where infoid='"+infoid+"' and userid='"+userid+"'";
        _ = db.execute(sql: sql)
        return true
    }
    
    func isexitzan(_ infoid:String,userid:String)->Bool
    {
        let db: SQLiteDB! = SQLiteDB.sharedInstance
        let sql="select * from messagezan where infoid='"+infoid+"' and userid='"+userid+"'";
        //NSLog(sql)
        let mess = db.query(sql: sql)
        if( mess.count>0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    
    
    
    func addts(_ infoid:String,userid:String)
    {
        let db: SQLiteDB! = SQLiteDB.sharedInstance
        let sql = "insert into messagets(infoid,userid) values('\(infoid )','\(userid)')"
        print("sql: \(sql)")
        //通过封装的方法执行sql
        let result = db.execute(sql: sql)
        print(result)
        NSLog(sql)
        
    }
    
    func removets(_ infoid:String,userid:String)->Bool
    {
        let db: SQLiteDB! = SQLiteDB.sharedInstance
        let sql="delete from messagets where infoid='"+infoid+"' and userid='"+userid+"'";
        _ = db.execute(sql: sql)
        return true
    }
    
    func isexitts(_ infoid:String,userid:String)->Bool
    {
        let db: SQLiteDB! = SQLiteDB.sharedInstance
        let sql="select * from messagets where infoid='"+infoid+"' and userid='"+userid+"'";
        //NSLog(sql)
        let mess = db.query(sql: sql)
        if( mess.count>0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    
    
    
    func addmemberts(_ memberid:String,userid:String)
    {
        let db: SQLiteDB! = SQLiteDB.sharedInstance
        let sql = "insert into memberts(memberid,userid) values('\(memberid )','\(userid)')"
        print("sql: \(sql)")
        //通过封装的方法执行sql
        let result = db.execute(sql: sql)
        
        print(result)
        NSLog(sql)
        
    }
    
    func removememberts(_ memberid:String,userid:String)->Bool
    {
        let db: SQLiteDB! = SQLiteDB.sharedInstance
        let sql="delete from memberts where memberid='"+memberid+"' and userid='"+userid+"'";
        _ = db.execute(sql: sql)
        return true
    }
    
    func isexitmemberts(_ memberid:String,userid:String)->Bool
    {
        let db: SQLiteDB! = SQLiteDB.sharedInstance
        let sql="select * from memberts where memberid='"+memberid+"' and userid='"+userid+"'";
        //NSLog(sql)
        let mess = db.query(sql: sql)
        if( mess.count>0)
        {
            return true
        }
        else
        {
            return false
        }
    }




    
}
