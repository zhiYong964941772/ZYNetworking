//
//  ZYAPIBaseManager.m
//  ZYNetworking
//
//  Created by evan on 2020/1/16.
//  Copyright © 2020 evan. All rights reserved.
//

#import "ZYAPIBaseManager.h"
#import "ZYURLResponse.h"
#import "ZYCacheCenter.h"
#import "ZYLogger.h"
#import "ZYApiProxy.h"
#import "ZYServiceFactory.h"
#import "CTMediator+ZYAppContext.h"
#import "NSURLRequest+ZYNetworkingMethods.h"
NSString * const ZYUserTokenInvalidNotification = @"ZYUserTokenInvalidNotification";
NSString * const ZYUserTokenIllegalNotification = @"ZYUserTokenIllegalNotification";

NSString * const ZYUserTokenNotificationUserInfoKeyManagerToContinue = @"ZYUserTokenNotificationUserInfoKeyManagerToContinue";
NSString * const ZYAPIBaseManagerRequestID = @"ZYAPIBaseManagerRequestID";

@interface ZYAPIBaseManager()
@property (nonatomic, strong, readwrite) id fetchedRawData;
@property (nonatomic, assign, readwrite) BOOL isLoading;
@property (nonatomic, copy, readwrite) NSString *errorMessage;

@property (nonatomic, readwrite) ZYAPIManagerErrorType errorType;
@property (nonatomic, strong) NSMutableArray *requestIdList;

@property (nonatomic, strong, nullable) void (^successBlock)(ZYAPIBaseManager *apiManager);
@property (nonatomic, strong, nullable) void (^failBlock)(ZYAPIBaseManager *apiManager);
@end

