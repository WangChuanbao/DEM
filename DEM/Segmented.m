//
//  Segmented.m
//  CeShi
//
//  Created by 王宝 on 15/5/7.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "Segmented.h"

@implementation Segmented

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.color = [UIColor whiteColor];
        self.titleColorWithNormal = [UIColor blackColor];
        self.titleColorWithHighlighted = [UIColor blueColor];
        self.animateDuration = .3;
        self.labelColor = [UIColor blueColor];
        self.segmentCount = 2;
        self.font = [UIFont systemFontOfSize:12];
    }
    
    return self;
}

- (void)setArray:(NSArray *)array {
    
    if (_scrollView != nil) {
        [_scrollView removeFromSuperview];
    }
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    _scrollView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:_scrollView];
    
    float width = self.bounds.size.width/self.segmentCount;
    
    if ([array isKindOfClass:[NSArray class]] && array.count>0) {
        
        _scrollView.contentSize = CGSizeMake(width*array.count, 0);
        
        for (int i=0; i<array.count; i++) {
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(i*width+10,0, width-20, self.bounds.size.height*8/9)];
            
            if (i==0) {
                button.selected = YES;
                _send = button;
            }
            
            //button.backgroundColor = [UIColor whiteColor];
            button.backgroundColor = self.color;
            
            button.titleLabel.font = _font;
            
            button.titleLabel.adjustsFontSizeToFitWidth = YES;
            
            [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
            
            [button setTitle:[array objectAtIndex:i] forState:UIControlStateHighlighted];
            
            [button setTitleColor:self.titleColorWithNormal forState:UIControlStateNormal];
            
            [button setTitleColor:self.titleColorWithHighlighted forState:UIControlStateHighlighted];
            
            [button setTitleColor:self.titleColorWithHighlighted forState:UIControlStateSelected];
            
            button.tag = i;
            
            [button addTarget:self action:@selector(buttonSend:) forControlEvents:UIControlEventTouchUpInside];
            
            [_scrollView addSubview:button];
            
        }
        
        float labelHeight = self.bounds.size.height*1/9;
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-labelHeight, width, labelHeight)];
        
       // _label.backgroundColor = [UIColor blueColor];
        _label.backgroundColor = self.labelColor;
        
        [_scrollView addSubview:_label];
        
    }
    
}

- (void)setSelectedAtIndex:(NSInteger)selectedAtIndex {
    UIButton *button = (UIButton *)[self viewWithTag:selectedAtIndex];
    [self buttonSend:button];
}

- (void)buttonSend:(UIButton *)button {
    
    if (_send != button) {
        
        _send.selected = NO;
        _send = button;
        
        button.selected = YES;
        
        [UIView animateWithDuration:self.animateDuration animations:^{
            
            [_label setFrame:CGRectMake(button.frame.origin.x-10, self.bounds.size.height-self.bounds.size.height*1/9, button.bounds.size.width+20, self.bounds.size.height/9)];
            
        }];
        
    }
    
    //[self.delegate SegmentedDidSelectAtIndex:button.tag];
    [self.delegate Segmented:self DidSelectAtIndex:button.tag];
}

//改变偏移量
- (void)changeScrollAtIndex:(int)index {
    UIButton *button = (UIButton *)[self viewWithTag:index];
    float right = button.frame.size.width+button.frame.origin.x;
    if (right > kScreenWidth) {
        [_scrollView setContentOffset:CGPointMake(right-kScreenWidth, 0)];
    }
}

@end
