//
//  EPUser.h
//  weibo1.0
//
//  Created by 谢恩平 on 2021/5/18.
//  Copyright © 2021 谢恩平. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EPUser : NSObject

@property (nonatomic,copy) NSString* screen_name;//昵称
@property (nonatomic,copy) NSString* profile_image_url;//头像


+ (instancetype)userWithDic: (NSDictionary*)dic;
+ (NSDictionary*)dicWithUser: (EPUser*)user;
@end




NS_ASSUME_NONNULL_END
