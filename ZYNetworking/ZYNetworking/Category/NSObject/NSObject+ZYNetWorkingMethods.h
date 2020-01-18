//
//  NSObject+ZYNetWorkingMethods.h
//  ZYNetworking
//
//  Created by evan on 2020/1/16.
//  Copyright © 2020 evan. All rights reserved.
//

//该分类的作用是判断object是否空

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (ZYNetWorkingMethods)
- (BOOL)ZY_isEmptyObject;
- (id)ZY_defaultValue:(id)defaultData;
@end

NS_ASSUME_NONNULL_END
