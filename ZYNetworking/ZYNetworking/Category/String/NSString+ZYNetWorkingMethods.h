//
//  NSString+ZYNetWorkingMethods.h
//  ZYNetworking
//
//  Created by evan on 2020/1/16.
//  Copyright © 2020 evan. All rights reserved.
//



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ZYNetWorkingMethods)
- (NSString *)ZY_MD5;
- (NSString *)ZY_SHA1;
- (NSString *)ZY_Base64Encode;

@end

NS_ASSUME_NONNULL_END
