//
//  WebViewController.m
//  weibo1.0
//
//  Created by 谢恩平 on 2021/5/18.
//  Copyright © 2021 谢恩平. All rights reserved.
//
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, ScreenWidth, ScreenHeight-self.navigationController.navigationBar.frame.size.height)];
    [self.view addSubview:self.webView];
    self.url = [NSURL URLWithString:self.str];
    
    NSURLRequest* request = [[NSURLRequest alloc]initWithURL:self.url];
    [self.webView loadRequest:request];
 
}



@end
