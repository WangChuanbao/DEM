//
//  AlarmDetailTableViewCell.m
//  DEM
//
//  Created by 王宝 on 15/6/24.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "AlarmDetailTableViewCell.h"
#import "ZLabel.h"
#import "UIViewExt.h"

@implementation AlarmDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _keyLabel = [[ZLabel alloc] initWithFrame:CGRectZero font:[UIFont boldSystemFontOfSize:12]];
        _keyLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_keyLabel];
        
        _valueLabel = [[ZLabel alloc] initWithFrame:CGRectZero font:[UIFont systemFontOfSize:12]];
        _valueLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_valueLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    
    _keyLabel.frame = CGRectMake(0, 10, self.width*90/320, 0);
    _keyLabel.text = [[_data allKeys] firstObject];
    
    _valueLabel.frame = CGRectMake(self.width*120/320, 10, self.width-self.width*140/320, 0);
    _valueLabel.text = [[_data allValues] firstObject];
    
    if ([_keyLabel.text isEqualToString:@"处理状态"] && ![_valueLabel.text isEqualToString:@"已处理"]) {
        _valueLabel.textColor = [UIColor redColor];
    }
    else {
        _valueLabel.textColor = [UIColor blackColor];
    }
    
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1.0f);
    
    CGContextSetStrokeColorWithColor(context, RGBA(54, 125, 242, 1).CGColor);
    
    CGContextMoveToPoint(context, self.width*100/320, 0);
    
    CGContextAddLineToPoint(context, self.width*100/320, self.height);
    
    CGContextStrokePath(context);
    
    CGRect aRect= CGRectMake(self.width*98/320.0, 16, 5, 5);
    CGContextAddEllipseInRect(context, aRect); //椭圆, 参数2:椭圆的坐标。
    CGContextSetFillColorWithColor(context, RGBA(54, 125, 242, 1).CGColor);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0, 0, self.width, 0.5);
    topBorder.backgroundColor = RGBA(194, 216, 251, 1).CGColor;
    [self.layer addSublayer:topBorder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
