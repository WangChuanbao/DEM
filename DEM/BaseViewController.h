//
//  BaseViewController.h
//  DEM
//
//  Created by 王宝 on 15/5/8.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "UIViewExt.h"
#import "UIImageView+WebCache.h"
#import "DEMDataSevice.h"
@interface BaseViewController : UIViewController<UIAlertViewDelegate>

@property(nonatomic ,retain)MBProgressHUD *hud;

@property BOOL isBackButton;

@property (nonatomic ,strong)UITapGestureRecognizer *tap;

@property (nonatomic ,strong)UIAlertView *alertView;

- (void)showHUD:(NSString *)title;

- (void)hiddenHUD;

- (void)rightSwipe;

/**
 *  重新加载手势
 */
- (void)setReLoadDataTap;

- (void)removeReLoadDataTap;

@end
