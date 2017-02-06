//
//  AlarmDetailTableViewCell.h
//  DEM
//
//  Created by 王宝 on 15/6/24.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZLabel;

@interface AlarmDetailTableViewCell : UITableViewCell
{
    ZLabel *_keyLabel;
    ZLabel *_valueLabel;
}

@property (nonatomic ,retain)NSDictionary *data;

@end
