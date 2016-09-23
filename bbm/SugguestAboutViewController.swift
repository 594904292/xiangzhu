//
//  SugguestAboutViewController.swift
//  bbm
//
//  Created by songgc on 16/9/5.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit

class SugguestAboutViewController: UIViewController {

    @IBOutlet weak var row1: UIView!
    
    @IBOutlet weak var row2: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title="设置"
        var returnimg=UIImage(named: "xz_nav_return_icon")
        
        let item3=UIBarButtonItem(image: returnimg, style: UIBarButtonItemStyle.Plain, target: self,  action: "backClick")
        
        item3.tintColor=UIColor.whiteColor()
        
        self.navigationItem.leftBarButtonItem=item3
        
        
        var searchimg=UIImage(named: "xz_nav_icon_search")
        
        let item4=UIBarButtonItem(image: searchimg, style: UIBarButtonItemStyle.Plain, target: self,  action: "searchClick")
        
        item4.tintColor=UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItem=item4
        
        AddRow1Click();
        AddRow2Click();

    }

    
    func AddRow1Click()
    {
        
        row1.userInteractionEnabled = true
        
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "gorow1")
        row1 .addGestureRecognizer(singleTap)
        
    }
    
    func gorow1()
    {
        var sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("settingviewcontroller") as!SettingViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    func AddRow2Click()
    {
        
        row2.userInteractionEnabled = true
        
        var singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "gorow2")
        row2 .addGestureRecognizer(singleTap)
        
    }
    
    func gorow2()
    {
        var sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("aboutviewcontroller") as!AboutViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
