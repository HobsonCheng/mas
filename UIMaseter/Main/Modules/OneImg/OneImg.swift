//
//  OneImg.swift
//  UIDS
//
//  Created by one2much on 2018/1/10.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class OneImgMode: ConfigModel {
    var imgList: [PageInfo]?
    
}




class OneImg: BaseModuleView {

    var imgView :UIImageView?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.genderView();
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: 创建页面
    private func genderView(){
        
        self.backgroundColor = UIColor.white
        
        self.imgView = UIImageView.init(frame: CGRect(x: 10,y: 10,width: self.width - 20,height: self.height - 20))
        self.addSubview(self.imgView!)
        self.imgView?.layer.cornerRadius = 8
        self.imgView?.layer.masksToBounds = true
    }
    
    public func setUrl(url: NSString){
        if url.hasPrefix("http") {
            self.imgView?.sd_setImage(with: URL(string: url as String))
        }else{
            if let image = UIImage.init(named: url as String) {
                self.imgView?.image = image;
            }else{
                self.imgView?.image = UIImage.init(contentsOfFile: url as String)
            }
        }
    }
}
