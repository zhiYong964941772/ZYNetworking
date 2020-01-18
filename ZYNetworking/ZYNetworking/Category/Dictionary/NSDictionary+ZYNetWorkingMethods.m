//
//  NSDictionary+ZYNetWorkingMethods.m
//  ZYNetworking
//
//  Created by evan on 2020/1/17.
//  Copyright © 2020 evan. All rights reserved.
//

#import "NSDictionary+ZYNetWorkingMethods.h"


@implementation NSDictionary (ZYNetWorkingMethods)
- (NSString *)ZY_transformToUrlParamString{
    NSMutableString *paramString = [NSMutableString string];
    for (int i = 0; i < self.count; i++) {
        NSString *str;
        if (i == 0) {
            str = [NSString stringWithFormat:@"?%@=%@",self.allKeys[i],self.allValues[i]];
        }else{
            str = [NSString stringWithFormat:@"%@=%@",self.allKeys[i],self.allValues[i]];
        }
        [paramString appendString:str];
    }
    return paramString;
}
- (NSString *)ZY_jsonToString{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:NULL];
    return [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end
