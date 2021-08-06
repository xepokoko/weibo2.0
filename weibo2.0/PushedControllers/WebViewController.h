//
//  WebViewController.h
//  weibo1.0
//
//  Created by 谢恩平 on 2021/5/18.
//  Copyright © 2021 谢恩平. All rights reserved.
//
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebViewController : UIViewController
@property (nonatomic,strong) UIWebView* webView;
@property (nonatomic,strong) NSURL* url;
@property (nonatomic,copy) NSString* str;
@end

NS_ASSUME_NONNULL_END
