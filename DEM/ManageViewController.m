//
//  ManageViewController.m
//  DEM
//
//  Created by 王宝 on 15/5/25.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "ManageViewController.h"
#import "HandleInformationViewController.h"

@interface ManageViewController ()
{
    NSString *_tel;
    NSDictionary *_data;
    UIAlertView *_alert;
}
@end

@implementation ManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"处理";
    
    _tel = @"";
    _data = [[NSDictionary alloc] init];
    
    [self loadData];
    
    [super showHUD:@"加载中"];
    
    UITapGestureRecognizer *phone = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneTap)];
    [self.phone addGestureRecognizer:phone];
    
    UITapGestureRecognizer *message = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(messageTap)];
    [self.message addGestureRecognizer:message];
    
    UITapGestureRecognizer *information = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(informationTap)];
    [self.information addGestureRecognizer:information];
    
    [self uploadHandleTime];
}

- (void)loadData {
    NSString *url = @"index/getHandleUserInfo";
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.room_id,@"room_id", nil];
    [DEMDataSevice requestWithURL:url params:params httpMethod:@"POST" finishBlock:^(id result) {
        if (result == NULL) {
            self.alertView.message = @"与服务器连接中断";
            [self.alertView show];
            [super hiddenHUD];
            return ;
        }
        
        NSString *msg = [result objectForKey:@"msg"];
        
        @try {
            _data = [result objectForKey:@"data"];
            _tel = [_data objectForKey:@"phone"];
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

- (void)phoneTap {
    if ([self CheckTheRoomIsHaveHandlePeople]) {
        if (![_tel isEqualToString:@""]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_tel]]];
            [self uploadHandleTime];
        }
    }
}

- (void)messageTap {
    if ([self CheckTheRoomIsHaveHandlePeople]) {
        if (![_tel isEqualToString:@""]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@",_tel]]];
            [self uploadHandleTime];
        }
    }
}

- (void)informationTap {
    if ([self CheckTheRoomIsHaveHandlePeople]) {
        HandleInformationViewController *informationVC = [[HandleInformationViewController alloc] init];
        informationVC.data = _data;
        informationVC.roomid = _room_id;
        [self.navigationController pushViewController:informationVC animated:YES];
    }
    
}

/**
 *  检查是否设置机房管理员
 *
 *  @return
 */
- (BOOL)CheckTheRoomIsHaveHandlePeople {
    if (![_data isKindOfClass:[NSDictionary class]]) {
        _alert = [[UIAlertView alloc] initWithTitle:nil message:@"该机房暂无管理员信息" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [_alert show];
        
        [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(disMissAlert) userInfo:nil repeats:NO];
        
        return NO;
    }
    
    return YES;
}

- (void)disMissAlert {
    [_alert dismissWithClickedButtonIndex:0 animated:YES];
}

/**
 *  告警处理接口
 */
- (void)uploadHandleTime {
    NSString *url = @"index/reportHandleUser";
    NSDictionary *params = [NSDictionary dictionaryWithObject:self.alarm_id forKey:@"id"];
    [DEMDataSevice requestWithURL:url params:params httpMethod:@"POST" finishBlock:^(id result) {
        
        NSString *state = [result objectForKey:@"state"];
        if ([state isEqualToString:@"0"] || state.integerValue == 0) {
            //处理完成通知
            [[NSNotificationCenter defaultCenter] postNotificationName:HandleFinish object:nil];
        }
        
    } erro:^(id erro) {
        
    }];
}

- (void)backAction {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)rightSwipe {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
