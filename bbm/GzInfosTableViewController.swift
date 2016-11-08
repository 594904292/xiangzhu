//
//  GzInfosTableViewController.swift
//  bbm
//
//  Created by ericsong on 15/12/22.
//  Copyright © 2015年 sprin. All rights reserved.
//

import UIKit
import Alamofire
class GzInfosTableViewController: UITableViewController {

    var start:Int = 0
    var limit:Int = 10
    
    var items:[itemMess]=[]
    override func viewDidLoad() {
        super.viewDidLoad()

        
        initnavbar("收藏信息")
        self.tableView.register(OneTableViewCell.self, forCellReuseIdentifier: "cell")//注册自定义cell
        tableView.estimatedRowHeight = 250
        //setSeparatorInset:UIEdgeInsetsMake
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        //设置分割线颜色
        self.tableView.separatorColor = UIColor.red
        //设置分割线内边距
        self.tableView.separatorInset = UIEdgeInsetsMake(5, 0, 0, 0)

        querydata()
        
        
    }
    
    func initnavbar(_ titlestr:String)
    {
        self.title=titlestr
        let returnimg=UIImage(named: "xz_nav_return_icon")
        
        let item3=UIBarButtonItem(image: returnimg, style: UIBarButtonItemStyle.plain, target: self,  action: #selector(GzInfosTableViewController.backClick))
        
        item3.tintColor=UIColor.white
        
        self.navigationItem.leftBarButtonItem=item3
        
        
        
        
        let searchimg=UIImage(named: "xz_nav_icon_search")
        
        let item4=UIBarButtonItem(image: searchimg, style: UIBarButtonItemStyle.plain, target: self,  action: #selector(GzInfosTableViewController.searchClick))
        
        item4.tintColor=UIColor.white
        
        self.navigationItem.rightBarButtonItem=item4
    }
    func backClick()
    {
        self.navigationController!.popViewController(animated: true)
    }
    
    func searchClick()
    {
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "souviewcontroller") as! SouViewController
        self.navigationController?.pushViewController(vc, animated: true)
        //var vc = SearchViewController()
        //self.navigationController?.pushViewController(vc, animated: true)
    }
  
    
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.items.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        
        let str:String = "cell"
        
        var cell:OneTableViewCell = tableView.dequeueReusableCell(withIdentifier: str, for: indexPath) as! OneTableViewCell
        
        if cell.isEqual(nil) {
            cell = OneTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: str)
        }
        //var senduser=(items[indexPath.row] as itemMess).username
        let namestr:String=(items[indexPath.row] as itemMess).username
        
        cell.username.text = namestr//array[indexPath.row]//(items[indexPath.row] as itemMess).username
        
        
        let options:NSStringDrawingOptions = .usesLineFragmentOrigin
        //let options:NSStringDrawingOptions = .UsesLineFragmentOrigin
        
        let boundingRect = namestr.boundingRect(with: CGSize(width: 200, height: 0), options: options, attributes:[NSFontAttributeName:cell.username.font], context: nil)
        
        if((items[indexPath.row] as itemMess).sex == "0")
        {
            cell.seximg.image=UIImage(named: "xz_nan_icon")
            
        }else
        {
            cell.seximg.image=UIImage(named: "xz_nv_icon")
        }
        cell.seximg.frame=CGRect(x: boundingRect.width+70, y: 25, width: 10, height: 15)
        
        
        
        
        if (items[indexPath.row] as itemMess).street.characters.count > 0
        {
            cell.street.text=(items[indexPath.row] as itemMess).street
        }else
        {
            cell.street.text="未知"
        }
        
        
        let streettr:String = cell.street.text!
        
        
        let distanceboundingRect = streettr.boundingRect(with: CGSize(width: 200, height: 0), options: options, attributes:[NSFontAttributeName:cell.street.font], context: nil)
        cell.distance.frame=CGRect(x: distanceboundingRect.width+70, y: 43, width: distanceboundingRect.width*2, height: 30)
        cell.distance.text=(items[indexPath.row] as itemMess).address
        
        cell.timesgo.text=(items[indexPath.row] as itemMess).time
        
        
        
        
        
        
        cell.content.text=(items[indexPath.row] as itemMess).content
        
