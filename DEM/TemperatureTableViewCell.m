//
//  TemperatureTableViewCell.m
//  DEM
//
//  Created by 王宝 on 15/5/20.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "TemperatureTableViewCell.h"
#import "UIViewExt.h"
#import "ZLabel.h"
#import "UIImageView+WebCache.h"
#import "LineChartView.h"
#import "ManageViewController.h"

@implementation TemperatureTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _margin = (kScreenHeight-64)*5/504;
        _isTwoLevel = NO;
        _segment2dArray = [[NSArray alloc] init];
        _titleLabels = [[NSMutableArray alloc] init];
        _labels = [[NSMutableArray alloc] init];
        self.backgroundColor = RGBA(237, 237, 237, 1);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark 整体运行状态
- (void)setAllState {
    //数据
    NSDictionary *warning = [self.data objectForKey:@"warning"];
    NSString *state = [warning objectForKey:@"state"];
    
    //视图
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, (kScreenHeight-64)*5/504, kScreenWidth, (kScreenHeight-64)*35/504)];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    
    CALayer *topBorder = [CALayer layer];
    //topBorder.frame = CGRectMake(0, (kScreenHeight-64)*5/504, kScreenWidth, 1);
    topBorder.frame = CGRectMake(0, 0, kScreenWidth, 1);
    topBorder.backgroundColor = RGBA(203, 203, 203, 1).CGColor;
    [view.layer addSublayer:topBorder];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0, view.height-1, kScreenWidth, 1);
    bottomBorder.backgroundColor = RGBA(203, 203, 203, 1).CGColor;
    [view.layer addSublayer:bottomBorder];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 95, view.height-20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:14];
    label.text = @"整体运行状态";
    [view addSubview:label];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(view.width-kScreenWidth*20/320-20, (view.height-20)/2, 20, 20)];
    
    //根据状态选择显示的图片
    if ([state isEqualToString:@""] || state == NULL) {
        imageView.image = [UIImage imageNamed:@"绿灯.png"];
    }
    switch (state.intValue) {
        case 1:
        {
            imageView.image = [UIImage imageNamed:@"绿灯.png"];
        }
            break;
            
        case 2:
        {
            imageView.image = [UIImage imageNamed:@"黄灯.png"];
        }
            break;
            
        case 3:
        {
            imageView.image = [UIImage imageNamed:@"红灯.png"];
        }
            break;
            
        default:
            break;
    }
    
    [view addSubview:imageView];
}

#pragma mark 关键指标
- (void)setKeyIndex {
    //数据
    NSArray *toplist = [self.data objectForKey:@"top_list"];
    
    if (![toplist isKindOfClass:[NSArray class]] || [toplist isEqual:@""]) {
        return;
    }
    
    float labelTop = 0.0;   //关键指标label的y坐标
    
    //存储二级label显示数据，如果数据为一级则存储toplist，如果数据为二级，则存储toplist下child
    NSArray *array = [NSArray arrayWithArray:toplist];
    
    NSArray *child = [toplist.firstObject objectForKey:@"child"];
    
    //视图
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, _margin, kScreenWidth, (kScreenHeight-64)*59/504)];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    
    //二级数据时显示的界面
    if ([child isKindOfClass:[NSArray class]] && child.count>0) {
        
        array = child;
        
        NSMutableArray *ary = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in toplist) {
            NSString *title = [dic objectForKey:@"name"];
            [ary addObject:title];
        }
        
        Segmented *segment = [[Segmented alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (kScreenHeight-64)*44/504)];
        segment.tag = 1000;
        segment.titleColorWithHighlighted = RGBA(54, 125, 242, 1);
        segment.labelColor = RGBA(54, 125, 242, 1);
        if (ary.count>3) {
            segment.segmentCount = 3;
        }
        else{
            segment.segmentCount = (int)ary.count;
        }
        segment.delegate = self;
        segment.array = ary;
        [view addSubview:segment];
        
        CALayer *bottomBorder = [CALayer layer];
        bottomBorder.frame = CGRectMake(0, segment.height-0.5, segment.width, 0.5);
        bottomBorder.backgroundColor = RGBA(44, 96, 182, 1).CGColor;
        [segment.layer addSublayer:bottomBorder];
        
        labelTop = segment.bottom;
        
    }
    
    //一级数据时显示的界面
    for (int i=0; i<3; i++) {
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/3*i, labelTop+10, kScreenWidth/3, (view.height-20)/2)];
        titleLabel.hidden = YES;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:12];
        [view addSubview:titleLabel];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(titleLabel.left, titleLabel.bottom, titleLabel.width, titleLabel.height)];
        label.hidden = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10];
        
        [view addSubview:label];
        
        if (i<array.count) {
            NSDictionary *dic = [array objectAtIndex:i];
            titleLabel.text = [dic objectForKey:@"name"];
            titleLabel.hidden = NO;
            label.text = [dic objectForKey:@"value"];
            label.hidden = NO;
        }
        
        [_titleLabels addObject:titleLabel];
        [_labels addObject:label];
    }
    
    [view setFrame:CGRectMake(view.left, view.top, view.width, view.height+labelTop)];
    
    CALayer *topBorder = [CALayer layer];
    topBorder.backgroundColor = RGBA(44, 96, 182, 1).CGColor;
    topBorder.frame = CGRectMake(0, 0, view.width, 0.5);
    [view.layer addSublayer:topBorder];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.backgroundColor = RGBA(44, 96, 182, 1).CGColor;
    bottomBorder.frame = CGRectMake(0, view.height-0.5, view.width, 0.5);
    [view.layer addSublayer:bottomBorder];
    
}

