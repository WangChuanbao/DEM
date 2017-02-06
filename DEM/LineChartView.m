//
//  LineChartView.m
//  DrawDemo
//
//  Created by 东子 Adam on 12-5-31.
//  Copyright (c) 2012年 热频科技. All rights reserved.
//

#import "LineChartView.h"

@interface LineChartView()
{
    CALayer *linesLayer;
    
    
    UIView *popView;
    UILabel *disLabel;
}

@end

@implementation LineChartView

@synthesize array;

@synthesize hInterval,vInterval;

@synthesize hDesc,vDesc;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        linesLayer = [[CALayer alloc] init];
        linesLayer.masksToBounds = YES;
        linesLayer.contentsGravity = kCAGravityLeft;
        linesLayer.backgroundColor = [[UIColor whiteColor] CGColor];
        
        [self.layer addSublayer:linesLayer];
        
        //PopView
        popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        //[popView setBackgroundColor:[UIColor blackColor]];
        popView.backgroundColor = [UIColor yellowColor];
        [popView setAlpha:0.0f];
        
        disLabel = [[UILabel alloc]initWithFrame:popView.frame];
        disLabel.backgroundColor = [UIColor clearColor];
        [disLabel setTextAlignment:NSTextAlignmentCenter];
        
        [popView addSubview:disLabel];
        [self addSubview:popView];
    }
    return self;
}

#define ZeroPoint CGPointMake(30,460)

- (void)drawRect:(CGRect)rect
{
    [self setClearsContextBeforeDrawing: YES];
    
    if (array.count<=0) {
        return;
    }
    
    hInterval = (self.frame.size.width-30)/hDesc.count;
    vInterval = (self.frame.size.height-30-20)/vDesc.count;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //画背景线条------------------
    //CGColorRef backColorRef = [UIColor blackColor].CGColor;
    CGFloat backLineWidth = 1.f;
    //CGFloat backMiterLimit = 0.f;
    
    CGContextSetLineWidth(context, backLineWidth);//主线宽度
    //CGContextSetMiterLimit(context, backMiterLimit);//投影角度
    
    //CGContextSetShadowWithColor(context, CGSizeMake(3, 5), 8, backColorRef);//设置双条线
    
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    //CGContextSetLineCap(context, kCGLineCapRound );//设置线条终点形状
    CGContextSetLineCap(context, kCGLineCapButt);
    
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    
    int x = self.frame.size.width;
    int y = self.frame.size.height;
    
    //纵坐标单位
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 10, x-20, vInterval)];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:10];
    label.text = self.yunit;
    [self addSubview:label];
    
    //纵坐标
    for (int i=0; i<vDesc.count; i++) {
        
        CGPoint bPoint = CGPointMake(30, y);
        CGPoint ePoint = CGPointMake(x, y);
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [label setCenter:CGPointMake(bPoint.x-15, bPoint.y-30)];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor blackColor]];
        label.font = [UIFont systemFontOfSize:10];
        
        //NSString *text = [vDesc objectAtIndex:i];
            
        [label setText:[vDesc objectAtIndex:i]];
        [self addSubview:label];
            
        CGContextSetStrokeColorWithColor(context, RGBA(215, 229, 252, 1).CGColor);
        
        /*
        if (text.intValue == self.yellow) {
            CGContextSetStrokeColorWithColor(context, [UIColor yellowColor].CGColor);
        }
        else if (text.integerValue == self.red) {
            CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
        }
         */
            
        CGContextMoveToPoint(context, bPoint.x, bPoint.y-30);
        CGContextAddLineToPoint(context, ePoint.x, ePoint.y-30);
            
        CGContextStrokePath(context);
            
        y -= vInterval;
        
    }
    
    //横坐标
    int j = 0;  //记录显示的横坐标
    int j_stem = (int)array.count/5; //横坐标步长
    for (int i=0; i<array.count; i++) {
        //UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i*vInterval+30, self.bounds.size.height-30, 40, 30)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i*hInterval+30, self.bounds.size.height-30, self.bounds.size.width-30, 30)];
        [label setTextAlignment:NSTextAlignmentLeft];
        [label setBackgroundColor:[UIColor clearColor]];
        if (i == j) {
            [label setTextColor:[UIColor blackColor]];
            label.numberOfLines = 1;
            label.adjustsFontSizeToFitWidth = YES;
            //label.minimumScaleFactor = 1.0f;
            label.font = [UIFont systemFontOfSize:10];
            [label setText:[hDesc objectAtIndex:i]];
            j += j_stem;
        }
        [self addSubview:label];
    }
    
//    //画点线条------------------
    CGContextRef context1 = UIGraphicsGetCurrentContext();
    
    //CGColorRef pointColorRef = [UIColor colorWithRed:24.0f/255.0f green:116.0f/255.0f blue:205.0f/255.0f alpha:1.0].CGColor;
    CGFloat pointLineWidth = 1.f;
    
    CGContextSetLineWidth(context, pointLineWidth);//主线宽度
    
    CGContextSetLineJoin(context1, kCGLineJoinRound);
    
    CGContextSetLineCap(context1, kCGLineCapRound );
    
    CGContextSetBlendMode(context1, kCGBlendModeNormal);
    
    //设置线条颜色
    CGContextSetStrokeColorWithColor(context1, RGBA(54, 125, 242, 1).CGColor);

	//绘图
    CGPoint p1 = [[array objectAtIndex:0] CGPointValue];
    CGContextMoveToPoint(context1, 30, (self.frame.size.height-30)-(p1.y-self.min)*vInterval/_step);
	for (int i=1; i<[array count]; i++)
	{
		p1 = [[array objectAtIndex:i] CGPointValue];
        CGPoint goPoint = CGPointMake(i*hInterval+30, (self.frame.size.height-30)-(p1.y-self.min)*vInterval/_step);
        //直线
		CGContextAddLineToPoint(context1, goPoint.x, goPoint.y);
        
        //添加触摸点
        /*
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        bt.userInteractionEnabled = NO;
        
        [bt setBackgroundColor:[UIColor redColor]];
        bt.backgroundColor = [UIColor clearColor];
        
        [bt setFrame:CGRectMake(0, 0, 10, 10)];
        
        [bt setCenter:goPoint];
        
        [bt addTarget:self 
               action:@selector(btAction:) 
     forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:bt];
         */
	}
	CGContextStrokePath(context1);
    
}

- (void)btAction:(id)sender{
    [disLabel setText:@"100"];
    
    UIButton *bt = (UIButton*)sender;
    popView.center = CGPointMake(bt.center.x, bt.center.y - popView.frame.size.height/2);
    [popView setAlpha:1.0f];
}

@end
