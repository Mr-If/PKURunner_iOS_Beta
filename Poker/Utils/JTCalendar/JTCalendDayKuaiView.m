//
//  JTCalendDayKuaiView.m
//  PKU
//
//  Created by ironfive on 16/8/11.
//  Copyright © 2016年 ironfive. All rights reserved.
//

#import "JTCalendDayKuaiView.h"

@implementation JTCalendDayKuaiView
- (instancetype)init
{
    self = [super init];
    if(!self){
        return nil;
    }
    
    self.backgroundColor = [UIColor clearColor];
    self.color = [UIColor whiteColor];
    
    return self;
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    CGContextAddRect(ctx, rect);
    CGContextSetFillColorWithColor(ctx, _color.CGColor);
    CGContextFillPath(ctx);
}

- (void)setColor:(UIColor *)color
{
    self->_color = color;
    
    [self setNeedsDisplay];
}

@end
