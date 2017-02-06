//
//  UserViewController.m
//  DEM
//
//  Created by 王宝 on 15/5/8.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "UserViewController.h"
#import "ChangePasswordViewController.h"
#import "KeyIndexViewController.h"
#import "HandleViewController.h"
#import "WXalarmViewController.h"
#import "AboutViewController.h"

@interface UserViewController ()
{
    UITableView *_tableView;
    NSArray *_items;
    
    //清理缓存
    UIView *_bgview;
    UIView *_view;
    //加载轮
    UIActivityIndicatorView *_indic;
    //缓存大小
    float filesize;
}
@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"用户";
    
    filesize = 0.0;
    
    _items = @[@"修改用户密码",@"设置关键指标",@"设置处理人",@"打开微信报警",@"清除缓存",@"关于",@"退出当前账号"];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-49) style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.sectionFooterHeight = 0;
    _tableView.sectionHeaderHeight = (kScreenHeight-49-64)*5/(568-49-64);
    [self.view addSubview:_tableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identity = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    
    if (cell == nil) {

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        
        CALayer *topBorder = [CALayer layer];
        topBorder.frame = CGRectMake(0, 0, self.view.width, 1);
        topBorder.backgroundColor = RGBA(184, 184, 184, 1).CGColor;
        [cell.layer addSublayer:topBorder];
        
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0, (kScreenHeight-49-64)*36/(568-49-64)-1, self.view.width, 1);
        bottomBorder.backgroundColor = RGBA(184, 184, 184, 1).CGColor;
        [cell.layer addSublayer:bottomBorder];
        
    }
    
    [cell setFrame:CGRectMake(0, 0, self.view.width, 0)];
    
    cell.textLabel.text = [_items objectAtIndex:indexPath.row+indexPath.section];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (kScreenHeight-49-64)*36/(568-49-64);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {

        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, (kScreenHeight-49-64)*205/(568-49-64))];
        view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];

        UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.width-self.view.width*150/320)/2, (kScreenHeight-49-64)*50/(568-49-64), self.view.width*150/320, (kScreenHeight-49-64)*50/(568-49-64))];
        headView.backgroundColor = [UIColor clearColor];
        headView.contentMode = UIViewContentModeScaleAspectFit;
        headView.image = [UIImage imageNamed:@"001.png"];
        [view addSubview:headView];
        
        UIImageView *textView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.width-self.view.width*200/320)/2, headView.bottom, self.view.width*200/320, view.height-headView.bottom)];
        textView.backgroundColor = [UIColor clearColor];
        textView.contentMode = UIViewContentModeScaleAspectFit;
        textView.image = [UIImage imageNamed:@"字01.png"];
        [view addSubview:textView];
        
        return view;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return (kScreenHeight-49-64)*205/(568-49-64);
    }
    return (kScreenHeight-49-64)*5/(568-49-64);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.section) {
        case 0://修改密码
        {
            ChangePasswordViewController *changeVC = [[ChangePasswordViewController alloc] init];
            [self.navigationController pushViewController:changeVC animated:YES];
        }
            break;
            
        case 1://设置关键指标
        {
            KeyIndexViewController *keyVC = [[KeyIndexViewController alloc] init];
            [self.navigationController pushViewController:keyVC animated:YES];
        }
            
            break;
            
        case 2://设置处理人
        {
            HandleViewController *handleVC = [[HandleViewController alloc] init];
            [self.navigationController pushViewController:handleVC animated:YES];
        }
            break;
            
        case 3://打开微信报警
        {
            WXalarmViewController *alarmVC = [[WXalarmViewController alloc] init];
            [self.navigationController pushViewController:alarmVC animated:YES];
        }
            break;
            
        case 4://清除缓存
        {
            _bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
            _bgview.backgroundColor = [UIColor blackColor];
            _bgview.alpha = 0;
            [self.view addSubview:_bgview];
            
            _view = [[UIView alloc] initWithFrame:CGRectMake(35, (kScreenHeight-64-49)*277/(568-64-49), self.view.width-70, (kScreenHeight-64-49)*100/(568-64-49))];
            _view.alpha = 0;
            _view.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:_view];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, _view.width-20, _view.height-20)];
            label.userInteractionEnabled = YES;
            label.layer.masksToBounds = YES;
            label.layer.borderColor = [UIColor blackColor].CGColor;
            label.layer.borderWidth = .5;
            [_view addSubview:label];
            
            UIButton *makeSure = [[UIButton alloc] initWithFrame:CGRectMake(40, 30, label.width/2-80, label.height-60)];
            makeSure.layer.masksToBounds = YES;
            makeSure.layer.borderColor = [UIColor blackColor].CGColor;
            makeSure.layer.borderWidth = .5;
            [makeSure setTitle:@"确定" forState:UIControlStateNormal];
            [makeSure setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            makeSure.titleLabel.font = [UIFont systemFontOfSize:11];
            [makeSure addTarget:self action:@selector(makeSureAction:) forControlEvents:UIControlEventTouchUpInside];
            [label addSubview:makeSure];
            
            UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(label.width/2+40, makeSure.top, makeSure.width, makeSure.height)];
            cancel.layer.masksToBounds = YES;
            cancel.layer.borderColor = [UIColor blackColor].CGColor;
            cancel.layer.borderWidth = .5;
            [cancel setTitle:@"取消" forState:UIControlStateNormal];
            [cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            cancel.titleLabel.font = [UIFont systemFontOfSize:11];
            [cancel addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
            [label addSubview:cancel];
            
            [UIView animateWithDuration:.5 animations:^{
                _bgview.alpha = .6;
                _view.alpha = 1;
            }];
        }
            break;
            
        case 5://关于
        {
            AboutViewController *aboutVC = [[AboutViewController alloc] init];
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
            break;
            
        case 6://注销登录
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"退出登录？" message:nil delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"取消", nil];
            [alert show];
        }
            break;
            
        default:
            break;
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"login"];
        [self.tabBarController.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)makeSureAction:(UIButton *)send {
    [send.superview removeFromSuperview];
    
    _view.backgroundColor = [UIColor clearColor];
    
    _indic = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    _indic.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [_indic setCenter:CGPointMake(_view.width/2, _view.height/2)];
    [_indic startAnimating];
    [_view addSubview:_indic];
    
    NSString* cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)firstObject];
    
    filesize = [self folderSizeAtPath:cachPath];
    
    [self clearCache:cachPath];
    
}

