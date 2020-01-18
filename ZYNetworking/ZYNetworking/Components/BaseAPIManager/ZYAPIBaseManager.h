//
//  ZYAPIBaseManager.h
//  ZYNetworking
//
//  Created by evan on 2020/1/16.
//  Copyright © 2020 evan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYNetworkingConfiguration.h"

@class ZYURLResponse;
/*************************************************************************************/

NS_ASSUME_NONNULL_BEGIN

@interface ZYAPIBaseManager : NSObject<NSCopying>
// outter functions
@property (nonatomic, weak) id <ZYAPIManagerCallBackDelegate> _Nullable delegate;
@property (nonatomic, weak) id <ZYAPIManagerParamSource> _Nullable paramSource;
@property (nonatomic, weak) id <ZYAPIManagerValidator> _Nullable validator;
@property (nonatomic, weak) NSObject<ZYAPIManager> * _Nullable child; //里面会调用到NSObject的方法，所以这里不用id
@property (nonatomic, weak) id <ZYAPIManagerInterceptor> _Nullable interceptor;
// cache
@property (nonatomic, assign) ZYAPIManagerCachePolicy cachePolicy;
@property (nonatomic, assign) NSTimeInterval memoryCacheSecond; // 默认 3 * 60
@property (nonatomic, assign) NSTimeInterval diskCacheSecond; // 默认 3 * 60
@property (nonatomic, assign) BOOL shouldIgnoreCache;  //默认NO
// response
@property (nonatomic, strong) ZYURLResponse * _Nonnull response;
@property (nonatomic, readonly) ZYAPIManagerErrorType errorType;
@property (nonatomic, copy, readonly) NSString * _Nullable errorMessage;
// before loading
@property (nonatomic, assign, readonly) BOOL isReachable;
@property (nonatomic, assign, readonly) BOOL isLoading;

// start
- (NSInteger)loadData;
+ (NSInteger)loadDataWithParams:(NSDictionary * _Nullable)params success:(void (^ _Nullable)(ZYAPIBaseManager * _Nonnull apiManager))successCallback fail:(void (^ _Nullable)(ZYAPIBaseManager * _Nonnull apiManager))failCallback;

// cancel
- (void)cancelAllRequests;
- (void)cancelRequestWithRequestId:(NSInteger)requestID;

// finish
- (id _Nullable )fetchDataWithReformer:(id <ZYAPIManagerDataReformer> _Nullable)reformer;
- (void)cleanData;



@end
@interface ZYAPIBaseManager (InnerInterceptor)
- (BOOL)beforePerformSuccessWithResponse:(ZYURLResponse *_Nullable)response;
- (void)afterPerformSuccessWithResponse:(ZYURLResponse *_Nullable)response;

- (BOOL)beforePerformFailWithResponse:(ZYURLResponse *_Nullable)response;
- (void)afterPerformFailWithResponse:(ZYURLResponse *_Nullable)response;

- (BOOL)shouldCallAPIWithParams:(NSDictionary *_Nullable)params;
- (void)afterCallingAPIWithParams:(NSDictionary *_Nullable)params;
@end
NS_ASSUME_NONNULL_END
