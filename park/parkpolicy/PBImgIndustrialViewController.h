//
//  PBImgIndustrialViewController.h
//  ParkBusiness
//
//  Created by  on 13-3-7.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIInputToolbar.h"
#import "PBActivityIndicatorView.h"
#import "PBParkManager.h"
@interface PBImgIndustrialViewController : UIViewController<UIScrollViewDelegate,UIInputToolbarDelegate,PBParkManagerDelegate,UIActionSheetDelegate>
{
    PBParkManager* policymanager;
    PBActivityIndicatorView *indicator;
}
@property (nonatomic, retain) UIInputToolbar *inputToolbar;
@property (nonatomic,retain) IBOutlet UITextView *dataTextView;
@property (nonatomic,retain) NSMutableDictionary *data;
@property (nonatomic,retain)NSString* parkNoString;
@end
