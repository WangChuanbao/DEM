//
//  MainTabBarController.h
//  DEM
//
//  Created by 王宝 on 15/5/8.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTabBarController : UITabBarController<UINavigationControllerDelegate>

- (void)showTabBar;

- (void)hiddenTabBar;

+(id)shareMainTabBarController;

@end
