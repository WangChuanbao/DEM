//
//  HandleViewController.m
//  DEM
//
//  Created by 王宝 on 15/5/22.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "HandleViewController.h"

@interface HandleViewController ()
{
    NSMutableArray *_persons;
    NSMutableArray *_phones;
    NSMutableArray *_indexs;
}
@end

@implementation HandleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"设置处理人";
    
    _persons = [[NSMutableArray alloc] init];
    _phones = [[NSMutableArray alloc] init];
    _indexs = [[NSMutableArray alloc] init];
    
    _tableView.tableHeaderView = [self viewForHeader];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
    
    [self _loadData];
}

- (void)_loadData {
    [super showHUD:@"加载中"];
    
    NSString *url = @"index/showHandleUser";
    
    [DEMDataSevice requestWithURL:url params:nil httpMethod:@"POST" finishBlock:^(id result) {
        if (result == NULL) {
            self.alertView.message = @"与服务器断开连接";
            [self.alertView show];
            [super setReLoadDataTap];
            [super hiddenHUD];
            return ;
        }
        
        NSString *msg = [result objectForKey:@"msg"];
        
        @try {
            self.data = [result objectForKey:@"data"];
            
            [_tableView reloadData];
            
        }
        @catch (NSException *exception) {
            self.alertView.message = msg;
            [self.alertView show];
        }
        @finally {
            [super hiddenHUD];
        }
        
    } erro:^(id erro) {
        [self.alertView show];
    }];
    
}

- (void)viewDidLayoutSubviews {
    _tableView.tableFooterView = [self viewForFooter];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identity = @"handleCell";
    
    HandleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HandleTableViewCell" owner:self options:nil] lastObject];
        cell.delegate = self;
        
    }
    
    cell.superView = _tableView;
    cell.index = indexPath.row;
    cell.data = [_data objectAtIndex:indexPath.row];
    
    return cell;
}

- (UIView *)viewForHeader {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, 35)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)viewForFooter {

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, (kScreenHeight-64)*30/504)];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _tableView.width, (kScreenHeight-64)*20/504)];
    button.backgroundColor = RGBA(54, 125, 242, 1);
    button.titleLabel.font = [UIFont systemFontOfSize:11];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(finishAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    return view;
}

#pragma mark 提交数据
- (void)finishAction:(UIButton *)send {
    [self tapAction];
    
    [super showHUD:@"加载中"];
    
    NSString *url = @"index/setHandleUser";
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    
    for (int i=0; i<_indexs.count; i++) {
        NSString *name = [_persons objectAtIndex:i];
        NSString *phone = [_phones objectAtIndex:i];
        NSDictionary *dic = [self.data objectAtIndex:[[_indexs objectAtIndex:i] integerValue]];
        NSString *roomid = [dic objectForKey:@"machine_room_id"];
        
        [array addObject:[NSDictionary dictionaryWithObjectsAndKeys:name,@"name",phone,@"phone",roomid,@"machine_room_id", nil]];
    }
    
    NSDictionary *params = [NSDictionary dictionaryWithObject:array forKey:@"data"];
    
    [DEMDataSevice requestWithURL:url params:params httpMethod:@"POST" finishBlock:^(id result) {
        
        if (result == NULL) {
            self.alertView.message = @"与服务器断开连接";
            [self.alertView show];
            [super hiddenHUD];
            return ;
        }
        
        [super hiddenHUD];
        
        NSString *state = [result objectForKey:@"state"];
        
        if ([state isEqualToString:@"0"] || state.intValue == 0) {
            //保存成功
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            self.alertView.message = [result objectForKey:@"msg"];
            [self.alertView show];
        }
        
    } erro:^(id erro) {
        [super hiddenHUD];
        [self.alertView show];
    }];
}

#pragma mark handleCellDelegate
- (void)handleCellText:(NSString *)text phone:(NSString *)phone index:(NSInteger)index {
   
    NSNumber *number = [NSNumber numberWithInteger:index];
    if ([_indexs indexOfObject:number] != NSNotFound) {
        if (_persons.count>index && _phones.count>index) {
            [_persons replaceObjectAtIndex:index withObject:text];
            [_phones replaceObjectAtIndex:index withObject:phone];
        }
    }
    else {
        [_persons addObject:text];
        [_phones addObject:phone];
        [_indexs addObject:[NSNumber numberWithInteger:index]];
    }
}

- (void)tapAction {
    //发送结束编辑同志
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TextFildEndEdit" object:nil];
}

- (void)reLoadData {
    [self _loadData];
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
