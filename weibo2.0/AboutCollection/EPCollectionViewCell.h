//
//  EPCollectionViewCell.h
//  weibo1.0
//
//  Created by 谢恩平 on 2021/5/17.
//  Copyright © 2021 谢恩平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassUrlString.h"
#import "PassImformation.h"
#import "EPUser.h"
#import "EPCollectionViewCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface EPCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) EPStatuses* status;
@property (nonatomic,strong) EPUser* user;
@property (nonatomic,strong) UIButton* collectionBtn;
@property (nonatomic,strong) UIImageView* originalPic;//原始尺寸图片
@property (nonatomic,strong) UITextView* textView;//微博text内容
@property (nonatomic,strong) UITextView* retWeetTextView;//被转发微博的文本内容
@property (nonatomic,strong) UILabel* reposts_count;//转发数
@property (nonatomic,strong) UILabel* comments_count;//评论数
@property (nonatomic,strong) UILabel* attitudes_count;//表态数
@property (nonatomic,strong) UILabel* screenNameLabel;//用户名label
@property (nonatomic,strong) UILabel* createdTimeLabel;//创建时间label
@property (nonatomic,strong) UIImageView* headPicture;//头像
@property (nonatomic,strong) NSURL* profileImageUrl;//头像url
@property (nonatomic,copy) NSString* webUrlStr;

@property (nonatomic,weak) id<PassImformation>delegate;

@property (nonatomic,strong) UIImageView* zhuanfa;
@property (nonatomic,strong) UIImageView* pinglun;
@property (nonatomic,strong) UIImageView* dianzan;



@property (nonatomic) BOOL isHaveRetWeet;
@property (nonatomic) BOOL isHavePicture;

@property (nonatomic) float textViewHeigth;
@property (nonatomic) float retWeetTextHeight;
@property (nonatomic) float picHeight;

@property (nonatomic,strong) NSIndexPath* indexPath;

@property (nonatomic,strong) NSMutableArray* picsUrlArray;
@property (nonatomic,strong) NSMutableArray* picsImageArray;
@property (nonatomic,strong) NSMutableArray* picsArray;


- (void) setViewsFrame;
@end

NS_ASSUME_NONNULL_END
