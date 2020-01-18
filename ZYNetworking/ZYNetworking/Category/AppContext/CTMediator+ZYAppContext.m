//
//  CTMediator+ZYAppContext.m
//  ZYNetworking
//
//  Created by evan on 2020/1/17.
//  Copyright © 2020 evan. All rights reserved.
//

#import "CTMediator+ZYAppContext.h"


@implementation CTMediator (ZYAppContext)
- (BOOL)ZYNetworking_shouldPrintNetworkingLog
{
    return [[[CTMediator sharedInstance] performTarget:@"ZYAppContext" action:@"shouldPrintNetworkingLog" params:nil shouldCacheTarget:YES] boolValue];
}

- (BOOL)ZYNetworking_isReachable
{
    return [[[CTMediator sharedInstance] performTarget:@"ZYAppContext" action:@"isReachable" params:nil shouldCacheTarget:YES] boolValue];
}

- (NSInteger)ZYNetworking_cacheResponseCountLimit
{
    return [[[CTMediator sharedInstance] performTarget:@"ZYAppContext" action:@"cacheResponseCountLimit" params:nil shouldCacheTarget:YES] integerValue];
}
@end
