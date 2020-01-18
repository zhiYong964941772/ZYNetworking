//
//  ZYNetworkingConfiguration.h
//  ZYNetworking
//
//  Created by evan on 2020/1/10.
//  Copyright © 2020 evan. All rights reserved.
//

#ifndef ZYNetworkingConfiguration_h
#define ZYNetworkingConfiguration_h
@class ZYAPIBaseManager;
@class ZYURLResponse;
//开发环境枚举
typedef NS_ENUM(NSInteger,ZYServiceAPIEnvironment){
    ZYServiceAPIEnvironmentDevelop,
    ZYServiceAPIEnvironmentReleaseTest,
    ZYServiceAPIEnvironmentRelease
};
//请求枚举
typedef NS_ENUM(NSInteger,ZYAPIManagerRequestType){
    ZYAPIManagerRequestTypePost,
    ZYAPIManagerRequestTypeGet,
    ZYAPIManagerRequestTypeDelete
};
//业务层错误码展示
typedef NS_ENUM(NSInteger,ZYAPIManagerErrorType) {
    ZYAPIManagerErrorTypeNeedLogin,//登录失败
    ZYAPIManagerErrorTypeAccessToken,//网络token失效
    ZYAPIManagerErrorTypeSuccess,//成功
    ZYAPIManagerErrorTypeFault,//失败
    ZYAPIManagerErrorTypeParams,//参数错误
    ZYAPIManagerErrorTypeNotNetwork,//网络不通
    ZYAPIManagerErrorTypeTimeOut,//请求超时
    ZYAPIManagerErrorTypeDefault,//默认
    ZYAPIManagerErrorTypeCancel,//网络取消
    ZYAPIManagerErrorTypeDownGrade,//网络拥堵
    ZYAPIManagerErrorTypeNotError

};
//缓存枚举
typedef NS_ENUM(NSInteger,ZYAPIManagerCachePolicy) {
    ZYAPIManagerCachePolicyNoCache = 0,
    ZYAPIManagerCachePolicyMemory = 1<<0,
    ZYAPIManagerCachePolicyDisk = 1<<1
};


#pragma mark -- extern
extern NSString * _Nonnull const ZYAPIBaseManagerRequestID;

// notification name
extern NSString * _Nonnull const ZYUserTokenInvalidNotification;
extern NSString * _Nonnull const ZYUserTokenIllegalNotification;
extern NSString * _Nonnull const ZYUserTokenNotificationUserInfoKeyManagerToContinue;

// result
extern NSString * _Nonnull const kCTApiProxyValidateResultKeyResponseObject;
extern NSString * _Nonnull const kCTApiProxyValidateResultKeyResponseString;

#pragma mark --- protocol
@protocol ZYAPIManager <NSObject>

@required
- (NSString *_Nonnull)methodName;
- (NSString *_Nonnull)serviceIdentifier;
- (ZYAPIManagerRequestType)requestType;

@optional
- (void)cleanData;
- (NSDictionary *_Nullable)reformParams:(NSDictionary *_Nullable)params;
- (NSInteger)loadDataWithParams:(NSDictionary *_Nullable)params;

@end

/*************************************************************************************/
@protocol ZYAPIManagerInterceptor <NSObject>

@optional
- (BOOL)manager:(ZYAPIBaseManager *_Nonnull)manager beforePerformSuccessWithResponse:(ZYURLResponse *_Nonnull)response;
- (void)manager:(ZYAPIBaseManager *_Nonnull)manager afterPerformSuccessWithResponse:(ZYURLResponse *_Nonnull)response;

- (BOOL)manager:(ZYAPIBaseManager *_Nonnull)manager beforePerformFailWithResponse:(ZYURLResponse *_Nonnull)response;
- (void)manager:(ZYAPIBaseManager *_Nonnull)manager afterPerformFailWithResponse:(ZYURLResponse *_Nonnull)response;

- (BOOL)manager:(ZYAPIBaseManager *_Nonnull)manager shouldCallAPIWithParams:(NSDictionary *_Nullable)params;
- (void)manager:(ZYAPIBaseManager *_Nonnull)manager afterCallingAPIWithParams:(NSDictionary *_Nullable)params;
- (void)manager:(ZYAPIBaseManager *_Nonnull)manager didReceiveResponse:(ZYURLResponse *_Nullable)response;

@end

/*************************************************************************************/

@protocol ZYAPIManagerCallBackDelegate <NSObject>
@required
- (void)managerCallAPIDidSuccess:(ZYAPIBaseManager * _Nonnull)manager;
- (void)managerCallAPIDidFailed:(ZYAPIBaseManager * _Nonnull)manager;
@end

@protocol ZYPagableAPIManager <NSObject>

@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign, readonly) NSUInteger currentPageNumber;
@property (nonatomic, assign, readonly) BOOL isFirstPage;
@property (nonatomic, assign, readonly) BOOL isLastPage;

- (void)loadNextPage;

@end

/*************************************************************************************/

@protocol ZYAPIManagerDataReformer <NSObject>
@required
- (id _Nullable)manager:(ZYAPIBaseManager * _Nonnull)manager reformData:(NSDictionary * _Nullable)data;
@end

/*************************************************************************************/

@protocol ZYAPIManagerValidator <NSObject>
@required
- (ZYAPIManagerErrorType)manager:(ZYAPIBaseManager *_Nonnull)manager isCorrectWithCallBackData:(NSDictionary *_Nullable)data;
- (ZYAPIManagerErrorType)manager:(ZYAPIBaseManager *_Nonnull)manager isCorrectWithParamsData:(NSDictionary *_Nullable)data;
@end

/*************************************************************************************/

@protocol ZYAPIManagerParamSource <NSObject>
@required
- (NSDictionary *_Nullable)paramsForApi:(ZYAPIBaseManager *_Nonnull)manager;
@end



#endif /* ZYNetworkingConfiguration_h */
