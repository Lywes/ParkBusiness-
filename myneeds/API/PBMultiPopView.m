//
//  PBMultiPopView.m
//  ParkBusiness
//
//  Created by 上海 on 13-7-16.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define CELLHEIGHT 60.0f                    //cell 高度
#define OTHERREASONWEITH isPad()?400:200     //其他输入框bound的长度
#define OTHERREASONORIGIN isPad()?150:100     //其他输入框锚点X
#import "PBMultiPopView.h"
#import "UIImage+Scale.h"
@implementation PBMultiPopView
@synthesize _arry,name,delegate,dataStr;
-(void)dealloc
{
    [_arry release];
    [name release];
    RB_SAFE_RELEASE(otherReason);
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect rect = CGRectMake(OTHERREASONORIGIN, 0, OTHERREASONWEITH, CELLHEIGHT);
    UITextField *textfield = [[UITextField alloc] initWithFrame:rect];
    otherReason = textfield;
    otherReason.delegate = self;
     otherReason.hidden = YES;
    otherReason.font = [UIFont systemFontOfSize:15];
    otherReason.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textfield.borderStyle = UITextBorderStyleRoundedRect;
}
- (void)popClickAction
{
    CGFloat xWidth;
    CGFloat yHeight;
    CGFloat yOffset;
    if (isPad()) {
        xWidth = 600.0f;
        yHeight = 370.0f;
        yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
    }
    else
    {
        xWidth = self.view.bounds.size.width - 20.0f;
        yHeight = 250.0f;
        yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
    }
    dataStr = @"";
    checkArr = [[NSMutableArray alloc]init];
    for (int i=0;i<[self._arry count]+1;i++) {
        [checkArr addObject:[NSNumber numberWithBool:FALSE]];
    }
    poplistview = [[PBPopListView alloc] initWithFrame:CGRectMake(10, yOffset, xWidth, yHeight)];
    poplistview.delegate = self;
    poplistview.datasource = self;
    poplistview.listView.scrollEnabled = TRUE;
    [poplistview setTitle:self.name];
    [poplistview show];
    [poplistview release];
}


#pragma mark - UIPopoverListViewDataSource

- (UITableViewCell *)popoverListView:(PBPopListView *)popoverListView
                    cellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:identifier] autorelease];
    
    int row = indexPath.row;
    NSString *checkImage = [[checkArr objectAtIndex:indexPath.row] boolValue]?@"plugin_open":@"like_headbg";
    cell.imageView.image = [[UIImage imageNamed:checkImage] scaleToSize:CGSizeMake(27.0f, 27.0f)];
    if (indexPath.row < self._arry.count) {
        cell.textLabel.text = [self._arry objectAtIndex:row];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;

    }
    else{
        cell.textLabel.text = @"其它";
        [cell.contentView addSubview:otherReason];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    
    return cell;
}

- (NSInteger)popoverListView:(PBPopListView *)popoverListView
       numberOfRowsInSection:(NSInteger)section
{
    return [self._arry count] + 1;
}

#pragma mark - UIPopoverListViewDelegate
- (void)popoverListView:(PBPopListView *)popoverListView
     didSelectIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [popoverListView.listView cellForRowAtIndexPath:indexPath];
    BOOL check = ![[checkArr objectAtIndex:indexPath.row] boolValue];
    [checkArr replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:check]];
    NSString *checkImage = check?@"plugin_open":@"like_headbg";
    cell.imageView.image = [[UIImage imageNamed:checkImage] scaleToSize:CGSizeMake(27.0f, 27.0f)];
//    [self.delegate popView:self didSelectIndexPath:indexPath];
    if (indexPath.row == self._arry.count && [checkImage isEqualToString:@"plugin_open"]) {
        otherReason.hidden = NO;
        otherReason.enabled = YES;
        [otherReason becomeFirstResponder];
        
    }
    else{
         otherReason.enabled = NO;
        [otherReason resignFirstResponder];

    }
    
}

- (CGFloat)popoverListView:(PBPopListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELLHEIGHT;
}

-(void)submitBtnDidPush{
    for (int i=0;i<[checkArr count]-1; i++) {
        if ([[checkArr objectAtIndex:i] boolValue]) {
            dataStr = [NSString stringWithFormat:@"%@,%@",dataStr,[self._arry objectAtIndex:i]];
        }
    }
    if ([dataStr length]>0) {
        dataStr = [dataStr substringFromIndex:1];
    }
    dataStr = [NSString stringWithFormat:@"%@,%@",dataStr,otherReason.text];
    [self.delegate popView:self];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark - textfield delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    UITableViewCell *cell = (UITableViewCell *)[[textField superview]superview];
    
    CGRect frame = cell.frame;
    
    int offset = frame.origin.y  - (self.view.frame.size.height - 216.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    
    float width = poplistview.listView.frame.size.width;
    
    float height = poplistview.listView.frame.size.height;
    
    if(offset > 0)
        
    {
        
        CGRect rect = CGRectMake(0.0f, -offset,width,height);
        
        poplistview.listView.frame = rect;
        
    }
    
    [UIView commitAnimations];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    
    CGRect rect = CGRectMake(0.0f, 0.0f, poplistview.listView.frame.size.width, poplistview.listView.frame.size.height);
    
    poplistview.listView.frame = rect;
    
    [UIView commitAnimations];
    
    [textField resignFirstResponder];
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [otherReason resignFirstResponder];
    return YES;
}
@end
