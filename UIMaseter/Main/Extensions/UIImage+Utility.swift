//
//  UIImage+Utility.swift
//  UIMaseter
//
//  Created by gongcz on 2018/4/17.
//  Copyright © 2018年 one2much. All rights reserved.
//

import UIKit

extension UIImage {
    class func bundlePath(_ path: String?) -> UIImage? {
        var image = UIImage(named: path ?? "")
        if image == nil {
            image = UIImage(contentsOfFile: path ?? "")
        }
        return image
    }
    
    class func grayscale(_ anImage: UIImage?, type: Int8) -> UIImage? {
//        var imageRef: CGImage?
        guard let imageRef: CGImage = anImage?.cgImage else {
            return nil
        }
        
        let width: size_t = imageRef.width
        let height: size_t = imageRef.height
        // ピクセルを構成するRGB各要素が何ビットで構成されている
        var bitsPerComponent: size_t
        bitsPerComponent = imageRef.bitsPerComponent
        // ピクセル全体は何ビットで構成されているか
        var bitsPerPixel: size_t
        bitsPerPixel = imageRef.bitsPerPixel
        // 画像の横1ライン分のデータが、何バイトで構成されているか
        var bytesPerRow: size_t
        bytesPerRow = imageRef.bytesPerRow
        // 画像の色空間
        var colorSpace: CGColorSpace?
        colorSpace = imageRef.colorSpace
        // 画像のBitmap情報
        var bitmapInfo: CGBitmapInfo
        bitmapInfo = imageRef.bitmapInfo
        // 画像がピクセル間の補完をしているか
        var shouldInterpolate: Bool
        shouldInterpolate = imageRef.shouldInterpolate
        // 表示装置によって補正をしているか
        var intent: CGColorRenderingIntent
        intent = imageRef.renderingIntent
        // 画像のデータプロバイダを取得する
        var dataProvider: CGDataProvider?
        dataProvider = imageRef.dataProvider
        // TODO: swift4无法操作指针
        // データプロバイダから画像のbitmap生データ取得
        var data: CFData?
        var buffer: UnsafePointer<UInt8>?
        data = dataProvider?.data
        buffer = CFDataGetBytePtr(data)
//        let bytes = buffer.mem
        // 1ピクセルずつ画像を処理
        for y in 0..<Int(height) {
            for x in 0..<Int(width) {
                var tmp: UnsafeMutablePointer<UInt8>!
                tmp = UnsafeMutablePointer(mutating: buffer!) + y * bytesPerRow + x * 4
                // RGBAの4つ値をもっているので、1ピクセルごとに*4してずらす
                // RGB値を取得
                var red: UInt8
                var green: UInt8
                var blue: UInt8
                red = (tmp + 0).pointee
                green = (tmp + 1).pointee
                blue = (tmp + 2).pointee
                
                switch type {
                case 1:
                    //モノクロ
                    // 輝度計算
                    let brightness: UInt8 = red
                    (tmp + 0).pointee = brightness
                    (tmp + 1).pointee = brightness
                    (tmp + 2).pointee = brightness
                case 2:
                    //セピア
                    (tmp + 0).pointee = red
                    (tmp + 1).pointee = UInt8(Double(green) * 0.7)
                    (tmp + 2).pointee = UInt8(Double(blue) * 0.4)
                case 3:
                    //色反転
                    (tmp + 0).pointee = 255 - red
                    (tmp + 1).pointee = 255 - green
                    (tmp + 2).pointee = 255 - blue
                default:
                    (tmp + 0).pointee = red
                    (tmp + 1).pointee = green
                    (tmp + 2).pointee = blue
                }
            }
        }
        // 効果を与えたデータ生成
        var effectedData: CFData?
        effectedData = CFDataCreate(nil, buffer, CFDataGetLength(data))
        // 効果を与えたデータプロバイダを生成
        var effectedDataProvider: CGDataProvider?
        effectedDataProvider = CGDataProvider(data: effectedData!)
        // 画像を生成
        var effectedCgImage: CGImage?
        var effectedImage: UIImage?
        effectedCgImage = CGImage(width: width, height: height, bitsPerComponent: bitsPerComponent, bitsPerPixel: bitsPerPixel, bytesPerRow: bytesPerRow, space: colorSpace!, bitmapInfo: bitmapInfo, provider: effectedDataProvider!, decode: nil, shouldInterpolate: shouldInterpolate, intent: intent)
        if let anImage = effectedCgImage {
            effectedImage = UIImage(cgImage: anImage)
        }
        // データの解放
//        CGImageRelease(effectedCgImage!)
        return effectedImage
    }
    
    /// 彩色图片置灰，灰度图片
    public func grayImage(sourceImage : UIImage) -> UIImage{
        UIGraphicsBeginImageContext(self.size)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let context = CGContext(data: nil , width: Int(self.size.width), height: Int(self.size.height),bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.none.rawValue)
        context?.draw(sourceImage.cgImage!, in: CGRect.init(x: 0, y: 0, width: sourceImage.size.width, height: sourceImage.size.height))
        let cgImage = context!.makeImage()
        let grayImage = UIImage.init(cgImage: cgImage!)
        return grayImage
    }
    
    static func from(_ color: UIColor?) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor((color?.cgColor)!)
        context?.fill(rect)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}
