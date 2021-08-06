//
//  MyWeiboViewController.h
//  weibo1.0
//
//  Created by 谢恩平 on 2021/5/24.
//  Copyright © 2021 谢恩平. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EPStatuses.h"
#import "EPCollectionViewCell.h"
#import "NSDate+WeiboTime.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyWeiboViewController : UIViewController
@property (nonatomic,strong) NSArray* statuses;
@property (nonatomic,strong) NSMutableArray* users;
@property (nonatomic,strong) NSArray* photo;
@property (nonatomic,strong) UICollectionView* collectionView;
@property (nonatomic) float textViewHeigth;
@property (nonatomic) float retWeetTextHeight;
@property (nonatomic,strong) NSMutableArray* textViewHeigthArray;
@property (nonatomic,strong) NSMutableArray* retWeetTextHeightArray;
@property (nonatomic,strong) NSMutableArray* collectionStatuses;


@property (nonatomic) BOOL canRefresh;

@end

NS_ASSUME_NONNULL_END
