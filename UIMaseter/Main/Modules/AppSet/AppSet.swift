//
//  AppSet.swift
//  UIDS
//
//  Created by one2much on 2018/1/24.
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
import JMessage
import WebKit

// MARK:- 复用
private enum Reusable {
    
    static let settingCell = ReusableCell<SettingCell>()
    static let mycell = ReusableCell<MyCell>(identifier: nil, nibName: "MyCell")
    static let myIconCell = ReusableCell<myIconCell>(identifier: nil, nibName: "myIconCell")
}

// MARK:- 常量
fileprivate struct MetricAppSet {
    
    static let cellHeight: CGFloat = 49.0
    static let sectionHeight: CGFloat = 10.0
    static let cellMyHeight: CGFloat = 70.0
}


class AppSet: NaviBarVC {
    
    var isUserInfo: Bool = false
    
    var pageData: PageInfo?
    
    // viewModel
    fileprivate var viewModel = SettingViewModel()
    fileprivate var vmOutput: SettingViewModel.SettingOutput?
    
    // View
    fileprivate var tableView: UITableView!
    
    // DataSuorce
    var dataSource : RxTableViewSectionedReloadDataSource<SettingSection>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if isUserInfo {
            self.naviBar()?.setTitle(title: "个人信息")
        }else {
            self.naviBar()?.setTitle(title: "设置中心")
        }
        
        self.initEnableMudule()
        self.initUI()
        self.bindUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


// MARK:- 初始化协议
extension AppSet {
    
    // MARK:- 协议组件
    fileprivate func initEnableMudule() {
        
        
    }
}

extension AppSet {
    
    // MARK:- 初始化视图
    fileprivate func initUI() {
        
        self.title = "设置"
        
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        view.addSubview(tableView)
        self.tableView = tableView
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.naviBar()?.bottom ?? 64)
            make.left.right.bottom.equalToSuperview()
        }
        
        // 设置代理
        tableView.rx.setDelegate(self).disposed(by: rx.disposeBag)
        
        // 注册cell
        tableView.register(Reusable.settingCell)
        tableView.register(Reusable.mycell)
        tableView.register(Reusable.myIconCell)
    }
    
    // MARK:- 绑定视图
    func bindUI() {
        
        dataSource = RxTableViewSectionedReloadDataSource(configureCell: { (ds, tv, indexPath, item) -> UITableViewCell in
            if indexPath.row == 0 {
                // 充当 SectionHeader 占位
                let placeCell = UITableViewCell()
                placeCell.backgroundColor = kThemeGainsboroColor
                return placeCell
            }
            if self.isUserInfo {
                if indexPath.section == 0 && indexPath.row == 1 {
                    let cell = tv.dequeue(Reusable.myIconCell, for:indexPath)
                    
                    return cell
                }
            }else {
                if UserUtil.isValid() {//植入用户信息入口
                    if indexPath.section == 0 {
                        let cell = tv.dequeue(Reusable.mycell, for:indexPath)
                        
                        return cell
                    }
                }
            }
            
            let cell = tv.dequeue(Reusable.settingCell, for: indexPath)
            
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            cell.model = item
            return cell
        })
        
        if isUserInfo {
            vmOutput = viewModel.transform(input: SettingViewModel.SettingInput(type: .mine))
            
        }else {
            vmOutput = viewModel.transform(input: SettingViewModel.SettingInput(type: .setting))
            
        }
        
        vmOutput?.sections.asDriver().drive(tableView.rx.items(dataSource: dataSource)).disposed(by: rx.disposeBag)
    }
}

