//
//  ChangePasswordViewController.h
//  DEM
//
//  Created by 王宝 on 15/5/21.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "BaseViewController.h"

@interface ChangePasswordViewController : BaseViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *oldPassword;
@property (strong, nonatomic) IBOutlet UITextField *newpassword;
@property (strong, nonatomic) IBOutlet UITextField *aginPassword;
@property (strong, nonatomic) IBOutlet UIButton *finish;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIView *contentView;

@end

/*
 {
 addtime = 1400000000;
 child =         (
 {
 addtime = 1400000000;
 child =                 (
 );
 "host_name" = hostname;
 id = 2;
 ip = "127.0.0.1";
 "machine_room_id" = 1;
 name = "\U6e29\U5ea61";
 "parent_id" = 1;
 "post_name" = "\U4e8c\U697c\U6e29\U6e7f\U5ea61_\U6e29\U5ea6";
 state = 0;
 "target_id" = 1;
 threshold = "[20,28]";
 },
 
 
 {
 addtime = 1400000000;
 child =                 (
 );
 "host_name" = hostname;
 id = 3;
 ip = "127.0.0.1";
 "machine_room_id" = 1;
 name = "\U6e29\U5ea62";
 "parent_id" = 1;
 "post_name" = "\U4e8c\U697c\U6e29\U6e7f\U5ea62_\U6e29\U5ea6";
 state = 0;
 "target_id" = 1;
 threshold = "[20,28]";
 },
 
 
 {
 addtime = 1400000000;
 child =                 (
 );
 "host_name" = hostname;
 id = 4;
 ip = "127.0.0.1";
 "machine_room_id" = 1;
 name = "\U6e29\U5ea63";
 "parent_id" = 1;
 "post_name" = "\U4e8c\U697c\U6e29\U6e7f\U5ea63_\U6e29\U5ea6";
 state = 0;
 "target_id" = 1;
 threshold = "[20,28]";
 },
 
 
 {
 addtime = 1400000000;
 child =                 (
 );
 "host_name" = hostname;
 id = 5;
 ip = "127.0.0.1";
 "machine_room_id" = 1;
 name = "\U6e29\U5ea64";
 "parent_id" = 1;
 "post_name" = "\U4e8c\U697c\U6e29\U6e7f\U5ea64_\U6e29\U5ea6";
 state = 0;
 "target_id" = 1;
 threshold = "[20,28]";
 },
 
 
 {
 addtime = 1400000000;
 child =                 (
 );
 "host_name" = hostname;
 id = 6;
 ip = "127.0.0.1";
 "machine_room_id" = 1;
 name = "\U6e29\U5ea65";
 "parent_id" = 1;
 "post_name" = "\U4e8c\U697c\U6e29\U6e7f\U5ea65_\U6e29\U5ea6";
 state = 0;
 "target_id" = 1;
 threshold = "[20,28]";
 },
 
 
 {
 addtime = 1400000000;
 child =                 (
 );
 "host_name" = hostname;
 id = 38;
 ip = "127.0.0.1";
 "machine_room_id" = 1;
 name = "\U6e29\U5ea66";
 "parent_id" = 1;
 "post_name" = "\U4e8c\U697c\U6e29\U6e7f\U5ea66_\U6e29\U5ea6";
 state = 1;
 "target_id" = 1;
 threshold = "[20,28]";
 },
 
 
 {
 addtime = 1400000000;
 child =                 (
 );
 "host_name" = hostname;
 id = 39;
 ip = "127.0.0.1";
 "machine_room_id" = 1;
 name = "\U6e29\U5ea67";
 "parent_id" = 1;
 "post_name" = "\U4e8c\U697c\U6e29\U6e7f\U5ea67_\U6e29\U5ea6";
 state = 0;
 "target_id" = 1;
 threshold = "[20,28]";
 }
 );
 "host_name" = hostname;
 id = 1;
 ip = "127.0.0.1";
 isShow = 1;
 "machine_room_id" = 1;
 name = "\U6e29\U5ea6";
 "parent_id" = 0;
 "post_name" = "";
 "target_id" = 1;
 threshold = "[20,28]";
 }
 )
 2015-06-05 11:40:59.344 DEM[1586:46060] ========================(
 {
 addtime = 1400000000;
 child =         (
 {
 addtime = 1400000000;
 child =                 (
 );
 "host_name" = hostname;
 id = 2;
 ip = "127.0.0.1";
 "machine_room_id" = 1;
 name = "\U6e29\U5ea61";
 "parent_id" = 1;
 "post_name" = "\U4e8c\U697c\U6e29\U6e7f\U5ea61_\U6e29\U5ea6";
 state = 0;
 "target_id" = 1;
 threshold = "[20,28]";
 },
 {
 addtime = 1400000000;
 child =                 (
 );
 "host_name" = hostname;
 id = 3;
 ip = "127.0.0.1";
 "machine_room_id" = 1;
 name = "\U6e29\U5ea62";
 "parent_id" = 1;
 "post_name" = "\U4e8c\U697c\U6e29\U6e7f\U5ea62_\U6e29\U5ea6";
 state = 0;
 "target_id" = 1;
 threshold = "[20,28]";
 },
 {
 addtime = 1400000000;
 child =                 (
 );
 "host_name" = hostname;
 id = 4;
 ip = "127.0.0.1";
 "machine_room_id" = 1;
 name = "\U6e29\U5ea63";
 "parent_id" = 1;
 "post_name" = "\U4e8c\U697c\U6e29\U6e7f\U5ea63_\U6e29\U5ea6";
 state = 0;
 "target_id" = 1;
 threshold = "[20,28]";
 },
 {
 addtime = 1400000000;
 child =                 (
 );
 "host_name" = hostname;
 id = 5;
 ip = "127.0.0.1";
 "machine_room_id" = 1;
 name = "\U6e29\U5ea64";
 "parent_id" = 1;
 "post_name" = "\U4e8c\U697c\U6e29\U6e7f\U5ea64_\U6e29\U5ea6";
 state = 0;
 "target_id" = 1;
 threshold = "[20,28]";
 },
 {
 addtime = 1400000000;
 child =                 (
 );
 "host_name" = hostname;
 id = 6;
 ip = "127.0.0.1";
 "machine_room_id" = 1;
 name = "\U6e29\U5ea65";
 "parent_id" = 1;
 "post_name" = "\U4e8c\U697c\U6e29\U6e7f\U5ea65_\U6e29\U5ea6";
 state = 0;
 "target_id" = 1;
 threshold = "[20,28]";
 },
 {
 addtime = 1400000000;
 child =                 (
 );
 "host_name" = hostname;
 id = 38;
 ip = "127.0.0.1";
 "machine_room_id" = 1;
 name = "\U6e29\U5ea66";
 "parent_id" = 1;
 "post_name" = "\U4e8c\U697c\U6e29\U6e7f\U5ea66_\U6e29\U5ea6";
 state = 1;
 "target_id" = 1;
 threshold = "[20,28]";
 },
 {
 addtime = 1400000000;
 child =                 (
 );
 "host_name" = hostname;
 id = 39;
 ip = "127.0.0.1";
 "machine_room_id" = 1;
 name = "\U6e29\U5ea67";
 "parent_id" = 1;
 "post_name" = "\U4e8c\U697c\U6e29\U6e7f\U5ea67_\U6e29\U5ea6";
 state = 0;
 "target_id" = 1;
 threshold = "[20,28]";
 }
 );
 "host_name" = hostname;
 id = 1;
 ip = "127.0.0.1";
 isShow = 1;
 "machine_room_id" = 1;
 name = "\U6e29\U5ea6";
 "parent_id" = 0;
 "post_name" = "";
 "target_id" = 1;
 threshold = "[20,28]";
 }
 )

*/