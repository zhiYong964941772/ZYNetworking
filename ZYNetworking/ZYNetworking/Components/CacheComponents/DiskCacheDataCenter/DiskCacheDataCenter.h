//
//  DiskCacheDataCenter.h
//  ZYNetworking
//
//  Created by evan on 2020/1/17.
//  Copyright © 2020 evan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZYURLResponse;
NS_ASSUME_NONNULL_BEGIN

@interface DiskCacheDataCenter : NSObject
- (ZYURLResponse *)fetchCachedRecordWithKey:(NSString *)key;
- (void)saveCacheWithResponse:(ZYURLResponse *)response key:(NSString *)key cacheTime:(NSTimeInterval)cacheTime;
- (void)cleanAll;
@end

NS_ASSUME_NONNULL_END
