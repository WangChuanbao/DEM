//
//  HandleInformationViewController.m
//  DEM
//
//  Created by 王宝 on 15/5/25.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "HandleInformationViewController.h"

@interface HandleInformationViewController ()

@end

@implementation HandleInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"管理员信息";
    
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.borderColor = RGBA(184, 184, 184, 1).CGColor;
    self.bgView.layer.borderWidth = 1;
    
    NSString *text = @"";
    NSArray *roomary = [[NSUserDefaults standardUserDefaults] objectForKey:@"room"];
    for (NSDictionary *roomdic in roomary) {
        NSString *rid = [roomdic objectForKey:@"id"];
        if ([rid isEqualToString:_roomid] || rid.intValue == _roomid.intValue) {
            text = [NSString stringWithFormat:@"%@管理员",[roomdic objectForKey:@"title"]];
        }
    }
    
    self.handleTitle.text = text;
    
    self.handleName.text = [NSString stringWithFormat:@"姓       名：%@",[_data objectForKey:@"name"]];
    
    self.handlePhone.text = [NSString stringWithFormat:@"联系电话：%@",[_data objectForKey:@"phone"]];
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
