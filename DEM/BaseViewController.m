//
//  BaseViewController.m
//  DEM
//
//  Created by 王宝 on 15/5/8.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "BaseViewController.h"
#import "AlarmDetailViewController.h"

@interface BaseViewController ()
{
    UIAlertView *_alert;
    NSTimer *_timer;
    NSString *_contentId;
}
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    
    self.view.backgroundColor = RGBA(237, 237, 237, 1);
    
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveMessageNotification:)
                                                 name:kDidReceiveMessageNotification
                                               object:nil];
     */
    
    if (self.navigationController.viewControllers.count > 1) {
        self.isBackButton = YES;
    }
    
    if (self.isBackButton) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 13, 20);
        [button setImage:[UIImage imageNamed:@"返回按钮.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = item;
        
    }
    
    _alertView = [[UIAlertView alloc] initWithTitle:nil message:@"网络连接失败，请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(MonitorNetworkStatus) userInfo:nil repeats:YES];
    
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe)];
    [self.view addGestureRecognizer:rightSwipe];
}

- (void)rightSwipe {
    if (self.navigationController.viewControllers.count>1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/*
- (void)didReceiveMessageNotification:(NSNotification *)notifi {
    
    NSDictionary *dic = notifi.object;
    if (dic) {
        ns
        
        NSString *content = [dic objectForKey:@"content"];
        NSString *contentId = [dic objectForKey:@"id"];
        if (![_contentId isEqualToString:contentId] && _contentId.integerValue != contentId.integerValue) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:content delegate:self cancelButtonTitle:@"前往查看" otherButtonTitles:@"稍后再说",nil];
            [alert show];
        }
    }
}
 */

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        AlarmDetailViewController *detailVC = [[AlarmDetailViewController alloc] init];
        detailVC.detailId = _contentId;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

- (void)setReLoadDataTap {
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reLoadData)];
    [self.view addGestureRecognizer:_tap];
}

- (void)removeReLoadDataTap {
    [self.view removeGestureRecognizer:_tap];
}

/**重新加载，重新加载手势触发*/
- (void)reLoadData {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    if ([self isViewLoaded] && self.view.window == nil) {
        
        self.view = nil;
        
    }
    
}

- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showHUD:(NSString *)title {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = title;
}

- (void)hiddenHUD {
    [self.hud setHidden:YES];
}

- (void)MonitorNetworkStatus {
    NSString *state = [self getNetWorkStates];
    
    if ([state isEqualToString:@"无网络"] || [state isEqualToString:@""]) {
        _alert = [[UIAlertView alloc] initWithTitle:nil message:@"网络连接中断，请检查网络" delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
        [_alert show];
        
        [self performSelector:@selector(disMissAlertView) withObject:nil afterDelay:1];
    }
}

- (void)disMissAlertView {
    [_alert dismissWithClickedButtonIndex:0 animated:YES];
}

//获取网络状态，隐藏状态栏则无法获取
-(NSString *)getNetWorkStates{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"]valueForKeyPath:@"foregroundView"]subviews];
    NSString *state = [[NSString alloc] init];
    
    int netType =0;
    //获取到网络返回码
    for (id child in children) {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏
            netType = [[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (netType) {
                case 0:
                    state = @"无网络";
                    //无网模式
                    break;
                case 1:
                    state = @"2g";
                    break;
                case 2:
                    state = @"3g";
                    break;
                case 3:
                    state = @"4g";
                    break;
                case 5:
                {
                    state = @"wifi";
                }
                    break;
                default:
                    break;
            }
        }
        
    }
    //根据状态选择
    return state;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
