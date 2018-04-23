//
//  NSBundle+Module.m
//  UIMaster
//
//  Created by bai on 16/5/19.
//  Copyright © 2016年 com.UIMaster.com. All rights reserved.
//

#import "NSBundle+Module.h"

#define MAX_SUPPORT_SCREEN_SCALE            3

static NSMutableDictionary *g_moduleBundleMap;

@implementation NSBundle (Module)

+ (NSString *)B_BundlePath
{
    return [[NSBundle mainBundle] bundlePath];
}

+ (instancetype)bundleWithModuleName:(NSString *)moduleName
{
    if (g_moduleBundleMap == nil)
    {
        g_moduleBundleMap = [[NSMutableDictionary alloc] init];
    }
    
    if (moduleName == nil)
    {
        return nil;
    }
    
    NSBundle *bundle = [g_moduleBundleMap objectForKey:moduleName];
    
    if (bundle != nil)
    {
        return bundle;
    }
    
    bundle = [NSBundle searchBundleWithModuleName:moduleName];
    
    
    if (bundle != nil)
    {
        [g_moduleBundleMap setObject:bundle forKey:moduleName];
    }
    
    return bundle;
}

+ (instancetype)searchBundleWithModuleName:(NSString *)moduleName
{
    if (moduleName == nil || [moduleName length] <= 0)
    {
        return nil;
    }
    
    NSBundle *bundle = nil;
    
    if (bundle == nil && [moduleName hasSuffix:@".bundle"] == YES)
    {
        bundle = [NSBundle bundleWithPath:[NSString stringWithFormat:@"%@/%@", [NSBundle B_BundlePath], moduleName]];
    }
    
    if (bundle == nil && [moduleName hasSuffix:@".framework"] == YES)
    {
        bundle = [NSBundle bundleWithPath:[NSString stringWithFormat:@"%@/%@", [NSBundle B_BundlePath], moduleName]];
    }
    
    if (bundle == nil)
    {
        bundle = [NSBundle bundleWithPath:[NSString stringWithFormat:@"%@/%@.bundle", [NSBundle B_BundlePath], moduleName]];
    }
    
    if (bundle == nil)
    {
        bundle = [NSBundle bundleWithPath:[NSString stringWithFormat:@"%@/%@Bundle.bundle", [NSBundle B_BundlePath], moduleName]];
    }
    
    if (bundle == nil)
    {
        bundle = [NSBundle bundleWithPath:[NSString stringWithFormat:@"%@/%@.framework", [NSBundle B_BundlePath], moduleName]];
    }
    
    return bundle;
}

+ (NSString *)pathWihResource:(NSString *)resourceName inModule:(NSString *)moduleName;
{
    if (resourceName == nil || [resourceName length] <= 0)
    {
        return nil;
    }
    
    NSBundle *bundle = [NSBundle bundleWithModuleName:moduleName];
    
    if (bundle == nil)
    {
        return nil;
    }
    
    NSString *path = nil;
    
    NSString *resourceExtension = [resourceName pathExtension];
    NSString *resourceNoExtension = [resourceName stringByDeletingPathExtension];
    if (resourceExtension != nil && [[resourceExtension lowercaseString] isEqualToString:@"png"] == YES)
    {
        NSInteger scale = [[UIScreen mainScreen] scale];
        
        path = [bundle pathForResource:[NSString stringWithFormat:@"%@@%ldx", resourceNoExtension, (long)scale] ofType:resourceExtension];
        
        if (path == nil)
        {
            for (NSInteger i = MAX_SUPPORT_SCREEN_SCALE; i > 0; i--)
            {
                path = [bundle pathForResource:[NSString stringWithFormat:@"%@@%ldx", resourceNoExtension, (long)i] ofType:resourceExtension];
                
                if (path != nil)
                {
                    break;
                }
            }
        }
    }
    
    if (path == nil)
    {
        path = [bundle pathForResource:resourceNoExtension ofType:resourceExtension];
    }
    
    if (path == nil)
    {
        if (resourceExtension != nil && [[resourceExtension lowercaseString] isEqualToString:@"png"] == YES)
        {
            path = [bundle pathForResource:resourceNoExtension ofType:@"tiff"];
        }
    }
    
    return path;
}

@end
