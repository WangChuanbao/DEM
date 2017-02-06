//
//  HomeViewController.m
//  DEM
//
//  Created by 王宝 on 15/5/8.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeAlarmView.h"
#import "MBProgressHUD.h"
#import "MD5.h"
#import "UIButton+WebCache.h"
#import "Temperature ViewController.h"

@interface HomeViewController ()
{
    UITableView *_tableView;
    
    UITableViewCell *_cell;
    
    Segmented *_segment;
    
    UIView *_view;
    
    float _viewHeight;
    
    NSDictionary *_csdata;
    NSArray *_csBtnData;//中间按钮
    NSArray *_csAlarmData; //告警
    
    NSTimer *_timer;        //定时器，每个5分钟刷新数据
    
    int _index;         //记录显示哪个机房的数据
    
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"动环移动监控平台";
    
    _index = 8;
    _csdata = [[NSDictionary alloc] init];
    _csBtnData = [[NSArray alloc] init];
    _csAlarmData = [[NSArray alloc] init];
    
    [self _initTableView];
    
    [self _loadData:NO];
    
    [super showHUD:@"加载中"];
    
    [self performSelector:@selector(_loadTimer) withObject:nil afterDelay:300];
   
}

- (void)_loadTimer {
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(_loadData:) userInfo:nil repeats:YES];
    }
}

- (void)_initNavigationItem {
    
    NSDictionary *title = [_csdata objectForKey:@"title"];
    NSString *url = [title objectForKey:@"logo_home"];
    
    UIImageView *item = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 65, 20)];
    [item sd_setImageWithURL:[NSURL URLWithString:url]];

    item.contentMode = UIViewContentModeScaleAspectFit;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:item];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
}

- (void)_initTableView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-49-64) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollEnabled = NO;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    _cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    _cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [_cell setFrame:CGRectMake(0, 0, kScreenWidth, 0)];
    
    if (indexPath.row == 0) {
        
        [self _initSegmented];
        
    }
    else {
        
        [self _initButton];
        
        [self _initAlarm];
        
    }
    
    return _cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *array = [_csdata objectForKey:@"tag"];
    
    if (array.count == 1) {
        if (indexPath.row == 0) {
            return 0;
        }
        else {
            return kScreenHeight-49-64;
        }
    }
    if (indexPath.row == 0) {
        return (kScreenHeight-49-64)*49/(568-49-64);
    }
    return kScreenHeight-49-64-(kScreenHeight-49-64)*49/(568-49-64);
}


