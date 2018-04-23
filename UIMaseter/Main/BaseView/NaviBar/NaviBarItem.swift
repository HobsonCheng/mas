//
//  NaviBarItem.swift
//  UIMaseter
//
//  Created by one2much on 2018/4/17.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import Then
enum NaviBarItemState {
    /// 普通状态
    case normal
    /// 高亮状态
    case highlighted
    /// 禁用状态
    case disable
}

fileprivate enum NaviBarItemType{
    case image
    case text
    case close
    case back
    case empty
}
struct NaviBarItemStyle {
    let globalModel = GlobalConfigTool.shared.naviBar
    weak var delegate: NaviBarItem?
    // item普通状态的颜色
    var normalTextColor: UIColor{
        get{
            return globalModel?.styles?.itemColor?.toColor() ?? UIColor.white
        }
        set{
            delegate?.button?.setTitleColor(normalTextColor, for: .normal)
            delegate?.button?.setYJTitleColor(color: normalTextColor)
        }
    }
    //item的字体大小
    var fontSize: CGFloat{
        get{
            return CGFloat(globalModel?.styles?.itemSize ?? 16)
        }
        set{
            delegate?.button?.titleLabel?.font = UIFont.init(name: "iconfont", size: fontSize)
        }
    }
    let pressTextColor = UIColor.init(hex: 0xffffff, alpha: 0.5)
    let disabelColor = UIColor.init(hex: 0xffffff, alpha: 0.5)
   
}
//MARK: -


class NaviBarItem: UIView {
    /// item按钮
    var button: UIButton?
    /// navibarItem的样式
    lazy var navibarItemStyle: NaviBarItemStyle = {
        var style = NaviBarItemStyle()
        style.delegate = self
        return style
    }()
    
    /// 设置frame时，会自动修改button的frame
    override var frame: CGRect{
        didSet{
            button?.frame = CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
            super.frame = frame
        }
    }
    
    /// 设置Item是否为Disabled
    var isItemEnable: Bool = true{
        didSet{
            button?.isEnabled = isItemEnable
        }
    }
    
    fileprivate var type: NaviBarItemType = .text
    
    fileprivate static let itemHeight = 44
    fileprivate static let itemWidth = 44
    fileprivate static let hMargin = 6
    
    /// 创建自定义尺寸的BarItem,配合使用 设置背景图 或 icon图 风味更佳
    init(imageSize:CGSize,target: AnyObject,action: Selector) {
        super.init(frame: .zero)
        let frame = CGRect.init(origin: CGPoint.init(x: NaviBarItem.hMargin, y: 0), size: imageSize)
        self.frame = frame
        //创建button
        button = UIButton().then({
            $0.frame = CGRect.init(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
            $0.addTarget(target, action: action, for: .touchUpInside)
            $0.isExclusiveTouch = true
        })
        self.addSubview(button!)
        type = .image
    }
    
    /// 创建文字BarItem
    init(withText title:String,target: AnyObject,action: Selector) {
        super.init(frame: .zero)
        //计算设置尺寸
        let titleSize = title.getSize(fontSize: CGFloat(navibarItemStyle.fontSize))
        let width = titleSize.width + CGFloat(2 * NaviBarItem.hMargin)
        let height = NaviBarItem.itemHeight
        let frame = CGRect.init(x: 0, y: 0, width: Int(width), height: height)
        self.frame = frame
        //创建button
        button = UIButton().then({
            $0.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(navibarItemStyle.fontSize))
            $0.setTitle(title, for: .normal)
            $0.frame = frame
            $0.setTitleColor(navibarItemStyle.normalTextColor, for: .normal)
            $0.setTitleColor(navibarItemStyle.pressTextColor, for: .highlighted)
            $0.setTitleColor(navibarItemStyle.disabelColor, for: .disabled)
            $0.addTarget(target, action: action, for: .touchUpInside)
            $0.isExclusiveTouch = true
        })
        self.addSubview(button!)
        type = .text
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 创建占位BarItem
//    convenience init(emptyTarget: AnyObject,action: Selector) {
//        self.init(imageSize: CGSize.init(width: navibarItemStyle.itemWidth, height: navibarItemStyle.itemHeight), target: emptyTarget, action: action)
//        button?.backgroundColor = .clear
//        type = .empty
//    }
    
    /// 创建返回BarItem
    convenience init(backTarget target:AnyObject,action: Selector) {
        self.init(imageSize: CGSize.init(width: NaviBarItem.itemWidth, height: NaviBarItem.itemHeight), target: target, action: action)
        button?.setYJIcon(icon: YJType.back, iconSize: navibarItemStyle.fontSize, forState: .normal)
        button?.setYJIcon(icon: YJType.back, iconSize: navibarItemStyle.fontSize, forState: .highlighted)
        button?.setYJIcon(icon: YJType.back, iconSize: navibarItemStyle.fontSize, forState: .disabled)
        button?.setYJTitleColor(color: navibarItemStyle.normalTextColor)
        type = .back
    }
    
    /// 创建关闭BarItem
    convenience init(closeTarget target:AnyObject,action: Selector) {
        self.init(imageSize: CGSize.init(width: NaviBarItem.itemWidth, height: NaviBarItem.itemHeight), target: target, action: action)
        button?.setYJIcon(icon: YJType.close0, iconSize: navibarItemStyle.fontSize, forState: .normal)
        button?.setYJIcon(icon: YJType.close0, iconSize: navibarItemStyle.fontSize, forState: .highlighted)
        button?.setYJIcon(icon: YJType.close0, iconSize: navibarItemStyle.fontSize, forState: .disabled)
        button?.setYJTitleColor(color: navibarItemStyle.normalTextColor)
        type = .close
    }
    

    /// 设置title文字
    func setTitle(title:String) {
        if type == .text{
            let titleSize = title.getSize(fontSize: navibarItemStyle.fontSize)
            let width = titleSize.width  + CGFloat(2 * NaviBarItem.hMargin)
            let height = NaviBarItem.itemHeight
            self.frame = CGRect.init(x: 0, y: 0, width: Int(width), height: height)
            button?.frame = CGRect.init(x: 0, y: 0, width: Int(width), height: height)
            button?.setTitle(title, for: .normal)
        }
    }
    // 设置背景图
    func setBackgroundImage(with image: UIImage,for state:NaviBarItemState) {
        guard type == .image else {
            return
        }
        switch state {
        case .normal:
            button?.setBackgroundImage(image, for: .normal)
        case .disable:
            button?.setBackgroundImage(image, for: .disabled)
        case .highlighted:
            button?.setBackgroundImage(image, for: .highlighted)
        }
    }
    // 设置图片按钮
    func setIconImage(with image: UIImage,for state:NaviBarItemState) {
        guard type == .image else {
            return
        }
        switch state {
        case .normal:
            button?.setImage(image, for: .normal)
        case .disable:
            button?.setImage(image, for: .disabled)
        case .highlighted:
            button?.setImage(image, for: .highlighted)
        }
        
        
    }
    //网络图片
    func setIconImageUrl(with imageUrl: String,for state:NaviBarItemState) {
        guard type == .image else {
            return
        }
        switch state {
        case .normal:
            button?.sd_setImage(with: URL.init(string: imageUrl), for: .normal, completed: nil)
        case .disable:
            button?.sd_setImage(with: URL.init(string: imageUrl), for: .disabled, completed: nil)
        case .highlighted:
            button?.sd_setImage(with: URL.init(string: imageUrl), for: .highlighted, completed: nil)
        }
        button?.imageView?.contentMode = .scaleAspectFit
    }
    
}
