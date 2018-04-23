//
//  DS2RefreshHeader.swift
//  UIDS
//
//  Created by one2much on 2018/1/22.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import ESPullToRefresh

class DS2RefreshHeader: UIView, ESRefreshProtocol, ESRefreshAnimatorProtocol{

    public var insets: UIEdgeInsets = UIEdgeInsets.zero
    public var view: UIView { return self }
    public var duration: TimeInterval = 0.3
    public var trigger: CGFloat = 56.0
    public var executeIncremental: CGFloat = 56.0
    public var state: ESRefreshViewState = .pullToRefresh
    
    private let imageView: UIImageView = {
        let imageView = UIImageView.init()
        imageView.image = UIImage.init(named: "loading1.png")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func refreshAnimationBegin(view: ESRefreshComponent) {
        imageView.center = self.center
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
            self.imageView.frame = CGRect.init(x: (self.bounds.size.width - 39.0) / 2.0,
                                               y: self.bounds.size.height - 50.0,
                                               width: 45.0,
                                               height: 45.0)
            
            
        }, completion: { (finished) in
            var images = [UIImage]()
            for idx in 1 ... 15 {
                if let aImage = UIImage(named: "loading\(idx).png") {
                    images.append(aImage)
                }
            }
            self.imageView.animationDuration = 0.5
            self.imageView.animationRepeatCount = 0
            self.imageView.animationImages = images
            self.imageView.startAnimating()
        })
    }
    
    public func refreshAnimationEnd(view: ESRefreshComponent) {
        imageView.stopAnimating()
        imageView.image = UIImage.init(named: "loading1.png")
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
            self.refresh(view: view, progressDidChange: 0.0)
        }, completion: { (finished) in
        })
    }
    
    public func refresh(view: ESRefreshComponent, progressDidChange progress: CGFloat) {
        let p = max(0.0, min(1.0, progress))
        imageView.frame = CGRect.init(x: (self.bounds.size.width - 39.0) / 2.0,
                                      y: self.bounds.size.height - 50.0 * p,
                                      width: 39.0,
                                      height: 50.0 * p)
    }
    
    public func refresh(view: ESRefreshComponent, stateDidChange state: ESRefreshViewState) {
        guard self.state != state else {
            return
        }
        self.state = state
        
        switch state {
        case .pullToRefresh:
            var images = [UIImage]()
            for idx in 1 ... 15 {
                if let aImage = UIImage(named: "loading\((15 - idx + 1)).png") {
                    images.append(aImage)
                }
            }
            imageView.animationDuration = 0.2
            imageView.animationRepeatCount = 1
            imageView.animationImages = images
            imageView.image = UIImage.init(named: "loading1.png")
            imageView.startAnimating()
            break
        case .releaseToRefresh:
            var images = [UIImage]()
            for idx in 1 ... 16 {
                if let aImage = UIImage(named: "loading\(idx).png") {
                    images.append(aImage)
                }
            }
            imageView.animationDuration = 0.2
            imageView.animationRepeatCount = 1
            imageView.animationImages = images
            imageView.image = UIImage.init(named: "loading15.png")
            imageView.startAnimating()
            break
        default:
            break
        }
    }

}