#pragma mark 告警
- (void)setWarning {
    _room_id = @"";
    
    //数据
    NSDictionary *dic = [self.data objectForKey:@"warning"];
    NSString *state = [dic objectForKey:@"state"];
    
    if ([[dic objectForKey:@"title"] isEqualToString:@""] || state.intValue == 1) {
        return;
    }
    
    //视图
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];
    
    //告警信息
    ZLabel *laebl = [[ZLabel alloc] initWithFrame:CGRectMake(kScreenWidth*10/320, _margin*4, kScreenWidth-kScreenWidth*30/320, 0) font:[UIFont systemFontOfSize:12]];
    laebl.text = [dic objectForKey:@"title"];
    laebl.textColor = RGBA(221, 18, 18, 1);
    [view addSubview:laebl];
    
    //处理按钮
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-kScreenWidth*80/320, laebl.bottom+5, kScreenWidth*60/320, _margin*4)];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    button.backgroundColor = RGBA(54, 125, 242, 1);
    [button setTitle:@"处理" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    [view setFrame:CGRectMake(0, _margin, kScreenWidth, _margin*8+laebl.height+10)];
    
    _room_id = [dic objectForKey:@"room_id"];
}

+ (float)warningHeight:(NSString *)title {
    
    float margin = (kScreenHeight-64)*5/504;
    
    ZLabel *laebl = [[ZLabel alloc] initWithFrame:CGRectMake(kScreenWidth*10/320, margin*4, kScreenWidth-kScreenWidth*30/320, 0) font:[UIFont systemFontOfSize:12]];
    laebl.text = title;
    
    return margin*8+laebl.height+15;
}

#pragma mark 所有指标
- (void)setSegmented {
    
    //数据
    NSMutableArray *ary = [[NSMutableArray alloc] init];
    
    NSArray *list = [self.data objectForKey:@"list"];
    
    if (![list isKindOfClass:[NSArray class]] || list.count <= 0) {
        return;
    }
    NSArray *child = [[list firstObject] objectForKey:@"child"];
    
    for (NSDictionary *dic in list) {
        NSString *title = [dic objectForKey:@"name"];
        [ary addObject:title];
    }
    
    //视图
    _segment = [[Segmented alloc] initWithFrame:CGRectMake(0, _margin, kScreenWidth, (kScreenHeight-64)*44/504)];
    _segment.tag = 100;
    _segment.titleColorWithHighlighted = RGBA(54, 125, 242, 1);
    _segment.labelColor = RGBA(54, 125, 242, 1);
    if (ary.count > 3) {
        _segment.segmentCount = 3;
    }
    else{
        _segment.segmentCount = (int)ary.count;
    }
    _segment.delegate = self;
    _segment.array = ary;
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0, 0, _segment.width, 0.5);
    topBorder.backgroundColor = RGBA(44, 96, 182, 1).CGColor;
    [_segment.layer addSublayer:topBorder];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0, _segment.height-0.5, _segment.width, 0.5);
    bottomBorder.backgroundColor = RGBA(44, 96, 182, 1).CGColor;
    [_segment.layer addSublayer:bottomBorder];
    
    [self addSubview:_segment];
    
    if ([child isKindOfClass:[NSArray class]] && child.count>0) {
        _isTwoLevel = YES;
        
        _segment2dArray = child;
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in child) {
            NSString *title = [dic objectForKey:@"name"];
            [array addObject:title];
        }
        
        _segment2d = [[Segmented alloc] initWithFrame:CGRectMake(0, _segment.bottom, _segment.width, (kScreenHeight-64)*30/504)];
        _segment2d.tag = 200;
        _segment2d.titleColorWithHighlighted = RGBA(54, 125, 242, 1);
        _segment2d.labelColor = RGBA(54, 125, 242, 1);
        _segment2d.segmentCount = 4;
        _segment2d.delegate = self;
        _segment2d.font = [UIFont systemFontOfSize:11];
        _segment2d.array = array;
        
        [self addSubview:_segment2d];
    }
}

