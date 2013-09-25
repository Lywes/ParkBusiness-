//
//  PBMutabeImageView.m
//  ParkBusiness
//
//  Created by 上海 on 13-7-1.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBMutabeImageView.h"
#define IMAGEWIDTH 60
#define BLANKWIDTH 10
@implementation PBMutabeImageView
@synthesize delegate;
@synthesize imageArr;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        imageArr = [[NSMutableArray alloc]init];
        [self initAddButton];
    }
    return self;
}
-(void)initAddButton{
    addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(5, 5, IMAGEWIDTH, IMAGEWIDTH);
    [addBtn addTarget:self  action:@selector(addImage) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setBackgroundImage:[UIImage imageNamed:@"addimage.png"] forState:UIControlStateNormal];
    [self addSubview:addBtn];
}
-(void)addImage{
    [delegate addImage];
}
-(void)goNextView:(UIButton*)sender{
    [delegate goNextView:sender.tag];
}
-(void)resetImageView{
    int rownum = isPad()?8:4;
    for (UIControl* subview in [self subviews]) {
        [subview removeFromSuperview];
    }
    CGFloat height = 5.0f;
    int j = 0;
    for (int i=0;i<[imageArr count];i++) {
        UIImage* image = [imageArr objectAtIndex:i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:image forState:UIControlStateNormal];
        btn.tag = i;
        btn.frame = CGRectMake(j*(IMAGEWIDTH+BLANKWIDTH)+BLANKWIDTH, height, IMAGEWIDTH, IMAGEWIDTH);
        [btn addTarget:self action:@selector(goNextView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        if ((i+1)%rownum==0) {
            j = 0;
            height += IMAGEWIDTH+5;
        }else{
            j++;
        }
        
    }
    if ([imageArr count]==8) {
        height -= IMAGEWIDTH+5;
    }else{
        [self initAddButton];
        addBtn.frame = CGRectMake(j*(IMAGEWIDTH+BLANKWIDTH)+BLANKWIDTH, height, IMAGEWIDTH, IMAGEWIDTH);
    }
    CGRect frame = self.frame;
    frame.size.height = height +IMAGEWIDTH + 5;
    self.frame = frame;
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
