//
//  BrowsingHistoryController.h
//  weibo1.0
//
//  Created by 谢恩平 on 2021/5/26.
//  Copyright © 2021 谢恩平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EPCollectionViewFlowLayout.h"
#import "EPStatuses.h"
#import "EPCollectionViewCell.h"
#import "NSDate+WeiboTime.h"

NS_ASSUME_NONNULL_BEGIN

@interface BrowsingHistoryController : UIViewController
@property (nonatomic,strong) NSArray* statuses;//浏览记录微博model数组


@property (nonatomic,strong) UICollectionView* collectionView;
@property (nonatomic) float textViewHeigth;
@property (nonatomic) float retWeetTextHeight;
@property (nonatomic,strong) NSMutableArray* textViewHeigthArray;
@property (nonatomic,strong) NSMutableArray* retWeetTextHeightArray;
@property (nonatomic,strong) NSMutableArray* collectionStatuses;//浏览记录微博字典数组
@property (nonatomic) float originalPicHeight;
@property (nonatomic) float retWeetPicHeight;

@property (nonatomic,strong) NSMutableArray* users;

@end

NS_ASSUME_NONNULL_END
