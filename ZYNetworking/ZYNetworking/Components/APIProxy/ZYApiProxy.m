//
//  ZYApiProxy.m
//  ZYNetworking
//
//  Created by evan on 2020/1/17.
//  Copyright © 2020 evan. All rights reserved.
//

#import "ZYApiProxy.h"
#import <AFNetworking/AFNetworking.h>
#import "ZYServiceProtocol.h"
#import "NSURLRequest+ZYNetworkingMethods.h"
#import "ZYURLResponse.h"
#import "ZYLogger.h"
static NSString * const kAXApiProxyDispatchItemKeyCallbackSuccess = @"kAXApiProxyDispatchItemCallbackSuccess";
static NSString * const kAXApiProxyDispatchItemKeyCallbackFail = @"kAXApiProxyDispatchItemCallbackFail";

NSString * const kCTApiProxyValidateResultKeyResponseObject = @"kCTApiProxyValidateResultKeyResponseObject";
NSString * const kCTApiProxyValidateResultKeyResponseString = @"kCTApiProxyValidateResultKeyResponseString";
@interface ZYApiProxy ()

@property (nonatomic, strong) NSMutableDictionary *dispatchTable;
@property (nonatomic, strong) NSNumber *recordedRequestId;

@end
@implementation ZYApiProxy
#pragma mark ---getter and setter
- (AFHTTPSessionManager *)sessionManagerWithService:(id<ZYServiceProtocol>)service{
    AFHTTPSessionManager *sessionManager = nil;
    if ([service respondsToSelector:@selector(sessionManager)]) {
        sessionManager = service.sessionManager;
    }
    if (sessionManager == nil) {
        sessionManager = [AFHTTPSessionManager manager];
    }
    return sessionManager;
}
- (NSMutableDictionary *)dispatchTable{
    if (!_dispatchTable) {
        _dispatchTable = [[NSMutableDictionary alloc]init];
    }
    return _dispatchTable;
}
#pragma mark -- public methods
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static ZYApiProxy *sharedInstnce = nil;
    dispatch_once(&onceToken, ^{
        sharedInstnce = [[ZYApiProxy alloc]init];
    });
    return sharedInstnce;
}
- (NSNumber *)callApiWithRequest:(NSURLRequest *)request success:(ZYCallback)success fail:(ZYCallback)fail{
    __block  NSURLSessionDataTask *dataTask = nil;
    dataTask = [[self sessionManagerWithService:request.service] dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSNumber *requestID = @([dataTask taskIdentifier]);
        [self.dispatchTable removeObjectForKey:requestID];
        NSDictionary *result = [request.service resultWithResponseObject:responseObject response:response request:request error:&error];
        //组成我定义的格式数据类
        ZYURLResponse *ZYResponse = [[ZYURLResponse alloc]initWithResponseString:result[kCTApiProxyValidateResultKeyResponseString] requestId:requestID request:request responseObject:result[kCTApiProxyValidateResultKeyResponseObject] error:error];
        //组成打印日志
        ZYResponse.logString = [ZYLogger logDebugInfoWithResponse:(NSHTTPURLResponse*)response responseObject:responseObject responseString:result[kCTApiProxyValidateResultKeyResponseString] request:request error:error];
        if (error) {
            fail ? fail(ZYResponse) : nil;
        }else{
            success ? success(ZYResponse) : nil;
        }
        
    }];
    NSNumber *requestID = @([dataTask taskIdentifier]);
    self.dispatchTable[requestID] = dataTask;
    [dataTask resume];
    return requestID;
}
- (void)cancelRequestWithRequestID:(NSNumber *)requestID{
   NSURLSessionDataTask *requestOperation = self.dispatchTable[requestID];
    [requestOperation cancel];
    [self.dispatchTable removeObjectForKey:requestID];
}
- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList{
    for (NSNumber *requestId in requestIDList) {
           [self cancelRequestWithRequestID:requestId];
       }
}
@end
