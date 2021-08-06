//
//  EPCollectionViewFlowLayout.h
//  weibo1.0
//
//  Created by 谢恩平 on 2021/5/17.
//  Copyright © 2021 谢恩平. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EPCollectionViewFlowLayout : UICollectionViewFlowLayout
@property(nonatomic) CGFloat  itemWidth;     // item宽
@property(nonatomic) CGFloat  itemHeight;   // item高
@property(nonatomic) CGFloat  paddingMid;   // item最小间距
@end

NS_ASSUME_NONNULL_END
