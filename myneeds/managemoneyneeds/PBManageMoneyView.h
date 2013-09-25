//
//  PBManageMoneyView.h
//  ParkBusiness
//
//  Created by wangzhigang on 13-7-11.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POPView.h"
#import "PBPopListView.h"
@class PBManageMoneyView;
@protocol PBManageMoneyDelegate <NSObject>
-(void)popViewWillShow:(NSMutableDictionary*)dic;
@end
@interface PBManageMoneyView : UIViewController<UIListViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    UITableView* tableView;
    UIControl* _overlayView;
    POPView *pop;
    //本地表
    NSMutableArray *timeperiod;//时间周期
    NSMutableArray *mmtype;//理财类型
    NSMutableArray *earor;//期望年回报率
    NSArray* titleArr;
    UIButton* submit;
}
-(void)hidden;
-(void)dismiss;
-(void)show:(UINavigationController*)navi;
-(BOOL)checkText;
-(void)setSubmitBtn:(BOOL)enabled;
-(void)initPopView:(UIViewController*)controller;
@property(nonatomic,assign)id<PBManageMoneyDelegate> delegate;
@property(nonatomic,retain)UITextField *availablefund;
@property(nonatomic,retain)UILabel* typeLabel;//理财类型
@property(nonatomic,retain)UILabel* expectreturn;//期望年回报率
@property(nonatomic,retain)UILabel* timeperiodLabel;//时间周期
@end
