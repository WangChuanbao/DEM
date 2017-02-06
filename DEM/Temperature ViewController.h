//
//  Temperature ViewController.h
//  DEM
//
//  Created by 王宝 on 15/5/12.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "BaseViewController.h"
#import "TemperatureTableViewCell.h"

@interface Temperature_ViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,DetailDelegate>

@property(nonatomic ,assign)NSInteger type;     //接口参数（首页按钮标实）

@property(nonatomic ,retain)NSDictionary *data;

@end
