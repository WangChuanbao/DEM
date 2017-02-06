//
//  HandleTableViewCell.h
//  DEM
//
//  Created by 王宝 on 15/5/22.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol handleCellDelegate <NSObject>

- (void)handleCellText:(NSString *)text phone:(NSString *)phone index:(NSInteger)index;

@end

@interface HandleTableViewCell : UITableViewCell<UITextFieldDelegate>
{
    NSString *_personText;
    NSString *_phoneText;
}

@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UITextField *person;
@property (strong, nonatomic) IBOutlet UITextField *phone;

@property (nonatomic ,assign) id<handleCellDelegate> delegate;
@property (nonatomic ,assign) NSInteger index;
@property (nonatomic ,retain) NSDictionary *data;
@property (nonatomic ,retain) UIView *superView;

@end

