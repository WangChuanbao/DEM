//
//  LoginViewController.m
//  DEM
//
//  Created by 王宝 on 15/7/21.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "LoginViewController.h"
#import "DEMDataSevice.h"
#import "MainTabBarController.h"
#import "APService.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"登陆";
    
    [self checkLogin];
    
    _username.layer.masksToBounds = YES;
    _username.layer.borderWidth = 1;
    _username.layer.borderColor = RGBA(154, 154, 154, 1).CGColor;
    
    _password.layer.masksToBounds = YES;
    _password.layer.borderWidth = 1;
    _password.layer.borderColor = RGBA(154, 154, 154, 1).CGColor;
    
    _messageLabel.font = [UIFont boldSystemFontOfSize:12];
    _messageLabel.text = @"版本1.0\n北京鸿天融达信息技术有限公司\nCopyright©2015";
}

//检查是否登陆
- (void)checkLogin {
    NSDictionary *login = [[NSUserDefaults standardUserDefaults] objectForKey:@"login"];
    if (login != nil) {
        _isLogin = YES;
    }
}

- (void)implicitLogin:(NSString *)username password:(NSString *)password {
    _isLogin = YES;
    [self loginForRequest:username password:password];
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

- (IBAction)login:(UIButton *)sender {
    [_username resignFirstResponder];
    [_password resignFirstResponder];
    
    if ([_username.text isEqualToString:@""]) {
        _errorMessage.text = @"请填写账户";
        return;
    }
    if ([_password.text isEqualToString:@""]) {
        _errorMessage.text = @"请填写密码";
        return;
    }
    [self loginForRequest:_username.text password:_password.text];
}

- (void)loginForRequest:(NSString *)username password:(NSString *)password {
    [super showHUD:@"努力登录中"];
    
    NSString *url = @"index/login";
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:username,@"username",password,@"password", nil];
    [DEMDataSevice requestWithURL:url params:params httpMethod:@"POST" finishBlock:^(id result) {
        
        if (result == NULL) {
            if (_isLogin == NO) {
                _errorMessage.text = @"登陆失败，请重试";
            }
            else {
                [[NSNotificationCenter defaultCenter] postNotificationName:LoginFinish object:@"1"];
            }
        }
        
        NSString *state = [result objectForKey:@"state"];
        if (state.integerValue == 0 || [state isEqualToString:@"0"]) {
            _errorMessage.text = @"";
            NSString *token = [[result objectForKey:@"data"] objectForKey:@"token"];
            NSString *organization_id = [[result objectForKey:@"data"] objectForKey:@"organization_id"];
            
            //设置标签
            [APService setTags:[NSSet setWithObject:organization_id] callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
            
            NSDictionary *login = [NSDictionary dictionaryWithObjectsAndKeys:username,@"username",password,@"password",token,@"token", nil];
            
            [[NSUserDefaults standardUserDefaults] setObject:login forKey:@"login"];
            
            _username.text = @"";
            _password.text = @"";
            
            if (_isLogin == NO) {
                MainTabBarController *mainVC = [MainTabBarController shareMainTabBarController];
                [self.navigationController pushViewController:mainVC animated:YES];
            }
            else {
                [[NSNotificationCenter defaultCenter] postNotificationName:LoginFinish object:@"0"];
            }
        }
        else {
            _errorMessage.text = @"用户名密码错误";
        }
        
        [super hiddenHUD];
        
    } erro:^(id erro) {
        NSLog(@"----%@",erro);
        _errorMessage.text = @"网络连接失败，请检查网络后重试";
        [super hiddenHUD];
    }];
}

//设置标签回调
- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {

    NSLog(@"TagsAlias回调:%@", tags);
    NSLog(@"---------------%d",iResCode);
    
    //标签设置成功后，发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kPushSetTagsFinish object:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

@end
