//
//  MoveButton.m
//  CustomButton
//
//  Created by lywes on 13-8-24.
//  Copyright (c) 2013年 lywes. All rights reserved.
//

#import "MoveButton.h"
#import "FAMessageData.h"
@implementation MoveButton
@synthesize delegate;
-(void)dealloc{
    [super dealloc];
    [countBtn release];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        canMove = NO;
    }
    return self;
}
-(void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state{
    [super setBackgroundImage:image forState:state];
    countBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [countBtn setBackgroundImage:[UIImage imageNamed:@"info_unread"] forState:UIControlStateDisabled];
    countBtn.enabled = NO;
    UIView* superView = self.superview;
    countBtn.frame = CGRectMake(0, 0, 25, 25);
    countBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    countBtn.center = CGPointMake(self.frame.origin.x+self.frame.size.width, self.frame.origin.y);
    [self setTitleWithUnreadCount];
    [superView addSubview:countBtn];
}
-(void)setTitleWithUnreadCount{
    NSMutableArray* allData = [FAMessageData getUnreadDialog];
    int count = 0;
    for (FAMessageData* data in allData) {
        count += data.count;
    }
    if (count>0) {
        [countBtn setTitle:[NSString stringWithFormat:@"%d",count] forState:UIControlStateDisabled];
    }else{
        countBtn.hidden = YES;
    }

}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    canMove = YES;
    self.center = [[touches anyObject] locationInView:self.superview];
    CGRect frame = self.frame;
    if(frame.origin.y < 0){
        frame.origin.y = 0;
    }else if(frame.origin.y > self.superview.frame.size.height-frame.size.height){
        frame.origin.y = self.superview.frame.size.height-frame.size.height;
    }
    self.frame = frame;
    countBtn.center = CGPointMake(frame.origin.x+frame.size.width, frame.origin.y);
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    if (canMove) {
        CGPoint center = self.center;
        CGFloat x = self.superview.frame.size.width/2;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.3];
        CGRect frame = self.frame;
        if (center.x<=x) {
            frame.origin.x = 0;
            countBtn.center = CGPointMake(frame.origin.x+frame.size.width, frame.origin.y);
        }else if(center.x>x){
            frame.origin.x = 2*x-frame.size.width;
            countBtn.center = CGPointMake(frame.origin.x, frame.origin.y);
        }
        self.frame = frame;
        [UIView commitAnimations];
        canMove = NO;
    }else{
        [delegate touchUpInside:self];
    }
    [self setHighlighted:NO];
}
-(void)getMinSizewithX:(CGFloat)x withY:(CGFloat)y{
    
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
