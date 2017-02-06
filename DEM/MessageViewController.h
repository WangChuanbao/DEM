//
//  MessageViewController.h
//  DEM
//
//  Created by 王宝 on 15/5/8.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "BaseViewController.h"
#import "PullTableView.h"

@interface MessageViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,PullTableViewDelegate>

@property(nonatomic ,retain)NSMutableArray *data;

@end
