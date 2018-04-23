//
//  LoadBlockView.swift
//  UIMaseter
//
//  Created by gongcz on 2018/4/13.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

@objc protocol LoadBlockPtc {
    //    optional // error: can only be applied to members of an @objc protocol
    @objc optional func cancelLoad(for context: AnyObject)
}

class LoadBlockView: UIView {
    
    // 控件限高宽
    let loadBlockContentViewWidth: CGFloat          = 240
    let loadBlockContentViewHeight: CGFloat         = 124
    let loadBlockImageViewWidth: CGFloat            = 80
    let loadBlockImageViewHeight: CGFloat           = 100
    let loadBlockCancelButtonWidth: CGFloat         = 100
    let loadBlockCancelButtonHeight: CGFloat        = 44
    let loadBlockBGImageWidth: CGFloat              = 233
    let loadBlockBGImageHeight: CGFloat             = 233
    let loadBlockBGMaskWidth: CGFloat               = 320
    let loadBlockBGMaskHeight: CGFloat              = 329
    
    // 控件间距
    let loadBlockCamelVMargin: CGFloat              = 30
    let loadBlockHintLabelHMargin: CGFloat          = 12
    let loadBlockHintLabelVMargin: CGFloat          = 16
    let loadBlockBGVMargin: CGFloat                 = 2
    
    // 控件字体
    let loadBlockHintLabelFont: CGFloat             = 14
    