@implementation ZYAPIBaseManager
#pragma mark -- life cycle
- (instancetype)init{
    self = [super init];
    if (self) {
        _delegate = nil;
        _validator = nil;
        _paramSource = nil;
        _fetchedRawData = nil;
        _errorMessage = nil;
        _errorType = ZYAPIManagerErrorTypeDefault;
        _memoryCacheSecond = 3 * 60;
        _diskCacheSecond = 3 * 60;
        if ([self conformsToProtocol:@protocol(ZYAPIManager)]) {
            self.child = (id <ZYAPIManager>)self;
        }else{
            //若不准守ZYAPIManager协议，则抛出异常。继承类的时候，方法f
            NSException *exception = [[NSException alloc]init];
            @throw exception;
        }
    }
    return self;
}
- (id)copyWithZone:(NSZone *)zone{
    return self;
}
- (void)dealloc{
    [self cancelAllRequests];
}
- (void)cancelAllRequests{
    [[ZYApiProxy sharedInstance]cancelRequestWithRequestIDList:self.requestIdList];
    [self.requestIdList removeAllObjects];
    self.requestIdList = nil;
}
#pragma mark -- requestApi
- (NSInteger)loadDataWithParams:(NSDictionary *)params{
    NSInteger requestID = 0;
    NSDictionary *reformedParams = [self reformParams:params];
    if (!reformedParams) {
        reformedParams = @{};
    }
    if ([self shouldCallAPIWithParams:reformedParams]) {
        ZYAPIManagerErrorType errorType = [self.validator manager:self isCorrectWithParamsData:reformedParams];
        if (errorType == ZYAPIManagerErrorTypeNotError) {
            ZYURLResponse *response = nil;
            //是否存在磁盘缓存
            if ((self.cachePolicy & ZYAPIManagerCachePolicyDisk) && self.shouldIgnoreCache == false) {
                response = [[ZYCacheCenter sharedInstance]fetchDiskCacheWithServiceIdentifier:self.child.serviceIdentifier methodName:self.child.methodName params:params];
            }
            //是否存在内存缓存
            if ((self.cachePolicy & ZYAPIManagerCachePolicyMemory) && self.shouldIgnoreCache == false) {
                response = [[ZYCacheCenter sharedInstance]fetchMemoryCacheWithServiceIdentifier:self.child.serviceIdentifier methodName:self.child.methodName params:params];
            }
            if (response != nil) {
                return 0;
            }
            //实际网络请求
            if ([self isReachable]) {
                self.isLoading = true;
                id <ZYServiceProtocol> service = [[ZYServiceFactory sharedInstance]serviceWithIdentifier:self.child.serviceIdentifier];
                NSURLRequest *request = [service requestWithParams:reformedParams methodName:self.child.methodName requestType:self.child.requestType];
                request.service = service;
                [ZYLogger logDebugInfoWithRequest:request apiName:self.child.methodName service:service];
                NSNumber *newRequestID = [[ZYApiProxy sharedInstance] callApiWithRequest:request success:^(ZYURLResponse * _Nullable response) {
                    [self successedOnCallingApi:response];
                } fail:^(ZYURLResponse * _Nullable response) {
                    ZYAPIManagerErrorType errorType = ZYAPIManagerErrorTypeDefault;
                    if (response.status == ZYURLResponseStatusErrorCancel) {
                        errorType = ZYAPIManagerErrorTypeCancel;
                    }
                    if (response.status == ZYURLResponseStatusErrorTimeout) {
                        errorType = ZYAPIManagerErrorTypeTimeOut;
                    }
                    if (response.status == ZYURLResponseStatusErrorNotNetwork) {
                        errorType = ZYAPIManagerErrorTypeNotNetwork;
                    }
                    [self failedOnCallingAPI:response withErrorType:errorType];
                }];
                [self.requestIdList addObject:newRequestID];
                
                NSMutableDictionary *params = [reformedParams mutableCopy];
                params[ZYAPIBaseManagerRequestID] = newRequestID;
                [self afterCallingAPIWithParams:params];
                return [newRequestID integerValue];
            }else{
                [self failedOnCallingAPI:nil withErrorType:ZYAPIManagerErrorTypeNotNetwork];
                return requestID;
            }
        }else{
            [self failedOnCallingAPI:nil withErrorType:errorType];
            return requestID;
        }
    }
    return requestID;
}
- (NSDictionary *)reformParams:(NSDictionary*)params{
    //如果需要在调用API之前额外添加一些参数，比如pageNumber和pageSize之类的就在这里添加
    //子类中覆盖这个函数的时候就不需要调用[super reformParams:params]了
    IMP childIMP = [self.child methodForSelector:@selector(reformParams:)];
    IMP selfIMP = [self methodForSelector:@selector(reformParams:)];
    if (childIMP == selfIMP) {
        return params;
    }else{
        NSDictionary *result = nil;
        result = [self.child reformParams:params];
        if (result) {
            return result;
        }else{
            return params;
        }
    }
}
#pragma mark - api callback
- (void)successedOnCallingApi:(ZYURLResponse *)response{
    self.isLoading = false;
    self.response = response;
    if (response.content) {
        self.fetchedRawData = [response.content copy];
    }else{
        self.fetchedRawData = [response.responseData copy];
    }
    [self removeRequestIdWithRequestID:response.requestID];
    ZYAPIManagerErrorType errorType = [self.validator manager:self isCorrectWithCallBackData:response.content];
    if (errorType == ZYAPIManagerErrorTypeNotError) {
        if (self.cachePolicy != ZYAPIManagerCachePolicyNoCache && response.isCache == false ) {
            if (self.cachePolicy & ZYAPIManagerCachePolicyMemory) {
                [[ZYCacheCenter sharedInstance]saveMemoryCacheWithResponse:response serviceIdentifier:self.child.serviceIdentifier methodName:self.child.methodName cacheTime:self.memoryCacheSecond];
            }
            if (self.cachePolicy & ZYAPIManagerCachePolicyDisk) {
                [[ZYCacheCenter sharedInstance]saveDiskCacheWithResponse:response serviceIdentifier:self.child.serviceIdentifier methodName:self.child.methodName cacheTime:self.diskCacheSecond];
            }
        }
        if ([self.interceptor respondsToSelector:@selector(manager:didReceiveResponse:)]) {
            [self.interceptor manager:self didReceiveResponse:response];
        }
        if ([self beforePerformSuccessWithResponse:response]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(managerCallAPIDidSuccess:)]) {
                    [self.delegate managerCallAPIDidSuccess:self];
                }
                if (self.successBlock) {
                    self.successBlock(self);
                }
            });
        }
        [self afterPerformSuccessWithResponse:response];
    }else{
        [self failedOnCallingAPI:response withErrorType:errorType];
    }
        
}
//请求数据错误处理
- (void)failedOnCallingAPI:(ZYURLResponse *)response withErrorType:(ZYAPIManagerErrorType)errorType{
    self.isLoading = false;
    if (response) {
        self.response = response;
    }
    self.errorType = errorType;
    [self removeRequestIdWithRequestID:response.requestID];
    if (errorType == ZYAPIManagerErrorTypeNeedLogin) {
        [[NSNotificationCenter defaultCenter]postNotificationName:ZYUserTokenIllegalNotification object:nil userInfo:@{ZYUserTokenNotificationUserInfoKeyManagerToContinue : self}];
        return;
    }
    if (errorType == ZYAPIManagerErrorTypeAccessToken) {
        [[NSNotificationCenter defaultCenter]postNotificationName:ZYUserTokenInvalidNotification object:nil userInfo:@{ZYUserTokenNotificationUserInfoKeyManagerToContinue : self}];
        return;
    }
    id<ZYServiceProtocol> service = [[ZYServiceFactory sharedInstance]serviceWithIdentifier:self.child.serviceIdentifier];
    BOOL shouldContinue = [service handleCommonErrorWithResponse:response manager:self errorType:errorType];
    if (!shouldContinue) {
        return;//判断错误情况，如果不需要传递到业务层就返回事件 例如登录失效，token过期等
    }
    // 常规错误
    if (errorType == ZYAPIManagerErrorTypeNotNetwork) {
           self.errorMessage = @"无网络连接，请检查网络";
       }
       if (errorType == ZYAPIManagerErrorTypeTimeOut) {
           self.errorMessage = @"请求超时";
       }
       if (errorType == ZYAPIManagerErrorTypeCancel) {
           self.errorMessage = @"您已取消";
       }
       if (errorType == ZYAPIManagerErrorTypeDownGrade) {
           self.errorMessage = @"网络拥塞";
       }
       
       // 其他错误
       dispatch_async(dispatch_get_main_queue(), ^{
           if ([self.interceptor respondsToSelector:@selector(manager:didReceiveResponse:)]) {
               [self.interceptor manager:self didReceiveResponse:response];
           }
           if ([self beforePerformFailWithResponse:response]) {
               [self.delegate managerCallAPIDidFailed:self];
           }
           if (self.failBlock) {
               self.failBlock(self);
           }
           [self afterPerformFailWithResponse:response];
       });
    
    
}
#pragma mark - method for child
- (void)cleanData
{
    self.fetchedRawData = nil;
    self.errorType = ZYAPIManagerErrorTypeDefault;
}
#pragma mark - method for interceptor
/*
    拦截器的功能可以由子类通过继承实现，也可以由其它对象实现,两种做法可以共存
    当两种情况共存的时候，子类重载的方法一定要调用一下super
    然后它们的调用顺序是BaseManager会先调用子类重载的实现，再调用外部interceptor的实现
    
    notes:
        正常情况下，拦截器是通过代理的方式实现的，因此可以不需要以下这些代码
        但是为了将来拓展方便，如果在调用拦截器之前manager又希望自己能够先做一些事情，所以这些方法还是需要能够被继承重载的
        所有重载的方法，都要调用一下super,这样才能保证外部interceptor能够被调到
        这就是decorate pattern
 */
