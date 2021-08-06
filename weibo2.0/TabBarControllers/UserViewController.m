//
//  UserViewController.m
//  weibo1.0
//
//  Created by 谢恩平 on 2021/5/15.
//  Copyright © 2021 谢恩平. All rights reserved.
//
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#import "UserViewController.h"

@interface UserViewController ()

@end

@implementation UserViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self layOutView];
}

- (void)layOutView
{
    UIButton* myWeiboButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 140, ScreenWidth, 50)];
    [myWeiboButton setTitle:@"我的微博" forState:UIControlStateNormal];
    [myWeiboButton setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [myWeiboButton setBackgroundColor: [UIColor orangeColor]];
    myWeiboButton.layer.borderWidth = 1.2;
    myWeiboButton.layer.borderColor = [[UIColor colorWithRed:235/255.0 green:142/255.0 blue:85/255.0 alpha:1]CGColor];
    [myWeiboButton addTarget:self action:@selector(pushMyWeiboController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myWeiboButton];
    
    
    UIButton* myCollectedButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 200, ScreenWidth, 50)];
    [myCollectedButton setTitle:@"我的收藏" forState:UIControlStateNormal];
    [myCollectedButton setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
    [myCollectedButton setBackgroundColor: [UIColor orangeColor]];
    myCollectedButton.layer.borderWidth = 1.2;
    myCollectedButton.layer.borderColor = [[UIColor colorWithRed:235/255.0 green:142/255.0 blue:85/255.0 alpha:1]CGColor];
    [myCollectedButton addTarget:self action:@selector(pushCollectionController) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:myCollectedButton];
    
    
    UIButton* browsingHistory = [[UIButton alloc]initWithFrame: CGRectMake(0, 260, ScreenWidth, 50)];
    [browsingHistory setTitle:@"浏览记录" forState: UIControlStateNormal];
    [browsingHistory setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [browsingHistory setBackgroundColor: [UIColor orangeColor]];
    browsingHistory.layer.borderWidth = 1.2;
    browsingHistory.layer.borderColor = [[UIColor colorWithRed:235/255.0 green:142/255.0 blue:85/255.0 alpha:1]CGColor];
    [browsingHistory addTarget:self action:@selector(pushBrowsingHistoryController) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:browsingHistory];
    
    
    
    
}

- (void) pushCollectionController
{
    CollectionController* collectionController = [[CollectionController alloc]init];
    [self.navigationController pushViewController:collectionController animated:YES];
}

- (void) pushMyWeiboController
{
    MyWeiboViewController* myWeiboVC = [[MyWeiboViewController alloc]init];
    [self.navigationController pushViewController:myWeiboVC animated:YES];
}

- (void) pushBrowsingHistoryController
{
    BrowsingHistoryController* browsingHistoryVC = [[BrowsingHistoryController alloc]init];
    [self.navigationController pushViewController:browsingHistoryVC animated:YES];
}


@end
