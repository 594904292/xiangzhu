//
//  FirstTabViewController.swift
//  bbm
//
//  Created by songgc on 16/8/20.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit

class FirstTabViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "TabBarItem #1"
        
        self.view.backgroundColor = UIColor.purpleColor()
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
