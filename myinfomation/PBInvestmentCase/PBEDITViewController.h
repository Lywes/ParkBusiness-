//
//  PBEDITViewController.h
//  ParkBusiness
//
//  Created by  on 13-4-23.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YIPopupTextView.h"
@class  PBInvestmentCaseDetailViewController;
@class  PBAddCaseViewController;

@interface PBEDITViewController : UIViewController<UITableViewDelegate,YIPopupTextViewDelegate>
{

    BOOL isEdit;
    int lableCount;
    UIView* customView;
    UIView *footView;
    UILabel *footlabel;
    YIPopupTextView *popupTextView;
    BOOL btnPressed;

}
@property (nonatomic,retain) NSString *popStr;
@property (nonatomic, retain) YIPopupTextView *popupTextView;


@end
