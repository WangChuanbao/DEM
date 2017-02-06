//
//  AlarmTableViewCell.h
//  DEM
//
//  Created by 王宝 on 15/5/13.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLabel.h"

@interface AlarmTableViewCell : UITableViewCell
{
    CALayer *_topBorder;
    CALayer *_bottomBorder;
    UIView *_bgView;
    UIImageView *_imageView;
    ZLabel *_label;
    UIButton *_mark;
    NSString *_roomId;
    NSString *_alarmId;
}

@property(nonatomic ,retain)NSDictionary *data;
@property(nonatomic ,assign)UINavigationController *nav;

+(float)cellHeight:(NSString *)title;

@end
