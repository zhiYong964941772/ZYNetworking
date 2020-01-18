//
//  ZYApiProxy.h
//  ZYNetworking
//
//  Created by evan on 2020/1/17.
//  Copyright © 2020 evan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZYURLResponse;
typedef void(^ZYCallback)(ZYURLResponse * _Nullable response);
NS_ASSUME_NONNULL_BEGIN

@interface ZYApiProxy : NSObject
+ (instancetype)sharedInstance;

- (NSNumber *)callApiWithRequest:(NSURLRequest *)request success:(ZYCallback)success fail:(ZYCallback)fail;
- (void)cancelRequestWithRequestID:(NSNumber *)requestID;
- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList;
@end

NS_ASSUME_NONNULL_END
