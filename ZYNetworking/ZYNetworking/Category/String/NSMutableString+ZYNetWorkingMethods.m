//
//  NSMutableString+ZYNetWorkingMethods.m
//  ZYNetworking
//
//  Created by evan on 2020/1/17.
//  Copyright © 2020 evan. All rights reserved.
//

#import "NSMutableString+ZYNetWorkingMethods.h"
#import "NSURLRequest+ZYNetworkingMethods.h"
#import "NSDictionary+ZYNetWorkingMethods.h"
#import "NSObject+ZYNetWorkingMethods.h"
@implementation NSMutableString (ZYNetWorkingMethods)
- (void)appendURLRequest:(NSURLRequest *)request{
    [self appendFormat:@"\n\nHTTP URL:\n\t%@", request.URL];
       [self appendFormat:@"\n\nHTTP Header:\n%@", request.allHTTPHeaderFields ? request.allHTTPHeaderFields : @"\t\t\t\t\tN/A"];
       [self appendFormat:@"\n\nHTTP Origin Params:\n\t%@", request.originRequestParams.ZY_jsonToString];
       [self appendFormat:@"\n\nHTTP Actual Params:\n\t%@", request.actualRequestParams.ZY_jsonToString];
       [self appendFormat:@"\n\nHTTP Body:\n\t%@", [[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding] ZY_defaultValue:@"\t\t\t\tN/A"]];

       NSMutableString *headerString = [[NSMutableString alloc] init];
       [request.allHTTPHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
           NSString *header = [NSString stringWithFormat:@" -H \"%@: %@\"", key, obj];
           [headerString appendString:header];
       }];

       [self appendString:@"\n\nCURL:\n\t curl"];
       [self appendFormat:@" -X %@", request.HTTPMethod];
       
       if (headerString.length > 0) {
           [self appendString:headerString];
       }
       if (request.HTTPBody.length > 0) {
           [self appendFormat:@" -d '%@'", [[[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding] ZY_defaultValue:@"\t\t\t\tN/A"]];
       }
       
       [self appendFormat:@" %@", request.URL];}
@end
