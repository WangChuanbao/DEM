//
//  KeyIndexTableViewCell.h
//  DEM
//
//  Created by 王宝 on 15/6/4.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyIndexTableViewCell : UITableViewCell
{
    UILabel *label;
    CALayer *bottomBorder;
    
    //开关按钮
    UIButton *on;
    UIButton *off;
    
    UIView *view;
    int state;
    
}

@property (nonatomic ,retain)NSDictionary *data;
@property NSInteger superSection;
@property NSInteger superRow;
@property NSInteger row;
@property NSInteger openCount;

@end
