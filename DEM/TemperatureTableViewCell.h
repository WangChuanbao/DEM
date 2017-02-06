//
//  TemperatureTableViewCell.h
//  DEM
//
//  Created by 王宝 on 15/5/20.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Segmented.h"

@protocol DetailDelegate <NSObject>

- (void)detailSegmentSelectedForId:(NSString *)segmentid;

@end

@interface TemperatureTableViewCell : UITableViewCell<SegmentedDelegate>
{
    float _margin;  //间距
    NSString *_room_id;
    BOOL _isTwoLevel;
    Segmented *_segment;
    Segmented *_segment2d;
    NSArray *_segment2dArray;
    NSMutableArray *_titleLabels;   //存储关键指标中标题label
    NSMutableArray *_labels;       //存储关键指标中指标数值label
}

@property(nonatomic ,retain)NSDictionary *data;

@property(nonatomic ,retain)id<DetailDelegate> delegate;

@property(nonatomic ,retain)UINavigationController *nav;

//整体运行状态
- (void)setAllState;

- (void)setKeyIndex;

- (void)setWarning;

- (void)setSegmented;

- (void)setChart;

- (void)setLineChart;

- (BOOL)CheckWarning:(NSArray *)array;

+ (float)warningHeight:(NSString *)title;

@end
