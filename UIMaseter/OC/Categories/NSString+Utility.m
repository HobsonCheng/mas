//
//  NSString+Utility.m
//  UIMaster
//
//  Created by bai on 16/5/16.
//  Copyright © 2016年 com.UIMaster.com. All rights reserved.
//

#import "zlib.h"
#import "NSString+Utility.h"
#import <CommonCrypto/CommonHMAC.h>

@implementation NSString (Utility)

#pragma mark Encoding
- (NSString *)getSHA1
{
    // 分配hash结果空间
    uint8_t *hashBytes = malloc(CC_SHA1_DIGEST_LENGTH * sizeof(uint8_t));
    if(hashBytes)
    {
        memset(hashBytes, 0x0, CC_SHA1_DIGEST_LENGTH);
        
        // 计算hash值
        NSData *srcData = [self dataUsingEncoding:NSUTF8StringEncoding];
        CC_SHA1((void *)[srcData bytes], (CC_LONG)[srcData length], hashBytes);
        
        // 组建String
        NSMutableString* destString = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
        for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        {
            [destString appendFormat:@"%02X", hashBytes[i]];
        }
        
        // 释放空间
        free(hashBytes);
        
        return destString;
    }
    
    return nil;
}

- (NSString *)getMD5
{
    // 分配MD5结果空间
    uint8_t *md5Bytes = malloc(CC_MD5_DIGEST_LENGTH * sizeof(uint8_t));
    if(md5Bytes)
    {
        memset(md5Bytes, 0x0, CC_MD5_DIGEST_LENGTH);
        
        // 计算hash值
        NSData *srcData = [self dataUsingEncoding:NSUTF8StringEncoding];
        CC_MD5((void *)[srcData bytes], (CC_LONG)[srcData length], md5Bytes);
        
        // 组建String
        NSMutableString* destString = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
        for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        {
            [destString appendFormat:@"%02X", md5Bytes[i]];
        }
        
        // 释放空间
        free(md5Bytes);
        
        return destString;
    }
    
    return nil;
}

