//
//  SwiftIntroView.swift
//  UIDS
//
//  Created by one2much on 2018/2/6.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

// 代理
protocol SwiftIntroViewDelegate:AnyObject {
    func doneButtonClick()
}

class SwiftIntroView: UIView, UIScrollViewDelegate {
    
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    var doneButton: UIButton!
    
    var view1: UIImageView!
    var view2: UIImageView!
    var view3: UIImageView!
    var view4: UIImageView!
    var view5: UIImageView!
    
    var delegate: SwiftIntroViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //注意逻辑关系，有些视图依赖前一个视图而存在
        self.initScrollView()
        self.initPageViews()
        self.initPageControl()
        self.initDoneButton()
    }
    
    //初始化 scrollView
    func initScrollView() {
        scrollView = UIScrollView(frame: self.frame)
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        if Util.isAlone() {
            
            let appinfo = AppInfoData.shared.appModel
            scrollView.contentSize = CGSize(width: self.frame.size.width * (CGFloat((appinfo?.welcome_pic?.count)!)), height: scrollView.frame.size.height)
            
        }else{
            scrollView.contentSize = CGSize(width: self.frame.size.width * 3, height: scrollView.frame.size.height)
        }
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        scrollView.showsHorizontalScrollIndicator = false
        self.addSubview(scrollView)
    }
    
    //初始化页面视图 - 可根据需要自己增加控件
    func initPageViews() {
        let originW = self.frame.size.width
        
        if Util.isAlone() {
            
            let appinfo = AppInfoData.shared.appModel
            let countnum = (appinfo?.welcome_pic?.count)!
            if countnum >= 1 {
                view1 = UIImageView(frame: self.frame)
                view1.frame.origin.x = originW * 0
                
                view1.image = UIImage(named: "guiImage1.png")
                self.scrollView.addSubview(view1)
            }
            if countnum >= 2 {
                view2 = UIImageView(frame: self.frame)
                view2.frame.origin.x = originW * 1
                
                view2.image = UIImage(named: "guiImage2.png")
                self.scrollView.addSubview(view2)
            }
            
            if countnum >= 3 {
                view3 = UIImageView(frame: self.frame)
                view3.frame.origin.x = originW * 2
                
                view3.image = UIImage(named: "guiImage3.png")
                self.scrollView.addSubview(view3)
            }
            
            if countnum >= 4 {
                view4 = UIImageView(frame: self.frame)
                view4.frame.origin.x = originW * 3
                
                view4.image = UIImage(named: "guiImage4.png")
                self.scrollView.addSubview(view4)
            }
            
            if countnum >= 5 {
                view5 = UIImageView(frame: self.frame)
                view5.frame.origin.x = originW * 4
                
                view5.image = UIImage(named: "guiImage5.png")
                self.scrollView.addSubview(view5)
            }
            
        }else {
            view1 = UIImageView(frame: self.frame)
            view1.frame.origin.x = originW * 0
            
            view2 = UIImageView(frame: self.frame)
            view2.frame.origin.x = originW * 1
            
            view3 = UIImageView(frame: self.frame)
            view3.frame.origin.x = originW * 2
            
            
            view1.image = UIImage(named: "ios商店图1.jpg")
            view2.image = UIImage(named: "ios商店图2.jpg")
            view3.image = UIImage(named: "ios商店图3.jpg")
            
            self.scrollView.addSubview(view1)
            self.scrollView.addSubview(view2)
            self.scrollView.addSubview(view3)
        }
        
    }
    
    //初始化 pageControl
    func initPageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0, y: self.frame.size.height - 80, width: self.frame.size.width, height: 10))
        pageControl.currentPageIndicatorTintColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 0.8)
        pageControl.numberOfPages = 3
        self.addSubview(pageControl)
    }
    
    //初始化 DoneButton
    func initDoneButton() {
        doneButton = UIButton(frame: CGRect(x: 0, y: self.frame.size.height - 60, width: self.frame.size.width, height: 60))
        doneButton.setTitle("跳过", for: UIControlState.normal)
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        doneButton.backgroundColor = UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 0.5)
        //增加点击事件并交给代理去完成
        doneButton.rx.tap.do(onNext: {
            self.delegate?.doneButtonClick()
        }).asObservable().subscribe().disposed(by: rx.disposeBag)
        self.addSubview(doneButton)
    }
    
    //实现 UIScrollViewDelegate 方法

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = self.frame.width
        let pageFraction = self.scrollView.contentOffset.x / pageWidth
        self.pageControl.currentPage = Int(roundf(Float(pageFraction)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

