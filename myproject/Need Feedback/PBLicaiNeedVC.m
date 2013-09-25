//
//  PBLicaiNeedVC.m
//  ParkBusiness
//
//  Created by China on 13-7-10.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define LICAIXUQIU_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/searchmyneedsfeedback",HOST]]

#import "PBLicaiNeedVC.h"

@interface PBLicaiNeedVC ()

@end

@implementation PBLicaiNeedVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)initdata
{
    self.dataclass = [[PBdataClass alloc]init];
    self.dataclass.delegate = self;
    NSDictionary *dic= [[NSDictionary alloc]initWithObjectsAndKeys:USERNO,@"userno",@"2",@"type", nil];
    [self.dataclass dataResponse:LICAIXUQIU_URL postDic:dic searchOrSave:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}
-(void)InvestTableview
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
