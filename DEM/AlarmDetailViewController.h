//
//  AlarmDetailViewController.h
//  DEM
//
//  Created by 王宝 on 15/6/23.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "BaseViewController.h"

@interface AlarmDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,retain)NSString *detailId;

@end
