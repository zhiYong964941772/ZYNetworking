//
//  ZYMemoryCacheDataCenter.m
//  ZYNetworking
//
//  Created by evan on 2020/1/17.
//  Copyright © 2020 evan. All rights reserved.
//

#import "ZYMemoryCacheDataCenter.h"
#import "ZYURLResponse.h"
#import "CTMediator+ZYAppContext.h"
@interface ZYMemoryCacheDataCenter()
@property (nonatomic, strong) NSCache *cache;
@end
@implementation ZYMemoryCacheDataCenter
#pragma mark -- public method
- (void)saveCacheWithResponse:(ZYURLResponse *)response key:(NSString *)key cacheTime:(NSTimeInterval)cacheTime{
    ZYMemoryCacheRecord *cacheRecord = [self.cache objectForKey:key];
    if (cacheRecord == nil) {
        cacheRecord = [[ZYMemoryCacheRecord alloc]init];
    }
    cacheRecord.cacheTime = cacheTime;
    [cacheRecord updateContent:[NSJSONSerialization dataWithJSONObject:response.content options:0 error:NULL]];
    [self.cache setObject:cacheRecord forKey:key];
}
- (ZYURLResponse *)fetchCachedRecordWithKey:(NSString *)key{
    ZYURLResponse *result = nil;
    ZYMemoryCacheRecord *cacheRecord = [self.cache objectForKey:key];
    if (cacheRecord != nil) {
        if (cacheRecord.isOutdated || cacheRecord.isEmpty) {
            [self.cache removeObjectForKey:key];
        }else{
            result = [[ZYURLResponse alloc]initWithData:cacheRecord.content];
        }
    }
    return result;
}
- (void)cleanAll{
    [self.cache removeAllObjects];
}
#pragma mark -- getter and setter
- (NSCache *)cache{
    if (!_cache) {
        _cache = [[NSCache alloc]init];
        _cache.countLimit = [[CTMediator sharedInstance]ZYNetworking_cacheResponseCountLimit];
    }
    return _cache;
}
@end



@interface ZYMemoryCacheRecord()
@property (nonatomic, copy, readwrite) NSData *content;
@property (nonatomic, copy, readwrite) NSDate *lastUpdateTime;
@end
@implementation ZYMemoryCacheRecord
#pragma mark - getters and setters
- (BOOL)isEmpty
{
    return self.content == nil;
}
//判断缓存时间是否已过最大缓存时间区间
- (BOOL)isOutdated
{
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastUpdateTime];
    return timeInterval > self.cacheTime;
}

- (void)setContent:(NSData *)content
{
    _content = [content copy];
    self.lastUpdateTime = [NSDate dateWithTimeIntervalSinceNow:0];
}

#pragma mark - life cycle
- (instancetype)initWithContent:(NSData *)content
{
    self = [super init];
    if (self) {
        self.content = content;
    }
    return self;
}

#pragma mark - public method
- (void)updateContent:(NSData *)content
{
    self.content = content;
}


@end
