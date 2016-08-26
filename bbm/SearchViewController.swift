//
//  SearchViewController.swift
//  bbm
//
//  Created by songgc on 16/8/16.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController,UINavigationControllerDelegate, UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating{

    
    //展示列表
    var tableView: UITableView!
    
    //搜索控制器
    var countrySearchController = UISearchController()
    
    //原始数据集
    let schoolArray = ["清华大学","北京大学","中国人民大学","北京交通大学","北京工业大学",
                       "北京航空航天大学","北京理工大学","北京科技大学","中国政法大学","中央财经大学","华北电力大学",
                       "北京体育大学","上海外国语大学","复旦大学","华东师范大学","上海大学","河北工业大学"]
    
    //搜索过滤后的结果集
    var searchArray:[String] = [String](){
        didSet  {self.tableView.reloadData()}
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor=UIColor.whiteColor()
        self.navigationItem.title="襄助"
        
        var item3 = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: "backClick")
        item3.tintColor=UIColor.whiteColor()
        
        self.navigationItem.leftBarButtonItem=item3
    
    
        var item4 = UIBarButtonItem(title: "搜索", style: UIBarButtonItemStyle.Done, target: self, action: "searchClick")
        item4.tintColor=UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem=item4
    
        //创建表视图
        self.tableView = UITableView(frame: UIScreen.mainScreen().applicationFrame,
                                     style:UITableViewStyle.Plain)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        //创建一个重用的单元格
        self.tableView!.registerClass(UITableViewCell.self,
                                      forCellReuseIdentifier: "MyCell")
        self.view.addSubview(self.tableView!)
        
        //配置搜索控制器
        self.countrySearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.searchBarStyle = .Minimal
            controller.searchBar.sizeToFit()
            self.tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
    }
    
    
    
    func searchClick()
    {
        //var sb = UIStoryboard(name:"Main", bundle: nil)
        //var vc = sb.instantiateViewControllerWithIdentifier("tabone") as! OneViewController
        //self.navigationController?.pushViewController(vc, animated: true)
        var vc = SearchViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func backClick()
    {
        NSLog("back");
        //self.navigationController?.popViewControllerAnimated(true)
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("loginController") as! LoginViewController
        
        self.presentViewController(vc, animated: true, completion: nil)
        
    }

    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (self.countrySearchController.active)
        {
            return self.searchArray.count
        } else
        {
            return self.schoolArray.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell
    {
        //为了提供表格显示性能，已创建完成的单元需重复使用
        let identify:String = "MyCell"
        //同一形式的单元格重复使用，在声明时已注册
        let cell = tableView.dequeueReusableCellWithIdentifier(identify,
                                                               forIndexPath: indexPath)
        
        if (self.countrySearchController.active)
        {
            cell.textLabel?.text = self.searchArray[indexPath.row]
            return cell
        }
            
        else
        {
            cell.textLabel?.text = self.schoolArray[indexPath.row]
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController)
    {
        self.searchArray.removeAll(keepCapacity: false)
        print(searchController.searchBar.text)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@",
                                          searchController.searchBar.text!)
        let array = (self.schoolArray as NSArray)
            .filteredArrayUsingPredicate(searchPredicate)
        self.searchArray = array as! [String]
    }



}
