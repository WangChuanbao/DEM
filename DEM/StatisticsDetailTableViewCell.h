//
//  StatisticsDetailTableViewCell.h
//  DEM
//
//  Created by 王宝 on 15/5/25.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineChartView.h"

@interface StatisticsDetailTableViewCell : UITableViewCell
{
    UIView *_view;
    UILabel *_titleLabel;
    UIImageView *_imageView;
    LineChartView *_lineView;
    CALayer *_topBorder;
    CALayer *_bottomBorder;
    NSArray *_oldArray;         //记录上一次的平均温度
    NSMutableArray *_labels;           //存储第二种cell里显示平均值的label
    /**用于第二种cell，如指标过多，则只显10个，按此按钮显示全部*/
    UIButton *_moreButton;
}

/**是否点击_moreButton*/
@property BOOL isMore;
@property (nonatomic ,retain)NSDictionary *data;

@end
