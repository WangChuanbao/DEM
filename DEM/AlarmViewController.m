//
//  AlarmViewController.m
//  DEM
//
//  Created by 王宝 on 15/5/8.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "AlarmViewController.h"
#import "Segmented.h"
#import "AlarmTableViewCell.h"
#import "DEMDataSevice.h"
#import "AlarmDetailViewController.h"

@interface AlarmViewController ()
{
    PullTableView *_tableView;
    
    int pageIndex;  //页码
    NSString *_oldtime; //用于上拉加载更多，记录用户所选时间
    
    NSArray *_placeholders;
    
    UIButton *_search;//搜索按钮
    
}
@end

@implementation AlarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"告警";
    
    //处理完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFinish) name:HandleFinish object:nil];
    
    _oldtime = @"";
    _placeholders = [[NSArray alloc] init];
    
    [self _initViews];
    
    [self _loadData];
    
    [super showHUD:@"加载中"];
}

- (void)_loadData {
    pageIndex = 1;

    NSString *url = @"index/searchWarning";
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *datestr = [formatter stringFromDate:date];
    _placeholders = [datestr componentsSeparatedByString:@"-"];
    
    int interval = [date timeIntervalSince1970];
    NSString *star_time = [NSString stringWithFormat:@"%d",interval];
    _oldtime = star_time;
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:star_time,@"start_time", nil];
    
    [DEMDataSevice requestWithURL:url params:params httpMethod:@"POST" finishBlock:^(id result) {
        if (result == NULL) {
            self.alertView.message = @"与服务器断开连接";
            [self.alertView show];
            [super hiddenHUD];
            if (_data.count <=0 || _data == nil) {
                [super setReLoadDataTap];
            }
            return ;
        }
        
        NSString *msg = [result objectForKey:@"msg"];
        
        @try {
            NSDictionary *data = [result objectForKey:@"data"];
            NSArray *list = [data objectForKey:@"list"];
            self.data = [[NSMutableArray alloc] initWithArray:list];
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

- (void)_initViews {
    
    _tableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-64-49) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.pullDelegate = self;
    _tableView.backgroundColor = RGBA(237, 237, 237, 1);
    [self.view addSubview:_tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identity = @"cell";
    
    AlarmTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    
    if (cell == nil) {
        cell = [[AlarmTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
        cell.nav = self.navigationController;
    }
    
    //cell操作
    if (indexPath.row < self.data.count) {
        cell.data = [self.data objectAtIndex:indexPath.row];
    }
    NSDictionary *dic = [self.data objectAtIndex:0];
    NSString *sid = [dic objectForKey:@"id"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [self.data objectAtIndex:indexPath.row];
    NSString *title = [dic objectForKey:@"msg"];
    return [AlarmTableViewCell cellHeight:title];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //收起键盘
    for (int i=0; i<3; i++) {
        UITextField *textField = (UITextField *)[tableView viewWithTag:2000+i];
        [textField resignFirstResponder];
    }

    //－－－－－－－－－－－－－－－－－－－－
    
    AlarmDetailViewController *alarmDetail = [[AlarmDetailViewController alloc] init];
    
    NSDictionary *data = [self.data objectAtIndex:indexPath.row];

    NSString *aid = [data objectForKey:@"id"];
    
    alarmDetail.detailId = aid;
    
    [self.navigationController pushViewController:alarmDetail animated:YES];
    
}

#pragma mark 头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectZero];
    bgView.backgroundColor = RGBA(237, 237, 237, 1);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.view.width-20, 35)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.masksToBounds = YES;
    view.layer.borderColor = RGBA(184, 184, 184, 1).CGColor;
    view.layer.borderWidth = 1;
    view.layer.cornerRadius = 5;
    [bgView addSubview:view];
    
    NSArray *array = @[@"年",@"月",@"日"];
    
    for (int i=0; i<array.count; i++) {
        //创建文本框
        UITextField *textView = [[UITextField alloc] initWithFrame:CGRectMake(10+i*(self.view.width*60/320+self.view.width*20/320), 10, self.view.width*60/320, view.height-20)];
        textView.returnKeyType = UIReturnKeyDone;
        textView.textAlignment = NSTextAlignmentCenter;
        textView.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        textView.returnKeyType = UIReturnKeySearch;
        textView.font = [UIFont systemFontOfSize:11];
        textView.tag = 2000+i;
        textView.text = [_placeholders objectAtIndex:i];
        textView.backgroundColor = RGBA(237, 237, 237, 1);
        textView.delegate = self;
        [view addSubview:textView];
        
        //创建label
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(textView.right, textView.top, self.view.width*20/320, textView.height)];
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [array objectAtIndex:i];
        [view addSubview:label];
    }
    
    //头视图搜索按钮
    _search = [[UIButton alloc] initWithFrame:CGRectMake(view.width-40, 10, 30, 15)];
    _search.backgroundColor = RGBA(54, 125, 242, 1);
    _search.titleLabel.font = [UIFont boldSystemFontOfSize:11];
    [_search setTitle:@"搜索" forState:UIControlStateNormal];
    [_search setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_search setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [_search addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_search];
    
    return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 55;
}

//头视图搜索按钮点击事件
- (void)searchAction:(UIButton *)button {
    [super showHUD:@"加载中"];
    
    //收起键盘
    for (int i=0; i<3; i++) {
        UITextField *textField = (UITextField *)[button.superview viewWithTag:2000+i];
        [textField resignFirstResponder];
        if (textField.tag == 2000) {
            _year = textField.text;
        }
        else if (textField.tag == 2001) {
            _month = textField.text;
        }
        else if (textField.tag == 2002) {
            _day = textField.text;
        }
    }
    
    [self.data removeAllObjects];
    self.data = nil;
    
    _placeholders = @[_year,_month,_day];
    
    if (_month.length<2) {
        _month = [NSString stringWithFormat:@"0%@",_month];
    }
    if (_day.length<2) {
        _day = [NSString stringWithFormat:@"0%@",_day];
    }
    NSString *string = [NSString stringWithFormat:@"%@%@%@",_year,_month,_day];
    
    NSTimeZone *zone = [[NSTimeZone alloc] initWithName:@"UTC"];
    NSDateFormatter *fromatter = [[NSDateFormatter alloc] init];
    [fromatter setDateFormat:@"yyyyMMdd"];
    [fromatter setTimeZone:zone];
    NSDate *date = [fromatter dateFromString:string];
    
    int interval = [date timeIntervalSince1970];
    
    NSString *start_time = [NSString stringWithFormat:@"%d",interval];
    _oldtime = start_time;
    
    NSString *url = @"index/searchWarning";
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:start_time,@"start_time", nil];
    
    [DEMDataSevice requestWithURL:url params:params httpMethod:@"POST" finishBlock:^(id result) {
        if (result == NULL) {
            self.alertView.message = @"与服务器断开连接";
            [self.alertView show];
            [super hiddenHUD];
            return ;
        }
        
        NSString *msg = [result objectForKey:@"msg"];
        
        @try {
            NSDictionary *data = [result objectForKey:@"data"];
            NSArray *list = [data objectForKey:@"list"];
            
            self.data = [NSMutableArray arrayWithArray:list];
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

#pragma mark UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField becomeFirstResponder];
}

//按下Done按钮的调用方法，我们让键盘消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self searchAction:_search];
    
    //[textField resignFirstResponder];
    
    return YES;
    
}

#pragma mark PullTableViewDelegate
- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView {
    NSLog(@"下拉刷新");
    //更新数据
    [self performSelector:@selector(refreshStar:) withObject:pullTableView afterDelay:2];
}

- (void)refreshStar:(PullTableView *)pullView {
    [_data removeAllObjects];
    _data = nil;
    
    [self _loadData];
    
    pullView.pullLastRefreshDate = [NSDate date];
    pullView.pullTableIsRefreshing = NO;

}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView {
    NSLog(@"上拉加载更多");
    //请求更多数据
    [self performSelector:@selector(loadMoreStar:) withObject:pullTableView afterDelay:2];
}

- (void)loadMoreStar:(PullTableView *)pullView {
    
    ++pageIndex;
    
    NSString *url = @"index/searchWarning";
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:_oldtime,@"start_time",[NSNumber numberWithInt:pageIndex],@"p", nil];
    
    [DEMDataSevice requestWithURL:url params:params httpMethod:@"POST" finishBlock:^(id result) {
        if (result == NULL) {
            self.alertView.message = @"与服务器断开连接";
            [self.alertView show];
            [super hiddenHUD];
            return ;
        }
        
        NSString *msg = [result objectForKey:@"msg"];
        
        @try {
            NSDictionary *data = [result objectForKey:@"data"];
            NSArray *list = [data objectForKey:@"list"];
            [self.data addObjectsFromArray:list];
            [_tableView reloadData];
        }
        @catch (NSException *exception) {
            self.alertView.message = msg;
            [self.alertView show];
        }
        @finally {
            
        }
        
        pullView.pullTableIsLoadingMore = NO;
        
    } erro:^(id erro) {
        
    }];

}

- (void)handleFinish {
    [_data removeAllObjects];
    _data = nil;
    
    [self _loadData];
}

- (void)reLoadData {
    [super showHUD:@"加载中"];
    [self _loadData];
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
