//
//  NSDictionary+ZYNetWorkingMethods.h
//  ZYNetworking
//
//  Created by evan on 2020/1/17.
//  Copyright © 2020 evan. All rights reserved.
//



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface NSDictionary (ZYNetWorkingMethods)
 

/// json转字符串
- (NSString *)ZY_jsonToString;

/// 字典拼接成请求样式
- (NSString *)ZY_transformToUrlParamString;
@end

NS_ASSUME_NONNULL_END
