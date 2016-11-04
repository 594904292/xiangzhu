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
        let returnimg=UIImage(named: "xz_nav_return_icon")
        
        let item3=UIBarButtonItem(image: returnimg, style: UIBarButtonItemStyle.plain, target: self,  action: #selector(AboutViewController.backClick))
        
        item3.tintColor=UIColor.white
        
        self.navigationItem.leftBarButtonItem=item3
        
        
        let searchimg=UIImage(named: "xz_nav_icon_search")
        
        let item4=UIBarButtonItem(image: searchimg, style: UIBarButtonItemStyle.plain, target: self,  action: #selector(AboutViewController.searchClick))
        
        item4.tintColor=UIColor.white
        
        self.navigationItem.rightBarButtonItem=item4
        
        let infoDictionary = Bundle.main.infoDictionary
        
        //let appDisplayName: AnyObject? = infoDictionary![ "CFBundleDisplayName"] as AnyObject?
        
        let majorVersion : String = infoDictionary! [ "CFBundleShortVersionString"] as! String
        
        let minorVersion : String = infoDictionary! [ "CFBundleVersion"] as! String
        
        about.text=((("襄助(" + majorVersion) + ".") + minorVersion) + ")是基于位置的是传播正能量的联网互助平台。让附近的人互相帮忙，我们希望把大众的力量组织起来，有一技之长的人可以通过“襄助”为附近的人提供帮助；普通大众可以通过“襄助” 快速寻求帮助。 “涓滴之水成海洋，颗颗爱心变希望”。"
        
        
        Util.loadpic(self.downimg, url: downurl)
        AddImgClick()


    }

    
    func AddImgClick()
    {
        
        downimg.isUserInteractionEnabled = true
        
        let singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AboutViewController.goimg))
        downimg .addGestureRecognizer(singleTap)
        
    }
    
    func goimg()
    {
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "bigpicviewcontroller") as!BigPicViewController
        
        let nsd = try? Data(contentsOf: URL(string: downurl)!)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
