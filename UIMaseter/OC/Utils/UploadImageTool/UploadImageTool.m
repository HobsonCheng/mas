//
//  UploadImageTool.m
//  SportJX
//
//  Created by Chendy on 15/12/22.
//  Copyright © 2015年 Chendy. All rights reserved.
//

#import "UploadImageTool.h"
#import "QiniuUploadHelper.h"


#define QiNiuBaseUrl    @"http://omzvdb61q.bkt.clouddn.com/"
@implementation UploadImageTool


#pragma mark - Helpers
//给图片命名

+ (NSString *)getDateTimeString {
    
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    
    return dateString;
}


+ (NSString *)randomStringWithLength:(int)len {
    
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i = 0; i<len; i++) {
        
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    
    return randomString;
}


//上传单张图片
+ (void)uploadImage:(UIImage *)image progress:(QNUpProgressHandler)progress success:(void (^)(NSString *url))success failure:(void (^)())failure {
    
    [UploadImageTool getQiniuUploadToken:^(NSString *token) {
        
        NSData *data = UIImageJPEGRepresentation(image, 0.01);
        
        if (!data) {
            
            if (failure) {
                
                failure();
            }
            return;
        }
        
        NSString *fileName = [NSString stringWithFormat:@"%@_%@.png", [UploadImageTool getDateTimeString], [UploadImageTool randomStringWithLength:8]];
        
        QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:nil
                                                   progressHandler:progress
                                                            params:nil
                                                          checkCrc:NO
                                                cancellationSignal:nil];
        QNUploadManager *uploadManager = [QNUploadManager sharedInstanceWithConfiguration:nil];
        
        [uploadManager putData:data
                           key:fileName
                         token:token
                      complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                          
                          if (info.statusCode == 200 && resp) {
                              NSString *url= [NSString stringWithFormat:@"%@%@", QiNiuBaseUrl, resp[@"key"]];
                              if (success) {
                                  
                                  success(url);
                              }
                          }
                          else {
                              if (failure) {
                                  
                                  failure();
                              }
                          }
            
        } option:opt];
        
    } failure:^{
        
    }];
    
}

//上传多张图片
+ (void)uploadImages:(NSArray *)imageArray progress:(void (^)(CGFloat))progress success:(void (^)(NSArray *))success failure:(void (^)())failure {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    __block CGFloat totalProgress = 0.0f;
    __block CGFloat partProgress = 1.0f / [imageArray count];
    __block NSUInteger currentIndex = 0;
    
    QiniuUploadHelper *uploadHelper = [QiniuUploadHelper sharedUploadHelper];
    __weak typeof(uploadHelper) weakHelper = uploadHelper;
    
    uploadHelper.singleFailureBlock = ^() {
        failure();
        return;
    };
    uploadHelper.singleSuccessBlock  = ^(NSString *url) {
        [array addObject:url];
        totalProgress += partProgress;
        progress(totalProgress);
        currentIndex++;
        if ([array count] == [imageArray count]) {
            success([array copy]);
            return;
        }
        else {
            NSLog(@"---%ld",(unsigned long)currentIndex);
            
            if (currentIndex<imageArray.count) {
                
                 [UploadImageTool uploadImage:imageArray[currentIndex] progress:nil success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
            }
           
        }
    };
    
    [UploadImageTool uploadImage:imageArray[0] progress:nil success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
}

//获取七牛的token
+ (void)getQiniuUploadToken:(void (^)(NSString *))success failure:(void (^)())failure {
    
    NSString *getTokenApi = @"http://121.42.154.36:11124/getuptoken";
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:getTokenApi]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        
        success([[jsonDict objectForKey:@"data"] objectForKey:@"token"]);
    }];
    
    [dataTask resume];
}


@end
