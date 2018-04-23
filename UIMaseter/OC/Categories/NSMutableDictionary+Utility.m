//
//  NSMutableDictionary+Utility.m
//  UIMaster
//
//  Created by baiqilong on 16/6/15.
//  Copyright © 2016年 com.UIMaster.com. All rights reserved.
//

#import "NSMutableDictionary+Utility.h"

@implementation NSMutableDictionary (Utility)

- (void)setSafeObject:(id)anObject forKey:(id<NSCopying>)aKey{
    if (anObject) {
        [self setObject:anObject forKey:aKey];
    }
}

@end
