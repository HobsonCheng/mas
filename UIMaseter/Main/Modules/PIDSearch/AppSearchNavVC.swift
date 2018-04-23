//
//  AppSearchNavVC.swift
//  UIDS
//
//  Created by bai on 2018/2/1.
//  Copyright © 2018年 one2much. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx
import Then
import RxGesture
import ReusableKit
import RxDataSources
import Differentiator
import SwiftyJSON
import DZNEmptyDataSet
import SnapKit
import IQKeyboardManagerSwift
import MJRefresh
// MARK:- cell复用
private enum Reusable {
    static let searchCell = ReusableCell<SearchVCell>(nibName: "SearchVCell")
}

// MARK:- 代理
protocol AppSearchVCDelectege {
    //搜索结束
    func SearchpidEnd(pidObj: Any?)
}


class AppSearchNavVC: NaviBarVC{
    //MARK: - 属性
    var delegate: AppSearchVCDelectege?
    fileprivate var dataSource : RxTableViewSectionedReloadDataSource<SectionModel<String, Project>>?
    fileprivate var viewModel: SearchResultViewModel?
    fileprivate var page: Int?
    fileprivate var searchKey: String?
    fileprivate var searchField: UITextField?
    fileprivate var tableview: UITableView?
    //MARK: - 视图生命周期
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.sharedManager().enable = false
        if let name = UIApplication.shared.alternateIconName {
            UIApplication.shared.setAlternateIconName(nil) { (err:Error?) in
                print("set icon error：\(String(describing: err))")
            }
            print("the alternate icon's name is \(name)")
        }
        //不需要直接进入APP
        Util.save_defult(key: kIsNeedGotoApp, value: "0")
        
        //移除群聊悬浮层
        let appWindow = UIApplication.shared.delegate?.window
        if let window = appWindow{
            for view in (window?.subviews)!{
                if view is BSuspensionView{
                    view.removeFromSuperview()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.vcName = "AppSearchNavVC_home"
        self.view.backgroundColor = UIColor.init(hex: 0xf1f0f6, alpha: 1)
        self.naviBar()?.setTitle(title: "欢迎登录您单位的APP")
        self.naviBar()?.backgroundColor = UIColor.init(hexString: "#229aee")
        
        self.page = 1
        //初始化UI
        self.genderUI()
        //绑定数据
        self.bindUI()
        //初始化刷新
        self.refreshUI()
        //展示历史
        self.showHistoy()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        IQKeyboardManager.sharedManager().enable = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
}
//MARK: - gender UI
extension AppSearchNavVC {
    fileprivate func genderUI() {
        //搜索容器View
        let searchView = UIView.init(frame: CGRect.init(x: 0, y: self.naviBar()?.bottom ?? 64, width: kScreenW, height: 60))
        searchView.backgroundColor = UIColor.init(hexString: "229aee")
        //顶部线
        let lineView = UIView()
        lineView.backgroundColor = UIColor.init(hexString: "37a4f1")
        searchView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(searchView.snp.top).offset(-1)
            make.width.equalTo(searchView.snp.width)
            make.height.equalTo(1)
        }
        //扫码按钮
        let scanButton = UIButton()
        scanButton.setImage(UIImage.init(named:"扫一扫"), for: .normal)
        scanButton.addTarget(self, action: #selector(gotoSyS), for: .touchUpInside)
        searchView.addSubview(scanButton)
        scanButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(searchView.snp.centerY)
            make.height.equalTo(30)
            make.width.equalTo(25)
            make.left.equalTo(14)
        }
        //输入框
        let searchField = SearchBarFiled()
        searchField.backgroundColor = UIColor.init(hexString: "3AACF0")
        searchField.layer.cornerRadius = 5
        searchField.tintColor = .white
        searchField.textColor = .white
        searchField.placeholderTextColor = UIColor.white
        searchField.layer.masksToBounds = true
        searchField.setClearButtonImage()
        searchView.addSubview(searchField)
        searchField.snp.makeConstraints { (make) in
            make.left.equalTo(scanButton.snp.right).offset(10)
            make.right.equalTo(-12)
            make.height.equalTo(29)
            make.centerY.equalTo(searchView.snp.centerY)
        }
        self.searchField = searchField
        //tableView
        let tableview = UITableView.init(frame: CGRect.init(x: 0, y: (searchView.bottom), width: kScreenW, height: kScreenH - (searchView.bottom)))
        tableview.backgroundColor = UIColor.clear
        tableview.separatorStyle = .none
        tableview.emptyDataSetSource = self
        tableview.emptyDataSetDelegate = self
        tableview.register(Reusable.searchCell)
        tableview.rx.setDelegate(self).disposed(by: rx.disposeBag)
        self.tableview = tableview
        
        self.view.addSubview(searchView)
        self.view.addSubview(tableview)
        
    }
    //扫码
    @objc func gotoSyS() {
        self.searchField?.endEditing(true)
        LBXPermissions.authorizeCameraWith { (granted) in
            
            if granted{
                //设置扫码区域参数
                var style = LBXScanViewStyle()
                style.centerUpOffset = 60;
                style.xScanRetangleOffset = 30;
                
                if UIScreen.main.bounds.size.height <= 480{
                    //3.5inch 显示的扫码缩小
                    style.centerUpOffset = 40;
                    style.xScanRetangleOffset = 20;
                }
                
                style.color_NotRecoginitonArea = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.4)
                
                style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.Inner;
                style.photoframeLineW = 2.0;
                style.photoframeAngleW = 16;
                style.photoframeAngleH = 16;
                
                style.isNeedShowRetangle = false;
                
                style.anmiationStyle = LBXScanViewAnimationStyle.NetGrid;
                style.animationImage = UIImage(named: "qrcode_scan_full_net.png")
                
                let scan = LBXScanViewController.init(name: "LBXScanViewController")
                scan.naviBar()?.setTitle(title: "扫一扫")
                scan.scanStyle = style
                VCController.push(scan, with: VCAnimationBottom.defaultAnimation())
            }else{
                var actionInfos = [AlertActionInfo]()
                let goto = AlertActionInfo.init(title: "同意前往", style: .default, actionClosure: { (action) in
                    LBXPermissions.jumpToSystemPrivacySetting()
                })
                let cancle = AlertActionInfo.init(title: "取消", style: .cancel, actionClosure: nil)
                actionInfos.append(goto)
                actionInfos.append(cancle)
                EasyAlert.showAlertVC(title: "前往设置中心？", message: "允许使用照相机才能扫码哦", style: .alert, actionInfos: actionInfos)
            }
        }
    }
    // 绑定数据
    func bindUI() {
        //绑定搜索历史
        if let safeSearchField = self.searchField{
            viewModel = SearchResultViewModel(searchBar: safeSearchField)
            viewModel?.searchUseable.do(onNext: { [weak self] (key) in
                if key.isEmpty {
                    
                    self?.showHistoy()
                    
                    return
                }
                
                if self?.searchKey == key {
                    return
                }
                self?.searchKey = key
                self?.getData(loadMode: false)
                
            }).drive(safeSearchField.rx.value).disposed(by: rx.disposeBag)
        }
        
        //绑定tableView数据源
        self.dataSource = RxTableViewSectionedReloadDataSource(configureCell: { (ds, tv, indexPath, item) -> UITableViewCell in
            let cell = tv.dequeue(Reusable.searchCell,for: indexPath)
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.width = (cell.superview?.width ?? kScreenW) - 20
            cell.layer.cornerRadius = 5
            cell.layer.masksToBounds = true
            cell.searchKey = self.searchKey
            cell.objData = item
            return cell
        })
        //搜索结果 绑定到 tableView数据源
        viewModel?.searchList.asObservable().bind(to: (self.tableview?.rx.items(dataSource: (self.dataSource)!))!).disposed(by: rx.disposeBag)
        
    }
}
//MARK: - 刷新植入
extension AppSearchNavVC {
    
