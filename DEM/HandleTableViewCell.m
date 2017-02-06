//
//  HandleTableViewCell.m
//  DEM
//
//  Created by 王宝 on 15/5/22.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "HandleTableViewCell.h"
#import "UIViewExt.h"

@implementation HandleTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    _phoneText = @"";
    _personText = @"";
    
    _person.delegate = self;
    _phone.delegate = self;
}

- (void)layoutSubviews {
    
    NSString *name = [_data objectForKey:@"name"];
    NSString *phone = [_data objectForKey:@"phone"];
    NSString *room = [_data objectForKey:@"room_name"];
    
    _title.text = room;
    
    if ([name isEqualToString:@""] || name == nil) {
        _person.placeholder = [NSString stringWithFormat:@"请输入%@的处理人",room];
    }
    else {
        _person.text = name;
    }
    
    if (![phone isEqualToString:@""] && phone != nil) {
        _phone.text = phone;
        
        [self.delegate handleCellText:name phone:phone index:_index];
    }
    
    
    
}

//当开始点击textField会调用的方法
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    //弹出键盘通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardshow:) name:UIKeyboardWillShowNotification object:nil];
    //隐藏键盘通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardhidden:) name:UIKeyboardWillHideNotification object:nil];
    //结束编辑通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFildEnd) name:@"TextFildEndEdit" object:nil];
 
    [textField becomeFirstResponder];
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

//当textField编辑结束时调用的方法
-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 100) {
        _personText = textField.text;
    }
    else if (textField.tag == 200) {
        _phoneText = textField.text;
    }
    
    [self textFildEnd];
}

//按下Done按钮的调用方法，我们让键盘消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
    
}
    
#pragma mark 键盘弹出收起通知
- (void)keyboardshow:(NSNotification *)notity {
    float time = [[notity.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //CGRect rect = [[notity.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

    [UIView animateWithDuration:time animations:^{
        [self.superView setFrame:CGRectMake(_superView.left, -self.top, _superView.width, _superView.height)];
    }];
    
    //移除键盘显示通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)keyboardhidden:(NSNotification *)notity {
    float time = [[notity.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];

    [UIView animateWithDuration:time animations:^{
        [self.superView setFrame:CGRectMake(_superView.left, 0, _superView.width, _superView.height)];
    }];
    
    //移除键盘隐藏通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)textFildEnd {
    [_person resignFirstResponder];
    [_phone resignFirstResponder];
    
    _personText = _person.text;
    _phoneText = _phone.text;
    if (![_personText isEqualToString:@""] && ![_phoneText isEqualToString:@""]) {
        [self.delegate handleCellText:_personText phone:_phoneText index:self.index];
    }
    
    //移除结束编辑通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TextFildEndEdit" object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
