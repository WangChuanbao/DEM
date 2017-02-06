//
//  HandleViewController.h
//  DEM
//
//  Created by 王宝 on 15/5/22.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "BaseViewController.h"
#import "HandleTableViewCell.h"

@interface HandleViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,handleCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic ,retain) NSArray *data;
@end
