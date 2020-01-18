//
//  NSObject+ZYNetWorkingMethods.m
//  ZYNetworking
//
//  Created by evan on 2020/1/16.
//  Copyright © 2020 evan. All rights reserved.
//

#import "NSObject+ZYNetWorkingMethods.h"



@implementation NSObject (ZYNetWorkingMethods)
- (id)ZY_defaultValue:(id)defaultData{
    if (![defaultData isKindOfClass:[self class]]) {
        return defaultData;
    }
    if ([self ZY_isEmptyObject]) {
        return defaultData;
    }
    return self;
}
- (BOOL)ZY_isEmptyObject{
    if ([self isEqual:[NSNull null]]) {
        return YES;
    }
    
    if ([self isKindOfClass:[NSString class]]) {
        if ([(NSString *)self length] == 0) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSArray class]]) {
        if ([(NSArray *)self count] == 0) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSDictionary class]]) {
        if ([(NSDictionary *)self count] == 0) {
            return YES;
        }
    }
    return false;
}
@end
