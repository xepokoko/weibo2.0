//
//  HomePageController.h
//  weibo1.0
//
//  Created by 谢恩平 on 2021/5/15.
//  Copyright © 2021 谢恩平. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomePageController : UIViewController
@property (nonatomic,strong) NSArray* statuses;
@property (nonatomic,strong) NSArray* users;
@property (nonatomic,strong) NSMutableArray* myUsers;//我的作者
@property (nonatomic,strong) NSMutableArray* allUsers;//我和网络数据微博作者
@property (nonatomic,strong) NSArray* photo;
@property (nonatomic,strong) NSMutableArray* myStatuses;//我的微博数组
@property (nonatomic,strong) NSMutableArray* allStatuses;//我的微博和网络微博拼接的数据
@property (nonatomic,strong) NSMutableArray* collectionStatuses;//收藏微博数组
@property (nonatomic,strong) NSMutableArray* browsingHistoryStatuse;//浏览记录数组
@property (nonatomic,strong) UICollectionView* collectionView;
@property (nonatomic,strong) UISearchController* searchController;//搜索控制器

@property (nonatomic) BOOL canRefresh;//是否可刷新
@property (nonatomic) BOOL canLoadMore;//是否可加载更多

@property (nonatomic) CGFloat picHeight;//全部图片的所占的高度
@property (nonatomic) CGFloat textViewHeigth;
@property (nonatomic) CGFloat retWeetTextHeight;
@property (nonatomic,strong) NSMutableArray* textViewHeigthArray;//原创微博高度数组
@property (nonatomic,strong) NSMutableArray* retWeetTextHeightArray;//转发微博高度数组
@property (nonatomic,strong) NSMutableArray* picHeightArray;//图片占的高度
@property (nonatomic) float retWeetPicHeight;//转发微博的图片高度

@property (nonatomic,strong) NSMutableArray* searchListArray;//搜索时展示的数组内容
@property (nonatomic,strong) NSMutableArray* searchUserArray;//搜索时对应的作者信息

@end

NS_ASSUME_NONNULL_END
