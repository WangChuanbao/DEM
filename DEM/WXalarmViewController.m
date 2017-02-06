//
//  WXalarmViewController.m
//  DEM
//
//  Created by 王宝 on 15/5/22.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "WXalarmViewController.h"

@interface WXalarmViewController ()
{
    UITableView *_tableview;
    NSString *_title;
    NSString *_message;
    NSString *_btnTitle;
}
@end

@implementation WXalarmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"打开微信报警";
    
    _title = @"";
    _message = @"";
    _btnTitle = @"";
    
    [self initViews];
    [self loadData];
}

- (void)loadData {
    [super showHUD:@"加载中"];
    
    NSString *url = @"index/wechatWarning";
    [DEMDataSevice requestWithURL:url params:nil httpMethod:@"POST" finishBlock:^(id result) {
        
        if (result == NULL) {
            self.alertView.message = @"与服务器断开连接";
            [self.alertView show];
            [super setReLoadDataTap];
            [super hiddenHUD];
            return ;
        }
        
        @try {
            _data = [result objectForKey:@"data"];
            [_tableview reloadData];
            [super hiddenHUD];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
    } erro:^(id erro) {
        
    }];
}

- (void)initViews {
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-64+49) style:UITableViewStylePlain];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableview];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identity = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.view.width-40, (kScreenHeight-64)*30/504)];
        label.userInteractionEnabled = YES;
        label.tag = 2015;
        label.backgroundColor = RGBA(54, 125, 242, 1);
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [cell addSubview:label];
        
        UIImageView *mark = [[UIImageView alloc] initWithFrame:CGRectMake(label.right-20, (label.height-15)/2, 15, 15)];
        mark.image = [UIImage imageNamed:@"对勾.png"];
        mark.hidden = YES;
        mark.tag = 2016;
        [cell addSubview:mark];
        
    }
    
    UILabel *label = (UILabel *)[cell viewWithTag:2015];
    label.text = [[_data objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    NSString *state = [[_data objectAtIndex:indexPath.row] objectForKey:@"is_open"];
    UIImageView *mark = (UIImageView *)[cell viewWithTag:2016];
    if ([state isEqualToString:@"1"] && state.integerValue == 1) {
        mark.hidden = NO;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (kScreenHeight-64)*40/504;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *state = [[_data objectAtIndex:indexPath.row] objectForKey:@"is_open"];
    if ([state isEqualToString:@"0"] || state.integerValue == 0) {
        _title = @"打开微信报警";
        _message = @"如果打开，微信可以接受到系统告警";
        _btnTitle = @"打开";
    }
    else {
        _title = @"关闭微信报警";
        _message = @"如果关闭，微信将接受不到系统告警";
        _btnTitle = @"关闭";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_title message:_message delegate:self cancelButtonTitle:_btnTitle otherButtonTitles:@"取消", nil];
    alert.tag = indexPath.row;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [alertView removeFromSuperview];
    if (buttonIndex == 0) {
        [super showHUD:@""];
        
        NSString *url = @"index/setWechatWarning";
        
        NSString *roomid = [[_data objectAtIndex:alertView.tag] objectForKey:@"id"];
        NSString *state = [[_data objectAtIndex:alertView.tag] objectForKey:@"is_open"];
        if ([state isEqualToString:@"0"] || state.integerValue == 0) {
            state = @"1";
        }
        else {
            state = @"0";
        }
        
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:roomid,@"room_id",state,@"state", nil];
        
        [DEMDataSevice requestWithURL:url params:params httpMethod:@"POST" finishBlock:^(id result) {
            if (result == NULL) {
                self.alertView.message = @"与服务器断开连接";
                [self.alertView show];
                [super hiddenHUD];
                return ;
            }
            
            if ([[result objectForKey:@"state"] intValue] == 0) {
                
                UITableViewCell *cell = [_tableview cellForRowAtIndexPath:[NSIndexPath indexPathForRow:alertView.tag inSection:0]];
                UIImageView *label = (UIImageView *)[cell viewWithTag:2016];
                
                if (state.intValue == 0) {
                    label.hidden = YES;
                }
                else {
                    label.hidden = NO;
                }
                
                //改变数据中打开状态
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[_data objectAtIndex:alertView.tag]];
                [dic setObject:state forKey:@"is_open"];
                NSMutableArray *array = [NSMutableArray arrayWithArray:_data];
                [array replaceObjectAtIndex:alertView.tag withObject:dic];
                _data = array;
                
                [super hiddenHUD];
            }
            
        } erro:^(id erro) {
            [self.alertView show];
        }];
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
