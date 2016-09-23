//
//  PicsViewController.swift
//  bbm
//
//  Created by songgc on 16/9/1.
//  Copyright © 2016年 sprin. All rights reserved.
//

import UIKit

import Alamofire
class PicsViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
        var url:String = "";
        var pics:[String]=[]

        var picturesArray = [UIImage]()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
            self.navigationItem.title="全部图片"
            var returnimg=UIImage(named: "xz_nav_return_icon")
            
            let item3=UIBarButtonItem(image: returnimg, style: UIBarButtonItemStyle.Plain, target: self,  action: "backClick")
            
            item3.tintColor=UIColor.whiteColor()
            
            self.navigationItem.leftBarButtonItem=item3
            
            self.preparePictures()
            
            var cellW:CGFloat = self.view.frame.size.width;
            if(pics.count>1)
            {
                cellW=(self.view.frame.size.width - 10) / 3
            }
            let layOut = UICollectionViewFlowLayout()
            layOut.itemSize = CGSizeMake(cellW, cellW)
            layOut.minimumLineSpacing = 2
            layOut.minimumInteritemSpacing = 0
            layOut.scrollDirection = .Vertical
            
            let collectionView = UICollectionView.init(frame: CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height), collectionViewLayout: layOut)
            collectionView.backgroundColor = UIColor.whiteColor()
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.showsVerticalScrollIndicator = false
            collectionView.pagingEnabled = true
            collectionView.bounces = true
            collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier:"cell")
            
            self.view.addSubview(collectionView)
        }
    
    func backClick()
    {
        NSLog("back");
        self.navigationController?.popViewControllerAnimated(true)
        
    }

    
        func preparePictures() {
            var totalCount:NSInteger = self.pics.count;//轮播的图片数量；
            for index in 0..<totalCount{
                var imgurl:String = self.pics[index]
                let nsd = NSData(contentsOfURL:NSURL(string: imgurl)!)
                let image:UIImage = UIImage(data: nsd!)!
                self.picturesArray.append(image)
                
                
            }
        }
        
        func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            let cell:UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
            cell.backgroundColor = UIColor.clearColor()
            cell.backgroundView = UIImageView(image: self.picturesArray[indexPath.item] as UIImage)
            
            return cell
        }
        
        func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.picturesArray.count
        }
        
        func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
            
            let imageBroswer = LGImageBroswer.init()
            imageBroswer.picturesArray = self.picturesArray
            imageBroswer.currentPageIndex = indexPath.item
            self.navigationController?.pushViewController(imageBroswer, animated: true)
        }
}

