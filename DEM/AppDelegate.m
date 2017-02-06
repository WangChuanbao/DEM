//
//  AppDelegate.m
//  DEM
//
//  Created by 王宝 on 15/5/8.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "AppDelegate.h"
#import "LaunchViewController.h"
#import "APService.h"
#import "LoginViewController.h"
#import "MainTabBarController.h"
#import "AlarmDetailViewController.h"
#import "BaseNavigationController.h"
#import "AlarmViewController.h"

@interface AppDelegate ()
{
    NSString *content;
    NSString *contentId;
    /**记录推送标签设置状态*/
    NSString *loginState;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self.window makeKeyAndVisible];
    
    self.window.rootViewController = [[LaunchViewController alloc] init];
    
    //推送标签设置完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushSetTagsFinish) name:kPushSetTagsFinish object:nil];
    
    // 初始化推送
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    // Required
    [APService setupWithOption:launchOptions];
    
    return YES;
}

- (void)pushSetTagsFinish {
    loginState = @"sign";
    if (contentId != nil && ![contentId isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:content delegate:self cancelButtonTitle:@"前往查看" otherButtonTitles:@"稍后再说",nil];
        [alert show];
    }
}

//注册推送
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    // Required
    [APService registerDeviceToken:deviceToken];
}

//接到推送回调(点击推送通知调用)
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    [APService handleRemoteNotification:userInfo];
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    application.applicationIconBadgeNumber =0;
    [APService setBadge:0];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"----%@",userInfo);
    
    //获取推送通知信息
    content = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    contentId = [userInfo objectForKey:@"id"];
    
    if ([loginState isEqualToString:@"sign"]) {
        if (contentId && content) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:content delegate:self cancelButtonTitle:@"前往查看" otherButtonTitles:@"稍后再说",nil];
            [alert show];
        }
    }
    
    //设置badge
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    application.applicationIconBadgeNumber =0;
    
    [APService setBadge:0];
    
    // IOS 7 Support Required;
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    [APService showLocalNotificationAtFront:notification identifierKey:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

//前台进入后台调用
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    application.applicationIconBadgeNumber =0;
    [APService setBadge:0];
}

//从后台将要到前台调用
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    application.applicationIconBadgeNumber =0;
    [APService setBadge:0];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self pushSpecifiedPage];
    }
}

//跳转到指定页面
- (void)pushSpecifiedPage {
    MainTabBarController *mainVC = [MainTabBarController shareMainTabBarController];
    AlarmDetailViewController *alarmVC = [[AlarmDetailViewController alloc] init];
    alarmVC.detailId = contentId;
    [(BaseNavigationController *)mainVC.selectedViewController pushViewController:alarmVC animated:YES];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
