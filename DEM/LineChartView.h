//
//  LineChartView.h
//  DrawDemo
//
//  Created by 东子 Adam on 12-5-31.
//  Copyright (c) 2012年 热频科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface LineChartView : UIView

//y轴数据长度
@property NSInteger step;
//最高数据
@property NSInteger max;
//最低数据
@property NSInteger min;
//y周数据单位
@property(nonatomic ,retain)NSString *yunit;
//警告线
@property NSInteger yellow;
@property NSInteger red;

//横竖轴距离间隔
@property (assign) float hInterval;
@property (assign) NSInteger vInterval;

//横竖轴显示标签
@property (nonatomic, strong) NSArray *hDesc;
@property (nonatomic, strong) NSArray *vDesc;

//点信息
@property (nonatomic, strong) NSArray *array;

@end
