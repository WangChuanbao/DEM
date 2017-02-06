//
//  AboutViewController.m
//  DEM
//
//  Created by 王宝 on 15/5/25.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "AboutViewController.h"
#import "ZLabel.h"

@interface AboutViewController ()
{
    NSString *_text;
    ZLabel *label;
}
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"关于";
    
    _text = @"";
    
    [self initViews];
    
    [self loadData];
}

- (void)initViews {
    label = [[ZLabel alloc] initWithFrame:CGRectMake(10, 10, self.view.width-20, 0) font:[UIFont systemFontOfSize:12]];
    [self.view addSubview:label];
}

- (void)loadData {
    [super showHUD:@"加载中"];
    
    NSString *url = @"index/about";
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
            
            NSDictionary *data = [result objectForKey:@"data"];
            _text = [data objectForKey:@"content"];
            label.text = _text;
            
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
