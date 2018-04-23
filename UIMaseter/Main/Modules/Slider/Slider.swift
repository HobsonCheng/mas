//
//  Slider.swift
//  UIDS
//
//  Created by one2much on 2018/1/11.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxGesture
import NSObject_Rx
import HandyJSON

class SliderContentMode: ConfigModel {
    
    class centerData: HandyJSON {
        
        var selectType: Int?
        var color: String?
        var title: String?
        
        required init() {}
    }
    
    var fontSize: Int?
    var center: centerData?
    var List: [PageInfo]?
    
}
class SliderLayoutMode: ConfigModel {
    
    class shapeObjData: HandyJSON {
        
        var row: String?
        var line: String?
        
        required init() {}
    }
    
    var shape: Bool?
    var nets: Bool?
    var netsColor: String?
    var border_radius: Int?
    var shapeObj: shapeObjData?
}

class Slider: BaseModuleView,UIScrollViewDelegate {

    var bgScroll: UIScrollView?
    var pageControl: UIPageControl?
    var allList: [Any]!
    var netList: [InitiatorData]!
    var viewRow: Int!
    var viewRank: Int!
    //获取数据信息
    fileprivate func getInitiatorByModel(){
        let params = NSMutableDictionary()
        params.setValue(self.pageData.page_key, forKey: "page")
        params.setValue(self.model_code, forKey: "code")
        
        ApiUtil.share.getInitiatorByModel(params: params) { [weak self] (status, data, msg) in
            self?.netList = InitiatorModel.deserialize(from: data)?.data ?? [InitiatorData]()
            self?.changeSlider()
        }
        
    }
    
    
    //MARK: 初始化页面信息
    public func genderInit(contentData: SliderContentMode,row: NSInteger,rank: NSInteger){
        
        self.allList = [Any]()
        
        self.viewRow = row
        self.viewRank = rank
        
        self.getInitiatorByModel()
        
        self.backgroundColor = UIColor.white
        
        //驻扎住view
        bgScroll = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: self.width, height: 100))
        bgScroll?.delegate = self
        bgScroll?.showsVerticalScrollIndicator = false
        bgScroll?.showsHorizontalScrollIndicator = false
        bgScroll?.isPagingEnabled = true
        self.addSubview(bgScroll!)
        
        pageControl = UIPageControl()
        pageControl?.frame = CGRect.init(x: 0, y: (bgScroll?.bottom)!, width: self.width, height: 20)
        pageControl?.currentPage = 0
        pageControl?.pageIndicatorTintColor = UIColor.yellow
        pageControl?.currentPageIndicatorTintColor = UIColor.red
        self.addSubview(pageControl!)
        
        if contentData.List == nil {
            return
        }
        self.allList = self.allList + contentData.List! as [Any]
        self.changeSlider()
    }
    
    
    fileprivate func changeSlider(){
        
        self.bgScroll?.removeAllSubviews()
        
        //MARK: - 数据挂在
        if (self.netList != nil) && self.netList.count > 0 {
            //插入数据
            for item in self.netList {
                if item.index_num > self.allList.count {
                    self.allList.append(item)
                }else {
                    self.allList.insert(item, at: item.index_num)
                }
            }
        }
        
        
        //分组数据
        let onePageNum = self.viewRow * self.viewRank - 1
        let tmpList = NSMutableArray()
        var sonList = NSMutableArray()
        for (index,item) in (self.allList.enumerated()) {//数组分组
            
            sonList.add(item)
            
            if index >= (onePageNum * (tmpList.count + 1)){
                tmpList.add(sonList)
                sonList = NSMutableArray()
                sonList.add(item)
            }else if((index + 1) == self.allList?.count){
                tmpList.add(sonList)
                sonList = NSMutableArray()
            }
        }
        
        
        //每列间距
        let rankMargin = 5
        //每个Item宽高
        let W = (Int(self.width) - (self.viewRank+1)*rankMargin)/self.viewRank;
        let H = W;
        //每行间距
        let rowMargin = 10;
        
        var allHeight = 100
        
        var isGetHeight = false
        
        for (index,item) in tmpList.enumerated() {
            
            for (count,sonitem) in (item as! NSArray).enumerated() {
                
                
                let startX = (Int(self.width)*index) + ((count)%self.viewRank) * (W + rankMargin) + 5
                let startY = (count/self.viewRank) * (H + rowMargin + 20)
                let top = 10
                
                
                let speedView = UIImageView.init()
                
                if let pagedata = sonitem as? PageInfo{
                    speedView.sd_setImage(with: URL.init(string: pagedata.icon!))
                }else if let inital = sonitem as? InitiatorData{
                    speedView.sd_setImage(with: URL.init(string: inital.icon!))
                }
                
                speedView.frame = CGRect.init(x: startX + 20, y: startY+top + 20, width: W  - 40, height: H - 40)
                speedView.backgroundColor = UIColor.clear
                bgScroll?.addSubview(speedView)
                
                let titleLabel = UILabel.init()
                if let pagedata = sonitem as? PageInfo{
                    titleLabel.text = String(describing: pagedata.name!)
                }else if let inital = sonitem as? InitiatorData{
                    titleLabel.text = String(describing: inital.name!)
                }
                titleLabel.frame = CGRect.init(x: startX, y: Int(speedView.bottom + 10), width: W, height: 20)
                titleLabel.font = UIFont.systemFont(ofSize: 14)
                titleLabel.textColor = UIColor.black
                titleLabel.textAlignment = NSTextAlignment.center
                bgScroll?.addSubview(titleLabel)
                
                
                let touchBt = UIButton().then{
                    $0.frame = CGRect.init(x: speedView.left, y: speedView.top, width: speedView.width, height: titleLabel.height+speedView.height + 10)
                    $0.backgroundColor = UIColor.clear
                    $0.addTarget(self, action: #selector(Slider.touchItem(bt:)), for: .touchUpInside)
                    $0.tag = count+(index*onePageNum)
                }
                
                bgScroll?.addSubview(touchBt)
                
                if !isGetHeight {
                    allHeight = Int(titleLabel.bottom)
                }
            }
            
            if !isGetHeight {
                isGetHeight = true
            }
            
        }
        
        bgScroll?.height = CGFloat(allHeight)
        bgScroll?.contentSize = CGSize.init(width: Int(self.width)*tmpList.count, height: 0)
        if tmpList.count == 1 {
            pageControl?.isHidden = true
            pageControl?.numberOfPages = tmpList.count;
            pageControl?.top = (bgScroll?.bottom)!
            self.height = (bgScroll?.bottom)! + CGFloat(10)
        }else {
            pageControl?.numberOfPages = tmpList.count;
            pageControl?.top = (bgScroll?.bottom)!
            self.height = (pageControl?.bottom)! + CGFloat(10)
        }
    }
    
    
    
    //MARK: 回调
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = (self.bgScroll?.contentOffset.x)!/self.width
        
        pageControl?.currentPage = Int(page)
    }
    
    //MARK: - 点击启动器
    @objc func touchItem(bt: UIButton) {
        
        let itemobj = self.allList[bt.tag]
        
        if let pagedata = itemobj as? PageInfo{
            OpenVC.share.goToPage(pageType: (pagedata.page_type)!, pageInfo: pagedata)
        }else if let inital = itemobj as? InitiatorData{
            
            if inital.apply_type == 1 {//手机外部app
                self.gotoOtherApp(inital: inital)
            }else if inital.apply_type == 2 {//内部
                OpenVC.share.goToPage(pageType: (inital.page_info.page_type)!, pageInfo: inital.page_info)
            }else if inital.apply_type == 3 {//外部
                
                let otherweb = OtherWebVC.init(name: "webview")
                otherweb.urlString = inital.url ?? "http://m.baidu.com"
                VCController.push(otherweb, with: VCAnimationClassic.defaultAnimation())
                
            }
            
        }
    }
}
extension Slider {
    
    fileprivate func gotoOtherApp(inital: InitiatorData){
        
        guard let scheme = inital.ios_schema else {
            Util.msg(msg: "无scheme，请联系管理员", type: .Error)
            return
        }
        if let url = URL.init(string: scheme){
            let result = UIApplication.shared.canOpenURL(url)
            if result {//ok
                
                UIApplication.shared.open(URL.init(string: scheme)!, options: [:], completionHandler: { (obj) in
                    
                })
            }else {
                Util.msg(msg: "暂未安装该app", type: .Info)
            }
        }
    }
    
}
