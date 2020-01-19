//
//  ZYURLResponse.m
//  ZYNetworking
//
//  Created by evan on 2020/1/17.
//  Copyright © 2020 evan. All rights reserved.
//

#import "ZYURLResponse.h"
#import "NSObject+ZYNetWorkingMethods.h"
#import "NSURLRequest+ZYNetworkingMethods.h"
@interface ZYURLResponse ()
@property(nonatomic,assign,readwrite)ZYURLResponseStatus status;
@property(nonatomic,copy,readwrite)NSString *contentString;//外部只读，要赋值得在内部重新@property
@property(nonatomic,copy,readwrite)id content;
@property(nonatomic,assign,readwrite)NSInteger requestID;
@property(nonatomic,strong,readwrite)NSURLRequest *request;
@property(nonatomic,strong,readwrite)NSData *responseData;
@property(nonatomic,copy,readwrite)NSString *errorMessage;
@property (nonatomic, assign, readwrite) BOOL isCache;//是否是缓存数据

@end

@implementation ZYURLResponse
- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseObject:(id)responseObject error:(NSError *)error{
    self = [self init];
    if (self) {
        self.contentString = [responseString ZY_defaultValue:@""];
        self.requestID = [requestId integerValue];
        self.request = request;
        self.acturlRequestParams = request.actualRequestParams;
        self.originRequestParams = request.originRequestParams;
        self.isCache = false;
        self.status = [self responseStatusWithError:error];
        self.content = responseObject ? responseObject : @{};
        self.errorMessage = [NSString stringWithFormat:@"%@", error];
    }
    return self;
}
- (instancetype)initWithData:(NSData *)data{
    self = [super init];
    if (self) {
        self.contentString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        self.status = [self responseStatusWithError:nil];
        self.requestID = 0;
        self.request = nil;
        self.responseData = data;
        self.content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
        self.isCache = true;
    }
    return self;
}
- (ZYURLResponseStatus)responseStatusWithError:(NSError *)error {
    if (error) {
        ZYURLResponseStatus status = ZYURLResponseStatusErrorNotNetwork;
        if (error.code == NSURLErrorTimedOut) {
            status = ZYURLResponseStatusErrorTimeout;
        }
        if (error.code == NSURLErrorCancelled) {
            status = ZYURLResponseStatusErrorCancel;
        }
        if (error.code == NSURLErrorNotConnectedToInternet) {
            status = ZYURLResponseStatusErrorNotNetwork;
        }
        return status;
    }else{
        return ZYURLResponseStatusSuccess;
    }
    
}
#pragma mark --- getter and setter
- (NSData *)responseData{
    if (!_responseData) {
        NSError *error = nil;
        _responseData = [NSJSONSerialization dataWithJSONObject:self.content options:0 error:&error];
        if (error) {
            _responseData = [@"" dataUsingEncoding:NSUTF8StringEncoding];
        }
    }
    return _responseData;
}
@end
