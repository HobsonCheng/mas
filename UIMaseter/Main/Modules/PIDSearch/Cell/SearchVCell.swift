//
//  SearchVCell.swift
//  UIDS
//
//  Created by one2much on 2018/2/1.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

class SearchVCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var gotoApp: UIButton!
    @IBOutlet weak var phoneNum: UILabel!
    @IBOutlet weak var appName: UILabel!
    
    @IBOutlet weak var addItem: UILabel!
    @IBOutlet weak var registerName: UILabel!
    @IBOutlet weak var bossName: UILabel!
    
    @IBOutlet weak var iconImg: UIImageView!
    
    var searchKey: String?
    
    var objData: Project? {
        
        didSet {
            if objData != nil {
                
                var pnameStr = objData?.name
            
                let reg = "(?<=<em>).*?(?=</em>)"
                
                if pnameStr == nil {
                    return
                }
                let list = Util.regexGetSub(pattern: reg, str: pnameStr!)
                
                
                pnameStr = pnameStr?.replacingOccurrences(of: "<em>", with: "")
                pnameStr = pnameStr?.replacingOccurrences(of: "</em>", with: "")
                
                
                
                searchKey = searchKey ?? "世纪"
                

                appName.diverseStringOriginalStr(original: (pnameStr)!, conversionStrArr: (list as NSArray), withFont: UIFont.systemFont(ofSize: 15), withColor: UIColor(hexString: "#51b0ff"))
                
                pnameStr = objData?.pname
                
                pnameStr = pnameStr?.replacingOccurrences(of: "<em>", with: "")
                pnameStr = pnameStr?.replacingOccurrences(of: "</em>", with: "")
                
                bossName.text = "单位名称：\((pnameStr)!)"
                
                bossName.diverseStringOriginalStr(original: (bossName.text)!, conversionStrArr: (list as NSArray), withFont: UIFont.systemFont(ofSize: 15), withColor: UIColor(hexString: "#51b0ff"))
                
                phoneNum.text = "注册者手机号：\((objData?.register_phone)!)"
                registerName.text = "注册者姓名：\((objData?.register_name)!)"
                addItem.text = "注册时间：\((objData?.add_time)!)"
                
                iconImg.sd_setImage(with: URL(string: (objData?.icon)!), completed: nil)
                
            }
        }
    }
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.gotoApp.layer.cornerRadius = 6
        self.gotoApp.layer.masksToBounds = true
        
        self.iconImg.layer.cornerRadius = 6
        self.iconImg.layer.masksToBounds = true
//
//        self.iconImg.layer.borderColor = UIColor(hexString: "#51b0ff").cgColor
//        self.iconImg.layer.borderWidth = 0.5
        
        self.bgView.layer.cornerRadius = 6
        self.bgView.layer.masksToBounds = true
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var gotoAppAction: UIButton!
}
