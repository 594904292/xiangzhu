//
//  LGImageBroswer.swift
//  LGImageBroswer
//
//  Created by ligang on 16/1/13.
//  Copyright © 2016年 L&G. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"


class LGOneImageBroswer: UICollectionViewController {
    
    
    var picturesArray = [UIImage]()
    let paddingY:CGFloat = 10
    var currentPageIndex = 0
    
    init(){
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height)
        layout.minimumLineSpacing = paddingY
        layout.scrollDirection = .horizontal
        super.init(collectionViewLayout: layout)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title="相册"
        let returnimg=UIImage(named: "xz_nav_return_icon")
        
        let item3=UIBarButtonItem(image: returnimg, style: UIBarButtonItemStyle.plain, target: self,  action: #selector(LGOneImageBroswer.backClick))
        
        item3.tintColor=UIColor.white
        
        self.navigationItem.leftBarButtonItem=item3

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width + paddingY, height: self.view.frame.height)
        self.collectionView?.bounces = true
        self.collectionView?.isPagingEnabled = true        // Do any additional setup after loading the view.
        self.collectionView!.contentSize = CGSize(width: self.collectionView!.frame.width * CGFloat(self.picturesArray.count) + 10, height: 0)
        let www = CGFloat(self.currentPageIndex)
        self.collectionView?.contentOffset = CGPoint(x: (self.collectionView?.frame.width)! * www, y: 0)
    }
    
    
    func backClick()
    {
        NSLog("back");
        self.navigationController?.popViewController(animated: true)
        
    }
    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.picturesArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
        cell.backgroundColor = UIColor.black
        cell.backgroundView = UIImageView(image: self.picturesArray[indexPath.item] as UIImage)
        cell.backgroundView?.contentMode = UIViewContentMode.scaleAspectFit
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sb = UIStoryboard(name:"Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "bigpicviewcontroller") as! BigPicViewController
        //创建导航控制器
        
        vc.showimage = self.picturesArray[indexPath.item] as UIImage;
        self.navigationController?.pushViewController(vc, animated: true)

    }
}
