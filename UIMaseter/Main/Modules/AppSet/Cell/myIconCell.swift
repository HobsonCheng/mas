//
//  myIconCell.swift
//  UIDS
//
//  Created by one2much on 2018/2/9.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class myIconCell: UITableViewCell {

    
    @IBOutlet weak var iconname: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let userinfo = UserUtil.share.appUserInfo
        iconname.sd_setImage(with: URL.init(string: (userinfo?.head_portrait ?? "https://")!), completed: nil)
    }

    func changeIcon(){
        let userinfo = UserUtil.share.appUserInfo
        iconname.sd_setImage(with: URL.init(string: (userinfo?.head_portrait ?? "https://")!), completed: nil)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
