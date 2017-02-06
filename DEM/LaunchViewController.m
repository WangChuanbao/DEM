//
//  LaunchViewController.m
//  DEM
//
//  Created by 王宝 on 15/5/8.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "LaunchViewController.h"
#import "VPNManager.h"
#import "LoginViewController.h"
#import "BaseNavigationController.h"
#import "MainTabBarController.h"

@interface LaunchViewController ()
{
    UIImageView *_imgView;
    
    UIProgressView *_progress;
    
    float _pro;
    
    NSTimer *_timer;
    
    NSInteger _vpnCode;
    
    VPNAccount *account;
}
@end

@implementation LaunchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //登陆VPN状态通知
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMessage:) name:kVPNMessageNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(implicitLoginFinish:) name:LoginFinish object:nil];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    self.view.backgroundColor = RGBA(32, 33, 34, 1);
    
    [self initView];
    
    //[self VPNlogin];
    
}

- (void)VPNlogin{
    
    account = [[VPNAccount alloc] initWithHost:kVPNHost userName:kVPNUser passWord:kVPNPassWord];
    [[VPNManager sharedVPNManager] setLogLevel:0];
    [[VPNManager sharedVPNManager] startVPN:account];

}

- (void)handleMessage:(NSNotification *)notification{
    VPNMessage * msg = (VPNMessage *) notification.object;
    NSLog(@"<handleMessage> to %@ ",msg);
    _vpnCode = msg.code;
}

- (void)initView {
    _pro = 0.0;
    _vpnCode = 0;
    
    //背景图片
    _imgView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    _imgView.image = [UIImage imageNamed:@"loading页.png"];
    
    _imgView.alpha = _pro;
    
    [self.view addSubview:_imgView];
    
    //进度条
    _progress = [[UIProgressView alloc] initWithFrame:CGRectMake(10, kScreenHeight-kScreenHeight*80/568, kScreenWidth-20, 20)];
    
    _progress.transform = CGAffineTransformMakeScale(1.0f, 3.0f);
    
    _progress.trackTintColor = [UIColor clearColor];
    
    _progress.progressTintColor = RGBA(195, 245, 21, 1);
    
    [self.view addSubview:_progress];
    
    /*
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, _progress.top-23, kScreenWidth, 20)];
    label.text = @"努力登陆中。。。";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:label];
     */
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(progressChange) userInfo:nil repeats:YES];
}

- (void)progressChange {
    
    /*
    if (_pro >= 0.8 && _vpnCode != VPN_CB_CONNECTED) {
        return;
    }
     */
    
    if (_pro >= 1.0 /*&& _vpnCode == VPN_CB_CONNECTED*/) {
            
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        
        LoginViewController *login = [[LoginViewController alloc] init];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:login];
        
        NSDictionary *isLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"login"];
        if (isLogin != nil) {
            NSString *username = [isLogin objectForKey:@"username"];
            NSString *password = [isLogin objectForKey:@"password"];
            [login implicitLogin:username password:password];
        }
        else {
            self.view.window.rootViewController = nav;
        }
            
        [_timer invalidate];
    }
    
    /*
    if (_vpnCode == VPN_CB_CONN_FAILED) {
        [self popAlertView];
        [_timer invalidate];
    }
     */
    
    _pro += 0.1;
    
    _imgView.alpha = _pro;
    
    _progress.progress = _pro;
    
}

- (void)implicitLoginFinish:(NSNotification *)notifi {
    
    if ([notifi.object isEqualToString:@"1"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"登陆失败,请检查网络" delegate:self cancelButtonTitle:@"重试" otherButtonTitles:@"退出", nil];
        alert.tag = 100;
        [alert show];
        return;
    }
    LoginViewController *login = [[LoginViewController alloc] init];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:login];
    self.view.window.rootViewController = nav;
    [nav pushViewController:[MainTabBarController shareMainTabBarController] animated:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LoginFinish object:nil];
}

- (void)popAlertView {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"VPN连接失败，请检查网络" delegate:self cancelButtonTitle:@"重试" otherButtonTitles:@"退出", nil];
    alert.tag = 200;
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //登陆失败
    if (alertView.tag == 100) {
        if (buttonIndex == 0) {
            LoginViewController *login = [[LoginViewController alloc] init];
            NSDictionary *isLogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"login"];
            NSString *username = [isLogin objectForKey:@"username"];
            NSString *password = [isLogin objectForKey:@"password"];
            [login implicitLogin:username password:password];
        }
        else {
            [self exitApplication];
        }
        
        return;
    }
    
    //VPN连接失败
    if (buttonIndex == 0) {
        [_imgView removeFromSuperview];
        _imgView = nil;
        [_progress removeFromSuperview];
        _progress = nil;
        _timer = nil;
        
        [[VPNManager sharedVPNManager] stopVPN];
        account = nil;
        
        [self initView];
        [self VPNlogin];
    }
    else{
        
        [self exitApplication];
        
    }
}

- (void)exitApplication {

    [UIView beginAnimations:@"exitApplication" context:nil];
    
    [UIView setAnimationDuration:0.5];
    
    [UIView setAnimationDelegate:self];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view.window cache:NO];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    
    //[UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:self.window cache:NO];
    
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    
    self.view.window.bounds = CGRectMake(0, 0, 0, 0);
    
    //self.window.bounds = CGRectMake(0, 0, 0, 0);
    
    [UIView commitAnimations];
    
}

- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    if ([animationID compare:@"exitApplication"] == 0) {
        
        exit(0);
        
    }
    
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
