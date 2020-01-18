//
//  NSURLRequest+ZYNetworkingMethods.m
//  ZYNetworking
//
//  Created by evan on 2020/1/16.
//  Copyright © 2020 evan. All rights reserved.
//

#import "NSURLRequest+ZYNetworkingMethods.h"

#import <objc/runtime.h>
static void *ZYNetworkingActualRequestParams = &ZYNetworkingActualRequestParams;
static void *ZYNetworkingOriginRequestParams = &ZYNetworkingOriginRequestParams;
static void *ZYNetworkingRequestService = &ZYNetworkingRequestService;

@implementation NSURLRequest (ZYNetworkingMethods)
#pragma mark ----- get and set

- (void)setActualRequestParams:(NSDictionary *)actualRequestParams
{
    objc_setAssociatedObject(self, ZYNetworkingActualRequestParams, actualRequestParams, OBJC_ASSOCIATION_COPY);//copy
}

- (NSDictionary *)actualRequestParams
{
    return objc_getAssociatedObject(self, ZYNetworkingActualRequestParams);
}
#pragma mark ----- get and set

- (void)setOriginRequestParams:(NSDictionary *)originRequestParams
{
    objc_setAssociatedObject(self, ZYNetworkingOriginRequestParams, originRequestParams, OBJC_ASSOCIATION_COPY);//copy
}

- (NSDictionary *)originRequestParams
{
    return objc_getAssociatedObject(self, ZYNetworkingOriginRequestParams);
}
#pragma mark ----- get and set
- (void)setService:(id<ZYServiceProtocol>)service
{
    objc_setAssociatedObject(self, ZYNetworkingRequestService, service, OBJC_ASSOCIATION_RETAIN_NONATOMIC); //进行对象关联，retain
}

- (id<ZYServiceProtocol>)service
{
    return objc_getAssociatedObject(self, ZYNetworkingRequestService); //读取对象
}



@end
