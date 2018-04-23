//
//  LoadEmptyView.swift
//  UIMaseter
//
//  Created by gongcz on 2018/4/16.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

// MARK: -
fileprivate struct EmptyViewStyle {
    /// 控件限高宽
    static let loadEmptyLoadImageViewWidth:CGFloat        = 150
    static let loadEmptyLoadImageViewHeight:CGFloat       = 150
    static let loadEmptyErrorImageViewWidth:CGFloat       = 200
    static let loadEmptyErrorImageViewHeight:CGFloat      = 184
    static let loadEmptyErrorButtonWidth:CGFloat          = 220
    static let loadEmptyErrorButtonHeight:CGFloat         = 40
    static let loadEmptyBGImageWidth:CGFloat              = 233
    static let loadEmptyBGImageHeight:CGFloat             = 233
    static let loadEmptyBGMaskWidth:CGFloat               = 320
    static let loadEmptyBGMaskHeight:CGFloat              = 329
    
    /// 控件间距
    static let loadEmptyLoadImageVMargin:CGFloat          = 80
    static let loadEmptyLoadLabelVMargin:CGFloat          = 10
    static let loadEmptyErrorImageVMargin:CGFloat         = 60
    static let loadEmptyErrorLabelVMargin:CGFloat         = 8
    static let loadEmptyErrorButtonVMargin:CGFloat        = 16
    static let loadEmptyHintLabelHMargin:CGFloat          = 12
    static let loadEmptyBGVMargin:CGFloat                 = 2
    
    /// 控件字体
    static let loadEmptyHintLabelFont:CGFloat             = 20
    static let loadEmptyErrorButtonFont:CGFloat           = 18
}

// MARK: -
@objc protocol LoadEmptyPtc {
    
    /// 调整EmptyView的位置和尺寸
    ///
    /// - Parameters:
    ///   - loadEmptyView: 传递EmptyView用来设置Frame
    ///   - viewParent: 传递loadEmptyView的super view来
    func justifyEmptyView(loadEmptyView: LoadEmptyView, inView viewParent: UIView)
    
    // optional
    /// 当请求失败时，对VC进行回调
    ///
    /// - Parameter context: 回调的上下文
    @objc optional func doError(_ context: AnyObject)
}

// MARK: -
class LoadEmptyView: UIView {
    
    /// 代理
    weak var delegate: LoadEmptyPtc?
    
    /// 加载界面
    var viewLoad: UIView?
    /// 地图背景
    var imageBGAnimation: UIImageView?
    /// 加载动画
    var imageViewLoad: UIImageView?
    /// 加载提示
    var labelLoadHint: UILabel?
    /// 失败界面
    var viewError: UIView?
    /// 失败图片
    var imageViewError: UIImageView?
    /// 失败提示Title
    var labelErrorTitleHint: UILabel?
    /// 失败提示
    var labelErrorHint: UILabel?
    /// 失败按钮
    var buttonError: UIButton?
    /// 加载提示文本
    var loadHint: String?
    /// 失败提示Title文本
    var errorTitleHint: String? {
        didSet {
            if viewError != nil {
                setupViewErrorSubs(viewError!)
            }
        }
    }
    /// 失败提示文本
    var errorHint: String? {
        didSet {
            if viewError != nil {
                setupViewErrorSubs(viewError!)
            }
        }
    }
    /// 按钮提示文本
    var buttonHint: String? {
        didSet {
            if viewError != nil {
                setupViewErrorSubs(viewError!)
            }
        }
    }
    /// 上下文
    var context: AnyObject?
    