- (void)cancelAction:(UIButton *)send {
    [UIView animateWithDuration:.5 animations:^{
        _bgview.alpha = 0;
        _view.alpha = 0;
    } completion:^(BOOL finished) {
        [_view removeFromSuperview];
        [_bgview removeFromSuperview];
    }];
}

//计算耽搁文件大小
- (float)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}

//计算文件夹大小
- (float)folderSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize = 0;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize +=[self fileSizeAtPath:absolutePath];
        }
        //SDWebImage框架自身计算缓存的实现
        folderSize+=[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        return folderSize;
    }
    return 0;
}

//清理
- (void)clearCache:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
    
    [self performSelectorOnMainThread:@selector(clearCachSuccess)withObject:nil waitUntilDone:YES];
}

- (void)clearCachSuccess {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _view.width, 20)];
    label.font = [UIFont systemFontOfSize:11];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = [NSString stringWithFormat:@"已成功清理%0.2fM缓存",filesize];
    [label setCenter:CGPointMake(_view.width/2, _view.height/2)];
    [_view addSubview:label];
    
    [self performSelector:@selector(cleanOver) withObject:nil afterDelay:1];
}

- (void)cleanOver {
    [UIView animateWithDuration:.5 animations:^{
        _bgview.alpha = 0;
        _view.alpha = 0;
    } completion:^(BOOL finished) {
        [_bgview removeFromSuperview];
        [_view removeFromSuperview];
    }];
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
