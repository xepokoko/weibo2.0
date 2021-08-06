//
//  EPCollectionViewFlowLayout.m
//  weibo1.0
//
//  Created by 谢恩平 on 2021/5/17.
//  Copyright © 2021 谢恩平. All rights reserved.
//

#import "EPCollectionViewFlowLayout.h"
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
@implementation EPCollectionViewFlowLayout
-(void)prepareLayout
{
    [super prepareLayout];
    //设置基础数据
    self.itemWidth = ScreenWidth;
    self.itemHeight = ScreenHeight/3;//这个以后做自动适应
    self.paddingMid = 10;
    
    // 设置最小间距
    self.minimumLineSpacing = self.paddingMid;
  
    //设置item大小
    self.itemSize = CGSizeMake(self.itemWidth, self.itemHeight);
    

    self.sectionInset = UIEdgeInsetsMake(0, 0, 93, 0);
}


@end