    init() {
        let appFrame: CGRect = AppInfo.appFrame()
        super.init(frame: appFrame)
        self.backgroundColor = UIColor(hex: 0xf2f8fb, alpha: 1.0)
        loadHint = "努力加载中..."
        errorTitleHint = nil
        errorHint = "很抱歉, 加载失败"
        buttonHint = "重试"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadHint = "努力加载中..."
        errorTitleHint = nil
        errorHint = "很抱歉, 加载失败"
        buttonHint = "重试"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewRootSubs(_ viewParent: UIView) {
        // 父窗口属性
        let parentFrame: CGRect = viewParent.frame
        // 创建View
        if viewLoad == nil {
            viewLoad = UIView(frame: .zero)
        }
        
        viewLoad?.frame = CGRect(x: 0, y: 0, width: parentFrame.size.width, height: parentFrame.size.height)
        viewLoad?.backgroundColor = .white
        // 创建子界面
        self.setupViewLoadSubs(viewLoad!)
        // 添加到父窗口
        viewParent.addSubview(viewLoad!)
        // 创建View
        if viewError == nil {
            viewError = UIView(frame: .zero)
        }
        viewError?.frame = CGRect(x: 0, y: 0, width: parentFrame.size.width, height: parentFrame.size.height)
        viewError?.backgroundColor = .clear
        // 创建子界面
        self.setupViewErrorSubs(viewError!)
        // 添加到父窗口
        viewParent.addSubview(viewError!)
        
    }
    
    func setupViewLoadSubs(_ viewParent: UIView) {
        // 父窗口
        let parentFrame: CGRect = viewParent.frame
        // 子窗口
        var spaceYStart: CGFloat = 0
        /* 间距 */
        spaceYStart += EmptyViewStyle.loadEmptyLoadImageVMargin
        // 动画图片
        if imageViewLoad == nil {
            // 骆驼背景动画 ImageView
            let imageBGView: UIImageView = UIImageView()
            imageBGView.backgroundColor = UIColor.clear
            imageBGView.frame = CGRect(x: (parentFrame.size.width-EmptyViewStyle.loadEmptyBGImageWidth)/2, y: spaceYStart-EmptyViewStyle.loadEmptyBGVMargin, width: EmptyViewStyle.loadEmptyBGImageWidth, height: EmptyViewStyle.loadEmptyBGImageHeight)
            viewParent.addSubview(imageBGView)
            // 骆驼背景动画 ImageView
            //        imageBGAnimation = [[UIImageView alloc] initWithImage:UIMasterImage(@"iconservererror.png")];
            imageBGAnimation?.frame = CGRect(x: 0, y: 0, width: imageBGView.frame.size.width, height: imageBGView.frame.size.height)
            imageBGView.addSubview(imageBGAnimation!)
            // 遮罩Mask
            let maskImage: UIImage = UIImage.from(.red)
            //UIMasterImage(@"LoadingCamelBGMask.png");
            let maskLayer: CALayer = CALayer()
            maskLayer.frame = CGRect(x: (imageBGView.frame.size.width-EmptyViewStyle.loadEmptyBGMaskWidth)/2, y: (imageBGView.frame.size.height-EmptyViewStyle.loadEmptyBGMaskHeight)/2, width: EmptyViewStyle.loadEmptyBGMaskWidth, height: EmptyViewStyle.loadEmptyBGMaskHeight)
            maskLayer.contents = maskImage.cgImage
            imageBGView.layer.mask = maskLayer
            // =======================================================================
            // 骆驼动画 ImageView
            // =======================================================================
            imageViewLoad = UIImageView()
            imageViewLoad?.frame = CGRect(x: (parentFrame.size.width-EmptyViewStyle.loadEmptyLoadImageViewWidth)/2, y: spaceYStart, width: EmptyViewStyle.loadEmptyLoadImageViewWidth, height: EmptyViewStyle.loadEmptyLoadImageViewHeight)
            imageViewLoad?.animationDuration = 0.7
            // 设置动画图片
            var arrayImages: Array<UIImage> = Array()
            for i in 1...7 {
                let name: String = "iconshakeanimation_\((i+1)).png"
                arrayImages.append(UIImage(named: name)!)
            }
            imageViewLoad?.animationImages = arrayImages
            // 保存
            viewParent.addSubview(imageViewLoad!)
        }
        /* 间距 */
        spaceYStart += imageViewLoad?.frame.size.height ?? 0
        spaceYStart += EmptyViewStyle.loadEmptyLoadLabelVMargin*2
        // Hint Label
        if labelLoadHint == nil {
            labelLoadHint = UILabel(frame: .zero)
            labelLoadHint?.font = UIFont.systemFont(ofSize: EmptyViewStyle.loadEmptyHintLabelFont)
            labelLoadHint?.lineBreakMode = .byWordWrapping
            labelLoadHint?.numberOfLines = 0
            labelLoadHint?.textAlignment = .center
            labelLoadHint?.backgroundColor = .clear
            labelLoadHint?.textColor = UIColor(hex: 0x1ba9ba, alpha: 1.0)
            // 保存
            viewParent.addSubview(labelLoadHint!)
        }
        // 设置属性
        if loadHint != nil {
            // 设置字符串的尺寸
            let hintTextSize: CGSize = loadHint!.size(withFontCompatible: UIFont.systemFont(ofSize: EmptyViewStyle.loadEmptyHintLabelFont), constrainedTo: CGSize(width: parentFrame.size.width-2*EmptyViewStyle.loadEmptyHintLabelHMargin, height: CGFloat.greatestFiniteMagnitude), lineBreakMode: .byWordWrapping)
            // 设置Label属性
            labelLoadHint?.frame = CGRect(x: CGFloat((parentFrame.size.width-hintTextSize.width))/2, y: spaceYStart, width: hintTextSize.width, height: hintTextSize.height)
            labelLoadHint?.text = loadHint
            labelLoadHint?.isHidden = false
        } else {
            labelLoadHint?.isHidden = true
        }
    }
    
    func circleAnimationStart() {
        if imageBGAnimation != nil {
            let animation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            animation.toValue = Double.pi
            animation.duration = 9
            animation.isCumulative = true
            animation.repeatCount = .greatestFiniteMagnitude
            imageBGAnimation?.layer.add(animation, forKey: "activity")
        }
    }
    
    func setupViewErrorSubs(_ viewParent: UIView) {
        // 父窗口
        let parentFrame: CGRect = viewParent.frame
        // 子窗口
        var spaceYStart: CGFloat = 30
        /* 间距 */
        spaceYStart += EmptyViewStyle.loadEmptyErrorImageVMargin
        // 图片
        if imageViewError == nil {
            imageViewError = UIImageView()
            imageViewError?.frame = CGRect(x: (parentFrame.size.width-EmptyViewStyle.loadEmptyErrorImageViewWidth)/2, y: spaceYStart, width: EmptyViewStyle.loadEmptyErrorImageViewWidth, height: EmptyViewStyle.loadEmptyErrorImageViewHeight)
            imageViewError?.image = UIImage.from(.yellow)
            //UIMaster_Image(@"加载失败400.png")
            // 保存
            viewParent.addSubview(imageViewError!)
        }
        /* 间距 */
        spaceYStart += (imageViewError?.frame.size.height ?? 0)+20
        // =======================================================================
        // Hint Title Label
        // =======================================================================
        if labelErrorTitleHint == nil {
            labelErrorTitleHint = UILabel(frame: .zero)
            labelErrorTitleHint?.font = UIFont.systemFont(ofSize: EmptyViewStyle.loadEmptyHintLabelFont)
            labelErrorTitleHint?.lineBreakMode = .byWordWrapping
            labelErrorTitleHint?.numberOfLines = 0
            labelErrorTitleHint?.textAlignment = .center
            labelErrorTitleHint?.textColor = UIColor(hex: 0x333333, alpha: 1.0)
            // 保存
            viewParent.addSubview(labelErrorTitleHint!)
        }
        // 设置属性
        if errorTitleHint != nil {
            spaceYStart += EmptyViewStyle.loadEmptyErrorLabelVMargin
            // 设置字符串的尺寸
            let hintTextSize: CGSize = errorTitleHint!.size(withFontCompatible: UIFont.systemFont(ofSize: EmptyViewStyle.loadEmptyHintLabelFont), constrainedTo: CGSize(width: parentFrame.size.width-2*EmptyViewStyle.loadEmptyHintLabelHMargin, height: CGFloat.greatestFiniteMagnitude), lineBreakMode: .byWordWrapping)
            // 设置Label属性
            labelErrorTitleHint?.frame = CGRect(x: CGFloat((parentFrame.size.width-hintTextSize.width))/2, y: spaceYStart, width: hintTextSize.width, height: hintTextSize.height)
            labelErrorTitleHint?.text = errorTitleHint
            labelErrorTitleHint?.isHidden = false
            /* 间距 */
            spaceYStart += labelErrorTitleHint?.frame.size.height ?? 0
        } else {
            labelErrorTitleHint?.isHidden = true
            
        }
        // =======================================================================
        // Hint Label
        // =======================================================================
        if labelErrorHint == nil {
            labelErrorHint = UILabel(frame: .zero)
            labelErrorHint?.font = UIFont.systemFont(ofSize: EmptyViewStyle.loadEmptyHintLabelFont)
            labelErrorHint?.lineBreakMode = .byWordWrapping
            labelErrorHint?.numberOfLines = 0
            labelErrorHint?.textAlignment = .center
            labelErrorHint?.textColor = UIColor(hex: 0x333333, alpha: 1.0)
            // 保存
            viewParent.addSubview(labelErrorHint!)
        }
        // 设置属性
        if errorHint != nil {
            spaceYStart += EmptyViewStyle.loadEmptyErrorLabelVMargin
            // 设置字符串的尺寸
            let hintTextSize: CGSize = errorHint!.size(withFontCompatible: UIFont.systemFont(ofSize: EmptyViewStyle.loadEmptyHintLabelFont), constrainedTo: CGSize(width: parentFrame.size.width-2*EmptyViewStyle.loadEmptyHintLabelHMargin, height: CGFloat.greatestFiniteMagnitude), lineBreakMode: .byWordWrapping)
            // 设置Label属性
            labelErrorHint?.frame = CGRect(x: CGFloat((parentFrame.size.width-hintTextSize.width))/2, y: spaceYStart, width: hintTextSize.width, height: hintTextSize.height)
            labelErrorHint?.text = errorHint
            labelErrorHint?.isHidden = false
            /* 间距 */
            spaceYStart += labelErrorHint?.frame.size.height ?? 0
        } else {
            labelErrorHint?.isHidden = true
            
        }
        /* 间距 */
        spaceYStart += EmptyViewStyle.loadEmptyErrorLabelVMargin
        // =======================================================================
        // Button
        // =======================================================================
        if buttonError == nil {
            buttonError = UIButton(type: .custom)
            buttonError?.frame = CGRect(x: CGFloat((parentFrame.size.width-EmptyViewStyle.loadEmptyErrorButtonWidth))/2, y: spaceYStart, width: EmptyViewStyle.loadEmptyErrorButtonWidth, height: EmptyViewStyle.loadEmptyErrorButtonHeight)
            buttonError?.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            buttonError?.setBackgroundImage(UIImage.from(UIColor.mainNav()), for: .normal)
            buttonError?.addTarget(self, action: #selector(doError(_:)), for: .touchUpInside)
            buttonError?.layer.cornerRadius = 2.0
            buttonError?.layer.masksToBounds = true
            // 保存
            viewParent.addSubview(buttonError!)
        }
        if buttonHint != nil {
            buttonError?.setTitle(buttonHint, for: .normal)
            buttonError?.frame = CGRect(x: CGFloat((parentFrame.size.width-EmptyViewStyle.loadEmptyErrorButtonWidth))/2, y: spaceYStart, width: EmptyViewStyle.loadEmptyErrorButtonWidth, height: EmptyViewStyle.loadEmptyErrorButtonHeight)
            buttonError?.isHidden = false
        } else {
            buttonError?.isHidden = true
        }
    }
    
    @objc func doError(_ sender: AnyObject) {
        delegate?.doError?(context!)
    }
    
    func updateError(titleHintNew: String, errorHintNew: String) {
        errorTitleHint = titleHintNew
        errorHint = errorHintNew
        if viewError != nil {
            setupViewErrorSubs(viewError!)
        }
    }
    
    func show(in view: UIView, forContext ctx:AnyObject) {
        // 设置属性
        self.context = ctx
        // 布局
        delegate?.justifyEmptyView(loadEmptyView: self, inView: view)
//        delegate.justifyEmptyView(self, inView: view)
        // 刷新界面
        self.setupViewRootSubs(self)
        // 隐藏错误界面
        viewLoad?.isHidden = false
        viewError?.isHidden = true
        imageViewLoad?.startAnimating()
        // 设置动画
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = Double.pi
        animation.duration = 9
        animation.isCumulative = true
        animation.repeatCount = .infinity
        imageBGAnimation?.layer.add(animation, forKey: "activity")
        // 添加到父窗口
        view.addSubview(self)
    }
    
    /// 结束
    func loadError() {
        imageViewLoad?.stopAnimating()
        viewLoad?.isHidden = true
        viewError?.isHidden = false
    }
    
    /// 结束加载
    func dismiss() {
        // 停止动画
        imageViewLoad?.stopAnimating()
        imageBGAnimation?.layer.removeAnimation(forKey: "activity")
        imageViewLoad?.removeFromSuperview()
        imageViewLoad = nil
        // 移除屏幕
        self.removeFromSuperview()
    }
    
    // 销毁代理
    deinit {
        delegate = nil
    }
    
}
