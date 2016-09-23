//
//  LGImageBroswer.swift
//  LGImageBroswer
//
//  Created by ligang on 16/1/13.
//  Copyright © 2016年 L&G. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"


class LGImageBroswer: UICollectionViewController {
    
    
    var picturesArray = [UIImage]()
    let paddingY:CGFloat = 10
    var currentPageIndex = 0
    
    init(){
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width,UIScreen.mainScreen().bounds.height)
        layout.minimumLineSpacing = paddingY
        layout.scrollDirection = .Horizontal
        super.init(collectionViewLayout: layout)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title="相册"
        var returnimg=UIImage(named: "xz_nav_return_icon")
        
        let item3=UIBarButtonItem(image: returnimg, style: UIBarButtonItemStyle.Plain, target: self,  action: "backClick")
        
        item3.tintColor=UIColor.whiteColor()
        
        self.navigationItem.leftBarButtonItem=item3

        // Register cell classes
        self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.frame = CGRectMake(0, 0, self.view.frame.width + paddingY, self.view.frame.height)
        self.collectionView?.bounces = true
        self.collectionView?.pagingEnabled = true        // Do any additional setup after loading the view.
        self.collectionView!.contentSize = CGSizeMake(self.collectionView!.frame.width * CGFloat(self.picturesArray.count) + 10, 0)
        let www = CGFloat(self.currentPageIndex)
        self.collectionView?.contentOffset = CGPointMake((self.collectionView?.frame.width)! * www, 0)
    }
    
    
    func backClick()
    {
        NSLog("back");
        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.picturesArray.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
    
        // Configure the cell
        cell.backgroundColor = UIColor.blackColor()
        cell.backgroundView = UIImageView(image: self.picturesArray[indexPath.item] as UIImage)
        cell.backgroundView?.contentMode = UIViewContentMode.ScaleAspectFit
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewControllerWithIdentifier("bigpicviewcontroller") as! BigPicViewController
        //创建导航控制器
        
        vc.showimage = self.picturesArray[indexPath.item] as UIImage;
        self.navigationController?.pushViewController(vc, animated: true)

    }
}
