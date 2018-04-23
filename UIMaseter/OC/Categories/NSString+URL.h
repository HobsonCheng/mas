//
//  NSString+URL.h
//  UIMaster
//
//  Created by bai on 16/6/20.
//  Copyright © 2016年 com.UIMaster.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URL)

/// @name URL Encode/Decode

/**
 *  对 NSString 内容进行URL Encode
 *
 *  @return 返回Encod后的字符串
 */
- (NSString *)URLEncodedString;

/**
 *  对 NSString 的内容进行 URL Decode
 *
 *  @return 返回Decode后的字符串
 */
- (NSString *)URLDecodedString;

/// @name XQueryComponents

/**
 *  对 NSString 的内容进行 URL Decode
 *
 *  @return 返回Decode后的字符串
 */
- (NSString *)stringByDecodingURLFormat;

/**
 *  对 NSString 内容进行URL Encode
 *
 *  @return 返回Encod后的字符串
 */
- (NSString *)stringByEncodingURLFormat;

/**
 *  将URL中的 Query 转换为 NSDictionary, 对于参数中不带＝的，用@“”作为参数值
 *
 *  @return 返回转换后的NSDictionary，nil表示转换失败或无query
 */
- (NSDictionary *)dictionaryFromQueryComponents;

@end
