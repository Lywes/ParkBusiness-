//
//  PBApplyClassVC.m
//  ParkBusiness
//
//  Created by QDS on 13-7-1.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBApplyClassVC.h"
#import "NSObject+NVBackBtn.h"
@interface PBApplyClassVC ()

@end

@implementation PBApplyClassVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"申请开课";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customButtomItem:self];
    self.tableView.tableFooterView = [self footView];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier]autorelease];
        cell.backgroundColor = [UIColor clearColor];

    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 0;
}


-(UIView *)footView
{
    UITextView *footview = [[[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)]autorelease];
    footview.text = @"如果您或者您所在的公司或者机构希望为会员开设公益课程，请联系我们的业务部门，并将课程安排及课件资料发送至业务部门指定的邮箱中，业务部门会主动联系您的。\n业务联系电话：021-53930568\n联系邮箱：admin@iacademe.net";
    footview.scrollEnabled = NO;
    [footview setEditable:NO];
    footview.textAlignment = UITextAlignmentLeft;
    footview.backgroundColor = [UIColor clearColor];
    return footview;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
@end
