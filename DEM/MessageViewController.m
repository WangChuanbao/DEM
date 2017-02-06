//
//  MessageViewController.m
//  DEM
//
//  Created by 王宝 on 15/5/8.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "MessageViewController.h"
#import "ZLabel.h"

@interface MessageViewController ()
{
    PullTableView *_tableView;
    NSMutableArray *_heights;
    
    int pageIndex;
}
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"消息";
    
    pageIndex = 1;
    
    [self _initViews];
    
    [self _loadData];
    
    [super showHUD:@"加载中"];
    
}

- (void)_loadData {
    
    NSString *url = @"index/messageList";
    
    [DEMDataSevice requestWithURL:url params:nil httpMethod:@"POST" finishBlock:^(id result) {
        if (result == NULL) {
            self.alertView.message = @"与服务器断开连接";
            [self.alertView show];
            if (_data == nil || _data.count <= 0) {
                [super setReLoadDataTap];
            }
            [super hiddenHUD];
            return ;
        }
        
        NSString *msg = [result objectForKey:@"msg"];
        
        @try {
            NSDictionary *data = [result objectForKey:@"data"];
            NSArray *list = [data objectForKey:@"list"];
            self.data = [NSMutableArray arrayWithArray:list];
            _tableView.pullTableIsRefreshing = NO;
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
    _tableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-49-64) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.pullDelegate = self;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identity = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
        cell.backgroundColor = [UIColor clearColor];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.tag = 100;
        view.backgroundColor = [UIColor whiteColor];
        view.layer.masksToBounds = YES;
        view.layer.borderWidth = 1;
        view.layer.borderColor = RGBA(184, 184, 184, 1).CGColor;
        view.layer.cornerRadius = 10;
        [cell addSubview:view];
        
        ZLabel *label = [[ZLabel alloc] initWithFrame:CGRectZero font:[UIFont systemFontOfSize:12]];
        label.tag = 200;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.zHeight = 40;
        [view addSubview:label];
    }
    
    ZLabel *label = (ZLabel *)[cell viewWithTag:200];
    [label setFrame:CGRectMake(kScreenWidth*10/320, 0, kScreenWidth-kScreenWidth*20/320*2, 0)];

    //--------------------------------------------------------------------------------------------------
    
    if (indexPath.row < self.data.count) {
        NSDictionary *dic = [self.data objectAtIndex:indexPath.row];
        NSString *title = [dic objectForKey:@"title"];
        NSString *content = [dic objectForKey:@"content"];
        label.text = [NSString stringWithFormat:@"%@\n%@",title,content];
    }
    
    //--------------------------------------------------------------------------------------------------
    
    UIView *view = (UIView *)[cell viewWithTag:100];
    [view setFrame:CGRectMake(kScreenWidth*10/320, (kScreenHeight-64-49)*10/(568-49-64), kScreenWidth-kScreenWidth*10/320*2, label.height)];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    float height = 0;
    if (indexPath.row < self.data.count) {
        NSDictionary *dic = [self.data objectAtIndex:indexPath.row];
        height = [self cellHeight:[NSString stringWithFormat:@"%@\n%@",[dic objectForKey:@"title"],[dic objectForKey:@"content"]]];
    } 
    
    return height;
}

- (float)cellHeight:(NSString *)text {
    ZLabel *label = [[ZLabel alloc] initWithFrame:CGRectMake(kScreenWidth*10/320, 0, kScreenWidth-kScreenWidth*20/320*2, 0) font:[UIFont systemFontOfSize:12]];
    label.zHeight = 40;
    label.text = text;
    
    return label.height+10;
}

#pragma mark PullTableViewDelegate
- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView {
    [_data removeAllObjects];
    _data = nil;
    
    [self _loadData];
    
    _tableView.pullLastRefreshDate = [NSDate date];
    //_tableView.pullTableIsRefreshing = NO;
    
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView {
    
    ++pageIndex;
    
    NSString *url = @"index/messageList";
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:pageIndex],@"p", nil];
    
    [DEMDataSevice requestWithURL:url params:params httpMethod:@"POST" finishBlock:^(id result) {
        if (result == NULL) {
            self.alertView.message = @"与服务器断开连接";
            [self.alertView show];
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
        
        pullTableView.pullTableIsLoadingMore = NO;
        
    } erro:^(id erro) {
        [self.alertView show];
    }];
    
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
