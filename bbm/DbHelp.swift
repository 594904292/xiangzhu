//
//  DbHelp.swift
//  bbm
//
//  Created by ericsong on 15/10/10.
//  Copyright © 2015年 sprin. All rights reserved.
//

import Foundation

class DbHelp
{
    func initdb()
    {
        //获取数据库实例
        let db: SQLiteDB! = SQLiteDB.sharedInstance
        
        let sql0:NSString = "create table IF NOT EXISTS interest(_id integer primary key autoincrement, interestname varchar(20), imageurl varchar(20), weather varchar(20), temp varchar(20))";
         _ = db.execute(sql: sql0  as String);
        
        
        let sql:NSString = "create table  IF NOT EXISTS [user] (id integer primary key autoincrement,userid varchar(20),nickname varchar(20),password varchar(20),telphone varchar(2),headface varchar(2),pass BOOLEAN  NULL,online BOOLEAN  NULL,lastlogintime varchar(50)  NULL)";
         _ = db.execute(sql: sql  as String);
        
        
        let sql1:NSString  = "create table  IF NOT EXISTS [xiaoqu] (_id integer primary key autoincrement, xiaoquname varchar(20))";
         _ = db.execute(sql: sql1  as String);
        
        
        
        let sqlgz:NSString = "create table  IF NOT EXISTS [messagegz] (_id integer primary key autoincrement, infoid varchar(50), userid varchar(50))";
         _ = db.execute(sql: sqlgz  as String);
        
        
        let infotssql = "create table  IF NOT EXISTS  [messagets] (_id integer primary key autoincrement, infoid varchar(50), userid varchar(50))";
         _ = db.execute(sql: infotssql);
        
        let membertssql = "create table  IF NOT EXISTS  [memberts] (_id integer primary key autoincrement, memberid varchar(50), userid varchar(50))";
         _ = db.execute(sql: membertssql);
        
        
        let sqlzan:NSString = "create table  IF NOT EXISTS [messagezan] (_id integer primary key autoincrement, infoid varchar(50), userid varchar(50))";
         _ = db.execute(sql: sqlzan  as String);

        
        
        let sql3:NSString = "create table  IF NOT EXISTS [messagebm] (_id integer primary key autoincrement, infoid varchar(50), userid varchar(50))";
         _ = db.execute(sql: sql3  as String);
        
        
        
        let sql4:NSString = "CREATE table IF NOT EXISTS [message] (_id INTEGER PRIMARY KEY AUTOINCREMENT,senduserid varchar(20), sendnickname varchar(50),community varchar(200), address varchar(200),lng varchar(20), lat varchar(20),guid varchar(100),infocatagroy varchar(20),message varchar(200),icon   varchar(200), date varchar(20) , is_coming integer ,readed integer)";
        
        _ = db.execute(sql: sql4 as String)
        
        
        
        
        
        let sql5:NSString = "CREATE table IF NOT EXISTS [chat] (_id INTEGER PRIMARY KEY AUTOINCREMENT, guid varchar(100), senduserid varchar(20), sendnickname varchar(50),sendusericon varchar(200),touserid varchar(20),tonickname varchar(50),tousericon varchar(200),message varchar(200), date varchar(20) ,readed integer)";
        
        _ = db.execute(sql: sql5 as String);
        
        
        
        
        
        let sql6 = "CREATE table IF NOT EXISTS [notice] (_id INTEGER PRIMARY KEY AUTOINCREMENT, "
            
            + "date varchar(100), " //提醒时间
            
            + "catagory varchar(20), " //提醒类别
            
            + "relativeid varchar(50), " //关联id
            
            + "content varchar(20), " //内容
            
            + "readed integer)";
        
         _ = db.execute(sql: sql6 as String);//
        
        

       
          _ = db.execute(sql: "create table if not exists friend(uid integer primary key,userid varchar(100),nickname varchar(100),usericon varchar(100),lastuserid varchar(100),lastnickname varchar(100),lastinfo varchar(100),lasttime varchar(100),messnum varchar(100))")
        
        
        
         _ =  db.execute(sql: "create table if not exists users(uid integer primary key,userid varchar(100),nickname varchar(100),usericon varchar(100),lastlogintime varchar(100))")
    
        
    }

}
