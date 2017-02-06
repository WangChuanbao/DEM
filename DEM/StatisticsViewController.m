//
//  StatisticsViewController.m
//  DEM
//
//  Created by 王宝 on 15/5/8.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "StatisticsViewController.h"
#import "StatisticsTableViewCell.h"
#import "StatisticsDetailViewController.h"

@interface StatisticsViewController ()
{
    Segmented *_segment;
    PullTableView *_tableView;
    
    //接口所需参数
    NSString *_roomid;  //机房id
    NSString *_year;
    NSString *_month;
    NSString *_day;
    NSArray *_placeholders;
    int pageIndex;      //页码
    NSString *startime; //时间
    
    NSArray *_roomList;
    NSMutableArray *_data;
    
    UIButton *_search;//搜索按钮
    
}

@end

@implementation StatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"统计";
    
    //变量初始化
    pageIndex = 1;
    _roomid = @"";
    _year = @"";
    _month = @"";
    _day = @"";
    _roomList = [[NSArray alloc] init];
    _data = [[NSMutableArray alloc] init];
    _placeholders = [[NSArray alloc] init];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *datestr = [formatter stringFromDate:date];
    _placeholders = [datestr componentsSeparatedByString:@"-"];
    startime = @"";
    
    [self initViews];
    
    [self loadSegment];
    
    [super showHUD:@"加载中"];
}

- (void)loadSegment {
    NSString *url = @"index/getRoomList";
    [DEMDataSevice requestWithURL:url params:nil httpMethod:@"POST" finishBlock:^(id result) {
        
        if (result == NULL) {
            self.alertView.message = @"与服务器断开连接";
            [self.alertView show];
            [super setReLoadDataTap];
            [super hiddenHUD];
            return ;
        }
        
        @try {
            
            _roomList = [result objectForKey:@"data"];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in _roomList) {
                NSString *title = [dic objectForKey:@"title"];
                [array addObject:title];
            }
            
            //分段控件赋值
            //如果只有一个机房则不显示分段控件，并重新布局
            if (_roomList.count == 1) {
                [_segment removeFromSuperview];
                [_tableView setFrame:CGRectMake(0, 0, self.view.width, self.view.height-49)];
            }
            else {
                if (_roomList.count>3) {
                    _segment.segmentCount = 3;
                }
                else {
                    _segment.segmentCount = (int)_roomList.count;
                }
                _segment.array = array;
            }
            
            //请求数据的初始化条件
            _roomid = [_roomList.firstObject objectForKey:@"id"];
            
            [self loadData];
            
        }
        @catch (NSException *exception) {
        }
        @finally {
        }
        
    } erro:^(id erro) {
        
    }];
  
}

- (void)loadData {
    
    NSString *url = @"index/statisticsWenduList";
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            _roomid,@"room_id",
                            startime,@"start_time",
                            [NSNumber numberWithInt:pageIndex],@"p", nil];
    
    [DEMDataSevice requestWithURL:url params:params httpMethod:@"POST" finishBlock:^(id result) {
        
        if (result == NULL) {
            self.alertView.message = @"与服务器断开连接";
            [self.alertView show];
            [super hiddenHUD];
            return ;
        }
        
        NSString *msg = [result objectForKey:@"msg"];
        
        @try {
            
            [_data addObjectsFromArray:[result objectForKey:@"data"]];
            
            _tableView.pullTableIsRefreshing = NO;
            _tableView.pullTableIsLoadingMore = NO;
            
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

- (void)initViews {
    _segment = [[Segmented alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 45)];
    _segment.titleColorWithHighlighted = RGBA(54, 125, 242, 1);
    _segment.labelColor = RGBA(54, 125, 242, 1);
    _segment.delegate = self;
    [self.view addSubview:_segment];
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0.0f, 0.0f, _segment.width, 1.0f);
    topBorder.backgroundColor = RGBA(154, 154, 154, 1).CGColor;
    [_segment.layer addSublayer:topBorder];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, _segment.height-1.0f, _segment.width, 1.0f);
    bottomBorder.backgroundColor = RGBA(154, 154, 154, 1).CGColor;
    [_segment.layer addSublayer:bottomBorder];
    
    _tableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, _segment.bottom, self.view.width, self.view.height-64-_segment.height-49) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.pullDelegate = self;
    [self.view addSubview:_tableView];
}

#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identity;
    if (indexPath.row==0) {
        identity = @"first";
    }
    else {
        identity = @"cell";
    }
    
    StatisticsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[StatisticsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    
    if (indexPath.row == 0) {
        cell.data = [NSDictionary dictionaryWithObject:_placeholders forKey:@"date"];
    }
    else {
        if (_data.count>indexPath.row-1) {
            cell.data = [_data objectAtIndex:indexPath.row-1];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 23;
    }
    return 75;
}

#pragma mark 头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectZero];
    bgView.backgroundColor = RGBA(237, 237, 237, 1);
    
    CALayer *border = [CALayer layer];
    border.backgroundColor = RGBA(184, 184, 184, 1).CGColor;
    border.frame = CGRectMake(0, 54, self.view.width, 1);
    [bgView.layer addSublayer:border];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    for (int i=0; i<3; i++) {
        UITextField *textView = (UITextField *)[tableView viewWithTag:2000+i];
        [textView resignFirstResponder];
    }
    
    if (indexPath.row != 0 ) {
        
        NSDictionary *dic = [_data objectAtIndex:indexPath.row-1];
        NSString *time = [dic objectForKey:@"time"];
        
        StatisticsDetailViewController *detailVC = [[StatisticsDetailViewController alloc] init];
        detailVC.roomid = _roomid;
        detailVC.dateTime = time;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }
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
    
    startime = [NSString stringWithFormat:@"%d",interval];
    
    pageIndex = 1;
    
    [_data removeAllObjects];
    
    [self loadData];
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

#pragma mark 上拉下拉刷新
- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView {
    NSDate *date = [NSDate date];
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
    int interval = [date timeIntervalSince1970];
    startime = [NSString stringWithFormat:@"%d",interval];
    
    pageIndex = 1;
    
    [_data removeAllObjects];
    
    [self loadData];
    
    pullTableView.pullLastRefreshDate = [NSDate date];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView {
    ++pageIndex;
    
    [self loadData];
}

#pragma mark SegmentedDelegate
- (void)Segmented:(Segmented *)segmented DidSelectAtIndex:(NSInteger)index {
    _roomid = [[_roomList objectAtIndex:index] objectForKey:@"id"];
    [_data removeAllObjects];
    [self loadData];
}

- (void)reLoadData {
    [super showHUD:@"加载中"];
    [self loadSegment];
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
