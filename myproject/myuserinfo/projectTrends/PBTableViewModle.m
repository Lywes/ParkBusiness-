//
//  PBTableViewModle.m
//  ParkBusiness
//
//  Created by lywes lee on 13-3-28.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBTableViewModle.h"

@interface PBTableViewModle ()
-(void)pbResignFirstResponder:(UIView *)view;

@end

@implementation PBTableViewModle
@synthesize mustResignFirstResponder;
-(void)dealloc
{
    [self.mustResignFirstResponder release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - 编辑
-(void)navigatorRightButtonType:(RIGHT)type
{
    if (type == BIANJIBUTTON) {
        UIBarButtonItem *rightbutton = [[[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editButtonPress:)]autorelease];
        self.navigationItem.rightBarButtonItem = rightbutton;
        rightbutton.tag = BIANJIBUTTON+100;
    }
    if (type == ZUIJIABUTTON) {
        UIBarButtonItem *rightbutton = [[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"nav_btn_zj", nil) style:UIBarButtonItemStylePlain target:self action:@selector(editButtonPress:)]autorelease];
        self.navigationItem.rightBarButtonItem = rightbutton;
        rightbutton.tag = ZUIJIABUTTON+100;
        
    }
    if (type == WANCHENBUTTON) {
        UIBarButtonItem *rightbutton = [[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"nav_btn_wc", nil) style:UIBarButtonItemStylePlain target:self action:@selector(editButtonPress:)]autorelease];
        self.navigationItem.rightBarButtonItem = rightbutton;
        rightbutton.tag = WANCHENBUTTON+100;
        
    }
}
-(void)editButtonPress:(id)sender
{
    
}
-(UITextField *)addTextField:(UITableViewCell *)cell withString:(NSString *)str
{
    UITextField *textfield = [[[UITextField alloc]initWithFrame:CGRectMake(140, 12, 130, 29)]autorelease];
    textfield.text = str;
    textfield.textAlignment = UITextAlignmentLeft;
    textfield.delegate = self;
    [self pbResignFirstResponder:textfield];
    return textfield;

}
-(UITextView *)addTextView:(UITableViewCell *)cell
{
    UITextView *textview = [[[UITextView alloc]initWithFrame:CGRectMake(120, 15, 180, 80)]autorelease];
    textview.delegate = self;
    textview.font = [UIFont systemFontOfSize:15];
    textview.textAlignment = UITextAlignmentLeft;
    textview.backgroundColor = [UIColor clearColor];
    [self pbResignFirstResponder:textview];

    return textview;
}
-(UILabel *)addLable:(UITableViewCell *)cell
{
    UILabel *lable = [[[UILabel alloc]initWithFrame:CGRectMake(180, 100, 100, 15)]autorelease];
    lable.text = @"最多输入300字";
    lable.font = [UIFont fontWithName:@"Hoefler Text" size:13];
    lable.backgroundColor = [UIColor clearColor];
    return lable;
}
-(UILabel *)addLable:(UITableViewCell *)cell withFram:(CGRect)frame withName:(NSString *)name
{
    UILabel *lable = [[[UILabel alloc]initWithFrame:frame]autorelease];
    lable.text = name;
    lable.font = [UIFont fontWithName:@"Hoefler Text" size:13];
    lable.backgroundColor = [UIColor clearColor];
    return lable;
}
-(UITextView *)addTextView:(UITableViewCell *)cell withFram:(CGRect)frame withString:(NSString *)str
{
    UITextView *textview = [[[UITextView alloc]initWithFrame:frame]autorelease];
    textview.text = str;
    textview.delegate = self;
    textview.font = [UIFont systemFontOfSize:15];
    textview.textAlignment = UITextAlignmentLeft;
    textview.backgroundColor = [UIColor clearColor];
    [self pbResignFirstResponder:textview];

    return textview;
}
-(void)pbResignFirstResponder:(UIView *)view
{
    self.mustResignFirstResponder = [NSMutableArray arrayWithObject:view];
//    if ([view isKindOfClass:[UITextField class]]) {
//        UITextField *textfield = (UITextField *)view;
//        [textfield setEnabled:YES];
//    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"back.png"];
    UIButton *lefbt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [lefbt setBackgroundImage:image forState:UIControlStateNormal];
    [lefbt addTarget:self action:@selector(backUpView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftbutton = [[[UIBarButtonItem alloc]initWithCustomView:lefbt]autorelease];
    self.navigationItem.leftBarButtonItem = leftbutton;
}
-(void)backUpView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder]; 
    return YES; 
}
//textview
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{    
    
    if ([text isEqualToString:@"\n"]||range.location>=300
        ) {    
        
        if ([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder]; 
        }
        return NO;    
        
    }
    
    return YES;    
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
