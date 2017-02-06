//
//  StatisticsTableViewCell.h
//  DEM
//
//  Created by 王宝 on 15/5/15.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatisticsTableViewCell : UITableViewCell
{
    CGContextRef _context;
    UILabel *_dataLabel;
    UILabel *_indexOne;         //第一个指标
    UILabel *_indexTwo;         //第二个指标
    UILabel *_indexThree;       //第三个指标
    UIImageView *_markView;     //标示视图
    UIImageView *_stateView;    //状态图标
    UILabel *_label;            //运行状态
}

@property (nonatomic ,retain) NSDictionary *data;

@end
