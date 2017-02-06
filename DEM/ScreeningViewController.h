//
//  ScreeningViewController.h
//  DEM
//
//  Created by 王宝 on 15/8/4.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScreeningViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong)NSString *labelTitle;

@property (nonatomic ,strong)NSArray *data;

@property (nonatomic ,strong)NSDictionary *notiObject;  //通知传参

@end
