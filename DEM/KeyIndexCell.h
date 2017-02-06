//
//  KeyIndexCell.h
//  DEM
//
//  Created by 王宝 on 15/6/7.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KeyIndexDelegate <NSObject>

- (void)cellHeightChangeAtSection:(NSInteger)section Row:(NSInteger)row Height:(float)height State:(NSString *)showState;

@end

@interface KeyIndexCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_dataAry;
}
@property NSInteger section;
@property NSInteger row;
@property (nonatomic ,retain)NSString *show;
@property(nonatomic ,retain)NSDictionary *data;
@property(nonatomic ,assign)id<KeyIndexDelegate> delegate;
@end
