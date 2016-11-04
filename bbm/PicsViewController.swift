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
            let returnimg=UIImage(named: "xz_nav_return_icon")
            
            let item3=UIBarButtonItem(image: returnimg, style: UIBarButtonItemStyle.plain, target: self,  action: #selector(PicsViewController.backClick))
            
            item3.tintColor=UIColor.white
            
            self.navigationItem.leftBarButtonItem=item3
            
            self.preparePictures()
            
            var cellW:CGFloat = self.view.frame.size.width;
            if(pics.count>1)
            {
                cellW=(self.view.frame.size.width - 10) / 3
            }
            let layOut = UICollectionViewFlowLayout()
            layOut.itemSize = CGSize(width: cellW, height: cellW)
            layOut.minimumLineSpacing = 2
            layOut.minimumInteritemSpacing = 0
            layOut.scrollDirection = .vertical
            
            let collectionView = UICollectionView.init(frame: CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: self.view.frame.size.height), collectionViewLayout: layOut)
            collectionView.backgroundColor = UIColor.white
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.showsVerticalScrollIndicator = false
            collectionView.isPagingEnabled = true
            collectionView.bounces = true
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier:"cell")
            
            self.view.addSubview(collectionView)
        }
    
    func backClick()
    {
        NSLog("back");
        self.navigationController?.popViewController(animated: true)
        
    }

    
        func preparePictures() {
            let totalCount:NSInteger = self.pics.count;//轮播的图片数量；
            for index in 0..<totalCount{
                let imgurl:String = self.pics[index]
                let nsd = try? Data(contentsOf: URL(string: imgurl)!)
                let image:UIImage = UIImage(data: nsd!)!
                self.picturesArray.append(image)
                
                
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell:UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            cell.backgroundColor = UIColor.clear
            cell.backgroundView = UIImageView(image: self.picturesArray[indexPath.item] as UIImage)
            
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.picturesArray.count
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            let imageBroswer = LGImageBroswer.init()
            imageBroswer.picturesArray = self.picturesArray
            imageBroswer.currentPageIndex = indexPath.item
            self.navigationController?.pushViewController(imageBroswer, animated: true)
        }
}

