//
//  Oauth2ViewController.m
//  weibo1.0
//
//  Created by 谢恩平 on 2021/5/16.
//  Copyright © 2021 谢恩平. All rights reserved.
//
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#import "Oauth2ViewController.h"



@interface Oauth2ViewController ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView* webView;
@property (nonatomic,copy) NSString *appKey;
@property (nonatomic,copy) NSString *appSecret;
@property (nonatomic,copy) NSString *reDirectUrl;
@property (nonatomic,copy) NSString *code;
@property (nonatomic,copy) NSString *accessToken;
@end

@implementation Oauth2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.webView = [[UIWebView alloc]init];
    self.webView.frame = self.view.bounds;
    self.webView.delegate = self;
    self.view= self.webView;
    
//    self.appKey = @"2136747773";
//    self.appSecret = @"318840452ac411acbf1e8c55875dc9d2";
    self.appKey = @"1738619712";
    self.appSecret = @"1fd59bcf76fe78906624ddeeadaab577";
    
    self.reDirectUrl= @"http://www.baidu.com";
    
    //发起网络请求
    NSString* urlStr = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/authorize?client_id=%@&redirect_uri=%@",self.appKey,self.reDirectUrl];
    
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
   
    
    

 
    
    
//    NSURLSession* urlSession = [NSURLSession sharedSession];
//    NSURLSessionDataTask* dataTask = [urlSession dataTaskWithRequest:homeTimeLineRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
//
//     {
//
//        NSDictionary* content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//
//        NSLog(@"the data is ---------%@",content);
//
//
//
//    }];
//
//    [dataTask resume];

}

#pragma mark - webview delegate
 - (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString* reDirectURL = request.URL.absoluteString;
    NSLog(@"redirecturl=%@",reDirectURL);
    
    //判断redirectURL是不是以self.reDirectUrl开头
    if ([reDirectURL hasPrefix:@"https://m.baidu.com/?code="])
    {
        //截取code
        //现将code=前面的内容去掉
        NSRange range = [reDirectURL rangeOfString:@"code="];
        NSUInteger index = range.location+range.length;
        NSString* tempCode = [reDirectURL substringFromIndex:index];
        //再将code=后面的内容去掉
        range =  [tempCode rangeOfString:@"&from"];
        index = range.location;
        self.code = [tempCode substringToIndex:index];
        NSLog(@"code=%@",self.code);

        NSString* accessTokenRequestUrlStr = [NSString stringWithFormat:@"https://api.weibo.com/oauth2/access_token?client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@",self.appKey,self.appSecret,self.reDirectUrl,self.code];
        NSLog(@"accesstokenurl====%@",accessTokenRequestUrlStr);
        //创建URL
        NSURL* accessTokenRequestURL = [NSURL URLWithString:accessTokenRequestUrlStr];
        //创建POST请求
        NSMutableURLRequest* mutRequest = [[NSMutableURLRequest alloc]initWithURL:accessTokenRequestURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30];
        [mutRequest setHTTPMethod:@"POST"];
        
        //连接server并接受数据
        NSURLSession* urlSession = [NSURLSession sharedSession];
        NSURLSessionDataTask* dataTask = [urlSession dataTaskWithRequest:mutRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                          
         {
                                              
            NSDictionary* content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                              
            NSLog(@"the data is ---------%@",content);
            self.accessToken = [content objectForKey:@"access_token"];
            NSLog(@"------%@",self.accessToken);
            
        }];
        
        [dataTask resume];
 
          
            
                      
            
      
        
    }
    
    return YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
