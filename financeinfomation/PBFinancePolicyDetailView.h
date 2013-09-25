//
//  PBFinancePolicyDetailView.h
//  ParkBusiness
//
//  Created by 上海 on 13-6-5.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBWeiboDataConnect.h"
#import "PBActivityIndicatorView.h"
#import "PBdataClass.h"
#import "UIInputToolbar.h"
@interface PBFinancePolicyDetailView : UIViewController<PBWeiboDataDelegate,PBdataClassDelegate,UIActionSheetDelegate,UIInputToolbarDelegate,UIWebViewDelegate>{
    PBWeiboDataConnect* sendmanager;
    PBActivityIndicatorView* indicator;
    UIInputToolbar* inputToolbar;
    NSString* inputtype;
}
@property (nonatomic, retain)UIImage *image;
@property (nonatomic, retain)NSString *remarktype;
@property (nonatomic, retain)IBOutlet UIImageView *imageView;
@property (nonatomic, retain)IBOutlet UILabel *name;
@property (nonatomic, retain)IBOutlet UILabel *financename;
@property (nonatomic, retain)IBOutlet UILabel *time;
@property (nonatomic, retain)IBOutlet UIWebView *webView;
@property (nonatomic, retain)IBOutlet UIButton *showFinance;
@property (nonatomic, retain)IBOutlet UIButton *shoucangbtn;
@property (nonatomic, retain)NSString *no;
@property (nonatomic, retain)NSURL *SC_URL;
@property (retain, nonatomic) NSMutableDictionary *dataDic;
@end
