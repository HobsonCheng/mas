//
//  ChangeIconVC.swift
//  UIDS
//
//  Created by one2much on 2018/2/9.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit
import SDWebImage

class ChangeIconVC: NaviBarVC,UIScrollViewDelegate {

    var scrollView:UIScrollView?
    var lastImageView:UIImageView?
    var originalFrame:CGRect!
    var isDoubleTap:ObjCBool!
    
    var myImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.naviBar()?.setTitle(title: "个人头像")
        
        let right = NaviBarItem.init(imageSize: CGSize.init(width: 44, height: 22), target: self, action: #selector(ChangeIconVC.touchRight))
        right.setIconImage(with: UIImage.init(named: "newscontent_share_more.png")!, for: .normal)
        self.naviBar()?.setRightBarItems(with: right)
        
        
        let bgView = UIScrollView.init(frame: CGRect.init(x: 0, y: self.naviBar()?.bottom ?? 64, width: kScreenW, height: kScreenH - (self.naviBar()?.bottom ?? 64)))
        bgView.backgroundColor = UIColor.black

        let imageView = UIImageView.init()
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        let userinfo = UserUtil.share.appUserInfo
    
        let placeimg = UIImage.init(named: "comment_profile_default.png")
        
        myImageView = imageView
        
        imageView.sd_setImage(with: URL.init(string: (userinfo?.head_portrait) ?? "https://sds"), placeholderImage: UIImage.init(named: "comment_profile_default.png"), options: SDWebImageOptions.avoidAutoSetImage) { [weak self] (img, erro, type, url) in
            if img != nil {
                
                self?.myImageView.image = img
                
                if (img?.size.width)! > kScreenW {
                    self?.myImageView.frame = CGRect.init(x: 0, y: 0, width: kScreenW, height: (self?.view.height)!)
                }else {
                    self?.myImageView.frame = CGRect.init(x: kScreenW/2 - (img?.size.width)!/2, y: kScreenH/2 - (img?.size.height)!/2, width: (img?.size.width)!, height: (img?.size.height)!)
                }            }
        }

        imageView.frame = CGRect.init(x: kScreenW/2 - (placeimg?.size.width)!/2, y: kScreenH/2 - (placeimg?.size.height)!/2, width: (placeimg?.size.width)!, height: (placeimg?.size.height)!)
        
        bgView.addSubview(imageView)
        
        
        
        self.view.addSubview(bgView)
        self.lastImageView = imageView
        self.originalFrame = imageView.frame
        self.scrollView = bgView
        self.scrollView?.maximumZoomScale = 1.5
        self.scrollView?.delegate = self
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            options: UIViewAnimationOptions.beginFromCurrentState,
            animations: {
                var frame = imageView.frame
                frame.size.width = bgView.frame.size.width
                frame.size.height = frame.size.width * ((imageView.image?.size.height)! / (imageView.image?.size.width)!)
                frame.origin.x = 0
                frame.origin.y = (bgView.frame.size.height - frame.size.height) * 0.5
                imageView.frame = frame
        }, completion: nil
        )
        
    }

    //正确代理回调方法
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.lastImageView
    }
    
    //错误代理回调方法
    //    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
    //        return self.lastImageView
    //    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func touchRight(){
        
        let actionSheet = UIAlertController(title: "上传头像", message: nil, preferredStyle: .actionSheet)
        let cancelBtn = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        
        let takePhotos = UIAlertAction(title: "拍照", style: .destructive, handler: {
            (action: UIAlertAction) -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let picker = UIImagePickerController()
                picker.sourceType = .camera
                picker.delegate = self
                picker.allowsEditing = true
                self.present(picker, animated: true, completion: nil)
                
            }
            else
            {
                print("模拟其中无法打开照相机,请在真机中使用");
            }
            
        })
        let selectPhotos = UIAlertAction(title: "相册选取", style: .default, handler: {
            (action:UIAlertAction)
            -> Void in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            self.present(picker, animated: true, completion: nil)
            
        })
        actionSheet.addAction(cancelBtn)
        actionSheet.addAction(takePhotos)
        actionSheet.addAction(selectPhotos)
        self.present(actionSheet, animated: true, completion: nil)
    }

}

extension ChangeIconVC : UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let type: String = (info[UIImagePickerControllerMediaType] as! String)
        
        //当选择的类型是图片
        if type == "public.image"
        {
            
            //修正图片的位置
            let image = (info[UIImagePickerControllerEditedImage] as! UIImage)
            //先把图片转成NSData
            let data = UIImageJPEGRepresentation(image, 0.1)
            
            
            //图片保存的路径
            //这里将图片放在沙盒的documents文件夹中
            
            //Home目录
            let homeDirectory = NSHomeDirectory()
            let documentPath = homeDirectory + "/Documents"
            //文件管理器
            let fileManager: FileManager = FileManager.default
            //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
            do {
                try fileManager.createDirectory(atPath: documentPath, withIntermediateDirectories: true, attributes: nil)
            }
            catch _ {
            }
            fileManager.createFile(atPath: String.init(format: "%@/image.png", documentPath), contents: data, attributes: nil)
            //得到选择后沙盒中图片的完整路径
            let filePath: String = String(format: "%@%@", documentPath, "/image.png")
            print("filePath:" + filePath)
            
            let upImg = UIImage.bundlePath(filePath)
            //上传骑牛 image
            let hud = MBMasterHUD.showProgress(view: self.view, title: "上传中...")
            UploadImageTool.uploadImage(image: upImg!, progress: { (url, proess) in
                Util.UpLoadProgres(progressNum: CGFloat(proess), hud: hud)
            }, success: { [weak self] (url) in
                
                
                self?.myImageView.sd_setImage(with: URL.init(string: (url) ?? "https://sds"), placeholderImage: UIImage.init(named: "comment_profile_default.png"), options: SDWebImageOptions.avoidAutoSetImage) { (img, erro, type, url) in
                    if img != nil {
                        
                        self?.myImageView.image = img
                        
                        if (img?.size.width)! > kScreenW {
                            self?.myImageView.frame = CGRect.init(x: 0, y: 0, width: kScreenW, height: (self?.view.height)!)
                        }else {
                            self?.myImageView.frame = CGRect.init(x: kScreenW/2 - (img?.size.width)!/2, y: kScreenH/2 - (img?.size.height)!/2, width: (img?.size.width)!, height: (img?.size.height)!)
                        }
                    }
                }
                
                //更新用户信息
                let userinfo = UserUtil.share.appUserInfo
                let params = NSMutableDictionary()
                params.setValue(url, forKey: "head_portrait")
                params.setValue(userinfo?.zh_name, forKey: "zh_name")
                ApiUtil.share.updateInfo(params: params, fininsh: { (status, data, msg) in
                    UserUtil.share.saveUser(userInfo: data)
                    Util.msg(msg: "更改成功", type: .Successful)
                })
                
            }, failure: { msg in
                Util.msg(msg: msg, type: .Error)
            })
        
        }
        
        
        picker.dismiss(animated: true, completion: nil)
    }

}
