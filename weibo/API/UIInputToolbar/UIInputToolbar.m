/*
 *  UIInputToolbar.m
 *  
 *  Created by Brandon Hamilton on 2011/05/03.
 *  Copyright 2011 Brandon Hamilton.
 *  
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *  
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *  
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 */

#import "UIInputToolbar.h"
#define kStatusBarHeight 20
#define kDefaultToolbarHeight 40
#define kKeyboardHeightPortrait 216
#define kKeyboardHeightPortrait_pad 352
#define kKeyboardHeightLandscape 140
#define kKeyboardHeightLandscape_pad 264
@implementation UIInputToolbar

@synthesize textView;
@synthesize inputButton;
@synthesize delegate;
@synthesize cancelButton;

-(void)inputButtonPressed
{
    if ([delegate respondsToSelector:@selector(inputButtonPressed:)]) 
    {
        [delegate inputButtonPressed:self.textView.text];
    }
    
    /* Remove the keyboard and clear the text */
    [self keyboardWillHide];
}


-(void)setupToolbar
{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    self.tintColor = [UIColor lightGrayColor];
    UIButton* input = [self customBarButton:@"发送"];
    input.titleLabel.font   = [UIFont boldSystemFontOfSize:15.0f];
    [input addTarget:self action:@selector(inputButtonPressed) forControlEvents:UIControlEventTouchDown];
    self.inputButton = [[UIBarButtonItem alloc] initWithCustomView:input];
    self.inputButton.customView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    /* Disable button initially */
    self.inputButton.enabled = NO;
    UIButton* cancel = [self customBarButton:NSLocalizedString(@"nav_btn_qx", nil)];
    cancel.titleLabel.font   = [UIFont boldSystemFontOfSize:10.0f];
    [cancel addTarget:self action:@selector(keyboardWillHide) forControlEvents:UIControlEventTouchDown];
    self.cancelButton = [[UIBarButtonItem alloc] initWithCustomView:cancel];
    CGRect frame = self.cancelButton.customView.frame;
    frame.size.width = 35;
    self.cancelButton.customView.frame = frame;
    self.cancelButton.customView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    /* Disable button initially */
    self.cancelButton.enabled = YES;

    /* Create UIExpandingTextView input */
    self.textView = [[UIExpandingTextView alloc] initWithFrame:CGRectMake(53, 7, isPad()?630:190, 26)];
    self.textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(4.0f, 0.0f, 10.0f, 0.0f);
    self.textView.delegate = self;
    [self addSubview:self.textView];
    
    /* Right align the toolbar button */
    UIBarButtonItem *flexItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    
    NSArray *items = [NSArray arrayWithObjects: self.cancelButton,flexItem, self.inputButton, nil];
    [self setItems:items animated:NO];
}

-(UIButton*)customBarButton:(NSString *)buttonLabel{
    /* Create custom send button*/
    UIImage *buttonImage = [UIImage imageNamed:@"buttonbg.png"];
    buttonImage          = [buttonImage stretchableImageWithLeftCapWidth:floorf(buttonImage.size.width/2) topCapHeight:floorf(buttonImage.size.height/2)];
    
    UIButton *button               = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.shadowOffset = CGSizeMake(0, -1);
    button.titleEdgeInsets         = UIEdgeInsetsMake(0, 2, 0, 2);
    button.contentStretch          = CGRectMake(0.5, 0.5, 0, 0);
    button.contentMode             = UIViewContentModeScaleToFill;
    
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setTitle:buttonLabel forState:UIControlStateNormal];
    [button sizeToFit];
    return button;
}

-(id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self setupToolbar];
    }
    return self;
}

-(id)init
{
    if ((self = [super init])) {
        [self setupToolbar];
    }
    return self;
}

- (void)drawRect:(CGRect)rect 
{
    /* Draw custon toolbar background */
    UIImage *backgroundImage = [UIImage imageNamed:@"toolbarbg.png"];
    backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:floorf(backgroundImage.size.width/2) topCapHeight:floorf(backgroundImage.size.height/2)];
    [backgroundImage drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    CGRect i = self.inputButton.customView.frame;
    i.origin.y = self.frame.size.height - i.size.height - 7;
    self.inputButton.customView.frame = i;
    CGRect j = self.cancelButton.customView.frame;
    j.origin.y = self.frame.size.height - j.size.height - 7;
    self.cancelButton.customView.frame = j;
}

- (void)dealloc
{
    [textView release];
    [inputButton release];
    [super dealloc];
}


#pragma mark -
#pragma mark UIExpandingTextView delegate

-(void)expandingTextView:(UIExpandingTextView *)expandingTextView willChangeHeight:(float)height
{
    /* Adjust the height of the toolbar when the input component expands */
    float diff = (textView.frame.size.height - height);
    CGRect r = self.frame;
    r.origin.y += diff;
    r.size.height -= diff;
    self.frame = r;
}

-(void)expandingTextViewDidChange:(UIExpandingTextView *)expandingTextView
{
    /* Enable/Disable the button */
    if ([expandingTextView.text length] > 0)
        self.inputButton.enabled = YES;
    else
        self.inputButton.enabled = NO;
}

#pragma mark Notifications

//添加键盘观察者
-(void)addObserverFromController:(UIViewController*)viewController{
    [[NSNotificationCenter defaultCenter] addObserver:viewController
											 selector:@selector(handleWillShowKeyboard:)
												 name:UIKeyboardWillShowNotification
                                               object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:viewController
											 selector:@selector(handleWillHideKeyboard:)
												 name:UIKeyboardWillHideNotification
                                               object:nil];
}
//删除键盘观察者

-(void)removeObserverFromController:(UIViewController*)viewController{
    [self keyboardWillHide];
    [[NSNotificationCenter defaultCenter] removeObserver:viewController name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:viewController name:UIKeyboardWillHideNotification object:nil];
}
//隐藏键盘
- (void)keyboardWillHide
{
    /* Move the toolbar back to bottom of the screen */
    [self.textView resignFirstResponder];
    [self.textView clearText];
    if ([delegate respondsToSelector:@selector(keyBorddisApper)]) {
        [delegate keyBorddisApper];
    }
}
//键盘方法调用实现方法
- (void)keyboardWillShowHide:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGFloat keyboardY = [self.superview convertRect:keyboardRect fromView:nil].origin.y;
    CGRect inputViewFrame = self.frame;
    CGFloat originY = self.superview.frame.size.height==keyboardY?keyboardY:(keyboardY - inputViewFrame.size.height);
    self.frame = CGRectMake(inputViewFrame.origin.x,
                            originY,
                            inputViewFrame.size.width,
                            inputViewFrame.size.height);
    [UIView commitAnimations];

}



@end
