//
//  PBtrend.m
//  ParkBusiness
//
//  Created by lywes lee on 13-4-9.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBtrend.h"
@interface PBtrend ()

@end

@implementation PBtrend
@synthesize trends;
@synthesize projectno;
@synthesize OtherData;
-(void)dealloc
{
    [activity release];
    [trends= nil release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.projectjieshao.text = nil;
    [activity removeFromSuperview];

}
-(void)viewWillAppear:(BOOL)animated
{
    if (![self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
        [self.view addSubview:activity];
        if (!self.trends) {
            isedit = NO;
            [self.projectjieshao becomeFirstResponder];
        }
        else {
            self.projectjieshao.text = self.trends.condition; 
        }
        [self.tableView reloadData];
    }

    else {
        self.projectjieshao.text = [self.OtherData objectForKey:@"dynamic"];
        [self.tableView reloadData];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    activity = [[PBActivityIndicatorView alloc]initWithFrame:self.view.frame];
    [activity retain];
}
-(void)postDataOnserver
{
    [activity startAnimating];
    NSString *str;
    if (self.trends.no) {
        str = @"mod";
    }
    else {
        str = @"add";
    }
        NSArray *a1 = [NSArray arrayWithObjects:@"mode",
                       @"no",
                       @"projectno", 
                       @"dynamic",
                       nil];
        NSArray *a2 = [NSArray arrayWithObjects:str,
                       [NSString stringWithFormat:@"%d",self.trends.no],
                       [NSString stringWithFormat:@"%d",self.projectno], 
                       self.projectjieshao.text == NULL?@"":self.projectjieshao.text,
                       nil];
        PBdataClass *pbdataclass = [PBdataClass sharePBdataClass];
        pbdataclass.delegate = self;
        [pbdataclass dataResponse:[NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/addprojectcondition",HOST]] postDic:[NSDictionary dictionaryWithObjects:a2 forKeys:a1] searchOrSave:NO];
    

}
-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue
{
    PBtrendData *pbtrenddata = [[[PBtrendData alloc]init]autorelease];

    pbtrenddata.no = [intvalue intValue];
    
    pbtrenddata.projectno = self.projectno;
    pbtrenddata.condition = self.projectjieshao.text;
    pbtrenddata.cdate = [NSString stringWithFormat:@"%@",[NSDate date]];
    [pbtrenddata saveRecord];
    [activity stopAnimating];
    [self.navigationController popViewControllerAnimated:YES];
}
/*
 上传失败
 */
-(void)requestFilad
{
    [activity stopAnimating];
}
-(void)searchFilad
{
    if (self.trends) {
        [self editButtonPress:self.navigationItem.rightBarButtonItem];
    }else{
        [self editState];
    }
    [activity stopAnimating];
}
-(void)addSubViewForCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self addTextViewForCell:cell];
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *str = @"动态";
    return str;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *str = self.trends.cdate;
    return str;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (![self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
        return [self TishiView];
    }
    else {
        return nil;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    if (indexPath.section == 0) {
        height = self.projectjieshao.contentSize.height;
        CGRect farm = self.projectjieshao.frame;
        farm.size.height = height;
        self.projectjieshao.frame = farm;
        if (self.projectjieshao.contentSize.height > 60.0f) {
            height = self.projectjieshao.contentSize.height;
            CGRect farm = self.projectjieshao.frame;
            farm.size.height = height;
            self.projectjieshao.frame = farm;
        }
        else {
            height = 44.0f;
            CGRect farm = self.projectjieshao.frame;
            farm.size.height = 60.0f;
            self.projectjieshao.frame = farm;
        } 
    }
    else
    {
        height = 44.0f;
    }
    return height;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