- (BOOL)beforePerformSuccessWithResponse:(ZYURLResponse *)response
{
    BOOL result = YES;
    
    self.errorType = ZYAPIManagerErrorTypeSuccess;
    if ((NSInteger)self != (NSInteger)self.interceptor && [self.interceptor respondsToSelector:@selector(manager: beforePerformSuccessWithResponse:)]) {
        result = [self.interceptor manager:self beforePerformSuccessWithResponse:response];
    }
    return result;
}

- (void)afterPerformSuccessWithResponse:(ZYURLResponse *)response
{
    if ((NSInteger)self != (NSInteger)self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterPerformSuccessWithResponse:)]) {
        [self.interceptor manager:self afterPerformSuccessWithResponse:response];
    }
}

- (BOOL)beforePerformFailWithResponse:(ZYURLResponse *)response
{
    BOOL result = YES;
    if ((NSInteger)self != (NSInteger)self.interceptor && [self.interceptor respondsToSelector:@selector(manager:beforePerformFailWithResponse:)]) {
        result = [self.interceptor manager:self beforePerformFailWithResponse:response];
    }
    return result;
}

- (void)afterPerformFailWithResponse:(ZYURLResponse *)response
{
    if ((NSInteger)self != (NSInteger)self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterPerformFailWithResponse:)]) {
        [self.interceptor manager:self afterPerformFailWithResponse:response];
    }
}

//只有返回YES才会继续调用API
- (BOOL)shouldCallAPIWithParams:(NSDictionary *)params
{
    if ((NSInteger)self != (NSInteger)self.interceptor && [self.interceptor respondsToSelector:@selector(manager:shouldCallAPIWithParams:)]) {
        return [self.interceptor manager:self shouldCallAPIWithParams:params];
    } else {
        return YES;
    }
}
//请求完成之后是否插入参数到params
- (void)afterCallingAPIWithParams:(NSDictionary *)params
{
    if ((NSInteger)self != (NSInteger)self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterCallingAPIWithParams:)]) {
        [self.interceptor manager:self afterCallingAPIWithParams:params];
    }
}
#pragma mark - private methods
//删掉请求列表的对应id
- (void)removeRequestIdWithRequestID:(NSInteger)requestId
{
    NSNumber *requestIDToRemove = nil;
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId integerValue] == requestId) {
            requestIDToRemove = storedRequestId;
        }
    }
    if (requestIDToRemove) {
        [self.requestIdList removeObject:requestIDToRemove];
    }
}
#pragma mark - getters and setters
- (NSMutableArray *)requestIdList
{
    if (_requestIdList == nil) {
        _requestIdList = [[NSMutableArray alloc] init];
    }
    return _requestIdList;
}

- (BOOL)isReachable
{
    BOOL isReachability = [[CTMediator sharedInstance] ZYNetworking_isReachable];
    if (!isReachability) {
        self.errorType = ZYAPIManagerErrorTypeNotNetwork;
    }
    return isReachability;
}

- (BOOL)isLoading
{
    if (self.requestIdList.count == 0) {
        _isLoading = NO;
    }
    return _isLoading;
}
@end
