//
//  HomeViewController.h
//  DEM
//
//  Created by 王宝 on 15/5/8.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "BaseViewController.h"
#import "Segmented.h"

@interface HomeViewController : BaseViewController<SegmentedDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic ,retain)NSArray *data;

@end
