//
//  ZYURLResponse.h
//  ZYNetworking
//
//  Created by evan on 2020/1/17.
//  Copyright © 2020 evan. All rights reserved.
//

#import <Foundation/Foundation.h>
//生成想要的response
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, ZYURLResponseStatus)
{
    ZYURLResponseStatusSuccess,
    ZYURLResponseStatusErrorTimeout, //超时
    ZYURLResponseStatusErrorCancel, //取消
    ZYURLResponseStatusErrorNotNetwork // 网络错误。
};

@interface ZYURLResponse : NSObject
@property(nonatomic,assign,readonly)ZYURLResponseStatus status;
@property(nonatomic,copy,readonly)NSString *contentString;
@property(nonatomic,copy,readonly)id content;
@property(nonatomic,assign,readonly)NSInteger requestID;
@property(nonatomic,strong,readonly)NSURLRequest *request;
@property (nonatomic, copy, readonly) NSData *responseData;
@property(nonatomic,copy,readonly)NSString *errorMessage;
@property (nonatomic, assign, readonly) BOOL isCache;

@property (nonatomic, copy) NSDictionary *acturlRequestParams;
@property (nonatomic, copy) NSDictionary *originRequestParams;
@property (nonatomic, strong) NSString *logString;


- (instancetype)initWithResponseString:(NSString *)responseString requestId:(NSNumber *)requestId request:(NSURLRequest *)request responseObject:(id)responseObject error:(NSError *)error;

// 使用initWithData的response，它的isCache是YES，上面函数生成的response的isCache是NO
- (instancetype)initWithData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
