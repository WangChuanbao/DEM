//
//  KeyIndexViewController.h
//  DEM
//
//  Created by 王宝 on 15/6/7.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "BaseViewController.h"
#import "Segmented.h"
#import "KeyIndexCell.h"

@interface KeyIndexViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,SegmentedDelegate,KeyIndexDelegate>

@property (nonatomic ,retain)NSArray *data;
@property (nonatomic ,retain)NSArray *roomList;

@end
