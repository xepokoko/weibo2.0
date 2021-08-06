//
//  CollectionController.h
//  weibo1.0
//
//  Created by 谢恩平 on 2021/5/23.
//  Copyright © 2021 谢恩平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EPStatuses.h"
#import "EPCollectionViewCell.h"
#import "NSDate+WeiboTime.h"
#import "EPCollectionViewFlowLayout.h"
NS_ASSUME_NONNULL_BEGIN

@interface CollectionController : UIViewController
@property (nonatomic,strong) NSArray* statuses;//收藏微博model数组

@property (nonatomic,strong) NSArray* photo;
@property (nonatomic,strong) UICollectionView* collectionView;
@property (nonatomic) float textViewHeigth;
@property (nonatomic) float retWeetTextHeight;
@property (nonatomic,strong) NSMutableArray* textViewHeigthArray;
@property (nonatomic,strong) NSMutableArray* retWeetTextHeightArray;
@property (nonatomic,strong) NSMutableArray* collectionStatuses;//收藏微博字典数组
@property(nonatomic)  float originalPicHeight;
@property (nonatomic) float retWeetPicHeight;

@property (nonatomic,strong) NSMutableArray* users;

@end

NS_ASSUME_NONNULL_END
