//
//  ZYCacheCenter.m
//  ZYNetworking
//
//  Created by evan on 2020/1/17.
//  Copyright © 2020 evan. All rights reserved.
//

#import "ZYCacheCenter.h"
#import "ZYURLResponse.h"
#import "ZYMemoryCacheDataCenter.h"
#import "DiskCacheDataCenter.h"
#import "ZYLogger.h"
#import "ZYServiceFactory.h"
#import "NSDictionary+ZYNetWorkingMethods.h"
@interface ZYCacheCenter ()

@property (nonatomic, strong) ZYMemoryCacheDataCenter *memoryCacheCenter;
@property (nonatomic, strong) DiskCacheDataCenter *diskCacheCenter;

@end

@implementation ZYCacheCenter
#pragma mark --- lift cycle
+ (instancetype)sharedInstance{
    static ZYCacheCenter *cacheCenter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cacheCenter = [[ZYCacheCenter alloc]init];
    });
    return cacheCenter;
}
#pragma mark -- public method
- (ZYURLResponse *)fetchDiskCacheWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName params:(NSDictionary *)params
{
    ZYURLResponse *response = [self.diskCacheCenter fetchCachedRecordWithKey:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:params]];
    if (response) {
        response.logString = [ZYLogger logDebugInfoWithCachedResponse:response methodName:methodName service:[[ZYServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier] params:params];
    }
    return response;
}

- (ZYURLResponse *)fetchMemoryCacheWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName params:(NSDictionary *)params
{
    ZYURLResponse *response = [self.memoryCacheCenter fetchCachedRecordWithKey:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:params]];
    if (response) {
        response.logString = [ZYLogger logDebugInfoWithCachedResponse:response methodName:methodName service:[[ZYServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier] params:params];
    }
    return response;
}

- (void)saveDiskCacheWithResponse:(ZYURLResponse *)response serviceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName cacheTime:(NSTimeInterval)cacheTime
{
    if (response.originRequestParams && response.content && serviceIdentifier && methodName) {
        [self.diskCacheCenter saveCacheWithResponse:response key:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:response.originRequestParams] cacheTime:cacheTime];
    }
}

- (void)saveMemoryCacheWithResponse:(ZYURLResponse *)response serviceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName cacheTime:(NSTimeInterval)cacheTime
{
    if (response.originRequestParams && response.content && serviceIdentifier && methodName) {
        [self.memoryCacheCenter saveCacheWithResponse:response key:[self keyWithServiceIdentifier:serviceIdentifier methodName:methodName requestParams:response.originRequestParams] cacheTime:cacheTime];
    }
}

- (void)cleanAllDiskCache
{
    [self.diskCacheCenter cleanAll];
}

- (void)cleanAllMemoryCache
{
    [self.memoryCacheCenter cleanAll];
}
#pragma mark - private methods
- (NSString *)keyWithServiceIdentifier:(NSString *)serviceIdentifier
                            methodName:(NSString *)methodName
                         requestParams:(NSDictionary *)requestParams
{
    NSString *key = [NSString stringWithFormat:@"%@%@%@", serviceIdentifier, methodName, [requestParams ZY_transformToUrlParamString]];
    return key;
}
#pragma mark - getters and setters
- (DiskCacheDataCenter *)diskCacheCenter
{
    if (_diskCacheCenter == nil) {
        _diskCacheCenter = [[DiskCacheDataCenter alloc] init];
    }
    return _diskCacheCenter;
}

- (ZYMemoryCacheDataCenter *)memoryCacheCenter
{
    if (_memoryCacheCenter == nil) {
        _memoryCacheCenter = [[ZYMemoryCacheDataCenter alloc] init];
    }
    return _memoryCacheCenter;
}

@end
