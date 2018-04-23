//
//  MyCell.swift
//  UIDS
//
//  Created by one2much on 2018/2/9.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class MyCell: UITableViewCell {

    
    @IBOutlet weak var usericon: UIImageView!
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var userid: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let userinfo = UserUtil.share.appUserInfo
        
        if userinfo != nil {
            if userinfo?.head_portrait != ""{
                usericon.sd_setImage(with: URL.init(string: (userinfo?.head_portrait ?? "https://")!), completed: nil)
            }
            
            
            username.text = userinfo?.zh_name
            userid.text = "UI大师号：\((userinfo?.uid)!)"
            
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
