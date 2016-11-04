//
//  PicViewController.swift
//  bbm
//
//  Created by ericsong on 16/1/4.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit
import Alamofire
class PicViewController: UIViewController,UIScrollViewDelegate,UINavigationControllerDelegate {
    var url:String = "";
    var pics:[String]=[]
    
    @IBOutlet weak var galleryPageControl: UIPageControl!
    @IBOutlet weak var galleryScrollView: UIScrollView!
    
    @IBOutlet weak var pic: UIImageView!
    
    var timer:Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title="图片"
        let returnimg=UIImage(named: "xz_nav_return_icon")
        
        let item3=UIBarButtonItem(image: returnimg, style: UIBarButtonItemStyle.plain, target: self,  action: #selector(PicViewController.backClick))
        
        item3.tintColor=UIColor.white
        
        self.navigationItem.leftBarButtonItem=item3

        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
            
            self.pictureGallery()
        //}
    }

    
    func pictureGallery(){   //实现图片滚动播放；
        //image width
        let imageW:CGFloat = self.galleryScrollView.frame.size.width;//获取ScrollView的宽作为图片的宽；
        let imageH:CGFloat = self.galleryScrollView.frame.size.height;//获取ScrollView的高作为图片的高；
        let imageY:CGFloat = 0;//图片的Y坐标就在ScrollView的顶端；
        let totalCount:NSInteger = self.pics.count;//轮播的图片数量；
        for index in 0..<totalCount{
            let imageView:UIImageView = UIImageView();
            let imageX:CGFloat = CGFloat(index) * imageW;
            imageView.frame = CGRect(x: imageX, y: imageY, width: imageW, height: imageH);//设置图片的大小，注意Image和ScrollView的关系，其实几张图片是按顺序从左向右依次放置在ScrollView中的，但是ScrollView在界面中显示的只是一张图片的大小，效果类似与画廊；
            
            //图片添加阴影
            imageView.layer.shadowOpacity = 0.8
            imageView.layer.shadowColor = UIColor.white.cgColor
            imageView.layer.shadowOffset = CGSize(width: 1, height: 1)
            imageView.tag=index;
            imageView.contentMode=UIViewContentMode.scaleAspectFit
            Util.loadpic(imageView, url: self.pics[index])
            
            imageView.isUserInteractionEnabled = true
            let tapGR = UITapGestureRecognizer(target: self, action: #selector(PicViewController.tapHandler(_:)))
            imageView.addGestureRecognizer(tapGR)

//
            self.galleryScrollView.showsHorizontalScrollIndicator = false;//不设置水平滚动条；
            self.galleryScrollView.addSubview(imageView);//把图片加入到ScrollView中去，实现轮播的效果；
        }         
        //需要非常注意的是：ScrollView控件一定要设置contentSize;包括长和宽；
        let contentW:CGFloat = imageW * CGFloat(totalCount);//这里的宽度就是所有的图片宽度之和；
        self.galleryScrollView.contentSize = CGSize(width: contentW, height: 0);
        self.galleryScrollView.isPagingEnabled = true;
        self.galleryScrollView.delegate = self;
        self.galleryPageControl.numberOfPages = totalCount;//下面的页码提示器；
        //self.addTimer()
        
    }
    func tapHandler(_ sender:UITapGestureRecognizer) {
        ///////todo....
        let labelView:UIView = sender.view!;
        let tapTag:NSInteger = labelView.tag;
        
        print(tapTag)
    }

    
    func nextImage(_ sender:AnyObject!){//图片轮播；
        var page:Int = self.galleryPageControl.currentPage;
        if(page == 4){   //循环；
            page = 0;
        }else{
            page += 1;
        }
        let x:CGFloat = CGFloat(page) * self.galleryScrollView.frame.size.width;
        self.galleryScrollView.contentOffset = CGPoint(x: x, y: 0);//注意：contentOffset就是设置ScrollView的偏移；
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //这里的代码是在ScrollView滚动后执行的操作，并不是执行ScrollView的代码；
        //这里只是为了设置下面的页码提示器；该操作是在图片滚动之后操作的；
        let scrollviewW:CGFloat = self.galleryScrollView.frame.size.width;
        let x:CGFloat = galleryScrollView.contentOffset.x;
        let page:Int = (Int)((x + scrollviewW / 2) / scrollviewW);
        self.galleryPageControl.currentPage = page;
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//    func addTimer(){   //图片轮播的定时器；
//        self.timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "nextImage:", userInfo: nil, repeats: true);
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func backClick()
    {
        NSLog("back");
        self.navigationController?.popViewController(animated: true)
        
    }
}
