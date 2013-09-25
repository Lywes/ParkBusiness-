//
//  PBAddCaseViewController.h
//  ParkBusiness
//
//  Created by  on 13-3-16.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBParkManager.h"
#import "PBIndustryClassificationViewController.h"
#import "PBAmountUnitViewController.h"
#import "PBAddAnLiData.h"
#import "PBProjectStageViewController.h"
#import "PBSearchsProjectsViewController.h"
#import "PBEDViewController.h"
@class PBEDITViewController;
#import "PBActivityIndicatorView.h"


@interface PBAddCaseViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,PBParkManagerDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    PBIndustryClassificationViewController *iCVC;
    
    UIDatePicker *datepicker;
    
    NSMutableArray  *sectionArr;
    NSMutableArray  *nodesMutableArr;
    
    UITextField *textField2;
    
    PBAmountUnitViewController *amountUnitVC;
    PBEDViewController *edVC;
    
    UIToolbar* toolBar;
    PBAddAnLiData *addAnli;

    PBProjectStageViewController *psVC;
    PBSearchsProjectsViewController *spVC;
    
    UILabel *labeljieshao;
    PBEDITViewController *edit2VC;
    CGFloat labelWidth;
    CGSize labelSize;
    
    PBActivityIndicatorView *indicator;
    
    UIPickerView *pickerView;
    
}
@property (nonatomic,retain) NSMutableDictionary *mutableDic;
@property (nonatomic,retain) UILabel *labeljieshao;
@property (nonatomic,retain) UILabel *nameLabel;
@property (nonatomic,retain) UILabel *rongziLabel;
@property (nonatomic,retain) PBAddAnLiData *addAnli;
@property (nonatomic,retain) UILabel *label1;
@property (nonatomic,retain) UILabel *label2;
@property (nonatomic,retain) UILabel *label4;
@property (nonatomic,retain) UIDatePicker *datepicker;
@property (nonatomic,retain) PBParkManager *parkManager;
@property(nonatomic ,retain) UITableView *tableView1;
@property (nonatomic,retain) NSString *str1;
@property (nonatomic,retain) UILabel *projectLabel;
-(void)editBtn;
-(void)finish;
-(void)sections;
-(void)saveData;
-(void)getData;
@end
