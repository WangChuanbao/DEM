//
//  StatisticsTableViewCell.m
//  DEM
//
//  Created by 王宝 on 15/5/15.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "StatisticsTableViewCell.h"
#import "UIViewExt.h"

@implementation StatisticsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _dataLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _dataLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_dataLabel];
        
        if ([reuseIdentifier isEqualToString:@"first"]) {
            
            _dataLabel.font = [UIFont systemFontOfSize:11];
            
        }
        else if ([reuseIdentifier isEqualToString:@"cell"]) {
            
            _dataLabel.font = [UIFont systemFontOfSize:11];
            
            //运行状态
            _label = [[UILabel alloc] initWithFrame:CGRectZero];
            _label.textAlignment = NSTextAlignmentLeft;
            _label.font = [UIFont boldSystemFontOfSize:11];
            _label.text = @"运行状态";
            [self addSubview:_label];
            
            //指标一
            _indexOne = [[UILabel alloc] initWithFrame:CGRectZero];
            _indexOne.textAlignment = NSTextAlignmentLeft;
            _indexOne.font = [UIFont systemFontOfSize:11];
            _indexOne.adjustsFontSizeToFitWidth = YES;
            [self addSubview:_indexOne];
            
            //指标二
            _indexTwo = [[UILabel alloc] initWithFrame:CGRectZero];
            _indexTwo.textAlignment = NSTextAlignmentLeft;
            _indexTwo.font = [UIFont systemFontOfSize:11];
            _indexTwo.adjustsFontSizeToFitWidth = YES;
            [self addSubview:_indexTwo];
            
            //指标三
            _indexThree = [[UILabel alloc] initWithFrame:CGRectZero];
            _indexThree.textAlignment = NSTextAlignmentLeft;
            _indexThree.font = [UIFont systemFontOfSize:11];
            _indexThree.adjustsFontSizeToFitWidth = YES;
            [self addSubview:_indexThree];
            
            //标示图标
            _markView = [[UIImageView alloc] initWithFrame:CGRectZero];
            _markView.userInteractionEnabled = YES;
            _markView.image = [UIImage imageNamed:@"箭头01.png"];
            [self addSubview:_markView];
            
            //状态图标
            _stateView = [[UIImageView alloc] initWithFrame:CGRectZero];
            [self addSubview:_stateView];
        }
        
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if ([self.reuseIdentifier isEqualToString:@"first"]) {
        
        _dataLabel.frame = CGRectMake(0, 5, self.width*57/320, 15);
        NSArray *dataary = [_data objectForKey:@"date"];
        NSString *year = [dataary firstObject];
        NSString *month = [dataary objectAtIndex:1];
        _dataLabel.text = [NSString stringWithFormat:@"%@.%@",year,month];
        
    }
    else if ([self.reuseIdentifier isEqualToString:@"cell"]) {
        NSArray *indexList = [_data objectForKey:@"data"];
        
        //日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[_data objectForKey:@"time"] integerValue]];
        NSString *time = [dateFormatter stringFromDate:date];
        
        _dataLabel.frame = CGRectMake(self.width*30/320, 7, self.width*30/320, 15);
        _dataLabel.text = time;
        
        //运行状态
        _label.frame = CGRectMake(self.width*80/320, 10, self.width*100/320, (self.height-20)/4);
        
        //指标一
        _indexOne.frame = CGRectMake(_label.left, _label.bottom, _label.width, _label.height);
        
        //指标二
        _indexTwo.frame = CGRectMake(_indexOne.left, _indexOne.bottom, _indexOne.width, _indexOne.height);
        
        //指标三
        _indexThree.frame = CGRectMake(_indexOne.left, _indexTwo.bottom, _indexTwo.width, _indexTwo.height);
        
        NSArray *indexLabels = @[_indexOne,_indexTwo,_indexThree];
        for (int i=0; i<indexLabels.count; i++) {
            UILabel *label = [indexLabels objectAtIndex:i];
            @try {
                NSDictionary *dic = [indexList objectAtIndex:i];
                label.text = [NSString stringWithFormat:@"%@：%0.1f",[dic objectForKey:@"name"],[[dic objectForKey:@"value_avg"] doubleValue]];
            }
            @catch (NSException *exception) {
                label.text = @"暂无数据";
            }
            @finally {
                
            }
        }
        
        //标示视图
        _markView.frame = CGRectMake(_indexThree.right+self.width*40/320, 29, 10, self.height-58);
        
        //状态图标
        _stateView.frame = CGRectMake(self.width-20-self.width*20/320, 10, 20, 20);
        NSString *state = [_data objectForKey:@"state"];
        switch (state.intValue) {
            case 1:
                _stateView.image = [UIImage imageNamed:@"绿.png"];
                break;
                
            case 2:
                _stateView.image = [UIImage imageNamed:@"黄.png"];
                break;
                
            case 3:
                _stateView.image = [UIImage imageNamed:@"红.png"];
                break;
                
            default:
                break;
        }
        
    }
}


- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1.0f);
    
    CGContextSetStrokeColorWithColor(context, RGBA(54, 125, 242, 1).CGColor);
    
    CGContextMoveToPoint(context, self.width*60/320.0, 0);
    
    if ([self.reuseIdentifier isEqualToString:@"first"]) {
        CGContextAddLineToPoint(context, self.width*60/320.0, 23);
        
        //画点
        CGRect aRect= CGRectMake(self.width*57/320.0, 10, 7, 7);
        CGContextAddEllipseInRect(context, aRect); //椭圆, 参数2:椭圆的坐标。
        CGContextSetFillColorWithColor(context, RGBA(54, 125, 242, 1).CGColor);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
    else if ([self.reuseIdentifier isEqualToString:@"cell"]) {
        //绘画上边线
        CALayer *topBorder = [CALayer layer];
        topBorder.frame = CGRectMake(0, 0, self.width, 0.5);
        topBorder.backgroundColor = RGBA(194, 216, 251, 1).CGColor;
        [self.layer addSublayer:topBorder];
        
        CGContextAddLineToPoint(context,self.width*60/320.0, self.height);
        
        //画点
        CGRect aRect= CGRectMake(self.width*58/320.0, 12, 5, 5);
        CGContextAddEllipseInRect(context, aRect); //椭圆, 参数2:椭圆的坐标。
        CGContextSetFillColorWithColor(context, RGBA(54, 125, 242, 1).CGColor);
        CGContextDrawPath(context, kCGPathFillStroke);
        
    }
    
    CGContextStrokePath(context);
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
