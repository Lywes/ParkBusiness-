//
//  CustomImageView.m
//  ParkBusiness
//
//  Created by QDS on 13-4-1.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "CustomImageView.h"

@implementation CustomImageView
@synthesize imageView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat cornerRadius = 5.0;
        UIView *container = [[UIView alloc] initWithFrame:frame];
        container.layer.shadowOffset = CGSizeMake(0, 0);
        container.layer.shadowOpacity = 0.8;
        container.layer.shadowRadius = cornerRadius;
        container.layer.shadowColor = [UIColor grayColor].CGColor;
        container.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:container.bounds cornerRadius:cornerRadius] CGPath];
        self.imageView = [[AsyncImageView alloc]initWithFrame:container.bounds];
        self.imageView.image = [UIImage imageNamed:@"list_addfriend_icon.png"];
        self.imageView.layer.cornerRadius = cornerRadius;
        self.imageView.layer.masksToBounds = YES;
        [container addSubview:self.imageView];
        [self addSubview:container];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame withBackColor:(UIColor*)color
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat cornerRadius = 5.0;
        UIView *container = [[UIView alloc] initWithFrame:frame];
        container.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:container.bounds cornerRadius:cornerRadius] CGPath];
        container.backgroundColor = color;
        container.layer.shadowRadius = cornerRadius;
        container.layer.shadowColor = color.CGColor;
        container.layer.cornerRadius = cornerRadius;
        CGRect frames = container.bounds;
        int x = 3;
        frames.origin.x += x;
        frames.origin.y += x;
        frames.size.width -= 2*x;
        frames.size.height -= 2*x;
        self.imageView = [[AsyncImageView alloc]initWithFrame:frames];
        self.imageView.image = [UIImage imageNamed:@"list_addfriend_icon.png"];
        self.imageView.layer.cornerRadius = cornerRadius;
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.shadowOffset = CGSizeMake(0, 0);
        self.imageView.layer.shadowOpacity = 0.5;
        self.imageView.layer.shadowRadius = cornerRadius;
        self.imageView.layer.shadowColor = [UIColor grayColor].CGColor;
        [container addSubview:self.imageView];
        [self addSubview:container];
    }
    return self;
}
@end
