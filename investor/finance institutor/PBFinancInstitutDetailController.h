//
//  PBFinancInstitutDetailController.h
//  ParkBusiness
//
//  Created by QDS on 13-5-24.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomImageView.h"
#import "PBWeiboDataConnect.h"
#import "PBActivityIndicatorView.h"
#import "UIImageView+CreditLevel.h"
@interface PBFinancInstitutDetailController : UIViewController<UITableViewDataSource, UITabBarDelegate,PBWeiboDataDelegate>
{
    NSArray *sectionAndRowDataArray;
    PBActivityIndicatorView* indicator;
    UIImageView* starImage;
}
@property (retain, nonatomic) NSString *financeno;
@property (retain, nonatomic) NSDictionary *dataDictionary;
@property (retain, nonatomic) IBOutlet UITableView *detailTableView;
@property(nonatomic,readwrite,retain)UIViewController* rootController;
@end
