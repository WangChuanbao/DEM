//
//  Segmented.h
//  CeShi
//
//  Created by 王宝 on 15/5/7.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Segmented;
@protocol SegmentedDelegate <NSObject>

- (void)Segmented:(Segmented *)segmented DidSelectAtIndex:(NSInteger) index ;

@end

@interface Segmented : UIView
{
    UIScrollView *_scrollView;
    
    UILabel *_label;
    
    UIView *_view;
    
    UIButton *_send;    //纪录上一个选中状态的按钮
}

@property(nonatomic,retain) NSArray *array;

@property(nonatomic,assign) id<SegmentedDelegate> delegate;

@property float animateDuration;    //动画持续时间

@property(nonatomic ,retain) UIColor *labelColor;   //下标颜色

@property(nonatomic ,retain) UIColor *color;    //按钮颜色

@property(nonatomic ,retain) UIColor *titleColorWithNormal;

@property(nonatomic ,retain) UIColor *titleColorWithHighlighted;

@property(nonatomic ,retain) UIFont *font;

@property(nonatomic) NSInteger selectedAtIndex;

@property int segmentCount;         //显示多少个分段

- (void)changeScrollAtIndex:(int)index;

@end
