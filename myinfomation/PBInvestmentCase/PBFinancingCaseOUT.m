//
//  PBFinancingCaseOUT.m
//  ParkBusiness
//
//  Created by China on 13-8-2.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBFinancingCaseOUT.h"
#import "PBFinancingCase.h"
@interface PBFinancingCaseOUT ()

@end

@implementation PBFinancingCaseOUT
@synthesize textview;
@synthesize ClassTitle;
@synthesize financingcase;
@synthesize indexpath;
-(void)dealloc
{
    ClassTitle = nil;
    RB_SAFE_RELEASE(textview);
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = ClassTitle;
    [self navigatorRightButtonType:WANCHENG];
    UITextView *text = [self addtextview];
    text.frame =  CGRectMake(0, 0, isPad()?679:300, 120);
    [text setEditable:YES];
    self.textview = text;

}
-(void)NvBtnPress:(id)sender{
    NSMutableArray *arr = [self.financingcase.DataArr objectAtIndex:indexpath.section];
    [arr replaceObjectAtIndex:indexpath.row withObject:textview.text];
    [self.financingcase.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
 }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:self.textview];
        
    }
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)]autorelease];
    if (isPad()) {
        view.frame = CGRectMake(0, 0, RATIO*320, 20);
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat i;
    i = 120;

    return i;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
