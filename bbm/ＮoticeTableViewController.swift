//
//  ＮoticeTableViewController.swift
//  bbm
//
//  Created by songgc on 16/8/18.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit
import Alamofire

class NoticeTableViewController: UITableViewController {
var items:[ItemNotice]=[]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        self.navigationItem.title="最新消息"
        var returnimg=UIImage(named: "xz_nav_return_icon")
        
        let item3=UIBarButtonItem(image: returnimg, style: UIBarButtonItemStyle.Plain, target: self,  action: "backClick")
        
        item3.tintColor=UIColor.whiteColor()
        
        self.navigationItem.leftBarButtonItem=item3
        
        
        var searchimg=UIImage(named: "xz_nav_icon_search")
        
        let item4=UIBarButtonItem(image: searchimg, style: UIBarButtonItemStyle.Plain, target: self,  action: "searchClick")
        
        item4.tintColor=UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItem=item4

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        querydata()
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



    func querydata()
    {
        var url:String="http://api.bbxiaoqu.com/getnotices.php?userid=369";
        print("url: \(url)")
        Alamofire.request(.GET, url, parameters: nil)
            .responseJSON { response in
                if(response.result.isSuccess)
                {
                    if let jsonItem = response.result.value as? NSArray{
                        for data in jsonItem{
                            print("data: \(data)")
                            var catagory:String = data.objectForKey("catagory") as! String;
                            var content:String = data.objectForKey("content") as! String;
                            var notictime:String = data.objectForKey("notictime") as! String;
                            
                            var senduser:String = data.objectForKey("senduser") as! String;
                            var username:String = data.objectForKey("username") as! String;
                            var relation:String = data.objectForKey("relation") as! String;
                            var readed:String = data.objectForKey("readed") as! String;
                           
                           
                             let item_obj:ItemNotice = ItemNotice(catagory: catagory, content: content, time: notictime, senduser: senduser, username: username, relation: relation, readed: readed)
                            self.items.append(item_obj)
                            
                        }
                        self.tableView.reloadData()
                        self.tableView.doneRefresh()
                        
                    }
                }else
                {
                    self.successNotice("网络请求错误")
                    print("网络请求错误")
                }
        }
        
    }

    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 0.0001;
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 0.0001;
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return self.items.count;
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId="noticecell"
        var cell:NoticeTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as! NoticeTableViewCell?
        if(cell == nil)
        {
            cell = NoticeTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellId)
        }
        
        if((items[indexPath.row] as ItemNotice).catagory=="pl")
        {
            cell?.notice_catagory.text="评论"
        }else if((items[indexPath.row] as ItemNotice).catagory=="xmpp")
        {
            cell?.notice_catagory.text="私信"
        }else if((items[indexPath.row] as ItemNotice).catagory=="sys")
        {
            cell?.notice_catagory.text="系统消息"
        }
        
        
        cell?.notice_content.text=(items[indexPath.row] as ItemNotice).content
        cell?.notice_time.text=(items[indexPath.row] as ItemNotice).time
        
                return cell!
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        NSLog("select \(indexPath.row)")
        print("clicked at \(indexPath.row)")
        let aa:ItemNotice=items[indexPath.row] as ItemNotice;
        if(aa.catagory=="pl")
        {
            let sb = UIStoryboard(name:"Main", bundle: nil)
            let vc = sb.instantiateViewControllerWithIdentifier("contentviewController") as! ContentViewController
            //创建导航控制器
            //vc.message = aa.content;
            vc.infoid=aa.relation
            self.navigationController?.pushViewController(vc, animated: true)

        }
        //设置根视图
        
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    

  
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
