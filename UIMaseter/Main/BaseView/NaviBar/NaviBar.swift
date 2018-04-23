//
//  NaviBar.swift
//  UIMaseter
//
//  Created by one2much on 2018/4/16.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import Then

/// 导航栏样式
struct NaviBarStyle {
    let globalModel = GlobalConfigTool.shared
    weak var delegate: NaviBar?
    ///字体大小
    var fontSize:CGFloat{
        set{
            font = UIFont.init(name: globalModel.global?.styles?.fontFamily ?? "", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        }
        get{
            return CGFloat(globalModel.global?.styles?.fontSize ?? 14)
        }
    }
    ///字体
    var font: UIFont{
        get{
            if let fo = UIFont.init(name: globalModel.global?.styles?.fontFamily ?? "", size: fontSize){
                return fo
            }
            return UIFont.systemFont(ofSize: fontSize)
        }
        set{
            self.delegate?.titleLabel?.font = font
        }
        
    }
    ///导航栏标题
    var title: String{
        get{
            return globalModel.naviBar?.fields?.title ?? "标题"
        }
        set{
            self.delegate?.setTitle(title: title)
        }
    }
    ///导航栏背景色
    var bgColor: UIColor{
        get{
            return globalModel.naviBar?.styles?.bgColor?.toColor() ?? UIColor.init(hex: 0x094f3, alpha: 1)
        }
        set{
            self.delegate?.backgroundColor = bgColor
        }
    }
    ///标题颜色
    var titleColor: UIColor{
        get{
            return globalModel.naviBar?.styles?.titleColor?.toColor() ?? UIColor.white
        }
        set{
            self.delegate?.titleColor = titleColor
        }
    }
    ///背景图
    var bgImg: String?{
        get{
            return globalModel.naviBar?.styles?.bgImg
        }
        set{
            self.delegate?.bgImg = UIImage.init(named: bgImg ?? "")
        }
    }
    let pressTitleColor = UIColor.init(hex: 0x77ffff, alpha: 0.5)
    let disableTitleColor = UIColor.init(hex: 0x77ffff, alpha: 0.5)
    //高度间距
    let navibarHeight = 44
    let titleArrowWidth = 20
    let titleArrowHeight = 16
    let itemMargin = 5
}

// MARK: -

class NaviBar: UIControl {
    /// 样式
    var navibarStyle: NaviBarStyle
    /// 背景view
    var viewBg: UIView?
    private var bgImgView: UIImageView?
    var bgImg: UIImage?{
        didSet{
            bgImgView?.image = bgImg
        }
    }
    /// 是否可点击
    var isClickEnable: Bool = false{
        didSet{
            self.reLayout()
        }
    }

    /// 设置获取标题
    private var title: String?
    /// 获取和设置标题View
    var titleView: UIView?{
        set{
            viewTitle?.removeFromSuperview()
            if let tv = titleView{
                viewTitle = tv
                self.addSubview(tv)
            }
            self.reLayout()
        }
        get{
            return viewTitle
        }
    }
    /// 设置获取标题颜色
    var titleColor: UIColor?{
        set{
            if let safeLabel = self.titleLabel{
                safeLabel.textColor = newValue
            }
            self.reLayout()
        }
        get{
            if titleLabel == nil {
                return nil
            }else{
                return titleLabel?.textColor
            }
        }
    }
    /// 设置获取 导航栏背景色
    var naviBarBgColor: UIColor{
        set{
            viewBg?.backgroundColor = naviBarBgColor
        }
        get{
            return viewBg?.backgroundColor ?? .white
        }
    }
    
    
    /// 是否隐藏左边视图
    var isHiddenLeftView: Bool = false{
        didSet{
            if leftBarItems.count > 0{
                for item in leftBarItems{
                    item.isHidden = isHiddenLeftView
                }
                self.reLayout()
            }
        }
    }
    /// 是否隐藏标题
    var isHiddenTitleView: Bool = false{
        didSet{
            if viewTitle != nil{
                viewTitle?.isHidden = isHiddenTitleView
                self.reLayout()
            }
        }
    }
    /// 是否隐藏右边视图
    var isHiddenRightView: Bool = false{
        didSet{
            if rightBarItems.count > 0{
                for item in rightBarItems{
                    item.isHidden = isHiddenLeftView
                }
                self.reLayout()
            }
        }
    }
    
