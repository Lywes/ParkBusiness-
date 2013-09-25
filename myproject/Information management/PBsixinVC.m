//
//  PBsixinVC.m
//  ParkBusiness
//
//  Created by lywes lee on 13-4-24.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define BTNTAG 60
#import "PBsixinVC.h"
@interface PBsixinVC ()

@end

@implementation PBsixinVC
@synthesize sixin;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"我的私信";
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //    UIImageView *NavBKimage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    //    NavBKimage.image = [UIImage imageNamed:@"bottomtabbar.png"];
    //    [NavBKimage release];

}
-(void)backUpView
{
    [self dismissModalViewControllerAnimated:YES];
    
    
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    if (indexPath.section == 1) {
        height = self.projectjieshao.contentSize.height;
        CGRect farm = self.projectjieshao.frame;
        farm.size.height = height;
        self.projectjieshao.frame = farm;
        if (self.projectjieshao.contentSize.height > 44.0f) {
            height = self.projectjieshao.contentSize.height;
            CGRect farm = self.projectjieshao.frame;
            farm.size.height = height;
            self.projectjieshao.frame = farm;
        }
        else {
            height = 44.0f;
            CGRect farm = self.projectjieshao.frame;
            farm.size.height = 44.0f;
            self.projectjieshao.frame = farm;
        } 
    }
    else {
        height= 80.0f;
    }
    return height;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        NSString *str = @"内容";
        return str;
    }
    else {
        return nil;
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 0) {        
            UITextField *title;
            if (isPad()) {
                title = [[[UITextField alloc]initWithFrame:CGRectMake(60, 0, 300, 50)]autorelease];
                title.font = [UIFont systemFontOfSize:PadContentFontSize];
            }
            else {
                title = [[[UITextField alloc]initWithFrame:CGRectMake(40, 0, 250, 50)]autorelease];
                 title.font = [UIFont systemFontOfSize:ContentFontSize];
            }
            [title setEnabled:NO];
            title.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
            title.tag = BTNTAG;

            UITextField *name;
            if (isPad()) {
                name = [[[UITextField alloc]initWithFrame:CGRectMake(60, 50, 300, 30)]autorelease];
                name.font = [UIFont systemFontOfSize:PadContentFontSize];
            }
            else {
                name = [[[UITextField alloc]initWithFrame:CGRectMake(40, 50, 110, 30)]autorelease];
                name.font = [UIFont systemFontOfSize:ContentFontSize];
            }   
            [name setEnabled:NO];
            name.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
            name.tag = BTNTAG+1;
            
            UIImageView *titleimage;
            UIImageView *nameimage;
            UIImageView *timeimage;
            UITextField *time;
            if (isPad()) {
                titleimage = [[[UIImageView alloc]initWithFrame:CGRectMake(15, 13, 21, 21)]autorelease];
                 nameimage = [[[UIImageView alloc]initWithFrame:CGRectMake(15, 55, 21, 21)]autorelease];
                timeimage = [[[UIImageView alloc]initWithFrame:CGRectMake(300, 55, 21, 21)]autorelease];
                time = [[[UITextField alloc]initWithFrame:CGRectMake(350, 50, 100, 30)]autorelease];
                time.font = [UIFont systemFontOfSize:PadContentFontSize];
            }
            else {
                 titleimage = [[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 21, 21)]autorelease];
                 nameimage = [[[UIImageView alloc]initWithFrame:CGRectMake(10, 55, 21, 21)]autorelease];
                 timeimage = [[[UIImageView alloc]initWithFrame:CGRectMake(180, 55, 21, 21)]autorelease];
                time = [[[UITextField alloc]initWithFrame:CGRectMake(210, 50, 90, 30)]autorelease];
                time.font = [UIFont systemFontOfSize:ContentFontSize];
            }
            [time setEnabled:NO];
            titleimage.image = [UIImage imageNamed:@"titleimage.png"];
            nameimage.image = [UIImage imageNamed:@"avatarslogo.png"];
             timeimage.image = [UIImage imageNamed:@"time.png"];
            time.tag = BTNTAG+2;
             time.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
            [cell.contentView addSubview:title];
             [cell.contentView addSubview:name];
            [cell.contentView addSubview:titleimage];
             [cell.contentView addSubview:nameimage];
             [cell.contentView addSubview:timeimage];
            [cell.contentView addSubview:time];
        }  
        if (indexPath.section == 1) {
            [cell.contentView addSubview:self.projectjieshao];
        }
    }
    UITextField *title = (UITextField *)[self.view viewWithTag:BTNTAG];
    UITextField *name = (UITextField *)[self.view viewWithTag:BTNTAG+1];
     UITextField *time = (UITextField *)[self.view viewWithTag:BTNTAG+2];
    title.text = [self.sixin objectForKey:@"title"];
    name.text = [self.sixin objectForKey:@"ruser"];
     time.text = [self.sixin objectForKey:@"time"];
    self.projectjieshao.text = [self.sixin objectForKey:@"content"];
    
    return cell;
}

@end
