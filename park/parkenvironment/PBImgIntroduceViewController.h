//
//  PBImgIntroduceViewController.h
//  ParkBusiness
//
//  Created by  on 13-3-6.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UIInputToolbar.h"
#import "PBParkManager.h"
#import "PBActivityIndicatorView.h"
#import "PBNaviViewController.h"

@interface PBImgIntroduceViewController : UIViewController<UIScrollViewDelegate,UIActionSheetDelegate,PBParkManagerDelegate,UIInputToolbarDelegate>
{
    
    NSMutableArray      *nodesMutableArr;
    UIImageView         *img;
    BOOL isflage;
    UIScrollView    *imageScrollView;
    BOOL fullScreen;
    CGRect originframe;
    PBActivityIndicatorView *indicator;

}
@property (nonatomic, retain) NSString *parkNoString;
@property (nonatomic, retain) UIInputToolbar *inputToolbar;
@property (nonatomic, retain) PBParkManager *parkManager;
@property (nonatomic,retain) UIScrollView *imageScrollView;
@property (nonatomic,retain) NSMutableDictionary *data;
@property (nonatomic, retain) UIViewController *parentsController;


@end
