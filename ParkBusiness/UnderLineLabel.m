//
//  UnderLineLabel.m
//  ParkBusiness
//
//  Created by 上海 on 13-8-26.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "UnderLineLabel.h"

@implementation UnderLineLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGSize fontsize = [self.text sizeWithFont:self.font forWidth:self.bounds.size.width lineBreakMode:UILineBreakModeTailTruncation];
//    const float* colors = CGColorGetComponents([UIColor blackColor].CGColor);
    CGContextSetRGBStrokeColor(ctx, 0, 0, 0, 1.0f);
    CGContextSetLineWidth(ctx, 1.0f);
    CGPoint l = CGPointMake(fontsize.width/3.0,self.frame.size.height/2.0+fontsize.height/2.0);
    CGPoint r = CGPointMake(fontsize.width, self.frame.size.height/2.0+fontsize.height/2.0);
    CGContextMoveToPoint(ctx, l.x, l.y);
    CGContextAddLineToPoint(ctx, r.x, r.y);
    CGContextStrokePath(ctx);
    [super drawRect:rect];
}


@end
