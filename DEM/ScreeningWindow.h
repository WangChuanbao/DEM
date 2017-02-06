//
//  ScreeningWindow.h
//  DEM
//
//  Created by 王宝 on 15/8/4.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScreeningWindow : UIWindow

@property (nonatomic ,strong) NSArray *data;

+ (ScreeningWindow *)shareInstance;

- (void)show;

- (void)hidden;

@end
