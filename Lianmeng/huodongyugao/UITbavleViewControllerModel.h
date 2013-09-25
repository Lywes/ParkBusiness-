//
//  UITbavleViewControllerModel.h
//  PBBank
//
//  Created by lywes lee on 13-5-7.
//  Copyright (c) 2013年 shanghai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBdataClass.h"
#import "PBActivityIndicatorView.h"
#import "PBRefreshTableHeaderView.h"

typedef enum 
{
    BAOMING = 0,
    FASONG = 1,
    WANCHENG,
}RIGHTNAVBUTTON;
@interface UITbavleViewControllerModel : UITableViewController<PBdataClassDelegate,UITextViewDelegate,UITextFieldDelegate,PBRefreshTableHeaderDelegate>
-(void)navigatorRightButtonType:(RIGHTNAVBUTTON)type;//右边导航键（官方样式）
-(void)NvBtnPress:(id)sender;//与楼上方法配套使用

-(void)navigatorRightButtonNme:(NSString *)name backimageName:(NSString *)imagename;//右边导航键（自定义贴图）
-(void)rightBarButtonItemPress:(id)sender;//与楼上方法配套使用

-(void)editButtonPress:(id)sender;//右边导航键响应事件
-(void)backUpView;//添加返回按钮并且实现返回上级页面
-(void)showAlertViewWithMessage:(NSString *)message;//提示框;
-(void)ExitenceNetwork:(NSString *)urlstr;//判断什么网络并且加载网络或者下载。
@property(nonatomic,retain)NSMutableArray *headArr;//每个cell上前面的提示标题
@property(nonatomic,retain)NSMutableArray *DataArr;//每个cell上正式内容
@property(nonatomic,retain)NSMutableDictionary *DataDic;//每个cell上正式内容
@property(nonatomic,retain)PBdataClass *dataclass;//网络请求
@property(nonatomic,retain)NSString *stylename;//判断类型;(跳转到共同类的时候需要用到此属性)
@property(nonatomic,retain)PBActivityIndicatorView *activity;//加载动画;
@property(nonatomic,readonly)BOOL isExitenceNetwork; //判断s

#pragma mark - 一般的add方法
-(UILabel *)addshortLable;//cell上添加较短的lable；
-(UILabel *)addLongLable;//cell上添加较长的lable；
-(UITextView *)addtextview;//cell上添加textview;
-(UITextField *)addtextfield;

//下拉刷新实现的属性及方法
@property (strong, nonatomic) PBRefreshTableHeaderView *refreshHeaderView;
@property (assign, nonatomic)BOOL reloading;
- (void)initRefreshView;
- (void)begainreloadTableViewDataSource;
- (void)finishdoneLoadingTableViewData;

@end
