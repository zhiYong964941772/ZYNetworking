//
//  NSMutableString+ZYNetWorkingMethods.h
//  ZYNetworking
//
//  Created by evan on 2020/1/17.
//  Copyright © 2020 evan. All rights reserved.
//



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableString (ZYNetWorkingMethods)
- (void)appendURLRequest:(NSURLRequest *)request;
@end

NS_ASSUME_NONNULL_END
