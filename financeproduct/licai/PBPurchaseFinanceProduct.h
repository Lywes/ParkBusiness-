//
//  PBPurchaseFinanceProduct.h
//  ParkBusiness
//
//  Created by 上海 on 13-6-3.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBWeiboDataConnect.h"
#import "PBActivityIndicatorView.h"
#import "UIInputToolbar.h"
@interface PBPurchaseFinanceProduct : UITableViewController<PBWeiboDataDelegate,UIInputToolbarDelegate,UIActionSheetDelegate>{
    PBWeiboDataConnect* shoucangData;
    PBWeiboDataConnect* zanData;
    PBWeiboDataConnect* sendmanager;
    PBActivityIndicatorView* indicator;
    UIInputToolbar* inputToolbar;
    NSString* inputtype;
    BOOL hasSC;
    BOOL hasZan;
    NSTimer *timer;
    NSIndexPath* index;
    UILabel* endLabel;
}
@property(nonatomic,retain)UIImage* image;
@property(nonatomic,retain)NSMutableDictionary* dataDic;
@property(nonatomic,retain)NSString* hasBuy;
@property(nonatomic,readwrite,retain)UIViewController* rootController;
@end
