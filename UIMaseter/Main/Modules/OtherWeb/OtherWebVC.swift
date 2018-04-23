//
//  OtherWebVC.swift
//  UIDS
//
//  Created by one2much on 2018/1/25.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import WebKit

class OtherWebVC: NaviBarVC {

    var urlString:String?{//set url 做安全处理
        didSet{
            if (urlString?.hasPrefix("http"))! || (urlString?.hasPrefix("https"))! {
                
            }else {
                urlString = "https://\(urlString!)"
            }
        }
    }

    
    fileprivate var leftBarButton:NaviBarItem?
    fileprivate var leftBarButtonSecond:NaviBarItem?
    
    /*
     *加载WKWebView对象
     */
    lazy var wkWebview:WKWebView =
        {
            () -> WKWebView in
            var tempWebView = WKWebView.init(frame: CGRect.init(x: 0, y: self.naviBar()?.bottom ?? 64, width: kScreenW, height: kScreenH - (self.naviBar()?.bottom ?? 64)))
            tempWebView.uiDelegate = self
            tempWebView.navigationDelegate = self
            tempWebView.backgroundColor = UIColor.white
            tempWebView.autoresizingMask = UIViewAutoresizing.init(rawValue: 1|4)
            tempWebView.isMultipleTouchEnabled = true
            tempWebView.autoresizesSubviews = true
            tempWebView.scrollView.alwaysBounceVertical = true
            tempWebView.allowsBackForwardNavigationGestures = true
            return tempWebView
    }()
    /*
     *懒加载UIProgressView进度条对象
     */
    lazy var progress:UIProgressView =
        {
            () -> UIProgressView in
            var rect:CGRect = CGRect.init(x: 0, y: self.naviBar()?.bottom ?? 64, width: kScreenW, height: 2.0)
            let tempProgressView = UIProgressView.init(frame: rect)
            tempProgressView.tintColor = UIColor.red
            tempProgressView.backgroundColor = UIColor.gray
            return tempProgressView
    }()

    
    
    /*
     *移除观察者,类似OC中的dealloc
     *观察者的创建和移除一定要成对出现
     */
    deinit
    {
        self.wkWebview.removeObserver(self, forKeyPath: "estimatedProgress")
        self.wkWebview.removeObserver(self, forKeyPath: "canGoBack")
        self.wkWebview.removeObserver(self, forKeyPath: "title")
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.setupUI()
        self.loadRequest()
        self.addKVOObserver()
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.naviBar()?.setLeftBarItems(with: [])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension OtherWebVC: WKUIDelegate,WKNavigationDelegate {
    
    
    /*
     *创建BarButtonItem
     */
    
    func setupBarButtonItem()
    {
    
//        self.leftBarButton = NaviBarItem.init(imageItem: CGRect.init(x: 0, y: 0, width: 44, height: 44), target: self, action: #selector(OtherWebVC.selectedToBack))
//        self.leftBarButton?.setBackgroundImage(UIImage.init(named: "goBackIcon.png"), for: eNaviBarItemStateNormal)
//
//
//        self.leftBarButtonSecond = NaviBarItem.init(imageItem: CGRect.init(x: 0, y: 0, width: 25, height: 25), target: self, action: #selector(OtherWebVC.selectedToClose))
//        self.leftBarButtonSecond?.setBackgroundImage(UIImage.init(named: "close.png"), for: eNaviBarItemStateNormal)
//
//        let items = NSArray.init(objects: self.leftBarButton!)
//        self.naviBar().leftBarItems = items as! [Any]
    }
    
    /*
     *设置UI部分
     */
    func setupUI()
    {
        self.setupBarButtonItem()
        self.view.addSubview(self.wkWebview)
        self.view.addSubview(self.progress)
    }
    
    /*
     *加载网页 request
     */
    func loadRequest()
    {
        self.wkWebview.load(NSURLRequest.init(url: NSURL.init(string: self.urlString!)! as URL) as URLRequest)
    }
    
    /*
     *添加观察者
     *作用：监听 加载进度值estimatedProgress、是否可以返回上一网页canGoBack、页面title
     */
    func addKVOObserver()
    {
        self.wkWebview.addObserver(self, forKeyPath: "estimatedProgress", options: [NSKeyValueObservingOptions.new,NSKeyValueObservingOptions.old], context: nil)
        self.wkWebview.addObserver(self, forKeyPath: "canGoBack", options:[NSKeyValueObservingOptions.new,NSKeyValueObservingOptions.old], context: nil)
        self.wkWebview.addObserver(self, forKeyPath: "title", options: [NSKeyValueObservingOptions.new,NSKeyValueObservingOptions.old], context: nil)
    }
    
    
    /*
     *返回按钮执行事件
     */
    @objc func selectedToBack()
    {
        if (self.wkWebview.canGoBack == true)
        {
            self.wkWebview.goBack()
        }
        else
        {
            VCController.pop(with: VCAnimationClassic.defaultAnimation())
        }
    }
    
    /*
     *关闭按钮执行事件
     */
    @objc func selectedToClose()
    {
        VCController.pop(with: VCAnimationClassic.defaultAnimation())
    }
    
    
    /*
     *观察者的监听方法
     */
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        
        if keyPath == "estimatedProgress"
        {
            print(self.progress.progress)
            self.progress.alpha = 1.0
            self.progress .setProgress(Float(self.wkWebview.estimatedProgress), animated: true)
            if self.wkWebview.estimatedProgress >= 1
            {
                UIView.animate(withDuration: 1.0, animations: {
                    self.progress.alpha = 0
                }, completion: { (finished) in
                    self.progress .setProgress(0.0, animated: false)
                })
            }
        }
        else if keyPath == "title"
        {
            self.naviBar()?.setTitle(title: self.wkWebview.title!)
        }
        else if keyPath == "canGoBack"
        {
//            if self.wkWebview.canGoBack == true
//            {
//                let items = NSArray.init(objects: self.leftBarButton!,self.leftBarButtonSecond!)
//                self.naviBar().leftBarItems = items as! [Any]
//            }
//            else
//            {
//                let items = NSArray.init(objects: self.leftBarButton!)
//                self.naviBar().leftBarItems = items as! [Any]
//            }
        }
        else
        {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}
