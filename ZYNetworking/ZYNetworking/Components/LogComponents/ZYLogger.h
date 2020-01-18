//
//  ZYLogger.h
//  ZYNetworking
//
//  Created by evan on 2020/1/17.
//  Copyright © 2020 evan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYServiceProtocol.h"
@class ZYURLResponse;
NS_ASSUME_NONNULL_BEGIN

@interface ZYLogger : NSObject
+ (NSString *)logDebugInfoWithRequest:(NSURLRequest *)request apiName:(NSString *)apiName service:(id <ZYServiceProtocol>)service;
+ (NSString *)logDebugInfoWithResponse:(NSHTTPURLResponse *)response responseObject:(id)responseObject responseString:(NSString *)responseString request:(NSURLRequest *)request error:(NSError *)error;
+ (NSString *)logDebugInfoWithCachedResponse:(ZYURLResponse *)response methodName:(NSString *)methodName service:(id <ZYServiceProtocol>)service params:(NSDictionary *)params;
@end

NS_ASSUME_NONNULL_END
