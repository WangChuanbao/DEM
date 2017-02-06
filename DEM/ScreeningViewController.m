//
//  ScreeningViewController.m
//  DEM
//
//  Created by 王宝 on 15/8/4.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "ScreeningViewController.h"
#import "UIViewExt.h"
#import "ScreeningWindow.h"

@interface ScreeningViewController ()
{
    UIView *_item;          //导航栏背景
    UILabel *_titleLabel;   //标题label
    UITableView *_tableView;
    NSArray *_child;        //子项
}
@end

@implementation ScreeningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _child = [[NSArray alloc] init];
    
    /******************  导航栏设置  ************************/
    self.navigationController.navigationBarHidden = YES;
    
    [self setNavigationItem];
    [self setRightBar];
    if (self.navigationController.viewControllers.count >1) {
        [self setBackBar];
    }
    else {
        [self setLeftBar];
    }
    
    /******************  页面布局  ************************/
    
    [self initViews];
    
}

- (void)initViews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.width-30, self.view.height-44) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (void)setData:(NSArray *)data {
    if (_data != data) {
        _data = data;
    }
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identity = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
        [cell setFrame:CGRectMake(0, 0, kScreenWidth-30, 0)];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
    }
    
    NSDictionary *dic = [_data objectAtIndex:indexPath.row];
    NSArray *child = [dic objectForKey:@"child"];
    if (child.count > 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = [dic objectForKey:@"name"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [_data objectAtIndex:indexPath.row];
    _child = [dic objectForKey:@"child"];
    NSString *name = [dic objectForKey:@"name"];
    if (_child.count > 0) {
        ScreeningViewController *viewVC = [[ScreeningViewController alloc] init];
        viewVC.data = _child;
        viewVC.labelTitle = name;
        [self.navigationController pushViewController:viewVC animated:YES];
    }
    else {
        NSString *target_id = [dic objectForKey:@"id"];
        _notiObject = [NSDictionary dictionaryWithObjectsAndKeys:name,@"name",target_id,@"target_id", nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35;
}

#pragma mark 自定义导航栏
/*************************  自定义导航栏  *************************************/
- (void)setNavigationItem {
    _item = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-30, 64)];
    _item.backgroundColor = RGBA(54, 125, 242, 1);
    [self.navigationController.view addSubview:_item];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, _item.width-100, _item.height-20)];
    _titleLabel.font = [UIFont boldSystemFontOfSize:14];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.text = _labelTitle;
    [_item addSubview:_titleLabel];
}

- (void)setRightBar {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(_item.right-40, 32, 30, 20);
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [_item addSubview:button];
}

- (void)setBackBar {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 32, 13, 20);
    [button setImage:[UIImage imageNamed:@"返回按钮.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [_item addSubview:button];
}

- (void)setLeftBar {
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(10, 32, 30, 20);
    cancel.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [cancel addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [_item addSubview:cancel];
}

//取消
- (void)cancelAction {
    ScreeningWindow *window = (ScreeningWindow *)self.view.window;
    [window hidden];
}

//确定
- (void)buttonAction {
    if (_notiObject!=nil && _notiObject.allKeys.count>0) {
        //发送筛选完成通知
        [[NSNotificationCenter defaultCenter] postNotificationName:ScreeningFinish object:_notiObject];
    }
    ScreeningWindow *window = (ScreeningWindow *)self.view.window;
    [window hidden];
}

//返回
- (void)backAction {
    [_item removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
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
