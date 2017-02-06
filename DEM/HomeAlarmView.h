//
//  HomeAlarmView.h
//  CeShi
//
//  Created by 王宝 on 15/5/7.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeAlarmView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *_heights;
}

@property (nonatomic ,retain)NSArray *array;
@property (nonatomic ,retain)UINavigationController *nav;

@end
