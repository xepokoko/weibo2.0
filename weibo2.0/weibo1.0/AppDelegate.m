//
//  AppDelegate.m
//  weibo1.0
//
//  Created by 谢恩平 on 2021/5/10.
//  Copyright © 2021 谢恩平. All rights reserved.
//



//         AppKey = 2136747773
//         AppSecret = 318840452ac411acbf1e8c55875dc9d2
//         Oauth2授权URL https://api.weibo.com/oauth2/authorize
//         授权回调页ReDirectUrl：    http://www.baidu.com
//         请求参数的名称:  client_id    这个对应appkey
//                       redirect_uri   这个对应授权回调页
/*        请求验证的拼接：https://api.weibo.com/oauth2/authorize?client_id=2136747773&redirect_uri=http://www.baidu.com
 */

//         code=70576233a1f3dfe457c1e12aef755ef0
/*
          "access_token" = "2.002bZvfGlhZb1C3a01768d7d0F8JKg";
          "expires_in" = 157679999;
          isRealName = true;
          "remind_in" = 157679999;
          uid = 6116348319;
*/




#import "AppDelegate.h"
#import "HomePageController.h"
#import "CreateViewController.h"
#import "MessageViewController.h"
#import "UserViewController.h"
#import "DiscoverViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window  = [[UIWindow alloc]initWithFrame: [[UIScreen mainScreen] bounds]];
    UITabBarController* tabBarController = [[UITabBarController alloc]init];
    
    
    HomePageController* homePageController = [[HomePageController alloc]init];
    homePageController.tabBarItem.title = @"首页";
    homePageController.tabBarItem.image = [UIImage imageNamed:@"home"];
    UINavigationController* homePageNavigationController = [[UINavigationController alloc]initWithRootViewController:homePageController];
    
    DiscoverViewController* discoverViewController = [[DiscoverViewController alloc]init];
    discoverViewController.tabBarItem.title = @"发现";
    discoverViewController.tabBarItem.image = [UIImage imageNamed:@"search"];
    UINavigationController* discoverNavigationController = [[UINavigationController alloc]initWithRootViewController:discoverViewController];
    
    CreateViewController* createViewController = [[CreateViewController alloc]init];
    createViewController.tabBarItem.image = [UIImage imageNamed:@"add"];
    UINavigationController* createNavigationController = [[UINavigationController alloc]initWithRootViewController:createViewController];
    
    MessageViewController* messageViewController = [[MessageViewController alloc]init];
  
    messageViewController.tabBarItem.title = @"消息";
    messageViewController.tabBarItem.image = [UIImage imageNamed:@"message"];
    UINavigationController* messageNavigationController = [[UINavigationController alloc]initWithRootViewController:messageViewController];
    
    UserViewController* userViewController = [[UserViewController alloc]init];
    userViewController.tabBarItem.title = @"我";
    userViewController.tabBarItem.image = [UIImage imageNamed:@"user"];
    UINavigationController* userNavigationController = [[UINavigationController alloc]initWithRootViewController:userViewController];
    
    [tabBarController setViewControllers:@[homePageNavigationController,discoverNavigationController,createNavigationController,messageNavigationController,userNavigationController]];
    
    
    
    
    [self.window setRootViewController:tabBarController];
    [self.window makeKeyWindow];
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
