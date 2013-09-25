//
//  PBFinanceNeedsView.h
//  ParkBusiness
//
//  Created by wangzhigang on 13-7-11.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "POPView.h"
#import "PBMultiPopView.h"
#import "PBPopListView.h"
@class PBFinanceNeedsView;
@protocol PBFinanceNeedsDelegate <NSObject>
-(void)popViewWillShow:(NSMutableDictionary*)dic;
@end
@interface PBFinanceNeedsView : UIViewController<UIListViewDelegate,PBListViewDelegate,UITextViewDelegate,UITableViewDataSource,UITableViewDelegate>{
    UITableView* tableView;
    UIControl* _overlayView;
    //POPview
    NSArray* titleArr;
    POPView *pop;
    PBMultiPopView* multipop;
    UIButton* submit;
    //本地表
    NSMutableArray *industry;
    NSMutableArray *yearsale;
    NSMutableArray* difficulty;
    NSMutableArray *period;
    NSMutableArray *raterange;
    NSMutableArray *fund;
}
-(void)hidden;
-(void)dismiss;
-(BOOL)checkText;
-(void)setSubmitBtn:(BOOL)enabled;
-(void)show:(UINavigationController*)navi;
-(void)initPopView:(UIViewController*)controller;
@property(nonatomic,assign)id<PBFinanceNeedsDelegate> delegate;
@property(nonatomic,retain)UILabel *fundLabel;
@property(nonatomic,retain)UITextView* fundused;
@property(nonatomic,retain)UILabel* periodLabel;//融资周期
@property(nonatomic,retain)UILabel* rateLabel;//年利率
@property(nonatomic,retain)UILabel* difficultyLabel;//困难
@property(nonatomic,retain)UILabel *tradeLabel;//行业
@property(nonatomic,retain)UILabel *yearsaleLabel;//年销售额
@end
