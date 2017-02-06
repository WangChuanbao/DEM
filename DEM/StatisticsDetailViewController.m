//
//  AlarmDetailViewController.m
//  DEM
//
//  Created by 王宝 on 15/5/25.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "StatisticsDetailViewController.h"
#import "StatisticsDetailTableViewCell.h"
#import "ScreeningWindow.h"

@interface StatisticsDetailViewController ()
{
    UITableView *_tableView;
    
    /*
     *筛选界面背景
     */
    UIView *_bgView;
    
    NSString *_title;    //指标名称（温度、湿度、电量仪..）
    
    NSInteger count;
    
    /**纪录cell中所有指标中更多按钮是否点击*/
    BOOL _isMore;
}
@end

@implementation StatisticsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"详情";
    _title = @"温度";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statisticsMoreAction) name:StatisticsMore object:nil];
    
    //添加导航栏右侧按钮
    [self setRightNavigationBar];
    
    [self initViews];
    
    [self loadData];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //请求筛选视图所需数据
        [self loadScreeningData];
    });
}

- (void)setRightNavigationBar {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 20);
    [button setTitle:@"筛选" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button addTarget:self action:@selector(screening) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
}

//筛选
- (void)screening{
    if (_screenData) {
        //检测筛选页面隐藏的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenWindowHidden) name:ScreeningWindowHidden object:nil];
        
        //筛选完成通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenFinish:) name:ScreeningFinish object:nil];
        
        _bgView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = .7;
        [self.view.window addSubview:_bgView];
        
        ScreeningWindow *screenWindow = [ScreeningWindow shareInstance];
        screenWindow.data = _screenData;
        [screenWindow show];
    }
}

- (void)screenWindowHidden {
    [_bgView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ScreeningWindowHidden object:nil];
}

//筛选完成重新请求数据
- (void)screenFinish:(NSNotification *)noti {
    NSDictionary *dic = noti.object;
    _target_id = [dic objectForKey:@"target_id"];
    _title = [dic objectForKey:@"name"];
    [self loadData];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ScreeningFinish object:nil];
}

- (void)loadScreeningData {
    NSString *url = @"index/getTargetNotLastList";
    NSDictionary *params = [NSDictionary dictionaryWithObject:_roomid forKey:@"room_id"];
    [DEMDataSevice requestWithURL:url params:params httpMethod:@"POST" finishBlock:^(id result) {
        _screenData = [result objectForKey:@"data"];
    } erro:^(id erro) {
        
    }];
}

/*******************************  以上是筛选视图操作  *********************************************/

- (void)initViews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
}

- (void)loadData {
    [super showHUD:@"加载中"];
    
    _isMore = NO;
    
    NSString *url = @"index/getWenDuDetails";
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:_roomid,@"room_id",_dateTime,@"datetime",_target_id,@"target_id", nil];
    [DEMDataSevice requestWithURL:url params:params httpMethod:@"POST" finishBlock:^(id result) {
        if (result == NULL) {
            self.alertView.message = @"与服务器断开连接";
            [self.alertView show];
            [super setReLoadDataTap];
            [super hiddenHUD];
            return ;
        }
        
        NSString *msg = [result objectForKey:@"msg"];
        
        @try {
            _data = [result objectForKey:@"data"];
            
            NSArray *svgs = [_data objectForKey:@"svg"];
            if (svgs.count<=10) {
                count = svgs.count;
            }
            else {
                count = 10;
            }

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_data == nil) {
        return 0;
    }
    return 2+[[_data objectForKey:@"line"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identity;
    
    if (indexPath.row == 0) {
        identity = @"one";
    }
    else if (indexPath.row == 1) {
        identity = @"two";
    }
    else {
        identity = @"cell";
    }
    
    StatisticsDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[StatisticsDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    
    if (indexPath.row == 0) {
        NSString *state = [_data objectForKey:@"state"];
        cell.data = [NSDictionary dictionaryWithObjectsAndKeys:
                     _dateTime,@"date",
                     state,@"state",
                     _title,@"title", nil];
    }
    else if (indexPath.row == 1) {
        cell.data = [NSDictionary dictionaryWithObject:[_data objectForKey:@"svg"] forKey:@"data"];
        cell.isMore = _isMore;
        cell.data = [NSDictionary dictionaryWithObjectsAndKeys:
                     [_data objectForKey:@"svg"],@"data",
                     _title,@"title", nil];
    }
    else {
        cell.data = [[_data objectForKey:@"line"] objectAtIndex:indexPath.row-2];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 40;
    }
    else if (indexPath.row == 1) {
        return 45+count*15;
    }
    return 162;
}

//所有指标更多按钮点击通知
- (void)statisticsMoreAction {
    count = [[_data objectForKey:@"svg"] count];
    _isMore = YES;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    NSArray *array = [NSArray arrayWithObjects:indexPath,nil];
    [_tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
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
