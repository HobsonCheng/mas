//
//  NSMutableDictionary+Utility.h
//  UIMaster
//
//  Created by baiqilong on 16/6/15.
//  Copyright © 2016年 com.UIMaster.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Utility)

- (void)setSafeObject:(id)anObject forKey:(id<NSCopying>)aKey;

@end