        if((items[indexPath.row] as itemMess).headface.characters.count>0)
        {
            let myhead:String="http://api.bbxiaoqu.com/uploads/" + (items[indexPath.row] as itemMess).headface
            
            
             Util.loadpic(cell.headface, url: myhead)
            
            
            cell.headface.layer.cornerRadius = cell.headface.frame.width / 2
            // image还需要加上这一句, 不然无效
            cell.headface.layer.masksToBounds = true
        }
        let bw:CGFloat = UIScreen.main.bounds.width-20
        
        var photoArr:[String] = (items[indexPath.row] as itemMess).photo.characters.split{$0 == ","}.map{String($0)}
        
        
        var picnum=photoArr.count
        if(picnum>4)
        {
            picnum=4
        }
        
        for j:Int in 0 ..< picnum
        {
            let imageView:UIImageView = UIImageView();
            let sw=bw/4;
            let x:CGFloat = sw * CGFloat(j);
            imageView.frame=CGRect.init(x: x+5, y: 5, width: sw-10, height: sw-10);
            imageView.tag=indexPath.row*100+j
            let picname:String = photoArr[j]
            let imgurl = "http://api.bbxiaoqu.com/uploads/".appending(picname)
            //添加边框
            let layer:CALayer = imageView.layer
            layer.borderColor=UIColor.lightGray.cgColor
            layer.opacity=1
            layer.borderWidth = 1.0;
            imageView.image=UIImage(named: "xz_pic_text_loading")
            Util.loadpic(imageView,url: imgurl);

            cell.imgview.addSubview(imageView);
        }
        cell.delimg.isHidden=true
        cell.clickBtn.tag = indexPath.row
        cell.clickBtn.isHidden = true
        //let tap = UITapGestureRecognizer.init(target: self, action: Selector.init("tapped:"))
        //cell.clickBtn.addGestureRecognizer(tap)
        
        
        cell.tag1.text=("浏览:" + (items[indexPath.row] as itemMess).visnum) + "次"
        cell.tag2.text=("评论:" + (items[indexPath.row] as itemMess).plnum) + "次"
        
