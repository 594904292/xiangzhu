//
//  FriendsTableViewController.swift
//  bbm
//
//  Created by ericsong on 15/12/22.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit
import Alamofire
class FriendsTableViewController: UITableViewController {

    var dataSource = NSMutableArray()
    var currentIndexPath: NSIndexPath?
    var items:[Friends]=[]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
//        self.navigationItem.title="朋友列表"
//        self.navigationItem.leftBarButtonItem=UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: "backClick")
        initnavbar("关注好友")
        querydata()
    }
    
    
    func initnavbar(titlestr:String)
    {
        self.title=titlestr
//        var item1 = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: "backClick")
//        item1.tintColor=UIColor.whiteColor()
//        self.navigationItem.leftBarButtonItem=item1
//        var itemsearch = UIBarButtonItem(title: "搜索", style: UIBarButtonItemStyle.Done, target: self, action: #selector(AppraiseViewController.searchClick))
//        itemsearch.tintColor=UIColor.whiteColor()
//        self.navigationItem.rightBarButtonItem = itemsearch
        
        
        var returnimg=UIImage(named: "xz_nav_return_icon")
        
        let item3=UIBarButtonItem(image: returnimg, style: UIBarButtonItemStyle.Plain, target: self,  action: "backClick")
        
        item3.tintColor=UIColor.whiteColor()
        
        self.navigationItem.leftBarButtonItem=item3
        
        
        
        
        var searchimg=UIImage(named: "xz_nav_icon_search")
        
        let item4=UIBarButtonItem(image: searchimg, style: UIBarButtonItemStyle.Plain, target: self,  action: "searchClick")
        
        item4.tintColor=UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItem=item4
        

        
    }
    func backClick()
    {
        NSLog("back");
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func searchClick()
    {
        var sb = UIStoryboard(name:"Main", bundle: nil)
        var vc = sb.instantiateViewControllerWithIdentifier("souviewcontroller") as! SouViewController
        self.navigationController?.pushViewController(vc, animated: true)
        //var vc = SearchViewController()
        //self.navigationController?.pushViewController(vc, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    
    // MARK: - Table view data source
    func querydata()
    {
        
        let defaults = NSUserDefaults.standardUserDefaults();
        let userid = defaults.objectForKey("userid") as! String;
        let url:String="http://api.bbxiaoqu.com/getfriends.php?mid1=".stringByAppendingString(userid);
        print("url: \(url)")
        Alamofire.request(.GET, url, parameters: nil)
            .responseJSON { response in
                if(response.result.isSuccess)
                {

                    if let jsonItem = response.result.value as? NSArray{
                    if(jsonItem.count==0)
                    {
                          self.successNotice("好友列表为空")
                            print("好友列表为空")
                            return;
                    }
                    for data in jsonItem{
                        print("data: \(data)")
                        
                       
                        let userid:String = data.objectForKey("userid") as! String;
                        let username:String = data.objectForKey("username") as! String;
                        let headface:String = data.objectForKey("headface") as! String;
                        
                        let item_obj:Friends = Friends(userid: userid, name: username, logo: headface)
                        self.items.append(item_obj)
                        
                    }
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.tableView.reloadData();
                        
                    })
                }
        }else
        {
            self.successNotice("网络请求错误")
            print("网络请求错误")
        }
        }
        
    }
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.items.count;
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cellId = "friendscell"
        //无需强制转换
         var cell:FriendsTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as? FriendsTableViewCell!
         if(cell == nil)
        {
            cell = FriendsTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellId)

        }
        cell?.names.text=(self.items[indexPath.row] as Friends).username
        
        var avatar:String = (self.items[indexPath.row] as Friends).avatar;
        
        if(avatar.characters.count>0)
        {
        var head = "http://api.bbxiaoqu.com/uploads/".stringByAppendingString(avatar)
         Alamofire.request(.GET, head).response {
                 (_, _, data, _) -> Void in
                if let d = data as? NSData!
                {
                    cell?.headface.image=UIImage(data: d)
                }
            
            }
        }else
        {
            cell?.headface.image=UIImage(named: "logo")
        }
        
       // cell?.headface.layer.cornerRadius = 5.0
         cell?.headface.layer.cornerRadius = (cell?.headface.frame.width)! / 2
        cell?.headface.layer.masksToBounds = true

         return cell!
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        NSLog("select \(indexPath.row)")
        
        let defaults = NSUserDefaults.standardUserDefaults();
        var senduserid = defaults.objectForKey("userid") as! String;
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("chatviewController") as! ChatViewController
        //创建导航控制器
        vc.from=(self.items[indexPath.row] as Friends).userid
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

