//
//  ZYCacheCenter.h
//  ZYNetworking
//
//  Created by evan on 2020/1/17.
//  Copyright © 2020 evan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class ZYURLResponse;
@interface ZYCacheCenter : NSObject
+ (instancetype)sharedInstance;

- (ZYURLResponse *)fetchDiskCacheWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName params:(NSDictionary *)params;
- (ZYURLResponse *)fetchMemoryCacheWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName params:(NSDictionary *)params;

- (void)saveDiskCacheWithResponse:(ZYURLResponse *)response serviceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName cacheTime:(NSTimeInterval)cacheTime;
- (void)saveMemoryCacheWithResponse:(ZYURLResponse *)response serviceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName cacheTime:(NSTimeInterval)cacheTime;

- (void)cleanAllMemoryCache;
- (void)cleanAllDiskCache;
@end

NS_ASSUME_NONNULL_END
