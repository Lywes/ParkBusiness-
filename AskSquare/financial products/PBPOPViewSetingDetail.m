//
//  PBPOPViewSetingDetail.m
//  ParkBusiness
//
//  Created by China on 13-7-18.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBPOPViewSetingDetail.h"
#import "PBKbnMasterModel.h"
#import "PBPOPViewSetting.h"
@interface PBPOPViewSetingDetail ()

@end

@implementation PBPOPViewSetingDetail
@synthesize replaceno;
@synthesize seting;
-(void)dealloc
{
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
-(void)forListString:(NSString *)str
{
    NSMutableArray *arr = [PBKbnMasterModel getKbnInfoByKind:str];
    for (PBKbnMasterModel * industryData in arr) {
        if (industryData.name != NULL) {
            [self.DataArr addObject:industryData.name];
        }
    }
    [arr release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *rightbar = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"nav_btn_wc", nil) style:UIBarButtonItemStylePlain target:self action:@selector(rightbarPress:)];
    self.navigationItem.rightBarButtonItem = rightbar;
    [rightbar release];

    self.DataArr = [[NSMutableArray alloc]init];
//    [self.DataArr release];
    if (seting.projecttype==6) {
        switch (self.replaceno) {
            case 0:
                [self forListString:@"mmtype"];
                break;
            case 1:
                [self forListString:@"earor"];
                break;
            case 2:
                [self forListString:@"timeperiod"];
                break;
            default:
                break;
        }
    }else{
        switch (self.replaceno) {
            case 0:
                [self forListString:@"fund"];
                break;
            case 1:
                [self forListString:@"companystage"];
                break;
            case 2:
                [self forListString:@"asset"];
                break;
            case 3:
                [self forListString:@"yearsale"];
                break;
            case 4:
                [self forListString:@"industry"];
                break;
            default:
                break;
        }
    }
    
    
}

-(void)rightbarPress:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier]autorelease];
    }
    if (indexPath.row == oldint.row && oldint != nil) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = [self.DataArr objectAtIndex:indexPath.row];
  
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
    [self.seting.DataArr replaceObjectAtIndex:self.replaceno withObject:[self.DataArr objectAtIndex:indexPath.row]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
