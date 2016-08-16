//
//  NetWorkUtil.h
//  iAuction
//
//  Created by shen on 14-11-28.
//  Copyright (c) 2014年 huipinzhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface NetWorkUtil : NSObject

+ (void)post:(NSString *)url imageData:(NSData *)imageData parameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
+ (void)post:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
+ (void)postWithRepeatConnection:(NSString *)url parameters:(NSDictionary *)parameters repeatCount:(NSInteger)count success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failur;
+ (void)get:(NSString *)url success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
+ (void)getWithRepeatConnection:(NSString *)url repeatCount:(NSInteger)count success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+ (void)post:(NSString *)url filePath:(NSString *)file fileType:(NSString *)fileType parameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
@end
