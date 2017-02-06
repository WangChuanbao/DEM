//
//  ChangePasswordViewController.m
//  DEM
//
//  Created by 王宝 on 15/5/21.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "DEMDataSevice.h"

@interface ChangePasswordViewController ()
{
    CALayer *_oldBorder;
    CALayer *_newBorder;
    CALayer *_aginBorder;
    
    NSString *_old;
    NSString *_new;
    NSString *_agin;
    
    
}

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"修改用户密码";
    
    _old = @"";
    _new = @"";
    _agin = @"";
    
    
    _oldBorder = [CALayer layer];
    _oldBorder.backgroundColor = RGBA(128, 128, 128, 1).CGColor;
    [self.oldPassword.layer addSublayer:_oldBorder];
    
    _newBorder = [CALayer layer];
    _newBorder.backgroundColor = RGBA(128, 128, 128, 1).CGColor;
    [self.newpassword.layer addSublayer:_newBorder];
    
    _aginBorder = [CALayer layer];
    _aginBorder.backgroundColor = RGBA(128, 128, 128, 1).CGColor;
    [self.aginPassword.layer addSublayer:_aginBorder];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)viewWillLayoutSubviews {
    
    _oldBorder.frame = CGRectMake(0, _oldPassword.height-1, self.oldPassword.width, 1);
    
    _newBorder.frame = CGRectMake(0, _newpassword.height-1, _newpassword.width, 1);
    
    _aginBorder.frame = CGRectMake(0, _aginPassword.height-1, _aginPassword.width, 1);
    
}


- (IBAction)finishAction:(id)sender {
    
    _old = _oldPassword.text;
    _new = _newpassword.text;
    _agin = _aginPassword.text;
    
    NSString *url = @"index/upUserPassword";
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:_old,@"old_password",_new,@"new_password",_agin,@"re_password", nil];
    
    [DEMDataSevice requestWithURL:url params:params httpMethod:@"POST" finishBlock:^(id result) {
        if (result == NULL) {
            self.alertView.message = @"与服务器断开连接";
            [self.alertView show];
            [super hiddenHUD];
            return ;
        }
        
        NSString *state = [result objectForKey:@"state"];
        if (state.integerValue == 0 || [state isEqualToString:@"0"]) {
            //修改成功
            [self.tabBarController.navigationController popToRootViewControllerAnimated:YES];
        }
        else {
            //修改失败
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"密码修改失败，请重试" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
            [alert show];
            NSDictionary *dic = [NSDictionary dictionaryWithObject:alert forKey:@"alert"];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dismissAlertView:) userInfo:dic repeats:NO];
        }
        
    } erro:^(id erro) {
        [self.alertView show];
    }];
    
}

- (void)dismissAlertView:(NSTimer *)timer{
    UIAlertView *alert = [timer.userInfo objectForKey:@"alert"];
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    //弹出键盘通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardshow:) name:UIKeyboardWillShowNotification object:nil];
    //隐藏键盘通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardhidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [textField becomeFirstResponder];
}

- (void)keyboardshow:(NSNotification *)notifi {
    NSValue *value = [notifi.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGPoint origin = [value CGRectValue].origin;
    CGFloat top = origin.y;
    
    float time = [[notifi.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    float poor = _bgView.bottom - top;
    
    if ( poor > 0 ) {
        
        [UIView animateWithDuration:time animations:^{
            [self.view setFrame:CGRectMake(self.view.left, 0, self.view.width, self.view.height)];
        }];
        
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyboardhidden:(NSNotification *)notifi {
    float time = [[notifi.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:time animations:^{
        [self.view setFrame:CGRectMake(self.view.left, 64, self.view.width, self.view.height)];
    
    }];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)tapAction {
    [_newpassword resignFirstResponder];
    [_oldPassword resignFirstResponder];
    [_aginPassword resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES; }

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
