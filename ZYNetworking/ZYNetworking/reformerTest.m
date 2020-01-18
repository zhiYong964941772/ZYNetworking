//
//  reformerTest.m
//  ZYNetworking
//
//  Created by evan on 2020/1/15.
//  Copyright © 2020 evan. All rights reserved.
//

#import "reformerTest.h"

@implementation reformerTest
- (instancetype)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (id)manager:(id)manager reformData:(id)data{
    NSLog(@"%@===%@",manager,data);
    return @"";
}
@end
