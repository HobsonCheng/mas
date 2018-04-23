//
//  NSString+URL.m
//  UIMaster
//
//  Created by bai on 16/6/20.
//  Copyright © 2016年 com.UIMaster.com. All rights reserved.
//

#import "NSString+URL.h"

@implementation NSString (URL)


#pragma mark URLEncoding
- (NSString *)URLEncodedString
{
    NSString *result = (__bridge_transfer NSString *)
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            NULL,
                                            CFSTR("!*'();:@&;=+$,/?%#[] "),
                                            kCFStringEncodingUTF8);
    return result;
}

- (NSString*)URLDecodedString
{
    NSString *result = (__bridge_transfer NSString *)
    CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                            (CFStringRef)self,
                                                            CFSTR(""),
                                                            kCFStringEncodingUTF8);
    return result;
}

#pragma mark XQueryComponents
- (NSString *)stringByDecodingURLFormat
{
    NSString *result = [self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return result;
}

- (NSString *)stringByEncodingURLFormat
{
    NSString *result = [self stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    result = [result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return result;
}

- (NSDictionary *)dictionaryFromQueryComponents
{
    NSMutableDictionary *queryComponents = [NSMutableDictionary dictionary];
    
    for(NSString *keyValuePairString in [self componentsSeparatedByString:@"&"])
    {
        NSArray *keyValuePairArray = [keyValuePairString componentsSeparatedByString:@"="];
        if ([keyValuePairArray count] < 2) continue; // Verify that there is at least one key, and at least one value.  Ignore extra = signs
        NSString *key = [[keyValuePairArray objectAtIndex:0] stringByDecodingURLFormat];
        if (key == nil)
        {
            key = [keyValuePairArray objectAtIndex:0];
        }
        NSString *value = [[keyValuePairArray objectAtIndex:1] stringByDecodingURLFormat];
        if (value == nil)
        {
            value = [keyValuePairArray objectAtIndex:1];
        }
        NSMutableArray *results = [queryComponents objectForKey:key]; // URL spec says that multiple values are allowed per key
        
        if(!results) // First object
        {
            [queryComponents setObject:value forKey:key];
        }
    }
    
    return queryComponents;
}


@end
