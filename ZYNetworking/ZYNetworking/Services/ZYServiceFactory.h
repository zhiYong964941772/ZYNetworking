//
//  ZYServiceFactory.h
//  ZYNetworking
//
//  Created by evan on 2020/1/17.
//  Copyright © 2020 evan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYServiceProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZYServiceFactory : NSObject
+ (instancetype)sharedInstance;

- (id <ZYServiceProtocol>)serviceWithIdentifier:(NSString *)identifier;
@end

NS_ASSUME_NONNULL_END
