//
//  AboutViewController.swift
//  bbm
//
//  Created by songgc on 16/9/5.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var about: UILabel!
    @IBOutlet weak var downimg: UIImageView!
    var downurl:String="http://www.bbxiaoqu.com/wap/qr_android.png";
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title="关于"
        var returnimg=UIImage(named: "xz_nav_return_icon")
        
        let item3=UIBarButtonItem(image: returnimg, style: UIBarButtonItemStyle.Plain, target: self,  action: "backClick")
        
        item3.tintColor=UIColor.whiteColor()
        
        self.navigationItem.leftBarButtonItem=item3
        
        
        var searchimg=UIImage(named: "xz_nav_icon_search")
        
        let item4=UIBarButtonItem(image: searchimg, style: UIBarButtonItemStyle.Plain, target: self,  action: "searchClick")
        
        item4.tintColor=UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItem=item4
        
        let infoDictionary = NSBundle .mainBundle ().infoDictionary
        
        let appDisplayName: AnyObject? = infoDictionary![ "CFBundleDisplayName"]
        
        let majorVersion : String = infoDictionary! [ "CFBundleShortVersionString"] as! String
        
        let minorVersion : String = infoDictionary! [ "CFBundleVersion"] as! String
        
        about.text="襄助(".stringByAppendingString(majorVersion).stringByAppendingString(".").stringByAppendingString(minorVersion).stringByAppendingString(")是基于位置的是传播正能量的联网互助平台。让附近的人互相帮忙，我们希望把大众的力量组织起来，有一技之长的人可以通过“襄助”为附近的人提供帮助；普通大众可以通过“襄助” 快速寻求帮助。 “涓滴之水成海洋，颗颗爱心变希望”。")
        
        
        Util.loadpic(self.downimg, url: downurl)
        AddImgClick()


    }

    
    func AddImgClick()
    {
        
        downimg.userInteractionEnabled = true
        
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "goimg")
        downimg .addGestureRecognizer(singleTap)
        
    }
    
    func goimg()
    {
        var sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("bigpicviewcontroller") as!BigPicViewController
        
        let nsd = NSData(contentsOfURL:NSURL(string: downurl)!)
        let image:UIImage = UIImage(data: nsd!)!
        
        vc.showimage = image;
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    
//    let sb = UIStoryboard(name:"Main", bundle: nil)
//    let vc = sb.instantiateViewControllerWithIdentifier("bigpicviewcontroller") as! BigPicViewController
//    //创建导航控制器
//    
//    vc.showimage = self.picturesArray[indexPath.item] as UIImage;
//    self.navigationController?.pushViewController(vc, animated: true)
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
