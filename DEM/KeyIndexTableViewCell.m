//
//  KeyIndexTableViewCell.m
//  DEM
//
//  Created by 王宝 on 15/6/4.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "KeyIndexTableViewCell.h"
#import "UIViewExt.h"
#import "DEMDataSevice.h"
#import "MBProgressHUD.h"

@implementation KeyIndexTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        state = 0;
        _openCount = 0;
        
        view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        
        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:11];
        label.textColor = RGBA(54, 125, 242, 1);
        label.tag = 100;
        [self addSubview:label];
        
        bottomBorder = [CALayer layer];
        bottomBorder.backgroundColor = RGBA(204, 204, 204, 1).CGColor;
        [self.layer addSublayer:bottomBorder];
        
        on = [[UIButton alloc] initWithFrame:CGRectZero];
        on.titleLabel.font = [UIFont systemFontOfSize:11];
        on.tag = 200;
        [on setTitle:@"开" forState:UIControlStateNormal];
        [on setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [on setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [on setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [on setBackgroundImage:[UIImage imageNamed:@"开"] forState:UIControlStateSelected];
        [on setBackgroundImage:[UIImage imageNamed:@"开"] forState:UIControlStateHighlighted];
        [on setBackgroundImage:[UIImage imageNamed:@"关"] forState:UIControlStateNormal];
        [on addTarget:self action:@selector(onOffAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:on];
        
        off = [[UIButton alloc] initWithFrame:CGRectZero];
        off.titleLabel.font = [UIFont systemFontOfSize:11];
        off.tag = 300;
        [off setTitle:@"关" forState:UIControlStateNormal];
        [off setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [off setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [off setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [off setBackgroundImage:[UIImage imageNamed:@"开"] forState:UIControlStateHighlighted];
        [off setBackgroundImage:[UIImage imageNamed:@"开"] forState:UIControlStateSelected];
        [off setBackgroundImage:[UIImage imageNamed:@"关"] forState:UIControlStateNormal];
        [off addTarget:self action:@selector(onOffAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:off];
        
    }
    return self;
}

- (void)layoutSubviews {
    
    [self getStateAndOpenCount];
    
    NSString *text = [self.data objectForKey:@"name"];
    
    bottomBorder.frame = CGRectMake(0, self.height-0.5, kScreenWidth*175/320, 0.5);
        
    if (state == 0) {
        off.selected = YES;
        on.selected = NO;
    }
    else {
        on.selected = YES;
        off.selected = NO;
    }

    view.frame = CGRectMake(0, 0, kScreenWidth*175/320, (kScreenHeight-49-64)*20/(568-49-64));
    
    label.frame = CGRectMake(kScreenWidth/3, 0, kScreenWidth*175/320-kScreenWidth/3, (kScreenHeight-49-64)*20/(568-49-64));
    label.text = text;
    
    on.frame = CGRectMake(label.right+kScreenWidth*65/320, (kScreenHeight-49-64)*2/(568-49-64), kScreenWidth*30/320, (kScreenHeight-49-64)*16/(568-49-64));
    
    off.frame = CGRectMake(on.right, on.top, on.width, on.height);
}

- (void)getStateAndOpenCount {
    //获取指标打开状态
    NSArray *states = [[NSUserDefaults standardUserDefaults] objectForKey:@"state"];
    NSArray *states2d = [states objectAtIndex:_superSection];
    NSArray *states3d = [states2d objectAtIndex:_superRow];
    state = [[states3d objectAtIndex:_row] intValue];
    
    //获取指标打开个数
    NSArray *openCounts = [[NSUserDefaults standardUserDefaults] objectForKey:@"openCount"];
    NSArray *openCounts2d = [openCounts objectAtIndex:_superSection];
    _openCount = [[openCounts2d objectAtIndex:_superRow] intValue];
}

- (void)onOffAction:(UIButton *)button {
    
    if (button.selected == NO) {
        
        [self getStateAndOpenCount];
        
        //打开
        if (button.tag == 200) {
            if (self.openCount >= 3) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"最多只能设置三个关键指标，如果您想继续，请先关闭一个" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alert show];
                return;
            }
            else {
                button.selected = YES;
                off.selected = NO;
                state = 1;
                _openCount++;
            }
        }
        //关闭
        if (button.tag == 300) {
            button.selected = YES;
            on.selected = NO;
            state = 0;
            _openCount--;
        }
        
        [self uploadData];
    }
    
}

//提交数据
- (void)uploadData {
    
    NSString *url = @"index/handleKeyTarget";
    
    NSString *tid = [self.data objectForKey:@"id"];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:tid,@"target_id",[NSNumber numberWithInt:state],@"state", nil];
    
    [DEMDataSevice requestWithURL:url params:params httpMethod:@"POST" finishBlock:^(id result) {
        
        if (result == NULL) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"与服务器断开连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            [MBProgressHUD hideHUDForView:self animated:YES];
            return ;
        }
        
        NSString *upLoadState = [result objectForKey:@"state"];
        if (![upLoadState isEqualToString:@"0"] || upLoadState.intValue != 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"设置失败" message:@"本次操作失败，请检查网络" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        else {
            
            //获取指标打开状态
            NSMutableArray *states = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"state"]];
            NSMutableArray *states2d = [NSMutableArray arrayWithArray:[states objectAtIndex:_superSection]];
            NSMutableArray *states3d = [NSMutableArray arrayWithArray:[states2d objectAtIndex:_superRow]];
            
            [states3d replaceObjectAtIndex:_row withObject:[NSString stringWithFormat:@"%d",state]];
            [states2d replaceObjectAtIndex:_superRow withObject:states3d];
            [states replaceObjectAtIndex:_superSection withObject:states2d];
            
            //获取指标打开个数
            NSMutableArray *openCounts = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"openCount"]];
            NSMutableArray *openCounts2d = [NSMutableArray arrayWithArray:[openCounts objectAtIndex:_superSection]];
            
            [openCounts2d replaceObjectAtIndex:_superRow withObject:[NSString stringWithFormat:@"%d",_openCount]];
            [openCounts replaceObjectAtIndex:_superSection withObject:openCounts2d];

            
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"state"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"openCount"];
            [[NSUserDefaults standardUserDefaults] setObject:states forKey:@"state"];
            [[NSUserDefaults standardUserDefaults] setObject:openCounts forKey:@"openCount"];
            
        }
        
    } erro:^(id erro) {
        
    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