#pragma mark 图标
- (void)setChart {
    //数据
    NSString *url = @"";
    NSString *title = @"";
    
    NSDictionary *dic = [self.data objectForKey:@"icon"];
    if ([dic isKindOfClass:[NSDictionary class]] && dic.allKeys > 0) {
        url = [dic objectForKey:@"url"];
        NSArray *titles = [dic objectForKey:@"title"];
        
        //NSString *title = @"";
        for (int i=0; i<titles.count; i++) {
            title = [title stringByAppendingString:[NSString stringWithFormat:@"\n%@\n",[titles objectAtIndex:i]]];
        }
    }
    
    //视图
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, _margin, kScreenWidth, (kScreenHeight-64)*150/504)];
    view.backgroundColor = [UIColor whiteColor];
    [self addSubview:view];

    CALayer *topBorder = [CALayer layer];
    //topBorder.frame = CGRectMake(0, (kScreenHeight-64)*5/504, kScreenWidth, 1);
    topBorder.frame = CGRectMake(0, 0, kScreenWidth, 1);
    topBorder.backgroundColor = RGBA(203, 203, 203, 1).CGColor;
    [view.layer addSublayer:topBorder];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0, view.height-1, kScreenWidth, 1);
    bottomBorder.backgroundColor = RGBA(203, 203, 203, 1).CGColor;
    [view.layer addSublayer:bottomBorder];
    
    //图像
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/2, view.height)];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.backgroundColor = [UIColor clearColor];
    [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
    [view addSubview:imageView];
    
    //采样信息
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right, 0, imageView.width, imageView.height)];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:12];
    label.text = title;
    [view addSubview:label];
    
}

#pragma mark 折线图
- (void)setLineChart {
    //y轴
    NSMutableArray *vary = [[NSMutableArray alloc] init];
    //x轴
    NSMutableArray *hary = [[NSMutableArray alloc] init];
    //point
    NSMutableArray *pointary = [[NSMutableArray alloc] init];
    NSInteger _step = 0;
    NSInteger _max = 0;
    NSInteger _min = 0;
    NSString *yunit = @"";
    NSInteger _yellow;
    NSInteger _red;
    
    NSArray *lines = [self.data objectForKey:@"line"];
    if (![lines isKindOfClass:[NSArray class]] || lines.count <= 0) {
        return;
    }
    
    for (NSDictionary *line in lines) {
        //点信息
        NSArray *lineDataAry = [line objectForKey:@"data"];
        
        if (![lineDataAry isKindOfClass:[NSArray class]] || lineDataAry.count <= 0) {
            return;
        }
        
        for (NSDictionary *dic in lineDataAry) {
            NSDate *xdate = [NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"x"] integerValue]];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm"];
            //[formatter setDateFormat:@"yyyy-MM-dd hh:mm"];
            NSString *datestr = [formatter stringFromDate:xdate];
            float x = datestr.floatValue;
            float y = [[dic objectForKey:@"y"] floatValue];
            //NSLog(@"data = %@",datestr);
            [hary addObject:datestr];
            [pointary addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
        }
        
        //y轴信息
        NSDictionary *ydic = [line objectForKey:@"y_axis"];
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
            
            _yellow = yellow;
            _red = red;
        }
        
        _step = step;
        _max = max;
        _min = min;
        yunit = unit;
        
        for (int i=(int)min; i<=max; i+=step) {
            [vary addObject:[NSString stringWithFormat:@"%d",i]];
        }
        
    }
    
    LineChartView *view = [[LineChartView alloc] initWithFrame:CGRectMake(0, _margin, kScreenWidth, (kScreenHeight-64)*175/504)];
    view.yellow = _yellow;
    view.red = _red;
    [view setMin:_min];
    [view setStep:_step];
    [view setYunit:yunit];
    [view setVDesc:vary];
    [view setHDesc:hary];
    [view setArray:pointary];
    
    CALayer *topBorder = [CALayer layer];
    topBorder.frame = CGRectMake(0, 0, kScreenWidth, 1);
    topBorder.backgroundColor = RGBA(203, 203, 203, 1).CGColor;
    [view.layer addSublayer:topBorder];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0, view.height-1, kScreenWidth, 1);
    bottomBorder.backgroundColor = RGBA(203, 203, 203, 1).CGColor;
    [view.layer addSublayer:bottomBorder];
    
    [self addSubview:view];
    
}

