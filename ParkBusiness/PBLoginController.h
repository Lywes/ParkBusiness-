//
//  PBLoginController.h
//  ParkBusiness
//
//  Created by lywes lee on 13-3-29.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBWeiboDataConnect.h"
#import "PBInsertDataConnect.h"
#import "PBActivityIndicatorView.h"
@interface PBLoginController : UIViewController<UITextFieldDelegate,UIAlertViewDelegate,PBWeiboDataDelegate,PBInsertDataDelegate>{
    PBActivityIndicatorView *indicator;
    PBWeiboDataConnect* sendData;
    PBWeiboDataConnect* checkData;
    PBWeiboDataConnect* institudeData;
    PBInsertDataConnect* insertData;
    UIAlertView* alerts;
    CGRect originframe;
    CGRect changeframe;
    IBOutlet UIView * customView;
}
@property(nonatomic,retain)IBOutlet UITextField* mobileText;
@property(nonatomic,retain)IBOutlet UITextField* passwordText;
@property(nonatomic,retain)IBOutlet UIButton* submitbtns;
@property(nonatomic,retain)IBOutlet UIButton* sendbtns;
-(IBAction)getPasswordText:(id)sender;
-(IBAction)checkPasswordText:(id)sender;
@end
