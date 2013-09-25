//
//  PBParkEnvironmentViewController.h
//  ParkBusiness
//
//  Created by  on 13-3-4.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaterflowView.h"
#import "PBWaterFallViewController.h"
#import "PBParkManager.h"
#import "PBImgIntroduceViewController.h"
#import "PBActivityIndicatorView.h"

@interface PBParkEnvironmentViewController : UIViewController<WaterflowViewDelegate,WaterflowViewDatasource,UIScrollViewDelegate,PBParkManagerDelegate>
{
    
    WaterflowView       *flowView;
    NSMutableArray      *nodesMutableArr;
    
    BOOL downflg ;
    PBImgIntroduceViewController *imgVC;

    PBActivityIndicatorView *indicator;
}

//parkNo的值有两种来源，园区会员的传值和走进园区本地数据库的获取
@property (nonatomic, retain) NSString *parkNoString;
@property (nonatomic,retain) PBParkManager *parkManager;
@property (nonatomic, retain) UIViewController *parentsController;

@end
