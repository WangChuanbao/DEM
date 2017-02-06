//
//  StatisticsDetailTableViewCell.m
//  DEM
//
//  Created by 王宝 on 15/5/25.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "StatisticsDetailTableViewCell.h"
#import "UIViewExt.h"

@implementation StatisticsDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        _oldArray = [[NSArray alloc] init];
        _view = [[UIView alloc] initWithFrame:CGRectZero];
        _view.backgroundColor = [UIColor whiteColor];
        [self addSubview:_view];
        
        _topBorder = [CALayer layer];
        _topBorder.backgroundColor = RGBA(184, 184, 184, 1).CGColor;
        [_view.layer addSublayer:_topBorder];
        
        _bottomBorder = [CALayer layer];
        _bottomBorder.backgroundColor = RGBA(184, 184, 184, 1).CGColor;
        [_view.layer addSublayer:_bottomBorder];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_view addSubview:_titleLabel];
        
        if ([reuseIdentifier isEqualToString:@"one"]) {
            
            _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
            [_view addSubview:_imageView];
            
        }
        else if ([reuseIdentifier isEqualToString:@"two"]) {
            
            _labels = [[NSMutableArray alloc] init];
            _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_moreButton setImage:[UIImage imageNamed:@"san.png"] forState:UIControlStateNormal];
            [_moreButton addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
            _moreButton.hidden = YES;
            [_view addSubview:_moreButton];
            
        }
        else if ([reuseIdentifier isEqualToString:@"cell"]) {
            
            
            
        }
        
    }
    
    return self;
}

- (void)layoutSubviews {
    
    _topBorder.frame = CGRectMake(0, 0, self.width, 1);
    if ([self.reuseIdentifier isEqualToString:@"one"]) {
        
        _view.frame = CGRectMake(0, 5, self.width, 35);
        _bottomBorder.frame = CGRectMake(0, _view.height-1, self.width, 1);
        _titleLabel.frame = CGRectMake(10, 0, _view.width-60, _view.height);
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        
        NSString *title = [_data objectForKey:@"title"];
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[_data objectForKey:@"date"] integerValue]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        NSString *datestr = [dateFormatter stringFromDate:date];
        _titleLabel.text = [NSString stringWithFormat:@"%@%@整体运行状态",datestr,title];
        
        _imageView.frame = CGRectMake(_view.width-40, (_view.height-20)/2, 20, 20);
        NSString *state = [_data objectForKey:@"state"];
        switch (state.intValue) {
            case 1:
                _imageView.image = [UIImage imageNamed:@"绿.png"];
                break;
                
            case 2:
                _imageView.image = [UIImage imageNamed:@"黄.png"];
                break;
                
            case 3:
                _imageView.image = [UIImage imageNamed:@"红.png"];
                break;
                
            default:
                break;
        }
        
    }
    else if ([self.reuseIdentifier isEqualToString:@"two"]) {
        
        NSArray *avgs = [_data objectForKey:@"data"];
        
        _titleLabel.frame = CGRectMake(10, 10, self.width-20, 15);
        _titleLabel.font = [UIFont systemFontOfSize:12];
        NSString *title = [_data objectForKey:@"title"];
        _titleLabel.text = [NSString stringWithFormat:@"%@平均值",title];
        
        if (_labels.count >0) {
            for (UILabel *label in _labels) {
                [label removeFromSuperview];
            }
        }
        
        [_labels removeAllObjects];
        
        NSInteger count;
        
        if (_isMore==NO) {
            if (avgs.count<=10) {
                count = avgs.count;
            }
            else {
                count = 10;
            }
        }
        else {
            count = avgs.count;
        }
        
        [self creatLabel:count];
        
    }
    else if ([self.reuseIdentifier isEqualToString:@"cell"]) {
        
        if (_lineView) {
            [_lineView removeFromSuperview];
        }
        
        _lineView = [[LineChartView alloc] initWithFrame:CGRectZero];
        [_view addSubview:_lineView];
        
        _view.frame = CGRectMake(0, 5, self.width, 157);
        _bottomBorder.frame = CGRectMake(0, _view.height-1, _view.width, 1);
        _titleLabel.frame = CGRectMake(0, 10, _view.width, 15);
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        //标题
        NSString *title = [_data objectForKey:@"title"];
        _titleLabel.text = title;
        
        _lineView.frame = CGRectMake(0, _titleLabel.bottom+5, _view.width, _view.height-_titleLabel.height-15);
        
        //点信息
        NSArray *lineDataAry = [_data objectForKey:@"data"];
        
        if (![lineDataAry isKindOfClass:[NSArray class]] || lineDataAry.count <= 0) {
            return;
        }
        
        NSMutableArray *hary = [[NSMutableArray alloc] init];
        NSMutableArray *vary = [[NSMutableArray alloc] init];
        NSMutableArray *pointary = [[NSMutableArray alloc] init];
        
        for (NSDictionary *dic in lineDataAry) {
            NSDate *xdate = [NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"x"] integerValue]];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm"];
            NSString *datestr = [formatter stringFromDate:xdate];
            float x = datestr.floatValue;
            float y = [[dic objectForKey:@"y"] floatValue];
            
            [hary addObject:datestr];
            [pointary addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
        }
        
        //y轴信息
        NSDictionary *ydic = [_data objectForKey:@"y_axis"];
        //最高
        NSInteger max = [[ydic objectForKey:@"max"] integerValue];
        //最低
        NSInteger min = [[ydic objectForKey:@"min"] integerValue];
        //长度
        NSInteger step = [[ydic objectForKey:@"step"] integerValue];
        //单位
        NSString *unit = [ydic objectForKey:@"title"];
        //警告线
        NSArray *marking = [ydic objectForKey:@"marking"];
        if ([marking isKindOfClass:[NSArray class]] && marking.count>0) {
            NSInteger yellow = [marking.firstObject integerValue];
            NSInteger red = [marking.lastObject integerValue];
            
            _lineView.yellow = yellow;
            _lineView.red = red;
        }
        
        
        for (int i=(int)min; i<=max; i+=step) {
            [vary addObject:[NSString stringWithFormat:@"%d",i]];
        }
        
        _lineView.min = min;
        _lineView.step = step;
        _lineView.yunit = unit;
        _lineView.vDesc = vary;
        _lineView.hDesc = hary;
        _lineView.array = pointary;
        
    }
    
}

- (void)creatLabel:(NSInteger)count{
    
    NSArray *avgs = [_data objectForKey:@"data"];
    
    for (int i=0; i<count; i++) {
        NSDictionary *dic = [avgs objectAtIndex:i];
        NSString *name = [dic objectForKey:@"name"];
        NSString *value = [dic objectForKey:@"value"];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth*66/320, (_titleLabel.bottom+5)+i*15, self.width-kScreenWidth*106/320, 15)];

        label.tag = i;
        label.font = [UIFont systemFontOfSize:12];
        label.text = [NSString stringWithFormat:@"%@：%@",name,value];
        [_labels addObject:label];
        [_view addSubview:label];
        
        if (i == count-1) {
            _view.frame = CGRectMake(0, 5, self.width, label.bottom+10);
            _bottomBorder.frame = CGRectMake(0, _view.height-1, _view.width, 1);
            if (avgs.count >10 && !_isMore) {
                _moreButton.frame = CGRectMake(_view.width-40, label.top, label.height, label.height);
                _moreButton.hidden = NO;
            }
        }
    }
}

- (void)moreAction {
    //NSArray *avgs = [_data objectForKey:@"data"];
    //[self creatLabel:avgs.count-10];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:StatisticsMore object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
