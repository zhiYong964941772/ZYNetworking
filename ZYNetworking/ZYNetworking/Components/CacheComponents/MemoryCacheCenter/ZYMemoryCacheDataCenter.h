//
//  ZYMemoryCacheDataCenter.h
//  ZYNetworking
//
//  Created by evan on 2020/1/17.
//  Copyright © 2020 evan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class ZYURLResponse;
@interface ZYMemoryCacheDataCenter : NSObject
- (ZYURLResponse *)fetchCachedRecordWithKey:(NSString *)key; //根据对应的key返回对应的response
- (void)saveCacheWithResponse:(ZYURLResponse *)response key:(NSString *)key cacheTime:(NSTimeInterval)cacheTime;  //保存
- (void)cleanAll; //清除所有
@end

@interface ZYMemoryCacheRecord : NSObject
@property (nonatomic, copy, readonly) NSData *content;
@property (nonatomic, copy, readonly) NSDate *lastUpdateTime;
@property (nonatomic, assign) NSTimeInterval cacheTime;

@property (nonatomic, assign, readonly) BOOL isOutdated;
@property (nonatomic, assign, readonly) BOOL isEmpty;

- (instancetype)initWithContent:(NSData *)content;
- (void)updateContent:(NSData *)content;
@end

NS_ASSUME_NONNULL_END
