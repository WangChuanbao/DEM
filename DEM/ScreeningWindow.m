//
//  ScreeningWindow.m
//  DEM
//
//  Created by 王宝 on 15/8/4.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "ScreeningWindow.h"
#import "BaseNavigationController.h"
#import "ScreeningViewController.h"

@implementation ScreeningWindow

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (ScreeningWindow *)shareInstance {
    static id shareInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[self alloc] initWithFrame:CGRectMake(30, 0, kScreenWidth-30, kScreenHeight)];
    });
    
    return shareInstance;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
    }
    
    return self;
}

- (void)setData:(NSArray *)data {
    ScreeningViewController *viewVC = [[ScreeningViewController alloc] init];
    viewVC.data = data;
    viewVC.labelTitle = @"筛选";
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:viewVC];
    self.rootViewController = nav;
}

- (void)show {
    [self makeKeyWindow];
    self.hidden = NO;
}

- (void)hidden {
    [[NSNotificationCenter defaultCenter] postNotificationName:ScreeningWindowHidden object:nil];
    [self resignKeyWindow];
    self.hidden = YES;
}

@end
