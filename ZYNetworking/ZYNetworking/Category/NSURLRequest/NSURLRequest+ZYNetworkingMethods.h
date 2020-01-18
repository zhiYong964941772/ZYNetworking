//
//  NSURLRequest+ZYNetworkingMethods.h
//  ZYNetworking
//
//  Created by evan on 2020/1/16.
//  Copyright © 2020 evan. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "ZYServiceProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface NSURLRequest (ZYNetworkingMethods)
@property (nonatomic, copy) NSDictionary *actualRequestParams;
@property (nonatomic, copy) NSDictionary *originRequestParams;
@property (nonatomic, strong) id <ZYServiceProtocol> service;
@end

NS_ASSUME_NONNULL_END
