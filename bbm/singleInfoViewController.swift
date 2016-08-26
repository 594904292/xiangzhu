//
//  singleInfoViewController.swift
//  bbm
//
//  Created by songgc on 16/8/17.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit

class singleInfoViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate{
    var dataTable:UITableView!;                                             //数据表格
    var itemString=["昵称","账号","生日","性别","电话","微信","紧急联系人","接收消息","系统设置","退出"]
    //当前屏幕对象
    var screenObject=UIScreen.mainScreen().bounds;
    
    //页面初始化
    override func viewDidLoad() {
        super.viewDidLoad();
        initView();
    }
    /**
     UI 初始化
     */
    func initView(){
        self.title="我的资料";
        self.view.backgroundColor = UIColor.lightGrayColor()
        creatTable();
    }
    /**
     我的资料表格初始化
     */
    func creatTable(){
        let dataTableW:CGFloat=screenObject.width;
        let dataTableH:CGFloat=screenObject.height;
        let dataTableX:CGFloat=0;
        let dataTableY:CGFloat=0;
        dataTable=UITableView(frame: CGRectMake(dataTableX, dataTableY, dataTableW, dataTableH),style:UITableViewStyle.Grouped);
        dataTable.delegate=self;
        dataTable.dataSource=self;
        self.view.addSubview(dataTable);
    }
    //1.1默认返回一组
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4;
    }
    
    // 1.2 返回行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return 4;
        }else if(section == 1){
            return 3;
        }else if(section == 2){
            return 2;
        }else{
            return 1;
        }
    }
    
    //1.3 返回行高
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        
        if(indexPath.section == 0){
            return 40;
        }else{
            return 40;
            
        }
    }
    
    //1.4每组的头部高度
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10;
    }
    
    //1.5每组的底部高度
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1;
    }
    //1.6 返回数据源
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier="identtifier";
        var cell=tableView.dequeueReusableCellWithIdentifier(identifier);
        if(cell == nil){
            cell=UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: identifier);
        }
        
        cell?.textLabel?.text=itemString[indexPath.row];

        if(indexPath.section == 0){
            cell?.textLabel?.text=itemString[indexPath.row];
        }else if(indexPath.section == 1){
            cell?.textLabel?.text=itemString[indexPath.row+4];
        }else if(indexPath.section == 2){
            cell?.textLabel?.text=itemString[indexPath.row+7];
        }else if(indexPath.section == 3){
            cell?.textLabel?.text=itemString[indexPath.row+9];
        }
        cell?.accessoryType=UITableViewCellAccessoryType.DisclosureIndicator;
        return cell!;
    }
    //1.7 表格点击事件
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //取消选中的样式
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
        if(indexPath.row == 0){
            let pushSingleInfo=singleInfoViewController();
            pushSingleInfo.hidesBottomBarWhenPushed=true;
            self.navigationController?.pushViewController(pushSingleInfo, animated: true);
        }
    }
    
    //内存警告
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
        print("个人信息内存警告");
    }
}