//
//  KeyIndexCell.m
//  DEM
//
//  Created by 王宝 on 15/6/7.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "KeyIndexCell.h"
#import "UIViewExt.h"
#import "KeyIndexTableViewCell.h"

@implementation KeyIndexCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _dataAry = [[NSArray alloc] init];
        
        self.backgroundColor = [UIColor clearColor];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        [self addSubview:_tableView];
        
    }
    return self;
}

- (void)layoutSubviews {
    
    _dataAry = [_data objectForKey:@"child"];
    
    NSArray *states = [[NSUserDefaults standardUserDefaults] objectForKey:@"state"];
    if (states == nil) {
        NSMutableArray *isOpens = [[NSMutableArray alloc] init];
        NSInteger openCount = 0;
        for (NSDictionary *dic in _dataAry) {
            NSString *state = [dic objectForKey:@"state"];
            [isOpens addObject:state];
            if ([state isEqualToString:@"1"] || state.intValue == 1) {
                openCount += 1;
            }
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:isOpens forKey:@"state"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",openCount] forKey:@"openCount"];
    }
    
    _tableView.frame = self.bounds;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identity = @"keycell";
    KeyIndexTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    if (cell == nil) {
        cell = [[KeyIndexTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    
    cell.data = [_dataAry objectAtIndex:indexPath.row];
    
    cell.superSection = _section;
    
    cell.superRow = _row;
    
    cell.row = indexPath.row;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([_show isEqualToString:@"0"] || _show.intValue == 0) {
        return 0;
    }
    return (kScreenHeight-64-49)*20/(568-49-64);
}

#pragma mark 头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *title = [_data objectForKey:@"name"];
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = RGBA(237, 237, 237, 1);
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/3, (kScreenHeight-49-64)*20/(568-49-64))];
    [button setTitle:title forState:UIControlStateNormal];
    button.tag = section;
    button.backgroundColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    [button setTitleColor:RGBA(54, 125, 242, 1) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0, button.bottom-0.5, button.width, 0.5);
    bottomBorder.backgroundColor = RGBA(204, 204, 204, 1).CGColor;
    [button.layer addSublayer:bottomBorder];
    
    return view;
}

- (void)buttonAction:(UIButton *)button {
    float height = 0.0f;
    if ([_show isEqualToString:@"0"] || _show.intValue == 0) {
        _show = @"1";
        height = (kScreenHeight-64-49)*20.0/(568-49-64)*_dataAry.count;
    }
    else {
        _show = @"0";
        height = -(kScreenHeight-64-49)*20.0/(568-49-64)*_dataAry.count;
    }
    
    [self.delegate cellHeightChangeAtSection:_section Row:_row Height:height State:_show];
    
    [_tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return (kScreenHeight-49-64)*20/(568-49-64);
}

@end