    /// 代理
    weak var delegate: LoadBlockPtc?
    /// 内容界面
    var viewContent: UIView?
    /// 地图背景
    var imageBGAnimation: UIImageView?
    /// 加载动画
    var imageViewLoad: UIImageView?
    /// 提示文本
    var labelHint: UILabel?
    /// 取消按钮
    var buttonCancel: UIButton?
    /// 网络连接
    var connect: AnyObject?
    /// 提示文本
    var hintText: String?
    /// 是否可以取消
    var canCancel: Bool = false
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        commonInit()
    }
    
    override var frame: CGRect
    {
        get {return super.frame}
        set {}
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        let appFrame: CGRect = AppInfo.appFrame()
        super.frame = CGRect(x: 0, y: 0, width: appFrame.size.width, height: appFrame.size.height)
        self.backgroundColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.4)
        hintText = "努力加载中..."
    }
    
    func setupViewRootSubs(_ viewParent: UIView) {
        // 父窗口属性
        let parentFrame: CGRect = viewParent.frame
        // 创建View
        if viewContent == nil {
            viewContent = UIView(frame: .zero)
        }
        viewContent?.frame = CGRect(x: CGFloat((parentFrame.size.width-loadBlockContentViewWidth))/2, y: CGFloat((parentFrame.size.height-loadBlockContentViewHeight))/2, width: loadBlockContentViewWidth, height: loadBlockContentViewHeight)
        viewContent?.backgroundColor = .white
        viewContent?.layer.cornerRadius = 5.0
        viewContent?.layer.masksToBounds = true
        // 创建子界面
        self.setupViewContentSubs(viewContent!)
        // 添加到父窗口
        viewParent.addSubview(viewContent!)

    }
    
    func setupViewContentSubs(_ viewParent: UIView) {
        // 父窗口
        let parentFrame: CGRect = viewParent.frame
        // 子窗口
        var spaceYStart: CGFloat = 0
        /* 间距 */
        spaceYStart += loadBlockCamelVMargin
        // 动画图片
        if imageViewLoad == nil {
            // =======================================================================
            // 骆驼背景动画 ImageView
            // =======================================================================
            let imageBGView: UIImageView = UIImageView()
            imageBGView.backgroundColor = UIColor.clear
            imageBGView.frame = CGRect(x: (parentFrame.size.width-loadBlockBGImageWidth)/2, y: spaceYStart-loadBlockBGVMargin, width: loadBlockBGImageWidth, height: loadBlockBGImageHeight)
            viewParent.addSubview(imageBGView)
            // 骆驼背景动画 ImageView
            if let imageBGAnimation = self.imageBGAnimation {
                imageBGView.addSubview(imageBGAnimation)
            }
            // 遮罩Mask
            let maskImage: UIImage = UIImage()
            let maskLayer: CALayer = CALayer.init()
            maskLayer.frame = CGRect(x: (imageBGView.frame.size.width-loadBlockBGMaskWidth)/2, y: (imageBGView.frame.size.height-loadBlockBGMaskHeight)/2, width: loadBlockBGMaskWidth, height: loadBlockBGMaskHeight)
            maskLayer.contents = maskImage.cgImage
            imageBGView.layer.mask = maskLayer
            imageViewLoad = UIImageView()
            imageViewLoad?.frame = CGRect(x: (parentFrame.size.width-loadBlockImageViewWidth)/2, y: spaceYStart, width: loadBlockImageViewWidth, height: loadBlockImageViewHeight)
            imageViewLoad?.animationDuration = 3.0
            // 设置动画图片
            var arrayImages: Array<UIImage> = Array()
            for i in 0...7 {
                let name: String = "icon_shake_animation_\((i+1)).png"
                arrayImages.append(UIImage(named: name)!)
            }
            imageViewLoad?.animationImages = arrayImages
            // 保存
            viewParent.addSubview(imageViewLoad!)
        }
        /* 间距 */
        spaceYStart += imageViewLoad?.frame.size.height ?? 0
        spaceYStart += loadBlockHintLabelVMargin
        // =======================================================================
        // Hint Label
        // =======================================================================
        if labelHint == nil {
            labelHint = UILabel(frame: .zero)
            labelHint?.font = UIFont.systemFont(ofSize: loadBlockHintLabelFont)
            labelHint?.lineBreakMode = .byWordWrapping
            labelHint?.numberOfLines = 0
            labelHint?.textAlignment = .center
            labelHint?.textColor = UIColor(hex: 0x000000, alpha: 1.0)
            // 保存
            viewParent.addSubview(labelHint!)
        }
        // 设置属性
        if hintText != nil {
            // 设置字符串的尺寸
            let hintTextSize: CGSize = hintText!.size(withFontCompatible: UIFont.systemFont(ofSize: loadBlockHintLabelFont), constrainedTo: CGSize(width: parentFrame.size.width-2*loadBlockHintLabelHMargin, height: CGFloat.greatestFiniteMagnitude), lineBreakMode: .byWordWrapping)
            // 设置Label属性
            labelHint?.frame = CGRect(x: CGFloat((parentFrame.size.width-hintTextSize.width))/2, y: spaceYStart, width: hintTextSize.width, height: hintTextSize.height)
            labelHint?.text = hintText
            labelHint?.isHidden = false
        } else {
            labelHint?.isHidden = true
        }
        /* 间距 */
        spaceYStart += (labelHint?.frame.size.height)!
        spaceYStart += loadBlockCamelVMargin
        // =======================================================================
        // Close Button
        // =======================================================================
        if buttonCancel == nil {
            buttonCancel = UIButton(type: .custom)
            buttonCancel?.addTarget(self, action: #selector(doCanceldo(_:)), for: .touchUpInside)
            // 保存
            viewParent.addSubview(buttonCancel!)
        }
        // 现实
        if canCancel {
            buttonCancel?.frame = CGRect(x: parentFrame.size.width-loadBlockCancelButtonWidth/2-12, y: -loadBlockCancelButtonHeight/2+12, width: loadBlockCancelButtonWidth, height: loadBlockCancelButtonHeight)
            buttonCancel?.isHidden = false
        } else {
            buttonCancel?.isHidden = true
        }
        // 重置高度
        if spaceYStart > parentFrame.size.height {
            let center: CGPoint = viewParent.center
            viewParent.setViewHeight(spaceYStart)
            viewParent.center = center
        }

    }
    
    @objc func doCanceldo(_ sender: AnyObject) {
        // 停止加载
        dismiss()
        // 请求代理函数
        // TODO: if delegate != nil && self.delegate.response 报错
        delegate?.cancelLoad!(for: connect!)
    }
    
    func show(in view: UIView, forConnect connect: AnyObject, andHint text: String, andCancel cancel: Bool) {
        // 设置属性
        self.connect = connect
        self.hintText = text
        self.canCancel = cancel
        // 刷新界面
        self.setupViewRootSubs(self)
        // 添加到父窗口
        self.alpha = 0
        view.addSubview(self)
        // 显示
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.imageViewLoad?.startAnimating()
            self.alpha = 1
            // 设置动画
            let animation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            animation.toValue = Double.pi //Numeric(value: M_PI)
            animation.duration = 9
            animation.isCumulative = true
            animation.repeatCount = Float.infinity
            self.imageBGAnimation?.layer.add(animation, forKey: "activity")
        })
    }
    
    func changeHint(hintNew: String) {
        hintText = hintNew
        self.setupViewRootSubs(self)
    }
    
    func dismiss() {
        // 停止动画
        imageViewLoad?.stopAnimating()
        imageBGAnimation?.layer.removeAnimation(forKey: "activity")
        imageViewLoad?.removeFromSuperview()
        imageViewLoad = nil
        // 移除屏幕
        self.removeFromSuperview()

    }
    
    deinit {
        delegate = nil
    }
    
}