#pragma mark Valid
- (BOOL)isRangeValidFromIndex:(NSInteger)index withSize:(NSInteger)rangeSize
{
    NSUInteger stringLength = [self length];
    
    if ((stringLength - index) < rangeSize)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

#pragma mark -- get Random String
- (NSString *)getRandomStringByLength:(NSInteger)len
{
    if (len<=0) {
        return nil;
    }
    
    char data[len];
    //    for (int x=0;x<len;data[x++] = (char)('A' + (arc4random_uniform(26))));
    
    for (int x=0;x<len;)
    {
        int i = arc4random_uniform(3);
        if (i%3 == 0) {
            data[x++] = (char)('A' + (arc4random_uniform(26)));
        }
        else if (i%3 == 1)
        {
            data[x++] = (char)('a' + (arc4random_uniform(26)));
        }
        else
        {
            data[x++] = (char)('0' + (arc4random_uniform(10)));
        }
        
    }
    
    return [[NSString alloc] initWithBytes:data length:len encoding:NSUTF8StringEncoding];
    
}

+ (NSString*)getAppGroupID
{
    //获取Bundle identifier
    NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [dic objectForKey:@"CFBundleIdentifier"];
    
    // 查找第一个点
    NSRange range = [appName rangeOfString:@"."];
    // 取第一个点及后面的内容
    NSString* subString = [appName substringWithRange:NSMakeRange(range.location, [appName length]-range.location)];
    
    // 连接字符串
    NSString* appGroupName = [@"group" stringByAppendingString:subString];
    return appGroupName;
}


#pragma mark String2Date
- (NSString *)getYYMMDDFWW
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale * gregorianLocale = [[NSLocale alloc] initWithLocaleIdentifier:NSGregorianCalendar];
    [dateFormatter setLocale:gregorianLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *searchDate = [dateFormatter dateFromString:self];
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSUInteger weekday = [gregorianCalendar ordinalityOfUnit:
                          NSDayCalendarUnit inUnit:NSWeekCalendarUnit forDate:searchDate];
    NSString *weekdayText = nil;
    switch (weekday)
    {
        case 1:
            weekdayText = @"星期日";
            break;
        case 2:
            weekdayText = @"星期一";
            break;
        case 3:
            weekdayText = @"星期二";
            break;
        case 4:
            weekdayText = @"星期三";
            break;
        case 5:
            weekdayText = @"星期四";
            break;
        case 6:
            weekdayText = @"星期五";
            break;
        case 7:
            weekdayText = @"星期六";
            break;
            
            
        default:
            break;
    }
    NSString *defaultDateText  = [NSString stringWithFormat:@"%@ %@", self, weekdayText];
    return defaultDateText;
}

//隐藏替换部分
- (NSString *)getHidenPartString
{
    NSRange range = NSMakeRange(3, 4);
    if ([self length] < (range.location+range.length))
    {
        return self;
    }
    else
    {
        return  [self stringByReplacingCharactersInRange:range withString:@"****"];
    }
}

+ (NSString *)hashString:(NSString *)data withSalt:(NSString *)salt
{
    if (![data isStringSafe] || ![salt isStringSafe])
    {
        return nil;
    }
    
    const char *cKey  = [salt cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [data cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSString *hash;
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA256_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", cHMAC[i]];
    hash = output;
    
    return hash;
}

- (BOOL)isStringSafe
{
    return [self length] > 0;
}

#pragma mark Trim Space
- (NSString *)trimSpaceString
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

#pragma mark 适配函数
- (CGSize)sizeWithFontCompatible:(UIFont *)font
{
    if([self respondsToSelector:@selector(sizeWithAttributes:)] == YES && font)
    {
        NSDictionary *dictionaryAttributes = @{NSFontAttributeName:font};
        CGSize stringSize = [self sizeWithAttributes:dictionaryAttributes];
        return CGSizeMake(ceil(stringSize.width), ceil(stringSize.height));
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return [self sizeWithFont:font];
#pragma clang diagnostic pop
    }
}

- (CGSize)sizeWithFontCompatible:(UIFont *)font forWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    if([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)] == YES && font)
    {
        NSDictionary *dictionaryAttributes = @{NSFontAttributeName:font,};
        
        CGRect stringRect = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                               options:NSStringDrawingTruncatesLastVisibleLine
                                            attributes:dictionaryAttributes
                                               context:nil];
        
        CGFloat widthResult = stringRect.size.width;
        if(widthResult - width >= 0.0000001)
        {
            widthResult = width;
        }
        
        return CGSizeMake(widthResult, ceil(stringRect.size.height));
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return [self sizeWithFont:font forWidth:width lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
}

- (CGSize)sizeWithFontCompatible:(UIFont *)font constrainedToSize:(CGSize)size
{
    if([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)] == YES && font)
    {
        NSDictionary *dictionaryAttributes = @{NSFontAttributeName:font};
        CGRect stringRect = [self boundingRectWithSize:size
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:dictionaryAttributes
                                               context:nil];
        
        return CGSizeMake(ceil(stringRect.size.width), ceil(stringRect.size.height));
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return [self sizeWithFont:font constrainedToSize:size];
#pragma clang diagnostic pop
    }
}

- (CGSize)sizeWithFontCompatible:(UIFont *)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    if([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)] == YES && font)
    {
        NSDictionary *dictionaryAttributes = @{NSFontAttributeName:font,};
        CGRect stringRect = [self boundingRectWithSize:size
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:dictionaryAttributes
                                               context:nil];
        
        return CGSizeMake(ceil(stringRect.size.width), ceil(stringRect.size.height));
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return [self sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
}

- (void)drawAtPointCompatible:(CGPoint)point withFont:(UIFont *)font
{
    if([self respondsToSelector:@selector(drawAtPoint:withAttributes:)] == YES && font)
    {
        NSDictionary *dictionaryAttributes = @{NSFontAttributeName:font};
        [self drawAtPoint:point withAttributes:dictionaryAttributes];
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [self drawAtPoint:point withFont:font];
#pragma clang diagnostic pop
    }
}

- (void)drawInRectCompatible:(CGRect)rect withFont:(UIFont *)font
{
    if([self respondsToSelector:@selector(drawWithRect:options:attributes:context:)] == YES && font)
    {
        NSDictionary *dictionaryAttributes = @{NSFontAttributeName:font};
        [self drawWithRect:rect
                   options:NSStringDrawingUsesLineFragmentOrigin
                attributes:dictionaryAttributes
                   context:nil];
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [self drawInRect:rect withFont:font];
#pragma clang diagnostic pop
    }
}

- (void)drawInRectCompatible:(CGRect)rect withFont:(UIFont *)font lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment
{
    if([self respondsToSelector:@selector(drawWithRect:options:attributes:context:)] == YES && font)
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        [paragraphStyle setAlignment:alignment];
        NSDictionary *dictionaryAttributes = @{NSFontAttributeName:font,
                                               NSParagraphStyleAttributeName:paragraphStyle};
        [self drawWithRect:rect
                   options:NSStringDrawingUsesLineFragmentOrigin
                attributes:dictionaryAttributes
                   context:nil];
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [self drawInRect:rect withFont:font lineBreakMode:lineBreakMode alignment:alignment];
#pragma clang diagnostic pop
    }
}