// MARK:- UITableViewDelegate
extension AppSet: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // 充当 SectionHeader 数据模型
        if indexPath.row == 0 {
            return MetricAppSet.sectionHeight
        }
        if isUserInfo {
            if indexPath.section == 0 && indexPath.row == 1 {
                return MetricAppSet.cellMyHeight
            }
        }else {
            if UserUtil.isValid() {//植入用户信息入口
                if indexPath.section == 0 {
                    return MetricAppSet.cellMyHeight
                }
            }
        }
        
        return MetricAppSet.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if isUserInfo {
            
            if indexPath.section == 0 && indexPath.row == 1 {
                let changeicon = ChangeIconVC.init(name: "ChangeIconVC")
                VCController.push(changeicon, with: VCAnimationClassic.defaultAnimation())
            }else if indexPath.row == 2 {
                let alert = LSXAlertInputView.init(title: "设置名字", placeholderText: "请输入新的名字", withKeybordType: LSXKeyboardType.default) {(contents) in
                    //更新用户信息
                    let userinfo = UserUtil.share.appUserInfo
                    let params = NSMutableDictionary()
                    params.setValue(userinfo?.head_portrait, forKey: "head_portrait")
                    params.setValue(contents, forKey: "zh_name")
                    ApiUtil.share.updateInfo(params: params, fininsh: { (status, data, msg) in
                        UserUtil.share.saveUser(userInfo: data)
                        Util.msg(msg: "更改成功", type: .Successful)
                    })
                }
                alert.show()
            }
            
        }else {
            if UserUtil.isValid() {
                if indexPath.section == 0 {
                    let info = AppSet.init(name: "ChangeInfoVC")
                    info.isUserInfo = true
                    VCController.push(info, with: VCAnimationClassic.defaultAnimation())
                }
                if indexPath.section == 3 {
                    self.outApp()
                }
                
                //意见反馈
                if indexPath.section == 1 && indexPath.row == 2{
                    let feedvc = FeedbackVC(name: "FeedbackVC")
                    VCController.push(feedvc, with: VCAnimationClassic.defaultAnimation())
                }
                //消息通知
                if indexPath.section == 1 && indexPath.row == 1{
                    let messageVC = NotifyListVC(name: "NotifyListVC")
                    VCController.push(messageVC, with: VCAnimationClassic.defaultAnimation())
                }
                if indexPath.section == 2 && indexPath.row == 1{
                    
                    ApiUtil.share.getAppAbout(finish: { (status, data, msg) in
                        if status == B_ResponseStatus.success{
                            DispatchQueue.main.async {
                                let naviVC = NaviBarVC()
                                naviVC.naviBar()?.setTitle(title: "关于")
                                let webView = WKWebView.init()
                                naviVC.view.addSubview(webView)
                                webView.backgroundColor = kThemeLightGreyColor
                                webView.top = naviVC.naviBar()?.bottom ?? 64
                                webView.width = DeviceInfo.screenW
                                webView.height = DeviceInfo.screenH - (naviVC.naviBar()?.bottom ?? 64)
                                let content = CommonModel.deserialize(from: data)?.data ?? ""
                                webView.loadHTMLString(content, baseURL: nil)
                                
                                VCController.push(naviVC, with: VCAnimationClassic.defaultAnimation())
                            }
                        }
                    })
                }
            }else {
                if indexPath.section == 2 {
                    self.outApp()
                }
                
                //意见反馈
                if indexPath.section == 0 && indexPath.row == 2{
                    let feedvc = FeedbackVC(name: "FeedbackVC")
                    VCController.push(feedvc, with: VCAnimationClassic.defaultAnimation())
                }
                //消息通知
                if indexPath.section == 0 && indexPath.row == 1{
                    let messageVC = NotifyListVC(name: "NotifyListVC")
                    VCController.push(messageVC, with: VCAnimationClassic.defaultAnimation())
                }
            }
            
        }
    }
}

// MARK:- 控制器跳转
extension AppSet {
    
    // MARK:- 登录
    func jump2Login() {
        
        
    }
    //MARK: - 退出
    func outApp() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let alertController = UIAlertController.init(title: nil, message: "退出当前账号？", preferredStyle: .actionSheet)
            let selectFromAlbumAction = UIAlertAction(title: "确定", style: .default, handler: { [weak self] (touch) in
                UserUtil.share.removerUser()
                self?.vmOutput = self?.viewModel.transform(input: SettingViewModel.SettingInput(type: .setting))
                self?.tableView.reloadData()
                
                JMSGUser.logout({ (result, error) in
                    UserDefaults.standard.removeObject(forKey: kCurrentUserName)
                    UserDefaults.standard.removeObject(forKey: kCurrentUserPassword)
                })
                
                let _ = VCController.pop(with: VCAnimationClassic.defaultAnimation())
            })
            alertController.addAction(selectFromAlbumAction)
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
}
