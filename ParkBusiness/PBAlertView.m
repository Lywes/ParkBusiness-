//
//  PBAlertView.m
//  ParkBusiness
//
//  Created by 上海 on 13-8-11.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBAlertView.h"

@implementation PBAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(id)initWithMessage:(NSString*)message{
    
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [self initWithFrame:keywindow.frame];
    view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 160, 100)];
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    //实现圆角效果
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
    view.center = self.center;
    CGRect frame = view.bounds;
    label = [[UILabel alloc]initWithFrame:frame];
    label.text = message;
    label.numberOfLines = 0;
    label.textAlignment = UITextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    [view addSubview:label];
    [self addSubview:view];
    self.transform = CGAffineTransformIdentity;
    self.alpha = 0;
    [keywindow addSubview:self];
    return self;
}
-(void)show{
    if([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown){
        self.transform = CGAffineTransformMakeRotation(180.0*(M_PI/180.0));
    }
    
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
//        self.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished){
        if (finished) {
            [self performSelector:@selector(dismiss) withObject:nil afterDelay:1];
        }
    }];
}
-(void)dismiss{
    [UIView animateWithDuration:.35 animations:^{
//        self.transform = CGAffineTransformIdentity;
        //CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
