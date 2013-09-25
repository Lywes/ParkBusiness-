//
//  PBChooseNormal VC.m
//  ParkBusiness
//
//  Created by China on 13-8-1.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBChooseNormal VC.h"
#import "PBFinancingCase.h"
@interface PBChooseNormal_VC ()

@end

@implementation PBChooseNormal_VC
@synthesize financingcase;
@synthesize indexpath;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization 
        NSMutableArray *arry1 = [[NSMutableArray alloc]init];
        self.DataArr = arry1;
        [arry1 release];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigatorRightButtonType:WANCHENG];
    isSelect = NO;
}
-(void)viewDidUnload
{
    [super viewDidUnload];
    self.financingcase = nil;
    str = nil;
    indexpath = nil;
}
-(void)NvBtnPress:(id)sender
{
    if (isSelect) {
        NSMutableArray *arr = [self.financingcase.DataArr objectAtIndex:indexpath.section];
        [arr replaceObjectAtIndex:indexpath.row withObject:str];
        [self.financingcase.tableView reloadData];
    }
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)KBMaster:(NSString *)key type:(NSString *)type{
    
    NSMutableArray *arr = [PBKbnMasterModel getKbnInfoByKind:key];
    for (PBKbnMasterModel * industryData in arr) {
        if (industryData.name != NULL) {
            [self.DataArr addObject:industryData.name];
        }
    }
    [arr release];
    
    [self.tableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.DataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.DataArr.count>0) {
        cell.textLabel.text = [self.DataArr objectAtIndex:indexPath.row];
    }
    if (indexPath.row == oldint.row && oldint != nil) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int oldRow = (oldint == nil)?-1:oldint.row;
    int currentRow = indexPath.row;
    if (currentRow != oldRow) {
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldint];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        oldint = [indexPath retain];
    }
    
    str =  [self.DataArr objectAtIndex:indexPath.row];
    isSelect = YES;
//    [self.seting.DataArr replaceObjectAtIndex:self.replaceno withObject:[self.DataArr objectAtIndex:indexPath.row]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
