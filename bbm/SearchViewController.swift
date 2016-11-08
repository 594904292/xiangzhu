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
        
        self.view.backgroundColor=UIColor.white
        self.navigationItem.title="襄助"
        
        let item3 = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.done, target: self, action: #selector(SearchViewController.backClick))
        item3.tintColor=UIColor.white
        
        self.navigationItem.leftBarButtonItem=item3
    
    
        let item4 = UIBarButtonItem(title: "搜索", style: UIBarButtonItemStyle.done, target: self, action: #selector(SearchViewController.searchClick))
        item4.tintColor=UIColor.white
        self.navigationItem.rightBarButtonItem=item4
    
        //创建表视图
        self.tableView = UITableView(frame: UIScreen.main.bounds,
                                     style:UITableViewStyle.plain)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        //创建一个重用的单元格
        self.tableView!.register(UITableViewCell.self,
                                      forCellReuseIdentifier: "MyCell")
        self.view.addSubview(self.tableView!)
        
        //配置搜索控制器
        self.countrySearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.hidesNavigationBarDuringPresentation = false
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.searchBarStyle = .minimal
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
        let vc = SearchViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func backClick()
    {
        NSLog("back");
        //self.navigationController?.popViewControllerAnimated(true)
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "loginController") as! LoginViewController
        
        self.present(vc, animated: true, completion: nil)
        
    }

    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if (self.countrySearchController.isActive)
        {
            return self.searchArray.count
        } else
        {
            return self.schoolArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        //为了提供表格显示性能，已创建完成的单元需重复使用
        let identify:String = "MyCell"
        //同一形式的单元格重复使用，在声明时已注册
        let cell = tableView.dequeueReusableCell(withIdentifier: identify,
                                                               for: indexPath)
        
        if (self.countrySearchController.isActive)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func updateSearchResults(for searchController: UISearchController)
    {
        self.searchArray.removeAll(keepingCapacity: false)
        //print(searchController.searchBar.text as String)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@",
                                          searchController.searchBar.text!)
        let array = (self.schoolArray as NSArray)
            .filtered(using: searchPredicate)
        self.searchArray = array as! [String]
    }



}
