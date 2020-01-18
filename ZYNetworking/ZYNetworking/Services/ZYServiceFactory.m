//
//  ZYServiceFactory.m
//  ZYNetworking
//
//  Created by evan on 2020/1/17.
//  Copyright © 2020 evan. All rights reserved.
//

#import "ZYServiceFactory.h"
#import <CTMediator/CTMediator.h>
@interface ZYServiceFactory()
@property(nonatomic, strong) NSMutableDictionary *serviceStorage;
@end
@implementation ZYServiceFactory
#pragma mark getter and setter
- (NSMutableDictionary *)serviceStorage{
    if (_serviceStorage == nil) {
        _serviceStorage = [[NSMutableDictionary alloc]init];
    }
    return _serviceStorage;
}
#pragma mark 单例
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static ZYServiceFactory *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ZYServiceFactory alloc]init];
    });
    return sharedInstance;
}

/// 创建一个遵守ZYServiceProtocol协议的类
/// @param identifier 类名
- (id<ZYServiceProtocol>)serviceWithIdentifier:(NSString *)identifier{
    if (self.serviceStorage[identifier] == nil) {
        self.serviceStorage[identifier] = [self newServiceWithIdentifier:identifier];
    }
    return self.serviceStorage[identifier];
}

/// 第一次创建
/// @param identifier 类名
- (id <ZYServiceProtocol>)newServiceWithIdentifier:(NSString *)identifier{
    return [[CTMediator sharedInstance] performTarget:identifier action:identifier params:nil shouldCacheTarget:false];
}
@end
