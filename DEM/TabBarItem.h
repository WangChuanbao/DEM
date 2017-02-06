//
//  TabBarItem.h
//  DEM
//
//  Created by 王宝 on 15/5/8.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarItem : UIControl
{
    UIImageView *imgView;
    UILabel *titleLabel;
    NSString *selectedImageName;
    NSString *_imageName;
}

- (id)initWithFrame:(CGRect)frame
          imageName:(NSString *)imageName
    selectImageName:(NSString *)selectImageName
              title:(NSString *)title;

@end
