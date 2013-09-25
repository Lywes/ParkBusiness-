//
//  PBInvestmentSettingViewController.h
//  ParkBusiness
//
//  Created by  on 13-3-18.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PBInvestmentIndustryViewController;
#import "PBEDITViewController.h"
#import "PBEDViewController.h"
#import "PBTouzishezhiData.h"
#import "PBParkManager.h"
#import "PBActivityIndicatorView.h"

@interface PBInvestmentSettingViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,PBParkManagerDelegate>
{
    BOOL isPressed;
    
    NSMutableArray  *sectionArr;
    
    PBInvestmentIndustryViewController   *informationVC;
    PBEDITViewController *edit2VC;
    PBEDViewController *edVC;
    
    NSMutableArray *arry;
    UILabel *headerLabel; 
    UIBarButtonItem *rightbtn;
    
    UIImageView *img1;
    UIImageView *img2;
    UIImageView *img3;
    UIImageView *img4;
    UIImageView *img5;
    
    CGSize labelSize;
    CGFloat labelWidth;
    
    PBTouzishezhiData *shezhiData;
    PBActivityIndicatorView *indicator;
    
}
@property (nonatomic,retain) PBParkManager *parkManager;
@property (nonatomic,retain) NSMutableDictionary *mutableDic;
@property (nonatomic,retain) NSString *string1;
@property (nonatomic,retain) NSString *string2;
@property (nonatomic,retain) NSMutableArray *arr;
@property (nonatomic, retain) UILabel *detailLabel;
@property (nonatomic, retain) UILabel *countLabel; 
@property (nonatomic, retain) UILabel *eduLabel;
@property (nonatomic, retain) IBOutlet UITableView *tableView1;
@property (nonatomic, retain) UILabel *label5;
@property (nonatomic, retain) UILabel *label2;
-(void)submitData;
-(void)sectionContent;
-(void)rightBtn;
-(void)edit;
@end
