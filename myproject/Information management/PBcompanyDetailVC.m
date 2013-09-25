//
//  PBcompanyDetailVC.m
//  ParkBusiness
//
//  Created by China on 13-8-30.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define BANKURL [NSString stringWithFormat:@"%@/admin/index/searchcompanyinfo",HOST]

#import "PBcompanyDetailVC.h"
#import "PBCompanyData.h"
@interface PBcompanyDetailVC ()

@end

@implementation PBcompanyDetailVC

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
    self.title = NSLocalizedString(@"_tb_gsgk", nil);
	// Do any additional setup after loading the view.
}
-(void)SearchOnServer
{
    [acitivity startAnimating];
    PBdataClass *pb = [[PBdataClass alloc]init];
    pb.delegate = self;
    [pb dataResponse:[NSURL URLWithString:BANKURL] postDic:[NSDictionary dictionaryWithObjectsAndKeys:[self.datadic objectForKey:@"userno"],@"userno", nil]searchOrSave:YES];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section<2) {
        return 0;
    }
    if (section==10&&self.companydata.actualoperatesite==1) {
        return 3;
    }
    if (section==11&&self.companydata.isfranchise==1) {
        return 2;
    }
    return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 9||section == 12||section == 13) {
        return [titleArr objectAtIndex:section-1];
    }else {
        return nil;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
