//
//  Temperature ViewController.m
//  DEM
//
//  Created by 王宝 on 15/5/12.
//  Copyright (c) 2015年 王宝. All rights reserved.
//  

#import "Temperature ViewController.h"

@interface Temperature_ViewController ()
{
    UITableView *_tableView;
}

@end

@implementation Temperature_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self _loadData];
}

- (void)_loadData {
    [super showHUD:@"加载中..."];
    
    NSString *url = @"index/indexDetailed";
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:self.type],@"type", nil];
    
    [DEMDataSevice requestWithURL:url params:params httpMethod:@"post" finishBlock:^(id result) {
        if (result == NULL) {
            self.alertView.message = @"与服务器断开连接";
            [self.alertView show];
            [super hiddenHUD];
            [super setReLoadDataTap];
            return ;
        }
        
        NSString *msg = [result objectForKey:@"msg"];
        
        @try {
            self.data = [result objectForKey:@"data"];
            self.title = [[self.data objectForKey:@"title"] objectForKey:@"title"];
            
            [self _initViews];
            
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
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = RGBA(237, 237, 237, 1);
    [self.view addSubview:_tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TemperatureTableViewCell *cell = [[TemperatureTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cell setFrame:CGRectMake(0, 0, self.view.width, 0)];
    cell.nav = self.navigationController;
    cell.data = self.data;
    cell.delegate = self;
    
    switch (indexPath.row) {
        case 0:
        {
            [cell setAllState];
        }
            break;
            
        case 1:
        {
            [cell setKeyIndex];
        }
            break;
            
        case 2:
            [cell setWarning];
            break;
            
        case 3:
            [cell setSegmented];
            [cell CheckWarning:[_data objectForKey:@"list"]];
            break;
            
        case 4:
            [cell setChart];
            break;
            
        case 5:
        {
            [cell setLineChart];
        }
            break;
            
        default:
            
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return (kScreenHeight-64)*40/504;
            break;
            
        case 1:
        {
            NSArray *array = [self.data objectForKey:@"top_list"];
            if ([array isKindOfClass:[NSArray class]] && array.count>0) {
                NSArray *child = [array.firstObject objectForKey:@"child"];
                if ([child isKindOfClass:[NSArray class]] && child.count>0) {
                    return (kScreenHeight-64)*108/504;
                }
                return (kScreenHeight-64)*64/504;
            }
            return 0;
        }
            break;
            
        case 2:
        {
            NSDictionary *dic = [self.data objectForKey:@"warning"];
            NSString *title = [dic objectForKey:@"title"];
            if (title != nil && ![title isEqualToString:@""]) {
                return [TemperatureTableViewCell warningHeight:title];
            }
            return 0;
        }
            break;
            
        case 3:
        {
            NSArray *list = [self.data objectForKey:@"list"];
            if (![list isKindOfClass:[NSArray class]] || list.count <= 0) {
                return 0;
            }
            id child = [[list firstObject] objectForKey:@"child"];
            if ([child isKindOfClass:[NSArray class]]) {
                return (kScreenHeight-64)*79/504;
            }
        }
            return (kScreenHeight-64)*49/504;
            break;
            
        case 4:
            return (kScreenHeight-64)*155/504;
            break;
            
        case 5:
            return (kScreenHeight-64)*180/504;
            break;
            
        default:
            break;
    }
    return 0;
}

- (void)detailSegmentSelectedForId:(NSString *)segmentid {
    
    [super showHUD:@"加载中"];
    
    NSString *url = @"index/indexDetailedClick";
    
    NSDictionary *params = [NSDictionary dictionaryWithObject:segmentid forKey:@"id"];
    
    [DEMDataSevice requestWithURL:url params:params httpMethod:@"POST" finishBlock:^(id result) {
        if (result == NULL) {
            self.alertView.message = @"与服务器断开连接";
            [self.alertView show];
            [super hiddenHUD];
            return ;
        }
        
        NSString *msg = [result objectForKey:@"msg"];
        
        @try {
            NSDictionary *dic = [result objectForKey:@"data"];
            NSDictionary *icon = [dic objectForKey:@"icon"];
            NSArray *line = [dic objectForKey:@"line"];
            
            NSMutableDictionary *mutabledic = [NSMutableDictionary dictionaryWithDictionary:self.data];
            [mutabledic setValue:icon forKey:@"icon"];
            [mutabledic setValue:line forKey:@"line"];
            self.data = mutabledic;
            
            NSIndexPath *chartPath = [NSIndexPath indexPathForRow:4 inSection:0];
            NSIndexPath *lineChartPath = [NSIndexPath indexPathForRow:5 inSection:0];
            NSArray *array = [NSArray arrayWithObjects:chartPath,lineChartPath, nil];
            [_tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
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

- (void)reLoadData {
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
