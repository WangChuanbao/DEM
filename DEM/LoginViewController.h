//
//  LoginViewController.h
//  DEM
//
//  Created by 王宝 on 15/7/21.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;
- (IBAction)login:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UILabel *errorMessage;

@property (strong, nonatomic) NSString *usernamestring;
@property (strong, nonatomic) NSString *passwordstring;
@property BOOL isLogin;

- (void)implicitLogin:(NSString *)username password:(NSString *)password;
@end
