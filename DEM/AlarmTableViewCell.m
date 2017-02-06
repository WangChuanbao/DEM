//
//  AlarmTableViewCell.m
//  DEM
//
//  Created by 王宝 on 15/5/13.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "AlarmTableViewCell.h"
#import "UIViewExt.h"
#import "ManageViewController.h"

@implementation AlarmTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        _roomId = @"";
        _alarmId = @"";
        
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_bgView];
        
        _topBorder = [CALayer layer];
        _topBorder.backgroundColor = RGBA(154, 154, 154, 0.5).CGColor;
        [_bgView.layer addSublayer:_topBorder];
        
        _bottomBorder = [CALayer layer];
        _bottomBorder.backgroundColor = RGBA(154, 154, 154, 0.5).CGColor;
        [_bgView.layer addSublayer:_bottomBorder];
        
        //状态图标
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.backgroundColor = [UIColor clearColor];
        [_bgView addSubview:_imageView];
        
        _label = [[ZLabel alloc] initWithFrame:CGRectZero font:[UIFont systemFontOfSize:12]];
        _label.zHeight = 20;
        [_bgView addSubview:_label];
        
        _mark = [[UIButton alloc] initWithFrame:CGRectZero];
        _mark.titleLabel.font = [UIFont systemFontOfSize:11];
        _mark.userInteractionEnabled = NO;
        [_mark setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_mark addTarget:self action:@selector(markAction) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:_mark];
        
    }
    
    return self;
}

- (void)layoutSubviews {
    _alarmId = [self.data objectForKey:@"id"];
    _roomId = [self.data objectForKey:@"machine_room_id"];
    NSString *state = [self.data objectForKey:@"state"];
    NSString *title = [self.data objectForKey:@"msg"];
    NSString *mark = [self.data objectForKey:@"is_solve"];
    
    if ([mark isEqualToString:@"0"] || mark.integerValue == 0) {
        mark = @"未处理";
        _mark.userInteractionEnabled = YES;
    }
    else if ([mark isEqualToString:@"1"] || mark.integerValue == 1) {
        mark = @"已处理";
        _mark.userInteractionEnabled = NO;
    }
    
    //状态图标
    _imageView.frame = CGRectMake(5, 8, 20, 20);
    switch (state.intValue) {
        case 1:
        {
            [_imageView setImage:[UIImage imageNamed:@"绿灯.png"]];
        }
            break;
            
        case 2:
        {
            [_imageView setImage:[UIImage imageNamed:@"黄灯.png"]];
            _label.textColor = [UIColor yellowColor];
        }
            break;
            
        case 3:
        {
            [_imageView setImage:[UIImage imageNamed:@"红灯.png"]];
            _label.textColor = [UIColor redColor];
        }
            break;
            
        default:
            break;
    }
    
    //text label
    [_label setFrame:CGRectMake(_imageView.right+5, 0, self.width-30-20, 0)];
    _label.text = title;
    
    //标示label
    [_mark setFrame:CGRectMake(self.width-35-10, _label.bottom-10, 35, 13)];
    [_mark setTitle:mark forState:UIControlStateNormal];
    
    //背景视图
    [_bgView setFrame:CGRectMake(0, 0, self.width, _label.height+5)];
    
    _topBorder.frame = CGRectMake(0, 0, _bgView.width, 1);
    
    _bottomBorder.frame = CGRectMake(0, _bgView.bottom-1, _bgView.width, 1);
    
}

//跳转到处理页面
- (void)markAction {
    ManageViewController *manageVC = [[ManageViewController alloc] init];
    manageVC.room_id = _roomId;
    manageVC.alarm_id = _alarmId;
    [self.nav pushViewController:manageVC animated:YES];
}

+(float)cellHeight:(NSString *)title {
    
    ZLabel *laebl = [[ZLabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-50, 0) font:[UIFont systemFontOfSize:12]];
    laebl.zHeight = 20;
    laebl.text = title;
    
    return laebl.height+10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