        if ((items[indexPath.row] as itemMess).status == "0")
        {
            cell.statusimg.image =  UIImage(named: "xz_qiuzhu_icon")
        }else if ((items[indexPath.row] as itemMess).status == "1")
        {
            cell.statusimg.image = UIImage(named: "xz_qiuzhu_icon")
        }else if ((items[indexPath.row] as itemMess).status == "2")
        {
            cell.statusimg.image = UIImage(named: "xz_yijiejue_icon")
        }
        
        
        
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        NSLog("select \(indexPath.row)")
        //NSLog("select \(items[indexPath.row])")
        let aa:itemMess=items[indexPath.row] as itemMess;
        
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "contentviewController") as! ContentViewController
        //创建导航控制器
        //vc.message = aa.content;
        vc.guid=aa.guid
        vc.infoid=aa.guid
        // let nvc=UINavigationController(rootViewController:vc);
        //设置根视图
        //  self.view.window!.rootViewController=nvc;
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath:IndexPath) -> CGFloat
    {
                   return 250;
        
    }

    
    
    
    
    func querydata()
    {
         let sqlitehelpInstance1=sqlitehelp.shareInstance()
        
        let defaults = UserDefaults.standard;
        let userid = defaults.object(forKey: "userid") as! String;
        
        let guids:String = sqlitehelpInstance1.getguids(userid)
        if(guids.characters.count==0)
        {
            self.successNotice("无收藏信息")
            print("无收藏信息")
            return;
        }
        let url:String="http://api.bbxiaoqu.com/getgzinfo.php?guid=" + guids;
        print("url: \(url)")
        Alamofire.request(url,method:.get, parameters: nil)
            .responseJSON { response in
                if(response.result.isSuccess)
                {
                if let jsonItem = response.result.value as? NSArray{
                    for adata in jsonItem{
                        //print("data: \(data)")
                        let data:NSDictionary = adata as! NSDictionary;
                        let content:String = data.object(forKey: "content") as! String;
                        let senduserid:String = data.object(forKey: "senduser") as! String;
                        
                        var sendnickname:String = "";
                        if(data.object(forKey: "username")==nil)
                        {
                            sendnickname="";
                        }else
                        {
                            sendnickname   = data.object(forKey: "username") as! String;
                            
                        }
                        let guid:String = data.object(forKey: "guid") as! String;
                        let sendtime:String;
                        let temptime:String=data.object(forKey: "sendtime") as! String;
                        
                        
                        
                        //temptime	String	"2016-04-06 13:40:11"
                        
                        let date:Date = Date()
                        let formatter:DateFormatter = DateFormatter()
                        formatter.dateFormat = "yyyy-MM-dd"
                        let dateString = formatter.string(from: date)
                        
                        if(temptime.contains(dateString))
                        {
                            sendtime = temptime.subString(start: 11)
                            
                        }else
                        {
                            
                            sendtime = (temptime as NSString).substring(with: NSRange(location: 0,length: 10))
                        }
                        
                        
                        
                        //let address:String = data.objectForKey("address") as! String;
                        
                        let lng:String = data.object(forKey: "lng") as! String;
                        let lat:String = data.object(forKey: "lat") as! String;
                        
                        
                        let lat_1=(lat as NSString).doubleValue;
                        let lng_1=(lng as NSString).doubleValue;
                        
                        let defaults = UserDefaults.standard;
                        _ = defaults.object(forKey: "userid") as! String;
                        //                            let mylat = defaults.objectForKey("lat") as! String;
                        //                            let mylng = defaults.objectForKey("lng") as! String;
                        
                        
                        let lat_2=(lat as NSString).doubleValue;
                        let lng_2=(lng as NSString).doubleValue;
                        var address:String="";
                        
                        
                            let p1:BMKMapPoint = BMKMapPointForCoordinate(CLLocationCoordinate2D(latitude: lat_1, longitude: lng_1))
                            let p2:BMKMapPoint = BMKMapPointForCoordinate(CLLocationCoordinate2D(latitude: lat_2, longitude: lng_2))
                            //var a2:BMKMapPoint = CLLocationCoordinate2D(latitude: lat_2, longitude: lng_2)
                            
                            let distance:CLLocationDistance = BMKMetersBetweenMapPoints(p1, p2);
                            
                            
                            let one:UInt32 = UInt32(distance)
                            if(one>1000)
                            {
                                address = ("\(self.roundoff(Double(one)/1000))千米");
                            }else
                            {
                                address = ("\(one)米");
                            }
                        
                        
                        
                        
                        let city:String = data.object(forKey: "city") as! String;
                        let street:String = data.object(forKey: "street") as! String;
                        let photo:String = data.object(forKey: "photo") as! String;
                        var community:String = ""
                        if(data.object(forKey: "community")==nil)
                        {
                            community = "";
                        }else
                        {
                            community = data.object(forKey: "community") as! String;
                            
                        }
                        let infocatagroy:String = data.object(forKey: "infocatagroy") as! String;
                        let status:String = data.object(forKey: "status") as! String;
                        let visit:String = data.object(forKey: "visit") as! String;
                        let plnum:String = data.object(forKey: "plnum") as! String;
                        let headface:String = data.object(forKey: "headface") as! String;
                        let sex:String = data.object(forKey: "sex") as! String;

                        let item_obj:itemMess = itemMess(userid: senduserid,headface:headface,sex:sex, vname: sendnickname, vtime: sendtime, city: city,street: street,vaddress: address, vcontent: content, vcommunity: community, vlng: lng, vlat: lat, vguid: guid, vinfocatagory: infocatagroy, vphoto: photo, status: status, visnum: visit, plnum: plnum)
                        self.items.append(item_obj)
                        
                    }
                    self.tableView.reloadData()
                    
                    
                }
                }else
                {
                    self.successNotice("网络请求错误")
                    print("网络请求错误")
                }
        }
        
    }
    func roundoff(_ x:Double)->Int
    {
        let a:Int = Int(x)
        let b:Double = Double(a)+0.5
        if(x>b)
        { return a+1 }
        else
        { return a}
    }
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
