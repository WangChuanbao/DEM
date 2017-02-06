//
//  MainTabBarController.m
//  DEM
//
//  Created by 王宝 on 15/5/8.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "MainTabBarController.h"
#import "HomeViewController.h"
#import "AlarmViewController.h"
#import "StatisticsViewController.h"
#import "MessageViewController.h"
#import "UserViewController.h"
#import "BaseNavigationController.h"
#import "TabBarItem.h"
#import "UIViewExt.h"

@interface MainTabBarController ()
{
    TabBarItem *_bar;
    UIImageView *_tabBarView;
}

@end

@implementation MainTabBarController

+(id)shareMainTabBarController {
    static MainTabBarController *single = nil;
    if (single == nil) {
        @synchronized (self)
        {
            single = [[MainTabBarController alloc]init];
        }
    }
    return single;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //self.tabBar.translucent = NO;
    
    [self _initViewControllers];
    
    [self _initTabBar];
}

- (void)_initViewControllers {
    
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    AlarmViewController *alarmVC = [[AlarmViewController alloc] init];
    StatisticsViewController *statisticsVC = [[StatisticsViewController alloc] init];
    MessageViewController *messageVC = [[MessageViewController alloc] init];
    UserViewController *userVC = [[UserViewController alloc] init];
    
    NSArray *viewCtrls = @[homeVC,alarmVC,statisticsVC,messageVC,userVC];
    
    NSMutableArray *navigations = [[NSMutableArray alloc] init];
    
    for (int i=0; i<viewCtrls.count; i++) {
        
        UIViewController *viewVC = [viewCtrls objectAtIndex:i];
        
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:viewVC];
        
        nav.delegate = self;
        
        [navigations addObject:nav];
        
    }
    
    self.viewControllers = navigations;
    
}

- (void)_initTabBar {
    
    self.tabBar.hidden = YES;
    //[self.tabBar setBarTintColor:[UIColor clearColor]];
    //[self.tabBar removeFromSuperview];
    
    _tabBarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kScreenHeight-49, kScreenWidth, 49)];
    _tabBarView.backgroundColor = RGBA(203, 203, 203, 1);
    _tabBarView.userInteractionEnabled = YES;
    [self.view addSubview:_tabBarView];
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0, 0, kScreenWidth, 1);
    topBorder.backgroundColor = RGBA(184, 184, 184, 1).CGColor;
    [_tabBarView.layer addSublayer:topBorder];
    
    NSArray *imgAryNormal = @[@"首页01.png",@"告警01.png",@"统计01.png",@"消息01.png",@"用户01.png"];
    NSArray *imgAry = @[@"首页02.png",@"告警02.png",@"统计02.png",@"消息02.png",@"用户02.png"];
    NSArray *titleAry = @[@"首页",@"告警",@"统计",@"消息",@"用户"];
    
    //float range = kScreenWidth*22/320;
    float width = kScreenWidth/imgAry.count;
    
    for (int i=0; i<imgAry.count; i++) {
        
        NSString *imageName = [imgAryNormal objectAtIndex:i];
        NSString *imgName = [imgAry objectAtIndex:i];
        NSString *title = [titleAry objectAtIndex:i];
        
        TabBarItem *item = [[TabBarItem alloc] initWithFrame:CGRectMake(width*i, 0, width, 49) imageName:imageName selectImageName:imgName title:title];
        
        if (i==0) {
            item.selected = YES;
            _bar = item;
        }
        
        item.tag = i;
        [item addTarget:self action:@selector(tabBarItemSelected:) forControlEvents:UIControlEventTouchUpInside];
        [_tabBarView addSubview:item];
        
    }

}

- (void)tabBarItemSelected:(TabBarItem *)item {
    
    self.selectedIndex = item.tag;
    
    if (_bar) {
        
        _bar.selected = NO;
        
    }
    item.selected = YES;
    _bar = item;
    
}

- (void)showTabBar {
    [UIView animateWithDuration:.35 animations:^{
        _tabBarView.left = 0;
    }];
}

- (void)hiddenTabBar {
    [UIView animateWithDuration:.35 animations:^{
        _tabBarView.left = -kScreenWidth;
    }];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    int count = (int)navigationController.viewControllers.count;
    
    if (count >= 2) {
        [self hiddenTabBar];
    }
    else {
        [self showTabBar];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
