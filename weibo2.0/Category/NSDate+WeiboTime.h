//
//  NSDate+WeiboTime.h
//  weibo1.0
//
//  Created by 谢恩平 on 2021/5/20.
//  Copyright © 2021 谢恩平. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (WeiboTime)

- (BOOL)isThisYear;

- (BOOL)isYesterday;

- (BOOL)isToday;
@end

NS_ASSUME_NONNULL_END
