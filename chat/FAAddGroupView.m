//
//  FAAddGroupView.m
//  ParkBusiness
//
//  Created by lywes lee on 13-4-12.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "FAAddGroupView.h"
#import <QuartzCore/QuartzCore.h>
#import "FAFriendGroupData.h"
@implementation FAAddGroupView
@synthesize delegate;
@synthesize groupLabel;
@synthesize labelView;
@synthesize groupText;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        groupLabel = [[UILabel alloc]initWithFrame:CGRectMake(80,10, 80, 20)];
        groupLabel.text = @"新分组";
        groupLabel.textAlignment = UITextAlignmentCenter;
        groupLabel.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        labelView = [[UIView alloc]initWithFrame:CGRectMake(isPad()?250:30, 50-self.frame.size.height, 260, 140)];
        labelView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"addgroup.png"]];
        labelView.layer.shadowOffset = CGSizeMake(10, 10);
        labelView.layer.shadowOpacity = 0.8;
        labelView.layer.shadowRadius = 3;
        labelView.layer.shadowColor = [UIColor grayColor].CGColor;
        groupText = [[UITextField alloc]initWithFrame:CGRectMake(10, 40, 240, 30)];
        groupText.borderStyle = UITextBorderStyleRoundedRect;
        groupText.placeholder = @"分组名称";
        UIButton* cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        UIButton* submitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [cancelBtn setTitle:NSLocalizedString(@"nav_btn_qx", nil) forState:UIControlStateNormal];
        [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(addGroupViewWillHidden) forControlEvents:UIControlEventTouchUpInside];
        [submitBtn addTarget:self action:@selector(submitDidPush) forControlEvents:UIControlEventTouchUpInside];
        cancelBtn.frame = CGRectMake(30, 90, 80, 30);
        submitBtn.frame = CGRectMake(150, 90, 80, 30);
        [labelView addSubview:groupLabel];
        [labelView addSubview:groupText];
        [labelView addSubview:cancelBtn];
        [labelView addSubview:submitBtn];
        [self addSubview:labelView];
        self.hidden = YES;

    }
    return self;
}

-(void)submitDidPush{
    if (groupText.text.length>0) {
        if ([delegate submitDidPushWithName:groupText.text]){
            [self addGroupViewWillHidden];
        }
    }else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入名称。"  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}
-(void)addGroupViewWillHidden{
    labelView.frame = CGRectMake(isPad()?250:30, 50-self.frame.size.height, 260, 140);
    self.hidden = YES;
    [groupText resignFirstResponder];
}
-(void)addGroupViewWillShow{
    self.hidden = NO;
    groupText.text = @"";
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    labelView.frame = CGRectMake(isPad()?250:30, isPad()?200:50, 260, 140);
    [UIView commitAnimations];
    [groupText becomeFirstResponder];
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
