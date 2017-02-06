//
//  AlarmViewController.h
//  DEM
//
//  Created by 王宝 on 15/5/8.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "BaseViewController.h"
#import "PullTableView.h"

@interface AlarmViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,PullTableViewDelegate>
{

}

@property(nonatomic,retain)NSMutableArray *data;

@property(nonatomic,retain)NSString *year;
@property(nonatomic,retain)NSString *month;
@property(nonatomic,retain)NSString *day;

@end
