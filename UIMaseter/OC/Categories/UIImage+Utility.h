//
//  UIImage+Utility.h
//  UIMaster
//
//  Created by bai on 16/5/19.
//  Copyright © 2016年 com.UIMaster.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utility)

/**
 *  使用 xxx.bundle/xxx.png 这样的path来获取UIImage对象的方法
 *
 *  @param path 图片文件所在的Path
 *
 *  @return 返回UIImage对象
 */
+ (UIImage *)imageWithBundlePath:(NSString *)path;

+(UIImage*)grayscale:(UIImage*)anImage type:(char)type;


+ (UIImage *)imageFromColor:(UIColor *)color;
@end
