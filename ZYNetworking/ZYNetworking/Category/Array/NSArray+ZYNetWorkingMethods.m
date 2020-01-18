//
//  NSArray+ZYNetWorkingMethods.m
//  ZYNetworking
//
//  Created by evan on 2020/1/17.
//  Copyright © 2020 evan. All rights reserved.
//

#import "NSArray+ZYNetWorkingMethods.h"



@implementation NSArray (ZYNetWorkingMethods)
- (NSString *)ZY_jsonToString{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:NULL];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
- (NSString *)ZY_paramsToString{
    NSMutableString *paramString = [[NSMutableString alloc] init];
       
       NSArray *sortedParams = [self sortedArrayUsingSelector:@selector(compare:)];
       [sortedParams enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
           if ([paramString length] == 0) {
               [paramString appendFormat:@"?%@", obj];
           } else {
               [paramString appendFormat:@"&%@", obj];
           }
       }];
       
       return paramString;
}
@end
