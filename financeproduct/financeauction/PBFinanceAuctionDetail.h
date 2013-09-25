//
//  PBFinanceAuctionDetail.h
//  ParkBusiness
//
//  Created by 上海 on 13-6-26.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBWeiboDataConnect.h"
#import "UIInputToolbar.h"
@interface PBFinanceAuctionDetail : UITableViewController<PBWeiboDataDelegate,UIActionSheetDelegate,UIInputToolbarDelegate>{
    PBWeiboDataConnect* sendmanager;
    NSMutableArray* titleArr;
    UILabel* endLabel;
    NSTimer *timer;
    UIView* auctionView;
    UITextField* priceField;
    int nowprice;
    UIButton* minus;
    UIInputToolbar* inputToolbar;
    PBActivityIndicatorView* indicator;
}
@property(nonatomic,retain)UIImage* image;
@property(nonatomic,retain)NSMutableDictionary* dataDic;
@property(nonatomic,readwrite,retain)UIViewController* rootController;

@end
