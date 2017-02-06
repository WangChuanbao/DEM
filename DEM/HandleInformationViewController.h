//
//  HandleInformationViewController.h
//  DEM
//
//  Created by 王宝 on 15/5/25.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "BaseViewController.h"

@interface HandleInformationViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UILabel *handleTitle;
@property (strong, nonatomic) IBOutlet UILabel *handleName;
@property (strong, nonatomic) IBOutlet UILabel *handlePhone;
@property (strong, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic ,retain) NSDictionary *data;
@property (nonatomic ,retain) NSString *roomid;

@end
