//
//  ZYServiceProtocol.h
//  ZYNetworking
//
//  Created by evan on 2020/1/16.
//  Copyright © 2020 evan. All rights reserved.
//

#ifndef ZYServiceProtocol_h
#define ZYServiceProtocol_h
#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "ZYNetworkingConfiguration.h"

@protocol ZYServiceProtocol <NSObject>

@property (nonatomic, assign)ZYServiceAPIEnvironment apiEnvironment;

- (NSURLRequest *)requestWithParams:(NSDictionary *)params
                         methodName:(NSString *)methodName
                        requestType:(ZYAPIManagerRequestType)requestType;

- (NSDictionary *)resultWithResponseObject:(id)responseObject
                                response:(NSURLResponse *)response
                                 request:(NSURLRequest *)request
                                   error:(NSError **)error;

/*
 return true means should continue the error handling process in CTAPIBaseManager
 return false means stop the error handling process
 
 如果检查错误之后，需要继续走fail路径上报到业务层的，return YES。（例如网络错误等，需要业务层弹框）
 如果检查错误之后，不需要继续走fail路径上报到业务层的，return NO。（例如用户token失效，此时挂起API，调用刷新token的API，成功之后再重新调用原来的API。那么这种情况就不需要继续走fail路径上报到业务。）
 */
- (BOOL)handleCommonErrorWithResponse:(ZYURLResponse *)response
                              manager:(ZYAPIBaseManager *)manager
                            errorType:(ZYAPIManagerErrorType)errorType;

@optional
- (AFHTTPSessionManager *)sessionManager;


@end

#endif /* ZYServiceProtocol_h */