//检查是否有报警，有则更细视图显示报警指标
- (BOOL)CheckWarning:(NSArray *)array{
    //获取报警的指标
    NSDictionary *warning = [self.data objectForKey:@"warning"];
    NSString *state = [warning objectForKey:@"state"];
    if ([state isEqualToString:@""] || [state isEqualToString:@"1"] || state.intValue == 1) {
        return NO;
    }
    NSString *warsid = [warning objectForKey:@"id"];
    NSString *warparent_id = [warning objectForKey:@"parent_id"];
    
    NSArray *child = [[array firstObject] objectForKey:@"child"];
    
    if ([child isKindOfClass:[NSArray class]] && child.count>0) {
        for (int i=0; i<array.count; i++) {
            NSDictionary *dic = [array objectAtIndex:i];
            NSString *parent_id = [dic objectForKey:@"id"];
            if ([warparent_id isEqualToString:parent_id]) {
                if (i != 0) {
                    _segment.selectedAtIndex = i;
                    [_segment changeScrollAtIndex:i];
                }
            }
        }
    }
    else {
        for (int i=0; i<array.count; i++) {
            NSDictionary *dic = [array objectAtIndex:i];
            NSString *parent_id = [dic objectForKey:@"id"];
            if ([warsid isEqualToString:parent_id]) {
                if (i != 0) {
                    if (_segment2d == nil) {
                        _segment.selectedAtIndex = i;
                        [_segment changeScrollAtIndex:i];
                    }
                    else {
                        _segment2d.selectedAtIndex = i;
                        [_segment2d changeScrollAtIndex:i];
                    }
                }
            }
        }
    }
    return YES;
}

//处理按钮点击方法
- (void)buttonAction:(UIButton *)send {
    ManageViewController *manageVC = [[ManageViewController alloc] init];
    manageVC.room_id = _room_id;
    [self.nav pushViewController:manageVC animated:YES];
}

#pragma mark segmentedDelegate
- (void)Segmented:(Segmented *)segmented DidSelectAtIndex:(NSInteger)index {
    if (segmented.tag == 1000) {
        NSArray *toplist = [self.data objectForKey:@"top_list"];
        NSLog(@"++   %@",toplist);
        NSArray *child = [[toplist objectAtIndex:index] objectForKey:@"child"];
        for (int i=0; i<3; i++) {
            UILabel *titleLabel = [_titleLabels objectAtIndex:i];
            UILabel *label = [_labels objectAtIndex:i];
            
            if (i<child.count) {
                NSDictionary *dic = [child objectAtIndex:i];
                titleLabel.text = [dic objectForKey:@"name"];
                titleLabel.hidden = NO;
                label.text = [dic objectForKey:@"value"];
                label.hidden = NO;
            }
            else {
                titleLabel.hidden = YES;
                label.hidden = YES;
            }
        }
        
        return;
    }

    /************************  下面是所有指标操作  ****************************************/
    
    if (_isTwoLevel == NO) {
        NSArray *list = [self.data objectForKey:@"list"];
        NSDictionary *dic = [list objectAtIndex:index];
        NSString *segmentid = [dic objectForKey:@"id"];
        [self.delegate detailSegmentSelectedForId:segmentid];
    }
    else {
        if (segmented.tag == 100) {
            [self reloadSegment2d:index];
            
            BOOL isWarning = [self CheckWarning:_segment2dArray];
            
            if (isWarning == NO) {
                NSDictionary *dic = [_segment2dArray firstObject];
                NSString *segmentid = [dic objectForKey:@"id"];
                [self.delegate detailSegmentSelectedForId:segmentid];
            }
            
        }
        else if (segmented.tag == 200) {
            NSDictionary *dic = [_segment2dArray objectAtIndex:index];
            NSString *segmentid = [dic objectForKey:@"id"];
            [self.delegate detailSegmentSelectedForId:segmentid];
        }
    }
}

- (void)reloadSegment2d:(NSInteger)index {
    NSArray *list = [self.data objectForKey:@"list"];
    NSDictionary *dic = [list objectAtIndex:index];
    NSArray *child = [dic objectForKey:@"child"];
    _segment2dArray = child;
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in child) {
        NSString *title = [dic objectForKey:@"name"];
        [array addObject:title];
    }
    _segment2d.array = array;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
