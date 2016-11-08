//
//  BigPicViewController.swift
//  bbm
//
//  Created by songgc on 16/9/1.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit

class BigPicViewController: UIViewController,UIScrollViewDelegate{
    var showimage: UIImage!
    @IBOutlet weak var iv: UIImageView!
    @IBOutlet weak var myScrollView: UIScrollView!
    
    fileprivate var lastDistance:CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        myScrollView.delegate=self
        myScrollView.contentSize=showimage.size
        myScrollView.minimumZoomScale=0.5;
        myScrollView.maximumZoomScale=2;
        myScrollView.bounces=true
        self.navigationItem.title="放大/缩小"
        let returnimg=UIImage(named: "xz_nav_return_icon")
        
        let item3=UIBarButtonItem(image: returnimg, style: UIBarButtonItemStyle.plain, target: self,  action: #selector(BigPicViewController.backClick))
        
        item3.tintColor=UIColor.white
        
        self.navigationItem.leftBarButtonItem=item3

        
        iv.image=showimage;
        self.view.isMultipleTouchEnabled = true
        self.view.backgroundColor = UIColor.white
        

        
        iv.contentMode = UIViewContentMode.scaleAspectFit
        
        
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return iv
    }
    
    func backClick()
    {
        self.navigationController!.popViewController(animated: true)
        
    }

    
    //////手势处理函数
    func tapHandler(_ sender:UITapGestureRecognizer) {
        ///////todo....
        self.dismiss(animated: true) { () -> Void in
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        NSLog("touchesBegan")
//    }
//    
//    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        // 判断是否是两指触摸
//        if(touches.count == 2){
//            let touchesSet:NSSet = touches as NSSet;
//            let p1:CGPoint = touchesSet.allObjects[0].locationInView(self.view);
//            let p2:CGPoint = touchesSet.allObjects[1].locationInView(self.view);
//            
//            let xx = p1.x-p2.x
//            let yy = p1.y-p2.y
//            
//            // 勾股定理算出两指之间的距离
//            let currentDistance = sqrt(xx*xx+yy*yy)
//            
//            // 判断是否第一次触摸
//            if(self.lastDistance==0.0){
//                self.lastDistance = currentDistance
//            }else{
//                // 不是第一次触摸，则开始和上次的记录的距离进行判断
//                // 假定一个临界值为5，差距比上次小5，视为缩小
//                if(self.lastDistance-currentDistance > 5){
//                    NSLog("缩小")
//                    self.lastDistance = currentDistance
//                    // 重新设置UIImageView.transform,通过CGAffineTransformScale实现缩小，这里缩小为原来的0.9倍
//                    self.iv.transform = CGAffineTransformScale(self.iv.transform, 0.9, 0.9)
//                }else if(self.lastDistance-currentDistance < -5){
//                    //差距比上次大5，视为方法
//                    NSLog("放大")
//                    self.lastDistance = currentDistance
//                    // 重新设置UIImageView.transform,通过CGAffineTransformScale实现放大，这里放大为原来的1.1倍
//                    self.iv.transform = CGAffineTransformScale(self.iv.transform, 1.1, 1.1)
//                }
//            }
//        }
//    }
//    
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        NSLog("touchesEnded")
//    }
//
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
