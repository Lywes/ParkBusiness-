//
//  PBInvestmentCaseDetailViewController.h
//  ParkBusiness
//
//  Created by  on 13-3-13.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBParkManager.h"
#import "PBIndustryClassificationViewController.h"
#import "PBAmountUnitViewController.h"
#import "PBDetailAnLiData.h"
#import "PBAddAnLiData.h"
#import "PBProjectStageViewController.h"
#import "PBSearchsProjectsViewController.h"
#import "PBEDViewController.h"
#import "PBEDITViewController.h" 
#import "PBActivityIndicatorView.h"


@interface PBInvestmentCaseDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,PBParkManagerDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    NSMutableArray  *sectionArr;
    NSMutableArray  *nodesMutableArr;

    UIDatePicker *datepicker;
    
    BOOL btnPressed;
    PBIndustryClassificationViewController *iCVC;
    PBAmountUnitViewController *amountUnitVC;
    UIBarButtonItem *rightButton;
    UILabel *label2;
    UIView* customView;
    UIToolbar* toolBar;
    UIImageView *img1;
    UIImageView *img2;
    UIImageView *img3;
    UIImageView *img4;
    UIImageView *img5;
    UIImageView *img6;
    UIImageView *img7;
    UIImageView *img8;
        //PBDetailAnLiData *detailAnli;
    PBAddAnLiData *addAnli;
    
    PBProjectStageViewController *psVC;
    PBSearchsProjectsViewController *spVC;
    
    PBEDViewController *edVC;
    PBEDITViewController *edit2VC;
    
    NSMutableArray *detailArr;
    CGFloat labelWidth;
    PBActivityIndicatorView *indicator;
}

@property (nonatomic,retain) PBAddAnLiData *addAnli;
@property (nonatomic, retain) UITextField *dateTextField;
@property (nonatomic, retain) NSMutableDictionary *mutableDic;
@property (nonatomic, retain)UILabel *labeljieshao;
@property (nonatomic,retain) UILabel *nameLabel;
@property (nonatomic,retain) UILabel *rongziLabel;
@property (nonatomic,retain) UILabel *label1;
@property (nonatomic,retain) UILabel *label2;
@property (nonatomic,retain) UILabel *label4;
@property (nonatomic,retain) NSMutableDictionary *data;
@property (nonatomic,retain) NSMutableDictionary *tradeDic;
@property (nonatomic,retain) UIDatePicker *datepicker;
@property(nonatomic ,retain) UITableView *tableView1;
@property (nonatomic,strong) PBParkManager *parkManager;
@property (nonatomic,retain) UILabel *projectLabel;

-(void)setAnimation:(NSTimeInterval)duration view:(UIView *)changeView frame:(CGRect)frame;
-(void)sections;
-(void)caseChange;
-(void)questData;
-(void)saveData;
-(void)getData;

@end