    func refreshUI() {
        // 顶部刷新
        let header = MJRefreshNormalHeader { [weak self] in
            self?.refreshEvent()
        }
        header?.setTitle("下拉刷新", for: .idle)
        header?.setTitle("松开刷新", for: .pulling)
        header?.setTitle("正在刷新", for: .refreshing)
        header?.lastUpdatedTimeLabel.isHidden = true
        // 底部刷新
        let footer = MJRefreshAutoNormalFooter { [weak self] in
            self?.loadMore()
        }
        
        self.tableview?.mj_header = header
        self.tableview?.mj_footer = footer

    }
    
    func getData(loadMode: Bool) {
        if loadMode {
            self.page = (self.page ?? 0) + 1
        }else{
            self.page = 1
        }
        let params = NSMutableDictionary()
        params.setValue(self.page, forKey: "page")
        params.setValue(self.searchKey, forKey: "key")
        params.setValue("20", forKey: "page_context")
        
        viewModel?.getSearchEnd(loadMode: loadMode,params: params, callback: { [weak self] (noMove) in
            self?.tableview?.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
            
        
            self?.tableview?.mj_header.endRefreshing()
            self?.tableview?.mj_footer.endRefreshing()
            if noMove {
                self?.tableview?.mj_footer.resetNoMoreData()
            }
        })
    }
    
    func refreshEvent() {
        
        if self.searchKey == nil || self.searchKey?.count == 0 {
            
            self.tableview?.mj_header.endRefreshing()
            return
        }
        
        self.page = 1
        self.getData(loadMode: false)
        
    }
    private func loadMore() {
        
        if self.searchKey == nil || self.searchKey?.count == 0 {
            
            self.tableview?.mj_footer.endRefreshing()
            self.tableview?.mj_footer.endRefreshingWithNoMoreData()
            return
        }
        
        self.page = 1
        self.getData(loadMode: true)
    }
    
}

// MARK:- UITableViewDelegate
extension AppSearchNavVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 133
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        self.view.endEditing(true)
        
