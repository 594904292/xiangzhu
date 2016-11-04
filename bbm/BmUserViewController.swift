//
//  BmUserViewController.swift
//  bbm
//
//  Created by songgc on 16/3/30.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit
import Alamofire
class BmUserViewController: UIViewController,UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate {
    
    @IBOutlet weak var _tableview: UITableView!
    var items:[ItemBm]=[]
    var isbm:DarwinBoolean = false
    var guid:String = "";
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title="帮助我的人"
        // Do any additional setup after loading the view.
        initnavbar("帮助我的人")

        _tableview.delegate=self
        _tableview.dataSource=self
        _tableview.estimatedRowHeight = 150
        //setSeparatorInset:UIEdgeInsetsMake
        _tableview.rowHeight = UITableViewAutomaticDimension
        
       _tableview.separatorStyle = UITableViewCellSeparatorStyle.none
        querydata();
    }
    
    func initnavbar(_ titlestr:String)
    {
        self.navigationItem.title=titlestr
        let returnimg=UIImage(named: "xz_nav_return_icon")
        let item3=UIBarButtonItem(image: returnimg, style: UIBarButtonItemStyle.plain, target: self,  action: #selector(BmUserViewController.backClick))
        item3.tintColor=UIColor.white
        self.navigationItem.leftBarButtonItem=item3
        let searchimg=UIImage(named: "xz_nav_icon_search")
        let item4=UIBarButtonItem(image: searchimg, style: UIBarButtonItemStyle.plain, target: self,  action: #selector(BmUserViewController.searchClick))
        item4.tintColor=UIColor.white
        self.navigationItem.rightBarButtonItem=item4
    }
    
    func backClick()
    {
        NSLog("back");
        self.navigationController?.popViewController(animated: true)
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
     
    func querydata()
    {
            let url:String="http://api.bbxiaoqu.com/getbmuserlist_v1.php?guid=" + guid;
            print("url: \(url)")
        Alamofire.request( url,method:HTTPMethod.get, parameters: nil).responseJSON
            { response in
                if(response.result.isSuccess)
                {
                    if let jsonItem = response.result.value as? NSArray{
                        for adata in jsonItem{
                            print("data: \(adata)")
                            let data:NSDictionary = adata as! NSDictionary
                            let id:String = data.object(forKey: "id") as! String;
                            let userid:String = data.object(forKey: "userid") as! String;
                            let senduserid:String = data.object(forKey: "senduserid") as! String;
                            let username:String = data.object(forKey: "username") as! String;
                            let telphone:String = data.object(forKey: "telphone") as! String;
                            let headface:String = data.object(forKey: "headface") as! String;
                            let sex:String = data.object(forKey: "sex") as! String;
                            let guid:String = data.object(forKey: "guid") as! String;
                            let infoid:String = data.object(forKey: "infoid") as! String;
                            let type:String = data.object(forKey: "type") as! String;
                            let content:String = data.object(forKey: "content") as! String;
                            let contentid:String = data.object(forKey: "contentid") as! String;
                            let status:String = data.object(forKey: "status") as! String;
                            if(self.isbm==false)
                            {
                                if(status != "0")
                                {
                                    self.isbm=true
                                }
                            }
                            let  item_obj:ItemBm = ItemBm(id: id, userid: userid, senduserid: senduserid, username: username, telphone: telphone, headface: headface, sex: sex, guid: guid, infoid: infoid, typestr: type, content: content, contentid: contentid, status: status)
                            //let item_obj:ItemBm = ItemBm(id: id, userid: userid, username: username, telphone: telphone, headface: headface, status: status)
                            self.items.append(item_obj)
                        
                        }
                        self._tableview.reloadData()
                    
                    }
                }else
                {
                    self.successNotice("网络请求错误")
                    print("网络请求错误")
                }
            }
                
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath:IndexPath) -> CGFloat
    {
        //计算行高，返回，textview根据数据计算高度
            let fixedWidth:CGFloat = 176;
            let contextLab:UITextView=UITextView()
            contextLab.text=(items[indexPath.row] as ItemBm).content
            let newSize:CGSize = contextLab.sizeThatFits(CGSize(width: fixedWidth, height: 123));
            let height=(newSize.height)
            print("height---\(height)")
            return height+80
          }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
       return self.items.count;
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //var ppp:String = (items[indexPath.row] as itemMess).photo;
        let cellId="bmcell"
        var cell:BmuserUITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellId) as! BmuserUITableViewCell?
        if(cell == nil)
        {
            cell = BmuserUITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: cellId)
        }
        
        let avatar:String = (items[indexPath.row] as ItemBm).headface;
        
        let head = "http://api.bbxiaoqu.com/uploads/" + avatar
        Util.loadheadface((cell?.headface)!,url: head);
        cell?.headface.layer.cornerRadius = (cell?.headface.frame.width)! / 2
        cell?.headface.layer.masksToBounds = true
        cell?.username.text=(items[indexPath.row] as ItemBm).username
        
        let abm:ItemBm=items[indexPath.row] as ItemBm;
        let string:String = abm.username
        
        let options:NSStringDrawingOptions = .usesLineFragmentOrigin
        let boundingRect = string.boundingRect(with: CGSize(width: 200, height: 0), options: options, attributes:[NSFontAttributeName:UIFont(name: "Heiti SC", size: 18.0)!], context: nil)

        
        let sex:String=(items[indexPath.row] as ItemBm).sex
        if sex=="0"
        {
            cell?.sex.image=UIImage(named: "xz_nan_icon");
        }else
        {
            cell?.sex.image=UIImage(named: "xz_nv_icon");
        }
        //let posx=(cell?.username.frame.origin.x)!+boundingRect.width+10
        //cell?.sex.frame=CGRect(x: posx, y: 12, width: 15, height: 15)
        
        //let typestr:String=(items[indexPath.row] as ItemBm).type
        let typestr:String=abm.typestr
        cell?.type.layer.masksToBounds = true;
        cell?.type.layer.cornerRadius = 5
        if typestr=="pl"
        {
            cell?.type.text="来自私聊"
        }else
        {
           cell?.type.isHidden=true
        }
        
        cell?.content.text=(items[indexPath.row] as ItemBm).content
        cell?.content.backgroundColor=UIColor(colorLiteralRed: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
        cell?.content.layer.masksToBounds = true;
        cell?.content.layer.cornerRadius = 3

       // cell?.content.textColor=UIColor(colorLiteralRed: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
        

        if(self.isbm).boolValue
        {
             //cell?.zanbtn.titleLabel?.textColor=UIColor(colorLiteralRed: 183/255.0, green: 80/255.0, blue: 76/255.0, alpha: 1)
            cell?.zanbtn.isEnabled=false;
            if((items[indexPath.row] as ItemBm).status=="0")
            {
                cell?.zanbtn.isHidden=true;
            }else if((items[indexPath.row] as ItemBm).status=="1")
            {
                 cell?.zanbtn.isHidden=false;
                cell?.zanbtn.setTitle("已采纳", for: UIControlState())
                
            }
        }else
        {
           // cell?.zanbtn.titleLabel?.textColor=UIColor(colorLiteralRed: 183/255.0, green: 80/255.0, blue: 76/255.0, alpha: 1)

            cell?.zanbtn.tag = indexPath.row
            

                    
            cell?.zanbtn.addTarget(self,action:#selector(BmUserViewController.tapped(_:)),for:.touchUpInside)
        }
        
        //cell?.zanbtn.titlePositionAdjustment=UIOffset(horizontal: 0,vertical: -6)
       
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        NSLog("select \(indexPath.row)")
        //NSLog("select \(items[indexPath.row])")
        
        
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "userinfoviewcontroller") as! UserInfoViewController
        //创建导航控制器
        vc.userid=(items[indexPath.row] as ItemBm).userid
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    var selpos:Int=0;
    func tapped(_ button:UIButton){
            //print(button.titleForState(.Normal))
        selpos = button.tag
        //self.setupSendPanel1()
        
        
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "appraiseviewcontroller") as! AppraiseViewController
        //创建导航控制器
        vc.id=(items[selpos] as ItemBm).id
        vc.guid=(items[selpos] as ItemBm).guid
        vc.infoid=(items[selpos] as ItemBm).infoid
        vc.username=(items[selpos] as ItemBm).username
        vc.headface=(items[selpos] as ItemBm).headface
        vc.senduserid=(items[selpos] as ItemBm).senduserid
        vc.type=(items[selpos] as ItemBm).typestr
        vc.content=(items[selpos] as ItemBm).content
        vc.contentid=(items[selpos] as ItemBm).contentid
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
            
    

    var sendView:UIView!;
    var txtMsg:UITextField!;
    var rate:RatingBar!;
    func setupSendPanel1()
    {
                self.sendView = UIView(frame:CGRect(x: 0,y: self.view.frame.size.height-102,width: self.view.frame.size.width,height: 102))
                self.sendView.backgroundColor=UIColor(colorLiteralRed: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
                self.sendView.alpha=0.9
                self.sendView.layer.borderWidth=1
                self.sendView.layer.borderColor = UIColor.gray.cgColor
    
                rate = RatingBar(frame:CGRect(x: 7,y: 10,width: self.view.frame.size.width/2,height: 36))
                rate.rating=CGFloat(4.00)
                self.sendView.addSubview(rate)
    
                txtMsg = UITextField(frame:CGRect(x: 7,y: 56,width: self.view.frame.size.width-84,height: 36))
                txtMsg.backgroundColor = UIColor.white
                txtMsg.textColor=UIColor.black
                txtMsg.font=UIFont.boldSystemFont(ofSize: 12)
                txtMsg.layer.cornerRadius = 10.0
                txtMsg.placeholder = "输入消息内容"
                self.sendView.addSubview(txtMsg)
    
    
                let sendButton = UIButton(frame:CGRect(x: self.view.frame.size.width-66,y: 56,width: 66,height: 36))
                sendButton.backgroundColor=UIColor.lightGray
                sendButton.layer.cornerRadius=6.0
                sendButton.addTarget(self, action:#selector(BmUserViewController.send) ,for:UIControlEvents.touchUpInside)
                 sendButton.setTitle("发送", for:UIControlState())
        
                self.sendView.addSubview(sendButton)
    
                self.view.addSubview(sendView)
    
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(BmUserViewController.handleTouches(_:)))
                tapGestureRecognizer.cancelsTouchesInView = false
                self.view.addGestureRecognizer(tapGestureRecognizer)
                

                
                NotificationCenter.default.addObserver(self, selector:#selector(BmUserViewController.keyBoardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
                NotificationCenter.default.addObserver(self, selector:#selector(BmUserViewController.keyBoardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    
    }
    func close()
    {
                    if(sendView != nil)
                {
                     sendView.isHidden=true
                    }
    }
    
    func send()
    {
    //
        if(txtMsg.text?.characters.count==0)
        {
            self.successNotice("评价不能为空")
            return;
        }
        var sqlitehelpInstance1=sqlitehelp.shareInstance()
        
        let defaults = UserDefaults.standard;
        let userid = defaults.object(forKey: "userid") as! String;
        
        var  dic:Dictionary<String,String> =  ["_guid": guid]
        
        dic["_fromuser"] = userid
        dic["_userid"] = (items[selpos] as ItemBm).userid
        dic["_status"] = "2"
        dic["_rating"] = String(describing: rate.rating)
        dic["_content"] = txtMsg.text
       
        Alamofire.request("http://api.bbxiaoqu.com/genfinshorder.php", method:.post,parameters: dic)
            .response { data in
                let tn:NSString = NSString(data: data.data!, encoding: String.Encoding.utf8.rawValue)!
                print(tn)
                DispatchQueue.main.async(execute: { () -> Void in
                    self.successNotice("评论成功")
                    
                    if(self.sendView != nil)
                    {
                        self.sendView.isHidden=true
                    }
                    
                });
        }
        
        

    }
    
    func sendMessage()
    {
    }
   
    func textFieldShouldReturn(_ textField:UITextField) -> Bool
    {
                    
        return true
    }

    func keyBoardWillShow(_ note:Notification)
    {
        let userInfo  = note.userInfo as! NSDictionary
        let  keyBoardBounds = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        var keyBoardBoundsRect = self.view.convert(keyBoardBounds, to:nil)
        var keyBaoardViewFrame = sendView.frame
        let deltaY = keyBoardBounds.size.height
        let animations:(() -> Void) = {
                        self.sendView.transform = CGAffineTransform(translationX: 0,y: -deltaY)
        }
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            animations()
        }
    }
    
    func keyBoardWillHide(_ note:Notification)
    {
        let userInfo  = note.userInfo as! NSDictionary
         let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        let animations:(() -> Void) = {
            self.sendView.transform = CGAffineTransform.identity
         }
         if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
         }else{
            animations()
        }
     }
    
    func handleTouches(_ sender:UITapGestureRecognizer){
        if sender.location(in: self.view).y < self.view.bounds.height - 250{
                            txtMsg.resignFirstResponder()
                            //close()
        }
    }

}
