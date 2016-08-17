//
//  NetWorkUtil.m
//  iAuction
//
//  Created by shen on 14-11-28.
//  Copyright (c) 2014年 huipinzhe. All rights reserved.
//

#import "NetWorkUtil.h"
#define REPEAT_CONNECTION_COUNT 3

@implementation NetWorkUtil

#pragma mark
+ (void)get:(NSString *)url success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];//设置相应内容类型
    
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getWithRepeatConnection:(NSString *)url repeatCount:(NSInteger)count success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    [NetWorkUtil get:url success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        if (count < REPEAT_CONNECTION_COUNT) {
            [NetWorkUtil getWithRepeatConnection:url repeatCount:(count +1) success:success failure:failure];
        }else{
            if (failure) {
                failure(error);
            }
        }
    }];
}

+ (void)post:(NSString *)url parameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"text/html", @"application/json",@"*/*"]];//设置相应内容类型
    
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)postWithRepeatConnection:(NSString *)url parameters:(NSDictionary *)parameters repeatCount:(NSInteger)count success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failur
{
    [NetWorkUtil post:url parameters:parameters success:^(id responseObject) {
        success(responseObject);
    } failure:^(NSError *error) {
        if (count < REPEAT_CONNECTION_COUNT) {
            [NetWorkUtil postWithRepeatConnection:url parameters:parameters repeatCount:(count + 1) success:success failure:failur];
        }else{
            if (failur) {
                failur(error);
            }
        }
    }];
}

+ (void)post:(NSString *)url imageData:(NSData *)imageData parameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];//设置相应内容类型
    
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFormData:imageData name:@"Filedata"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        NSLog(@"Error: %@", error);
    }];
    
}

+ (void)post:(NSString *)url filePath:(NSString *)file fileType:(NSString *)fileType parameters:(NSDictionary *)parameters success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];//设置相应内容类型
    NSURL *filePath = [NSURL fileURLWithPath:file];
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileURL:filePath name:fileType error:nil];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        NSLog(@"Error: %@", error);
    }];
    
}



@end