        let itemData = viewModel?.searchList.value[indexPath.section].items[indexPath.row]
        if let data = itemData{
            self.saveItem(parj: data)
            let assemble = AssembleVC(nibName: "AssembleVC", bundle: nil)
            assemble.pObj = itemData
            VCController.push(assemble, with: VCAnimationClassic.defaultAnimation())
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
    
}

//MARK: - 空数据展示
extension AppSearchNavVC: DZNEmptyDataSetSource,DZNEmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        var text = (YJType.quto.text ?? "？") + "暂未找到您的单位APP，请联系您单位的网管"
        
        if self.searchKey == nil || self.searchKey?.count == 0 {
            text = "搜索一个公司试一下"
        }
        
        let font = UIFont.init(name: "iconfont", size: 15)
        let textColor = UIColor.init(hex: 0x606262, alpha: 1)
        
        let attributes = NSMutableDictionary()
        attributes.setObject(textColor, forKey: NSAttributedStringKey.foregroundColor as NSCopying)
        attributes.setObject(font ?? UIFont.systemFont(ofSize: 15), forKey: NSAttributedStringKey.font as NSCopying)
        let str = NSMutableAttributedString.init(string: text, attributes: attributes as? [NSAttributedStringKey : Any])
        if !(self.searchKey == nil || self.searchKey?.count == 0) {
            attributes.setObject(UIColor.init(hexString: "#3AACF0"), forKey: NSAttributedStringKey.foregroundColor as NSCopying)
            str.setAttributes((attributes as! [NSAttributedStringKey : Any]), range: NSRange.init(location: 0, length: 1))
        }
       
        return str
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let text = ""
        
        let textColor = UIColor.black
        let attributes = NSMutableDictionary()
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = NSLineBreakMode.byWordWrapping
        paragraph.alignment = NSTextAlignment.center
        paragraph.lineSpacing = 2.0
        
        attributes.setObject(textColor, forKey: NSAttributedStringKey.foregroundColor as NSCopying)
        attributes.setObject(paragraph, forKey: NSAttributedStringKey.paragraphStyle as NSCopying)
        
        
        return NSMutableAttributedString.init(string: text, attributes: attributes as? [NSAttributedStringKey : Any])
        
    }
    
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.clear
    }
    
    func customView(forEmptyDataSet scrollView: UIScrollView!) -> UIView! {
        return nil
    }
    
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 0
    }
    
    func emptyDataSetShouldAllowTouch(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return false
    }
    
}
//MARK: - 历史数据  读存
extension AppSearchNavVC {
    
    func saveItem(parj: Project) {
        if parj.app_group_info.count == 0{
            return
        }
        ZZDiskCacheHelper.getObj(HistoryKey.HistoryKey_Phone) {[weak self] (obj) in
            
            if obj != nil {
                let tmpobj: String = obj as! String
                
                var getObj = ProjectList.deserialize(from: tmpobj) ?? ProjectList(data: [Project]())
                
                if getObj.data.count == 0 {
                    getObj.data.append(parj)
                    ZZDiskCacheHelper.saveObj(HistoryKey.HistoryKey_Phone, value: getObj.toJSONString())
                }else {
                    var count = 0
                    for item in getObj.data {
                        
                        if item.app_group_info[0].app_id == parj.app_group_info[0].app_id {
                            getObj.data.remove(at: count)
                            break
                        }
                        count = count + 1
                    }
                    getObj.data.insert(parj, at: 0)
                    
                    let section = [SectionModel(model: "", items: getObj.data!)]
                    
                    self?.viewModel?.searchList.value = section
                    
                    ZZDiskCacheHelper.saveObj(HistoryKey.HistoryKey_Phone, value: getObj.toJSONString())
                }
            }else {
                var getObj = ProjectList(data: [Project]())
                
                if getObj.data.count == 0 {
                    getObj.data.append(parj)
                    
                    let section = [SectionModel(model: "", items: getObj.data!)]
                    
                    self?.viewModel?.searchList.value = section
                    
                    ZZDiskCacheHelper.saveObj(HistoryKey.HistoryKey_Phone, value: getObj.toJSONString())
                }
            }
        }
    }
    func showHistoy() {
        
        ZZDiskCacheHelper.getObj(HistoryKey.HistoryKey_Phone) { [weak self] (obj) in
            
            if obj != nil {
                let tmpobj: String = obj as! String
                
                let getObj = ProjectList.deserialize(from: tmpobj) ?? ProjectList(data: [Project]())
                
                let section = [SectionModel(model: "", items: getObj.data!)]
                
                self?.viewModel?.searchList.value = section
            }
        }
    }
}
