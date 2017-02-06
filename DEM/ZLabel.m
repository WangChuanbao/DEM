//
//  ZLabel.m
//  CeShi
//
//  Created by 王宝 on 15/5/7.
//  Copyright (c) 2015年 王宝. All rights reserved.
//

#import "ZLabel.h"

@implementation ZLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/

-(id)initWithFrame:(CGRect)frame font:(UIFont *)font {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.lineBreakMode = NSLineBreakByWordWrapping;
        self.numberOfLines = 0;
        
        self.font = font;
        
    }
    
    return self;
}

- (void)setText:(NSString *)text {
    
    [super setText:text];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{NSFontAttributeName:self.font,NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize size = [self.text boundingRectWithSize:CGSizeMake(self.bounds.size.width, 999999) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    CGRect frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, size.height+self.zHeight);
    
    [self setFrame:frame];
    
}

@end
