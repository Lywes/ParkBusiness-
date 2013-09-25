//
//  PBImageScrollView.h
//  ParkBusiness
//
//  Created by 上海 on 13-7-2.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBParkManager.h"
#import "PBActivityIndicatorView.h"
#import "PBNaviViewController.h"
@interface PBImageScrollView : UIViewController<UIScrollViewDelegate,PBParkManagerDelegate>
{
    
    
    UIImageView         *img;
    UIScrollView    *imageScrollView;
    BOOL fullScreen;
    CGRect originframe;
    PBActivityIndicatorView *indicator;
    
}
@property (nonatomic, assign) int showno;
@property (nonatomic, retain) NSString *urlStr;
@property (nonatomic, retain) NSString *parkNoString;
@property (nonatomic, retain) PBParkManager *parkManager;
@property (nonatomic,retain) UIScrollView *imageScrollView;
@property (nonatomic,retain) NSMutableDictionary *data;
@property (nonatomic,retain) NSMutableArray *nodesMutableArr;
@property (nonatomic, retain) UIViewController *parentsController;

@end
