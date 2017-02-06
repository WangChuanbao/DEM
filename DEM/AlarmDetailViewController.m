//
//  AlarmDetailViewController.m
//  DEM
//
//  Created by 王宝 on 15/6/23.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "AlarmDetailViewController.h"
#import "AlarmDetailTableViewCell.h"
#import "ManageViewController.h"

@interface AlarmDetailViewController ()
{
    UITableView *_tableView;
    NSArray *_keys;
    NSArray *_data;
    NSString *_handleState; //处理状态
    NSString *_alarm_id;       //告警信息id
    NSString *_room_id;     //机房id
}
@end

@implementation AlarmDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"告警详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _data = [[NSArray alloc] init];
    _keys = @[@"告警设备",@"告警详情",@"告警级别",@"告警时间",@"处理状态",@"处理时间",@"处  理  人"];
    
    [self initViews];
    
    [self loadData];

}

- (void)loadData {
    [super showHUD:@"加载中..."];
    
    NSString *url = @"index/getEventDetails";
    NSDictionary *params = [NSDictionary dictionaryWithObject:_detailId forKey:@"id"];
    [DEMDataSevice requestWithURL:url params:params httpMethod:@"POST" finishBlock:^(id result) {
        if (result == NULL) {
            self.alertView.message = @"与服务器断开连接";
            [self.alertView show];
            [super hiddenHUD];
            [super setReLoadDataTap];
            return ;
        }
        
        NSString *msg = [result objectForKey:@"msg"];
        
        @try {
            NSDictionary *data = [result objectForKey:@"data"];
            _alarm_id = [data objectForKey:@"id"];
            _room_id = [data objectForKey:@"machine_room_id"];
            [self loadDataAfter:data];
            [_tableView reloadData];
        }
        @catch (NSException *exception) {
            self.alertView.message = msg;
            [self.alertView show];
        }
        @finally {
            
        }
        
        [super hiddenHUD];
        
    } erro:^(id erro) {
        [super hiddenHUD];
        [self.alertView show];
    }];
    
}

- (void)loadDataAfter:(NSDictionary *)data {
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    NSString *value = @"";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
    
    for (int i=0; i<_keys.count; i++) {
        switch (i) {
            case 0:
            {
                value = [NSString stringWithFormat:@"%@\n%@",[data objectForKey:@"target_name"],[data objectForKey:@"room_target_name"]];
            }
                break;
            case 1:
            {
                value = [data objectForKey:@"msg"];
            }
                break;
            case 2:
            {
                NSString *state = [data objectForKey:@"event_status"];
                if ([state isEqualToString:@"2"] || state.intValue == 2) {
                    value = @"黄色告警";
                }
                else if ([state isEqualToString:@"3"] || state.intValue == 3) {
                    value = @"红色告警";
                }
            }
                break;
            case 3:
            {
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[data objectForKey:@"addtime"] intValue]];
                value = [formatter stringFromDate:date];
            }
                break;
            case 4:
            {
                NSString *is_solve = [data objectForKey:@"is_solve"];
                if (is_solve.integerValue == 0 || [is_solve isEqualToString:@"0"]) {
                    value = @"未处理(点击处理)";
                }
                else {
                    value = @"已处理";
                }
            }
                break;
            case 5:
            {
                int timeSep = [[data objectForKey:@"solve_time"] intValue];
                if (timeSep == 0) {
                    value = @"";
                }
                else {
                    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeSep];
                    value = [formatter stringFromDate:date];
                }
            }
                break;
            case 6:
            {
                value = [data objectForKey:@"handle_username"];
            }
                break;
                
            default:
                break;
        }
        
        NSDictionary *dic = [NSDictionary dictionaryWithObject:value forKey:[_keys objectAtIndex:i]];
        [dataArray addObject:dic];
    }
    
    _data = dataArray;
}

- (void)initViews {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, self.view.width, (self.view.height-64)*420/504)];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0, _tableView.height-0.5, _tableView.width, .5);
    bottomBorder.backgroundColor = RGBA(194, 216, 251, 1).CGColor;
    [_tableView.layer addSublayer:bottomBorder];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identity = @"alarmcell";
    AlarmDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[AlarmDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
        [cell setFrame:CGRectMake(0, 0, self.view.width, 0)];
    }
    
    cell.data = [_data objectAtIndex:indexPath.row];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _tableView.height/_keys.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        ManageViewController *manageVC = [[ManageViewController alloc] init];
        manageVC.room_id = _room_id;
        manageVC.alarm_id = _alarm_id;
        [self.navigationController pushViewController:manageVC animated:YES];
    }
}

- (void)reLoadData {
    [self loadData];
    [super removeReLoadDataTap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
