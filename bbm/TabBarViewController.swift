//
//  TabBarViewController.swift
//  bbm
//
//  Created by songgc on 16/8/20.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
        
        var screenWidth: CGFloat?
        var screenHeight: CGFloat?
        
        let tabBarWidth: CGFloat = 64
        let tabBarHeight: CGFloat = 49
        let tabBarViewHeight: CGFloat = 60
        
        var tabButtons = [UIButton]()
    
    var imgSelArr = ["xz_fang_icon_sel","xz_huihua_icon_sel","xz_lei_icon_sel","xz_wo_icon_sel"]
    var imgArr = ["xz_fang_icon","xz_hua_icon","xz_lei_icon","xz_wo_icon"]
    
    

    
    
        override func viewDidLoad()
        {
            super.viewDidLoad()
            
            var screenFrame = UIScreen.mainScreen().bounds
            screenWidth = screenFrame.width
            screenHeight = screenFrame.height
            
            print(screenWidth)
            
            self.view.backgroundColor = UIColor.whiteColor()
            
            self.tabBar.hidden = true
            
            initControllers()
            
            customTabBar()
            
        }
        
        func customTabBar() -> Void
        {
            let tabBarOffsetX = screenWidth!/3
            let tabBarX = tabBarOffsetX/2 - tabBarWidth/2
            let tabBarY = tabBarViewHeight/2 - tabBarHeight/2
            var tabBarView = UIView(frame: CGRectMake(0, tabBarViewHeight+100, screenWidth!, tabBarViewHeight))
            tabBarView.backgroundColor = UIColor.blackColor()
            self.view.addSubview(tabBarView)
            
            for index in 0..<imgArr.count
            {
                var tabBar_X = (CGFloat)(index) * tabBarOffsetX
                var btn = UIButton(frame: CGRectMake((CGFloat)(tabBarX + tabBar_X), (CGFloat)(tabBarY), tabBarWidth, tabBarHeight))
                if(index == 0)
                {
                    btn.setBackgroundImage(UIImage(named: imgSelArr[index]), forState: UIControlState.Normal)
                }else{
                    btn.setBackgroundImage(UIImage(named: imgArr[index]), forState: UIControlState.Normal)
                }
                
                btn.tag = index + 100
                btn.addTarget(self, action: "tabAction:", forControlEvents: UIControlEvents.TouchUpInside)
                
                tabBarView.addSubview(btn)
                tabButtons.append(btn)
            }
            
        }
        
        func tabAction(obj: UIButton) -> Void
        {
            var indexSel = obj.tag - 100
            self.selectedIndex = indexSel
            for index in 0..<tabButtons.count
            {
                if(index == indexSel)
                {
                    tabButtons[indexSel].setBackgroundImage(UIImage(named: imgSelArr[indexSel]), forState: UIControlState.Normal)
                }else{
                    tabButtons[index].setBackgroundImage(UIImage(named: imgArr[index]), forState: UIControlState.Normal)
                }
            }
        }
        
        func initControllers() -> Void
        {
            let sb = UIStoryboard(name:"Main", bundle: nil)

            let firstTabView = FirstTabViewController()
            let secondTabView = SecondTabViewController()
            let thirdTabView = ThirdTabViewController()
            
            var viewArr = [firstTabView, secondTabView, thirdTabView]
            var viewCtlArr = [UIViewController]()
            for index in 0..<viewArr.count
            {
                if(index != 2)
                {
                    var navController = UINavigationController(rootViewController: viewArr[index])
                    viewCtlArr.append(navController)  
                }else{  
                    viewCtlArr.append(viewArr[index])  
                }  
            }  
            
            self.viewControllers = viewCtlArr  
        }  
        
        override func didReceiveMemoryWarning()  
        {  
            super.didReceiveMemoryWarning()  
        }  
        
}