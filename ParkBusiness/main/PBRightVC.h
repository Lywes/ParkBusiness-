//
//  PBRightVC.h
//  PBParkBusiness
//
//  Created by China on 13-8-19.
//  Copyright (c) 2013年 WINSEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBdataClass.h"
#import "PBInsertDataConnect.h"
#import "PBActivityIndicatorView.h"
@protocol SideBarSelectDelegate;
@interface PBRightVC : UIViewController<PBdataClassDelegate,PBInsertDataDelegate,UIAlertViewDelegate>{
    NSString* upgradeUrl;
    PBActivityIndicatorView* indicator;
    UIViewController* presentController;
}
@property (assign,nonatomic)id<SideBarSelectDelegate>delegate;
@property(nonatomic,retain) IBOutlet UIImageView *icon_image;
@property(nonatomic,retain) IBOutlet UIImageView *icon_image_back;
@property(nonatomic,retain) IBOutlet UIButton *shezhi;
@property(nonatomic,retain) IBOutlet UIButton *xinxizhongxin;
@property(nonatomic,retain) IBOutlet UIButton *guanyuwomen;
@property(nonatomic,retain) IBOutlet UIButton *fankui;
@property(nonatomic,retain) IBOutlet UIButton *bangzhu;
@property(nonatomic,retain) IBOutlet UIButton *tuijian_btn;
@property(nonatomic,retain) IBOutlet UIButton *Join_btn;
@property(nonatomic,retain) IBOutlet UIImageView *starImage;
@property(nonatomic,retain) IBOutlet UILabel *name;
-(IBAction)btnPress:(id)sender;
-(IBAction)goCreditIntroduce:(id)sender;
@end
