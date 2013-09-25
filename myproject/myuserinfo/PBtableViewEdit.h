//
//  PBtableViewEdit.h
//  ParkBusiness
//
//  Created by 新平 圣 on 13-3-4.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "PBSendData.h"
typedef enum 
{
    BIANJI = 0,
    ZUIJIA = 1,
    WANCHEN = 2,
    FANKUI = 3,
    NEXT = 4,
    HUIDA = 5,
    
}rightbutton;
@interface PBtableViewEdit : UITableViewController<UITextFieldDelegate,UITextViewDelegate,SuccessSendMessage>
{
    UITextField *projectname;//可修改的项目名称
    UITextView * projectjieshao;//项目介绍
    UILabel *projectjieshao_tishi;//项目介绍
    NSMutableArray* titleArr;//标题名字数组
    UILabel *addlable;
    BOOL isedit;
    int labletag;
    BOOL willAppear;

}
@property(nonatomic,assign)int productno;
@property (nonatomic, retain) PBSendData *collectData;
@property(nonatomic,retain)UITextField *projectname;
@property(nonatomic,retain)UITextView * projectjieshao;
@property(nonatomic,retain)UILabel *projectjieshao_tishi;
@property(nonatomic,retain)UILabel *addlable;
@property(nonatomic,retain)NSString *ProjectStyle;//判断只读操作
@property(nonatomic,retain)NSDictionary *datadic;//从别的页面跳转进来，进行数据只读操作的数据接口
-(CGFloat)textViewHeightWithView:(UITextView*)textView defaultHeight:(CGFloat)defaultHeight;//自定义高度
-(void)navigatorRightButtonType:(rightbutton)type;//在导航上加入右button
-(void)addSubViewForCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;//在cell在加入subview
-(void)addLableForCell:(UITableViewCell *)cell withFram:(CGRect)farm;//cell上加入lable
-(void)addTextfiledForCell:(UITableViewCell *)cell;//cell上加上textfiled
-(void)addTextViewForCell:(UITableViewCell *)cell;//cell 上加上textview
-(void)editButtonPress:(id)sender;//追加或者编辑触发
-(void)postDataOnserver;//上穿数据到服务器。
-(void)editState;
-(void)viewTapped:(UITapGestureRecognizer*)tapGr;//点击空白处键盘小时method
-(void)viewLoding;
-(UIView *)TishiView;//300输入提示,编辑时通过对self.projectjieshao_tishi的hidden属性进行显示与隐藏;
-(void)backButton;
@property(nonatomic,assign)BOOL textViewAndtextFieldHidden;//隐藏textview和textfield的边框

@end
