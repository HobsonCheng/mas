//
//  UIImageView+GIFDecode.m
//  UIMaster
//
//  Created by bai on 16/7/7.
//  Copyright © 2016年 com.UIMaster.com. All rights reserved.
//

#import "UIImageView+GIFDecode.h"
#import <ImageIO/ImageIO.h>

@implementation UIImageView (GIFDecode)

-(void)decodeWithData:(NSData *)data
{
    // 设置动画图片
    NSMutableArray *arrayImages = [[NSMutableArray alloc] init];
    
    CGImageSourceRef src = CGImageSourceCreateWithData((CFDataRef) data, NULL);
    if (src)
    {
        //获取gif的帧数
        NSUInteger frameCount = CGImageSourceGetCount(src);
        //获取GfiImage的基本数据
        NSDictionary *gifProperties = (NSDictionary *) CFBridgingRelease(CGImageSourceCopyProperties(src, NULL));
        if(gifProperties)
        {
            for (NSUInteger i = 0; i < frameCount; i++)
            {
                //得到每一帧的CGImage
                CGImageRef img = CGImageSourceCreateImageAtIndex(src, (size_t) i, NULL);
                if (img)
                {
                    //把CGImage转化为UIImage
                    UIImage *frameImage = [UIImage imageWithCGImage:img];
                
                    
                    
                    [arrayImages addObject:frameImage];
                    
                    CGImageRelease(img);
                }
            }
            CFRelease((__bridge CFTypeRef)(gifProperties));
        }
    }
    self.animationImages = arrayImages;
    self.animationDuration = 2 ;
    self.animationRepeatCount = 0;
    [self startAnimating];
}


@end
