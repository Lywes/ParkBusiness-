//
//  PBMessageToolBar.h
//  ParkBusiness
//
//  Created by QDS on 13-5-13.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIExpandingTextView.h"

@protocol UIInputToolbarDelegate <NSObject>
@optional
-(void)inputButtonPressed:(NSString *)inputText;
@end

@interface PBMessageToolBar : UIToolbar <UIExpandingTextViewDelegate>
{
    UIExpandingTextView *textView;
    UIBarButtonItem *inputButton;
    UIBarButtonItem *cancelButton;
    NSObject <UIInputToolbarDelegate> *delegate;
}
- (void)drawRect:(CGRect)rect;
- (void)keyboardWillHide;
@property (nonatomic, retain) UIExpandingTextView *textView;
@property (nonatomic, retain) UIBarButtonItem *inputButton;
@property (nonatomic, retain) UIBarButtonItem *cancelButton;
@property (assign) NSObject<UIInputToolbarDelegate> *delegate;

@end