//
//  WXalarmViewController.h
//  DEM
//
//  Created by 王宝 on 15/5/22.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "BaseViewController.h"

@interface WXalarmViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic ,retain) NSArray *data;

@end
