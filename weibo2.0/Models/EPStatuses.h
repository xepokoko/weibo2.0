//
//  EPStatuses.h
//  weibo1.0
//
//  Created by 谢恩平 on 2021/5/17.
//  Copyright © 2021 谢恩平. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EPUser.h"
NS_ASSUME_NONNULL_BEGIN

@interface EPStatuses : NSObject

// 微博内容 首张图片 发布时间 发布者的用户名 头像 评论数 点赞数 转发数

@property (nonatomic,copy) NSString* text;//微博信息内容
@property (nonatomic,copy) NSString* idstr; //用户id
@property (nonatomic,strong) NSObject* user;//微博作者的用户信息字段
@property (nonatomic,strong) EPUser * users;//微博作者模型信息
@property (nonatomic,copy) NSString* created_at;//微博创建时间
@property (nonatomic,copy) NSString* created_atNumber;//创建时间的原版，用来传递创建微博的时间
@property (nonatomic,copy) NSString* original_pic;//原始尺寸图片
@property (nonatomic) NSUInteger reposts_count;//转发数
@property (nonatomic) NSUInteger comments_count;//评论数
@property (nonatomic) NSUInteger attitudes_count;//表态数
@property (nonatomic,strong) NSDictionary* retweeted_status;//被转发的微博
@property (nonatomic,strong) NSArray* pic_urls;//多图数组
@property (nonatomic,strong) NSArray* picUrlStringArray;//多图数组的字符串数组

@property (nonatomic) BOOL isBrowsed;//判定是否已被浏览
@property (nonatomic) BOOL isCollection;//判定是否被收藏
@property (nonatomic,strong) NSNumber* collectionCount;//被收藏时的编码，方便删除 ,还能用来判断是否被收藏
@property (nonatomic,strong) NSNumber* browsingCount;//被浏览时的编码，方便交换位置


+ (instancetype)statusWithDic: (NSDictionary*)dic;
+ (NSDictionary*)dicWithModel:(EPStatuses*)status;
@end

NS_ASSUME_NONNULL_END
