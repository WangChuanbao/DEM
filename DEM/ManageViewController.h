//
//  ManageViewController.h
//  DEM
//
//  Created by 王宝 on 15/5/25.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "BaseViewController.h"

@interface ManageViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UIView *phone;
@property (strong, nonatomic) IBOutlet UIView *message;
@property (strong, nonatomic) IBOutlet UIView *information;

@property (nonatomic ,strong) NSString *room_id;
@property (nonatomic ,strong) NSString *alarm_id;

@end
