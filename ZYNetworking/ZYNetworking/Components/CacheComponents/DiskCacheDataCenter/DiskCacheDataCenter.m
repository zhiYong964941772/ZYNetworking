//
//  DiskCacheDataCenter.m
//  ZYNetworking
//
//  Created by evan on 2020/1/17.
//  Copyright © 2020 evan. All rights reserved.
//

#import "DiskCacheDataCenter.h"
#import "ZYURLResponse.h"
NSString * const DiskCacheCenterCachedObjectKeyPrefix = @"DiskCacheCenterCachedObjectKeyPrefix";

@implementation DiskCacheDataCenter
- (ZYURLResponse *)fetchCachedRecordWithKey:(NSString *)key
{
    NSString *actualKey = [NSString stringWithFormat:@"%@%@",DiskCacheCenterCachedObjectKeyPrefix, key];
    ZYURLResponse *response = nil;
    NSData *data = [[NSUserDefaults standardUserDefaults] dataForKey:actualKey];
    if (data) {
        NSDictionary *fetchedContent = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSNumber *lastUpdateTimeNumber = fetchedContent[@"lastUpdateTime"];
        NSDate *lastUpdateTime = [NSDate dateWithTimeIntervalSince1970:lastUpdateTimeNumber.doubleValue];
        NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:lastUpdateTime];
        if (timeInterval < [fetchedContent[@"cacheTime"] doubleValue]) {
            response = [[ZYURLResponse alloc] initWithData:[NSJSONSerialization dataWithJSONObject:fetchedContent[@"content"] options:0 error:NULL]];
        } else {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:actualKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    return response;
}

- (void)saveCacheWithResponse:(ZYURLResponse *)response key:(NSString *)key cacheTime:(NSTimeInterval)cacheTime
{
    if (response.content) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:@{
                                                                 @"content":response.content,
                                                                 @"lastUpdateTime":@([NSDate date].timeIntervalSince1970),
                                                                 @"cacheTime":@(cacheTime)
                                                                 }
                                                       options:0
                                                         error:NULL];
        if (data) {
            NSString *actualKey = [NSString stringWithFormat:@"%@%@",DiskCacheCenterCachedObjectKeyPrefix, key];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:actualKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

- (void)cleanAll
{
    NSDictionary *defaultsDict = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];//获取当前app所有硬盘文件
    NSArray *keys = [[defaultsDict allKeys] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", DiskCacheCenterCachedObjectKeyPrefix]];//获取对应的缓存
    for(NSString *key in keys) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
