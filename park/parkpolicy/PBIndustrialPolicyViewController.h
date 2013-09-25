//
//  PBIndustrialPolicyViewController.h
//  ParkBusiness
//
//  Created by  on 13-3-4.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaterflowView.h"
#import "PBWaterFallViewController.h"
#import "PBParkManager.h"
#import "PBImgIndustrialViewController.h"
#import "PBActivityIndicatorView.h"

@interface PBIndustrialPolicyViewController : UIViewController<UIActionSheetDelegate,WaterflowViewDelegate,WaterflowViewDatasource,UIScrollViewDelegate,PBParkManagerDelegate>
{
    WaterflowView       *flowView;    
    NSMutableArray      *nodesMutableArr;
    UISegmentedControl *segmentedControl;
    BOOL downflg ;
    PBImgIndustrialViewController *imgIndustrialVC;
  
    PBActivityIndicatorView *indicator;
    
    int type;
}

@property (nonatomic, retain) NSString *parkNoString;
@property (nonatomic,retain) PBParkManager *parkManager;

-(void) searchParkIntroduce:(int)pageno;
-(void)segmentedControl;
-(void)searchGuojia:(int)pageno;
@end
