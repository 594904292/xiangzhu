//
//  SouXiaoQuViewController.swift
//  bbm
//
//  Created by songgc on 16/9/19.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit
import Alamofire;


//定义协议改变Label内容
protocol ChangeXiaoquDelegate:NSObjectProtocol{
    //回调方法
    func ChangeXiaoqu(controller:SouXiaoQuViewController,name:String,code:String)
}

class SouXiaoQuViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate{

    @IBOutlet weak var xiaoquname: UITextField!
    @IBOutlet weak var _tableview: UITableView!
    var items:[ItemXiaoqu]=[]

    @IBAction func touchdown(sender: UIControl) {
        xiaoquname.resignFirstResponder()
    }
    @IBAction func nameexit(sender: UITextField) {
        xiaoquname.resignFirstResponder()
    }
    
    @IBAction func autoSearch(sender: UITextField) {
        querydata(xiaoquname.text!)

    }
    @IBAction func searchclick(sender: UIButton) {
        querydata(xiaoquname.text!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title="选择小区"
        let returnimg=UIImage(named: "xz_nav_return_icon")
        
        let item3=UIBarButtonItem(image: returnimg, style: UIBarButtonItemStyle.Plain, target: self,  action: #selector(SouXiaoQuViewController.backClick))
        
        item3.tintColor=UIColor.whiteColor()
        
        self.navigationItem.leftBarButtonItem=item3
        
        
             
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        _tableview.delegate=self;
        _tableview.dataSource=self;
        xiaoquname.delegate = self;
        //xiaoquname.addTarget(self, action: #selector(SouXiaoQuViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        querydata("")
        
    }
//    func textFieldDidChange(textField: UITextField) {
//        print(textField.text!)
//        querydata(xiaoquname.text!)
//    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        //收起键盘
        xiaoquname.resignFirstResponder()
        
        
        //输出文本
        print(textField.text!)
        
        querydata(xiaoquname.text!)

        return true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backClick()
    {
        NSLog("back");
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    
    func querydata(name:String)
    {
        let defaults = NSUserDefaults.standardUserDefaults();
        let userid = defaults.objectForKey("userid") as! NSString;
        var aname:String = name.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        

        var url:String="http://api.bbxiaoqu.com/getcxhfdm.php?name=".stringByAppendingString(aname);
        print("url: \(url)")
        self.items.removeAll()
        Alamofire.request(.GET, url, parameters: nil)
            .responseJSON { response in
                if(response.result.isSuccess)
                {
                    if let jsonItem = response.result.value as? NSArray{
                        for data in jsonItem{
                            print("data: \(data)")
                            var id:String = data.objectForKey("id") as! String;
                            var province:String = data.objectForKey("province") as! String;
                            var city:String = data.objectForKey("city") as! String;
                            var district:String = data.objectForKey("district") as! String;
                            var street:String = data.objectForKey("street") as! String;
                             var name:String = data.objectForKey("name") as! String;
                            var code:String = data.objectForKey("code") as! String;
                             let item_obj:ItemXiaoqu = ItemXiaoqu(id: id, province: province, city: city, district: district, street: street, code: code, name: name)
                            self.items.append(item_obj)
                            
                        }
                        self._tableview.reloadData()
                        //self._tableview.doneRefresh()
                        
                    }
                }else
                {
                    self.successNotice("网络请求错误")
                    print("网络请求错误")
                }
        }
        
    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 0.0001;
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 0.0001;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return self.items.count;
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath:NSIndexPath) -> CGFloat
    {
        //计算行高，返回，textview根据数据计算高度
        
        var fixedWidth:CGFloat = 270;
        var contextLab:UITextView=UITextView()
        var address:String="";
        address = address.stringByAppendingString((items[indexPath.row] as ItemXiaoqu).province)
        address = address.stringByAppendingString(",")
        if((items[indexPath.row] as ItemXiaoqu).province != (items[indexPath.row] as ItemXiaoqu).city)
        {
            address=address.stringByAppendingString((items[indexPath.row] as ItemXiaoqu).city)
            address = address.stringByAppendingString(",")
        }
        address=address.stringByAppendingString((items[indexPath.row] as ItemXiaoqu).district)
        address = address.stringByAppendingString(",")
        address=address.stringByAppendingString((items[indexPath.row] as ItemXiaoqu).street)
        
       
        
            contextLab.text = address
            var newSize:CGSize = contextLab.sizeThatFits(CGSizeMake(fixedWidth, 22));
            var height=(newSize.height)
            print("height---\(height)")
            return height+50
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId="xiaoqucell"
        var cell:HfDmTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellId) as! HfDmTableViewCell?
        if(cell == nil)
        {
            cell = HfDmTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellId)
        }
       
        //xz_fang_icon
       // cell?.logo
        cell?.xiaoqupic.image=UIImage(named: "xz_fang_icon")
        var xiaoquname=(items[indexPath.row] as ItemXiaoqu).name.stringByAppendingString("(").stringByAppendingString((items[indexPath.row] as ItemXiaoqu).code).stringByAppendingString(")")

        cell?.name.text=xiaoquname
        var address:String="";
        address = address.stringByAppendingString((items[indexPath.row] as ItemXiaoqu).province)
        address = address.stringByAppendingString(",")
        if((items[indexPath.row] as ItemXiaoqu).province != (items[indexPath.row] as ItemXiaoqu).city)
        {
            address=address.stringByAppendingString((items[indexPath.row] as ItemXiaoqu).city)
            address = address.stringByAppendingString(",")
        }
        address=address.stringByAppendingString((items[indexPath.row] as ItemXiaoqu).district)
        address = address.stringByAppendingString(",")
        address=address.stringByAppendingString((items[indexPath.row] as ItemXiaoqu).street)
        
        cell?.address.text = address

        return cell!
    }
    
   var delegate:ChangeXiaoquDelegate?
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        NSLog("select \(indexPath.row)")
        NSLog("select \(items[indexPath.row])")
        
        let alertController = UIAlertController(
            
            title: "社区修改",
            
            message: "确认修改小区信息吗?",
            
            preferredStyle: UIAlertControllerStyle.Alert)
        // 3.
        let modifyAction = UIAlertAction(
            
        title: "确认", style: UIAlertActionStyle.Default) {
            
            (action) -> Void in
              var item:ItemXiaoqu = self.items[indexPath.row] as ItemXiaoqu
            var xiaoquname=item.name
            var xiaoqucode=item.code
            
            if((self.delegate) != nil){
                self.delegate?.ChangeXiaoqu(self, name: xiaoquname, code: xiaoqucode)
            }
            self.navigationController?.popViewControllerAnimated(true)

            
            
            
        }
        
        
        
        
        
        // 5.
        
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel,handler:nil))
        
        alertController.addAction(modifyAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
        
      
        
        
        
        
    }

}