    //私有属性
    fileprivate var viewTitle: UIView?
    fileprivate var titleLabel: UILabel?
    fileprivate var titleArrow: UIImageView?
    fileprivate var rightBarItems: [NaviBarItem] = []
    /// 左边item按钮
    fileprivate var leftBarItems: [NaviBarItem] = []
    //MARK: - Init
    override init(frame: CGRect) {
        //初始化样式表
        navibarStyle = NaviBarStyle()
        super.init(frame: frame)
        navibarStyle.delegate = self
        genderUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - gender UI
extension NaviBar{
    /// 初始化UI
    func genderUI() {
        //初始化背景
        self.viewBg = UIView.init(frame: CGRect.init(x: 0, y: 0, width: Int(kScreenW), height: navibarStyle.navibarHeight))
        //背景图
        let imageView = UIImageView()
        imageView.frame = CGRect.init(x: 0, y: 0, width: Int(kScreenW), height: navibarStyle.navibarHeight + 20)
        self.bgImgView = imageView
        viewBg?.addSubview(imageView)
        self.viewBg?.backgroundColor = navibarStyle.bgColor
        if let imgUrl = navibarStyle.bgImg{
            imageView.sd_setImage(with: URL.init(string: imgUrl), completed: nil)
            viewBg?.addSubview(imageView)
        }
        self.addSubview(self.viewBg!)
        //初始化title
        self.viewTitle = LightControl().then({
            $0.isUserInteractionEnabled = false
        })
        self.titleLabel = UILabel().then {
            $0.backgroundColor = .clear
            $0.font = UIFont.systemFont(ofSize: CGFloat(navibarStyle.fontSize))
            $0.textColor = navibarStyle.titleColor
            $0.lineBreakMode = .byTruncatingTail
            $0.textAlignment = .center
            $0.adjustsFontSizeToFitWidth = true
            $0.text = navibarStyle.title
            $0.font = navibarStyle.font
            $0.numberOfLines = 1
            $0.lineBreakMode = .byTruncatingTail

        }
        viewTitle?.addSubview(titleLabel!)
        //设置title下拉箭头
        self.titleArrow = UIImageView().then {
            $0.setViewSize(CGSize.init(width: navibarStyle.titleArrowWidth, height: navibarStyle.titleArrowHeight))
            $0.setYJIconWithName(icon: .downArrow, textColor: navibarStyle.titleColor)

            $0.isHidden = !self.isClickEnable
        }
        viewTitle?.addSubview(titleArrow!)
        if let vt = viewTitle as? LightControl{
            vt.addTarget(self, action: #selector(titleTouchDown), for: .touchDown)
            vt.addTarget(self, action: #selector(titleTouchupInside), for: .touchUpInside)
            vt.addTarget(self, action: #selector(titleTouchupOutside), for: .touchUpOutside)
        }
        self.addSubview(viewTitle!)
    }
}

//MARK: - layout & config
extension NaviBar{
    /// 重新布局
    func reLayout() {
        let superFrame = self.frame
        //水平起止坐标
        var startX:CGFloat = 0.0
        var endX = superFrame.size.width
        //纵向起止坐标
        var startY:CGFloat = 0.0
        let endY = superFrame.size.height
        
        startY += superFrame.size.height - CGFloat(navibarStyle.navibarHeight)
        //重设view frame
        if let bg = viewBg{
            bg.frame = superFrame
        }
        //重设left item frame
        if leftBarItems.count > 0 && !isHiddenLeftView{
            for item in leftBarItems{
                let size = item.frame.size
                item.setViewOrigin(CGPoint.init(x: startX, y: startY + (endY - startY - size.height)/2))
                startX += size.width
            }
        }
        //重设right item frame
        if rightBarItems.count > 0 && !isHiddenRightView{
            for item in rightBarItems{
                let size = item.frame.size
                item.setViewOrigin(CGPoint.init(x: endX - size.width, y: startY + (endY - startY - size.height)/2))
                endX -= item.frame.size.width
            }
        }
        //重设titleView frame
        if viewTitle != nil && !isHiddenTitleView{
            startX += CGFloat(navibarStyle.itemMargin)
            endX -= CGFloat(navibarStyle.itemMargin)
            //取距离中心较短的为宽度的一半
            let mid = superFrame.size.width / 2
            let halfWidth = mid - startX > endX - mid ? endX - mid : mid - startX
            guard halfWidth > 0 else{
                return
            }
            let titleWidth = halfWidth * 2
            var titleLableWidth: CGFloat = 0
            if isClickEnable{
                titleLableWidth = titleWidth - 2 * CGFloat(navibarStyle.titleArrowWidth)
            }else{
                titleLableWidth = titleWidth
            }
            
            if (viewTitle as? LightControl) != nil{
                let font = self.titleLabel?.font
                let size = self.title?.getSize(font: font!, viewWidth: titleLableWidth)
                self.titleLabel?.setViewSize(size ?? .zero)
                    if isClickEnable{
                        viewTitle?.isUserInteractionEnabled = true
                        self.titleLabel?.textColor = navibarStyle.titleColor
                        self.titleLabel?.frame = CGRect.init(x: navibarStyle.itemMargin, y: 0, width: Int(titleLableWidth), height: Int(endY - startY))
                        self.titleArrow?.setViewOrigin(CGPoint.init(x: (self.titleLabel?.frame.origin.x ?? 0) + (self.titleLabel?.frame.size.width ?? 0) + CGFloat(navibarStyle.itemMargin), y: (endY - startY - CGFloat(navibarStyle.titleArrowHeight))/2))
                    }else{
                        viewTitle?.isUserInteractionEnabled = false
                        self.titleLabel?.frame = CGRect.init(x: 0, y: 0, width: titleLableWidth, height: endY - startY)
                    }

                self.titleArrow?.isHidden = !isClickEnable
            }
            
            //重设frame
            viewTitle?.frame = CGRect.init(x: (superFrame.size.width - titleWidth)/2, y: startY, width: titleWidth, height: endY - startY)
        }
        
    }
    
    /// 设置标题
    ///
    /// - Parameter title: 标题
    func setTitle(title: String){
        self.title = title
        if let safeLabel = self.titleLabel{
            safeLabel.text = title
        }
        self.reLayout()
    }
    /// 通过items数组，设置左边的items
    ///
    /// - Parameter barItems: 左边的items数组
    func setLeftBarItems(with barItems:[NaviBarItem]?){
        guard let items = barItems else{//传过来nil 直接移除
            for item in leftBarItems{
                item.removeFromSuperview()
            }
            leftBarItems = []
            return
        }
        //移除之前的item
        for item in leftBarItems{
            item.removeFromSuperview()
        }
        //遍历新的添加
        for item in items{
            self.addSubview(item)
        }
        leftBarItems = items
        self.reLayout()
    }
    
    /// 通过items数组，设置右边的items
    ///
    /// - Parameter barItems: 右边的items数组
    func setRightBarItems(with barItems:[NaviBarItem]?){
        guard let items = barItems else{//传过来nil 直接移除
            for item in rightBarItems{
                item.removeFromSuperview()
            }
            leftBarItems = []
            return
        }
        //移除之前的item
        for item in rightBarItems{
            item.removeFromSuperview()
        }
        //遍历新的添加
        for item in items{
            self.addSubview(item)
        }
        rightBarItems = items
        self.reLayout()
    }
    func getRightBarItems() -> [NaviBarItem]? {
        return rightBarItems
    }
    /// 设置左边的item
    ///
    /// - Parameter itemNew: 新的item
    func setLeftBarItem(with itemNew:NaviBarItem){
        for item in leftBarItems {
            item.removeFromSuperview()
        }
        if leftBarItems.count > 0{
            leftBarItems[0] = itemNew
            self.addSubview(itemNew)
        }else{
            leftBarItems.append(itemNew)
            self.addSubview(itemNew)
        }
        //刷新布局
        self.reLayout()
    }
    /// 设置右边的item
    ///
    /// - Parameter itemNew: 新的item
    func setRightBarItems(with itemNew:NaviBarItem){
        for item in rightBarItems {
            item.removeFromSuperview()
        }
        if rightBarItems.count > 0{
            rightBarItems[0] = itemNew
            self.addSubview(itemNew)
        }else{
            rightBarItems.append(itemNew)
            self.addSubview(itemNew)
        }
        //刷新布局
        self.reLayout()
    }
    
}

// MARK: - target selectors
extension NaviBar{
    @objc func titleTouchDown() {
        if (viewTitle is LightControl) && self.isClickEnable{
            self.sendActions(for: .touchDown)
        }
    }
    @objc func titleTouchupInside() {
        if (viewTitle is LightControl) && self.isClickEnable{
            self.sendActions(for: .touchUpInside)
        }
    }
    @objc func titleTouchupOutside() {
        if (viewTitle is LightControl) && self.isClickEnable{
            self.sendActions(for: .touchUpOutside)
        }
    }
}
