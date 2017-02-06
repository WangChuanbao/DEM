//
//  TabBarItem.m
//  DEM
//
//  Created by 王宝 on 15/5/8.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "TabBarItem.h"
#import "UIViewExt.h"

@implementation TabBarItem

- (id)initWithFrame:(CGRect)frame
          imageName:(NSString *)imageName
    selectImageName:(NSString *)selectImageName
              title:(NSString *)title
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        selectedImageName = selectImageName;
        _imageName = imageName;
        
        float range = (frame.size.width-22)/2;
        
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(range, 6, 22, 22)];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imgView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imgView.bottom+4, self.width, 11)];
        titleLabel.text = title;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:11];
        [self addSubview:titleLabel];
        
        if (self.selected == YES) {
            imgView.image = [UIImage imageNamed:selectImageName];
            titleLabel.textColor = RGBA(54, 125, 242, 1);
        }
        else {
            imgView.image = [UIImage imageNamed:imageName];
            titleLabel.textColor = [UIColor blackColor];
        }
        
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    self.selected = YES;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected == YES) {
        imgView.image = [UIImage imageNamed:selectedImageName];
        titleLabel.textColor = RGBA(54, 125, 242, 1);
    }
    else {
        imgView.image = [UIImage imageNamed:_imageName];
        titleLabel.textColor = [UIColor blackColor];
    }
}

@end
