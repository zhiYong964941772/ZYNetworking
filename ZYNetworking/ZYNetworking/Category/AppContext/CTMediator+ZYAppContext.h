//
//  CTMediator+ZYAppContext.h
//  ZYNetworking
//
//  Created by evan on 2020/1/17.
//  Copyright © 2020 evan. All rights reserved.
//


#import <CTMediator/CTMediator.h>

NS_ASSUME_NONNULL_BEGIN

@interface CTMediator (ZYAppContext)
- (BOOL)ZYNetworking_shouldPrintNetworkingLog;
- (BOOL)ZYNetworking_isReachable;
- (NSInteger)ZYNetworking_cacheResponseCountLimit;
@end

NS_ASSUME_NONNULL_END
