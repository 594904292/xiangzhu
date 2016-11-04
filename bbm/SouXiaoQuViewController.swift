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
    func ChangeXiaoqu(_ controller:SouXiaoQuViewController,name:String,code:String)
}

class SouXiaoQuViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate{

    @IBOutlet weak var xiaoquname: UITextField!
    @IBOutlet weak var _tableview: UITableView!
    var items:[ItemXiaoqu]=[]

    @IBAction func touchdown(_ sender: UIControl) {
        xiaoquname.resignFirstResponder()
    }
    @IBAction func nameexit(_ sender: UITextField) {
        xiaoquname.resignFirstResponder()
    }
    
    @IBAction func autoSearch(_ sender: UITextField) {
        querydata(xiaoquname.text!)

    }
    @IBAction func searchclick(_ sender: UIButton) {
        querydata(xiaoquname.text!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title="选择小区"
        let returnimg=UIImage(named: "xz_nav_return_icon")
        
        let item3=UIBarButtonItem(image: returnimg, style: UIBarButtonItemStyle.plain, target: self,  action: #selector(SouXiaoQuViewController.backClick))
        
        item3.tintColor=UIColor.white
        
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
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
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func querydata(_ name:String)
    {
        let defaults = UserDefaults.standard;
        let userid = defaults.object(forKey: "userid") as! NSString;
        let aname:String = name.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        var url:String=""
        if aname.characters.count>0
        {
            url="http://api.bbxiaoqu.com/getcxhfdm_v1.php?name=" + aname;
        }else{
            let province = defaults.object(forKey: "province") as! NSString;
            let city = defaults.object(forKey: "city") as! NSString;
            let sublocality = defaults.object(forKey: "sublocality") as! NSString;
            
            let aprovince:String = province.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            let acity:String = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            let asublocality:String = sublocality.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            url=(((("http://api.bbxiaoqu.com/getcxhfdm_v1.php?province=" + aprovince) + "&city=") + acity) + "&district=") + asublocality
           
        }
        print("url: \(url)")
        self.items.removeAll()
        Alamofire.request(url)
            .responseJSON { response in
                if(response.result.isSuccess)
                {
                    if let jsonItem = response.result.value as? NSArray{
                        for tempdata in jsonItem{
                            print("data: \(tempdata)")
                            let data:NSDictionary = tempdata as! NSDictionary;
                            let id:String = data.object(forKey: "id") as! String;
                            let province:String = data.object(forKey: "province") as! String;
                            let city:String = data.object(forKey: "city") as! String;
                            let district:String = data.object(forKey: "district") as! String;
                            let street:String = data.object(forKey: "street") as! String;
                             let name:String = data.object(forKey: "name") as! String;
                            let code:String = data.object(forKey: "code") as! String;
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
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 0.0001;
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 0.0001;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        return self.items.count;
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath:IndexPath) -> CGFloat
    {
        //计算行高，返回，textview根据数据计算高度
        
        let fixedWidth:CGFloat = 270;
        let contextLab:UITextView=UITextView()
        var address:String="";
        address = address + (items[indexPath.row] as ItemXiaoqu).province
        address = address + ","
        if((items[indexPath.row] as ItemXiaoqu).province != (items[indexPath.row] as ItemXiaoqu).city)
        {
            address=address + (items[indexPath.row] as ItemXiaoqu).city
            address = address + ","
        }
        address=address + (items[indexPath.row] as ItemXiaoqu).district
        address = address + ","
        address=address + (items[indexPath.row] as ItemXiaoqu).street
        
       
        
            contextLab.text = address
            let newSize:CGSize = contextLab.sizeThatFits(CGSize(width: fixedWidth, height: 22));
            let height=(newSize.height)
            print("height---\(height)")
            return height+50
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId="xiaoqucell"
        var cell:HfDmTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellId) as! HfDmTableViewCell?
        if(cell == nil)
        {
            cell = HfDmTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellId)
        }
       
        //xz_fang_icon
       // cell?.logo
        cell?.xiaoqupic.image=UIImage(named: "xz_fang_icon")
        let xiaoquname=(((items[indexPath.row] as ItemXiaoqu).name + "(") + (items[indexPath.row] as ItemXiaoqu).code) + ")"

        cell?.name.text=xiaoquname
        var address:String="";
        address = address + (items[indexPath.row] as ItemXiaoqu).province
        address = address + ","
        if((items[indexPath.row] as ItemXiaoqu).province != (items[indexPath.row] as ItemXiaoqu).city)
        {
            address=address + (items[indexPath.row] as ItemXiaoqu).city
            address = address + ","
        }
        address=address + (items[indexPath.row] as ItemXiaoqu).district
        address = address + ","
        address=address + (items[indexPath.row] as ItemXiaoqu).street
        
        cell?.address.text = address

        return cell!
    }
    
   var delegate:ChangeXiaoquDelegate?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        NSLog("select \(indexPath.row)")
        NSLog("select \(items[indexPath.row])")
        
        let alertController = UIAlertController(
            
            title: "社区修改",
            
            message: "确认修改小区信息吗?",
            
            preferredStyle: UIAlertControllerStyle.alert)
        // 3.
        let modifyAction = UIAlertAction(
            
        title: "确认", style: UIAlertActionStyle.default) {
            
            (action) -> Void in
              let item:ItemXiaoqu = self.items[indexPath.row] as ItemXiaoqu
            let xiaoquname=item.name
            let xiaoqucode=item.code
            
            if((self.delegate) != nil){
                self.delegate?.ChangeXiaoqu(self, name: xiaoquname, code: xiaoqucode)
            }
            self.navigationController?.popViewController(animated: true)

            
            
            
        }
        
        
        
        
        
        // 5.
        
        alertController.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel,handler:nil))
        
        alertController.addAction(modifyAction)
        
        self.present(alertController, animated: true, completion: nil)
        
        
        
      
        
        
        
        
    }

}
