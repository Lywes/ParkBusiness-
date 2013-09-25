//
//  PBLicaiNewsSC.m
//  ParkBusiness
//
//  Created by China on 13-9-2.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBLicaiNewsSC.h"
#define JINTONGXINWEN_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/searchknowledgeclassfavourites",HOST]]
@interface PBLicaiNewsSC ()

@end

@implementation PBLicaiNewsSC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)toGetTheData
{
    [activity startAnimating];
    PBdataClass *dc = [[PBdataClass alloc]init];
    dc.delegate = self;
    self.dataclass = dc;
    [dc release];
    [self.dataclass dataResponse:JINTONGXINWEN_URL postDic:[NSDictionary dictionaryWithObjectsAndKeys:USERNO,@"userno",@"2",@"kind", nil] searchOrSave:YES];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
