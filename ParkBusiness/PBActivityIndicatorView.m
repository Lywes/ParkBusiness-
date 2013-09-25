//
//  PBActivityIndicatorView.m
//  ParkBusiness
//
//  Created by lywes lee on 13-4-8.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBActivityIndicatorView.h"
#import <QuartzCore/QuartzCore.h>
@implementation PBActivityIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 160, 100)];
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        //实现圆角效果
        view.layer.cornerRadius = 5;
        view.layer.masksToBounds = YES;
        view.center = self.center;
        frame = view.frame;
        frame.origin.y -= 50;
        view.frame = frame;
        indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        indicator.frame = view.frame;
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, view.frame.size.height-25, view.frame.size.width, 20)];
        label.text = NSLocalizedString(@"WAITING", nil);
        label.textAlignment = UITextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        [view addSubview:label];
        [self addSubview:view];
        [self addSubview:indicator];
        [self stopAnimating];
    }
    return self;
}

-(void)setTitle:(NSString*)title{
    label.text = title;
}

-(void)startAnimating{//开始等待
    self.hidden = NO;
    [indicator startAnimating];
}

-(void)stopAnimating{//结束等待
    self.hidden = YES;
    [indicator stopAnimating];  
}

@end
