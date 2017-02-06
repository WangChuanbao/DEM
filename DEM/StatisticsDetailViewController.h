//
//  AlarmDetailViewController.h
//  DEM
//
//  Created by 王宝 on 15/5/25.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "BaseViewController.h"

@interface StatisticsDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,retain) NSString *roomid;     //机房id
@property (nonatomic ,retain) NSString *dateTime;
@property (nonatomic ,retain) NSDictionary *data;
@property (nonatomic ,strong) NSArray *screenData;
@property (nonatomic ,strong) NSString *target_id;  //指标id

@end