// 十六进制转换为普通字符串的
- (NSString *)stringFromHexString:(NSString *)hexString
{
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    
    for (int i = 0; i < [hexString length] - 1; i += 2)
    {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    
    NSString *utf8String = [[NSString alloc] initWithCString:myBuffer encoding:NSUTF8StringEncoding];
    free(myBuffer);
    
    return utf8String;
}

//普通字符串转换为十六进制的
- (NSString *)hexStringFromString:(NSString *)string
{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    
    //下面是Byte 转换为16进制。
    NSMutableString *hexStr = [[NSMutableString alloc] initWithString:@""];
    for(int i=0;i<[myD length];i++)
    {
        ///16进制数
        NSString *newHexStr = [NSString stringWithFormat:@"%X",bytes[i]&0xff];
        
        if([newHexStr length]==1)
        {
            
            [hexStr appendFormat:@"0%@", newHexStr];
        }
        else
        {
            [hexStr appendFormat:@"%@", newHexStr];
        }
    }
    
    return hexStr;
}



/**
 *  @brief 计算文字的高度
 *
 *  @param font  字体(默认为系统字体)
 *  @param width 约束宽度
 */
- (CGFloat)heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width
{
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGSize textSize;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                     NSParagraphStyleAttributeName: paragraph};
        textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                      options:(NSStringDrawingUsesLineFragmentOrigin |
                                               NSStringDrawingTruncatesLastVisibleLine)
                                   attributes:attributes
                                      context:nil].size;
    } else {
        textSize = [self sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                  options:(NSStringDrawingUsesLineFragmentOrigin |
                                           NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                                  context:nil].size;
#endif
    
    return ceil(textSize.height);
}

/**
 *  @brief 计算文字的宽度
 *
 *  @param font   字体(默认为系统字体)
 *  @param height 约束高度
 */
- (CGFloat)widthWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height
{
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGSize textSize;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                     NSParagraphStyleAttributeName: paragraph};
        textSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                      options:(NSStringDrawingUsesLineFragmentOrigin |
                                               NSStringDrawingTruncatesLastVisibleLine)
                                   attributes:attributes
                                      context:nil].size;
    } else {
        textSize = [self sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(CGFLOAT_MAX, height)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                  options:(NSStringDrawingUsesLineFragmentOrigin |
                                           NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                                  context:nil].size;
#endif
    
    return ceil(textSize.width);
}

/**
 *  @brief 计算文字的大小
 *
 *  @param font  字体(默认为系统字体)
 *  @param width 约束宽度
 */
- (CGSize)sizeWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width
{
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGSize textSize;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                     NSParagraphStyleAttributeName: paragraph};
        textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                      options:(NSStringDrawingUsesLineFragmentOrigin |
                                               NSStringDrawingTruncatesLastVisibleLine)
                                   attributes:attributes
                                      context:nil].size;
    } else {
        textSize = [self sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                  options:(NSStringDrawingUsesLineFragmentOrigin |
                                           NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                                  context:nil].size;
#endif
    
    return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
}

/**
 *  @brief 计算文字的大小
 *
 *  @param font   字体(默认为系统字体)
 *  @param height 约束高度
 */
- (CGSize)sizeWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height
{
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    
    CGSize textSize;
    
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000
    if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                     NSParagraphStyleAttributeName: paragraph};
        textSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                      options:(NSStringDrawingUsesLineFragmentOrigin |
                                               NSStringDrawingTruncatesLastVisibleLine)
                                   attributes:attributes
                                      context:nil].size;
    } else {
        textSize = [self sizeWithFont:textFont
                    constrainedToSize:CGSizeMake(CGFLOAT_MAX, height)
                        lineBreakMode:NSLineBreakByWordWrapping];
    }
#else
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName: textFont,
                                 NSParagraphStyleAttributeName: paragraph};
    textSize = [self boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                  options:(NSStringDrawingUsesLineFragmentOrigin |
                                           NSStringDrawingTruncatesLastVisibleLine)
                               attributes:attributes
                                  context:nil].size;
#endif
    
    return CGSizeMake(ceil(textSize.width), ceil(textSize.height));
}


/**
 *  @brief  反转字符串
 *
 *  @param strSrc 被反转字符串
 *
 *  @return 反转后字符串
 */
+ (NSString *)reverseString:(NSString *)strSrc
{
    NSMutableString* reverseString = [[NSMutableString alloc] init];
    NSInteger charIndex = [strSrc length];
    while (charIndex > 0) {
        charIndex --;
        NSRange subStrRange = NSMakeRange(charIndex, 1);
        [reverseString appendString:[strSrc substringWithRange:subStrRange]];
    }
    return reverseString;
}


@end

