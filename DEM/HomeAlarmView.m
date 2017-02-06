//
//  HomeAlarmView.m
//  CeShi
//
//  Created by 王宝 on 15/5/7.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "HomeAlarmView.h"
#import "UIViewExt.h"
#import "ZLabel.h"
#import "AlarmDetailViewController.h"

@implementation HomeAlarmView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/

- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.backgroundColor = [UIColor whiteColor];
    
    _heights = [[NSMutableArray alloc] init];
    
    ZLabel *label = [[ZLabel alloc] initWithFrame:CGRectMake(0, 0, self.width-80, 0) font:[UIFont systemFontOfSize:12]];
    label.zHeight = 3;
    
    for (int i=0; i<self.array.count; i++) {
        
        NSDictionary *dic = [self.array objectAtIndex:i];
        label.text = [dic objectForKey:@"msg"];
        [_heights addObject:[NSString stringWithFormat:@"%f",label.height]];
    }
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 5, self.width, self.height-10) style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.showsHorizontalScrollIndicator = NO;
    tableView.showsVerticalScrollIndicator = NO;
    [self addSubview:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identity = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identity];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 20, 20)];
        imgView.tag = 100;
        //imgView.contentMode = UIViewContentModeCenter;
        //imgView.contentMode = UIViewContentModeScaleAspectFill;
        [imgView setClipsToBounds:YES];
        [cell addSubview:imgView];
        
        ZLabel *label = [[ZLabel alloc] initWithFrame:CGRectMake(imgView.right+5, 0, self.width-70, 0) font:[UIFont systemFontOfSize:12]];
        label.tag = 200;
        label.zHeight = 5;
        [cell addSubview:label];
        
    }
    
    [cell setFrame:CGRectMake(0, 0, self.width, 0)];
    
    NSDictionary *dic = [self.array objectAtIndex:indexPath.row];
    
    NSString *state = [dic objectForKey:@"state"];
    NSString *title = [dic objectForKey:@"msg"];
    
    ZLabel *label = (ZLabel *)[cell viewWithTag:200];
    label.text = title;
    
    UIImageView *imgView = (UIImageView *)[cell viewWithTag:100];
    
    if ([state isEqualToString:@"0"] || state.intValue == 1) {
        imgView.image = [UIImage imageNamed:@"绿灯"];
    }
    else if ([state isEqualToString:@"1"] || state.intValue == 2) {
        imgView.image = [UIImage imageNamed:@"黄灯"];
        label.textColor = [UIColor yellowColor];
    }
    else {
        imgView.image = [UIImage imageNamed:@"红灯"];
        label.textColor = [UIColor redColor];
    }
    
    [_heights addObject:[NSString stringWithFormat:@"%f",label.height]];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_heights.count>indexPath.row) {
        NSString *str = [_heights objectAtIndex:indexPath.row];
        float height = [str floatValue];
        return height;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = [self.array objectAtIndex:indexPath.row];
    NSString *type = [dic objectForKey:@"id"];
    //根据type跳转页面
    AlarmDetailViewController *alarmDetail = [[AlarmDetailViewController alloc] init];
    alarmDetail.detailId = type;
    [self.nav pushViewController:alarmDetail animated:YES];
    
}

@end