#pragma mark 加载数据
- (void)_loadData:(BOOL)isRefresh {
    
    NSString *url = @"index/home";
    
    [DEMDataSevice requestWithURL:url params:nil httpMethod:@"POST" finishBlock:^(id result) {
        if (result == NULL) {
            self.alertView.message = @"与服务器断开连接";
            [self.alertView show];
            [super hiddenHUD];
            if (_csdata == nil || _csdata.allValues.count <= 0) {
                [super setReLoadDataTap];
            }
            return ;
        }
        
        NSString *msg = [result objectForKey:@"msg"];
        
        @try {
            _csdata = [result objectForKey:@"data"];
            
            NSDictionary *target = [_csdata objectForKey:@"target"];
            
            _csBtnData = [target objectForKey:[NSString stringWithFormat:@"%d",_index]];
            
            NSDictionary *warning = [_csdata objectForKey:@"warning"];
            
            _csAlarmData = [warning objectForKey:[NSString stringWithFormat:@"%d",_index]];
            
            if (isRefresh == NO) {
                [self _initNavigationItem];
                [_tableView reloadData];
            }
            else {
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                NSArray *array = [NSArray arrayWithObjects:indexPath,nil];
                [_tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
                
            }
        }
        @catch (NSException *exception) {
            [[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }
        @finally {
            
        }
        
        [super hiddenHUD];
    } erro:^(id erro) {
        [super hiddenHUD];
        [[[UIAlertView alloc] initWithTitle:nil message:@"网络连接失败，请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }];
    
}

#pragma mark 创建视图
- (void)_initSegmented {
    
    if (_csdata.allKeys.count>0 && _csdata != nil) {
     
        NSMutableArray *ary = [[NSMutableArray alloc] init];
        
        NSArray *array = [_csdata objectForKey:@"tag"];
        
        //存储机房信息
        [[NSUserDefaults standardUserDefaults] setObject:array forKey:@"room"];
        
        for (NSDictionary *tag in array) {
            NSString *title = [tag objectForKey:@"title"];
            [ary addObject:title];
        }
        
        if (ary.count == 1) {
            return;
        }
        
        _segment = [[Segmented alloc] initWithFrame:CGRectMake(0, 0, self.view.width, (kScreenHeight-49-64)*49/(568-49-64))];
        _segment.titleColorWithHighlighted = RGBA(54, 125, 242, 1);
        _segment.labelColor = RGBA(54, 125, 242, 1);
        if (ary.count>3) {
            _segment.segmentCount = 3;
        }
        else {
            _segment.segmentCount = (int)ary.count;
        }

        _segment.delegate = self;
        _segment.array = ary;
        
        CALayer *topBorder = [CALayer layer];
        topBorder.frame = CGRectMake(0.0f, 0.0f, _segment.width, 1.0f);
        topBorder.backgroundColor = RGBA(154, 154, 154, 1).CGColor;
        [_segment.layer addSublayer:topBorder];
        
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0.0f, _segment.height-1.0f, _segment.width, 1.0f);
        bottomBorder.backgroundColor = RGBA(154, 154, 154, 1).CGColor;
        [_segment.layer addSublayer:bottomBorder];
        
        [_cell addSubview:_segment];
        
    }
    
}

/**
 *  首页指标视图
 */
- (void)_initButton {
    
    if (_csBtnData.count>0 && _csBtnData!=nil) {
        
        NSMutableArray *ary = [[NSMutableArray alloc] initWithArray:_csBtnData];
        
        _view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, (kScreenHeight-49-64)*316/(568-49-64))];
        _view.backgroundColor = RGBA(237, 237, 237, 1);
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:_view.bounds];
        scrollView.userInteractionEnabled = YES;
        [_view addSubview:scrollView];
        
        float width = (kScreenWidth - kScreenWidth*15/320*5)/4;
        int count = ceil(ary.count/4.0);  //行数
        int countj;                     //列数
        for (int i=0; i<count; i++) {
            if (i == count-1) {
                countj = ary.count%4;
                if (countj == 0) {
                    countj = 4;
                }
            }
            else {
                countj = 4;
            }
            for (int j=0; j<countj; j++) {
                
                NSDictionary *dic = [ary objectAtIndex:i*4+j];
                NSString *icon = [dic objectForKey:@"icon"];
                NSString *title = [dic objectForKey:@"title"];
                NSInteger type = [[dic objectForKey:@"type"] integerValue];
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.tag = type;
                button.frame = CGRectMake(kScreenWidth*15/320+j*(width+kScreenWidth*15/320), kScreenHeight*33/568+i*(width+(kScreenHeight*33/568)), width, width);
                [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];

                [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                [button sd_setImageWithURL:[NSURL URLWithString:icon] forState:UIControlStateNormal];
                [scrollView addSubview:button];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(button.left, button.bottom+kScreenHeight*5/568, button.width, kScreenHeight*13/568)];
                label.font = [UIFont systemFontOfSize:11];
                label.textAlignment = NSTextAlignmentCenter;
                label.text = title;
                [scrollView addSubview:label];
                
            }
        }
        
        scrollView.contentSize = CGSizeMake(0, kScreenHeight*33/568+count*(width+(kScreenHeight*33/568))+width);
        
        [_cell addSubview:_view];
        
    }

}

/**
 *  首页告警列表
 */
- (void)_initAlarm {
    
    float height = (kScreenHeight-49-64)*90/(568-49-64);
    
    NSArray *array = [_csdata objectForKey:@"tag"];
    
    if (array.count == 1) {
        height = (kScreenHeight-49-64)*139/(568-49-64);
    }
    
    if (_csAlarmData.count>0) {
        
        HomeAlarmView *view = [[HomeAlarmView alloc] initWithFrame:CGRectMake(0, _view.bottom, self.view.width, height)];
        view.nav = self.navigationController;
        
        view.backgroundColor = [UIColor clearColor];
        
        view.array = _csAlarmData;
        
        CALayer *topBorder = [CALayer layer];
        topBorder.frame = CGRectMake(0.0f, 0.0f, view.width, 1.0f);
        topBorder.backgroundColor = RGBA(184, 184, 184, 1).CGColor;
        [view.layer addSublayer:topBorder];
        
        [_cell addSubview:view];
        
    }
    else {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, _view.bottom, self.view.width, height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"暂无数据";
        [_cell addSubview:label];
    }
    
}

#pragma mark 分段控件协议
- (void)Segmented:(Segmented *)segmented DidSelectAtIndex:(NSInteger)index {

    NSDictionary *target = [_csdata objectForKey:@"target"];
    //NSArray *keys = target.allKeys;
    
    NSDictionary *alarm = [_csdata objectForKey:@"warning"];
    
    /*
    _csBtnData = [target objectForKey:[keys objectAtIndex:index]];
    _csAlarmData = [alarm objectForKey:[alarm.allKeys objectAtIndex:index]];
     */
    
    _csBtnData = [target objectForKey:[NSString stringWithFormat:@"%d",index+1]];
    _csAlarmData = [alarm objectForKey:[NSString stringWithFormat:@"%d",index+1]];
    _index = (int)index+1;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    NSArray *array = [NSArray arrayWithObjects:indexPath,nil];
    [_tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];

}

#pragma mark 首页按钮点击事件
- (void)buttonAction:(UIButton *)button {
    Temperature_ViewController *viewVC = [[Temperature_ViewController alloc] init];
    viewVC.type = button.tag;
    [self.navigationController pushViewController:viewVC animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (_timer != nil) {
        [_timer setFireDate:[NSDate distantPast]];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if ([_timer isValid]) {
        [_timer setFireDate:[NSDate distantFuture]];
        
    }
}

- (void)reLoadData {
    [super showHUD:@"加载中"];
    [self _loadData:NO];
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
