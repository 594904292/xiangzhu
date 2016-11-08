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
    
    @IBOutlet weak var faq: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title="设置"
        let returnimg=UIImage(named: "xz_nav_return_icon")
        
        let item3=UIBarButtonItem(image: returnimg, style: UIBarButtonItemStyle.plain, target: self,  action: #selector(SugguestAboutViewController.backClick))
        
        item3.tintColor=UIColor.white
        
        self.navigationItem.leftBarButtonItem=item3
        
        
        let searchimg=UIImage(named: "xz_nav_icon_search")
        
        let item4=UIBarButtonItem(image: searchimg, style: UIBarButtonItemStyle.plain, target: self,  action: #selector(SugguestAboutViewController.searchClick))
        
        item4.tintColor=UIColor.white
        
        self.navigationItem.rightBarButtonItem=item4
        
        AddRow1Click();
        AddRow2Click();
        AddfaqClick();

    }

    
    func AddRow1Click()
    {
        
        row1.isUserInteractionEnabled = true
        
        let singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SugguestAboutViewController.gorow1))
        row1 .addGestureRecognizer(singleTap)
        
    }
    
    func gorow1()
    {
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "settingviewcontroller") as!SettingViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    func AddRow2Click()
    {
        
        row2.isUserInteractionEnabled = true
        
        let singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SugguestAboutViewController.gorow2))
        row2 .addGestureRecognizer(singleTap)
        
    }
    
    func gorow2()
    {
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "aboutviewcontroller") as!AboutViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    func AddfaqClick()
    {        
        faq.isUserInteractionEnabled = true
        let singleTap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SugguestAboutViewController.gofaq))
        faq .addGestureRecognizer(singleTap)
        
    }
    
    func gofaq()
    {
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "faqviewcontroller") as!FaqViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
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
