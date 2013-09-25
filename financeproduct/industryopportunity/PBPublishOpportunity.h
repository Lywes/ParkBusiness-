//
//  PBPublishOpportunity.h
//  ParkBusiness
//
//  Created by 上海 on 13-7-1.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBtableViewEdit.h"
#import "PBProjectData.h"
#import "POPView.h"
#import "ImagePickerView.h"
#import "PBdataClass.h"
#import "PBActivityIndicatorView.h"
#import "PBMutabeImageView.h"
@interface PBPublishOpportunity : PBtableViewEdit<UITextFieldDelegate,UITextViewDelegate,UIListViewDelegate,imageviewPickerdelegate,PBdataClassDelegate,PBMutabeImageDelegate>
{
    PBMutabeImageView* mutableImageView;
    PBActivityIndicatorView* acitivity;
    UILabel *tradeLabel;//行业划分
    UITextField *oppTitle;//标题
    UILabel *typeLabel;//类型
    UIImageView *LogImageAC;
    UITextView* content;
    //POPview
    POPView *pop;
    //本地表
    NSMutableArray *industry;
    NSMutableArray *projecttype;
    ImagePickerView *imagepickerview;
    CGFloat height;
    UIImage *NewImage;
}
@property(nonatomic,readwrite,retain)UIViewController* rootController;
@property(nonatomic,retain)NSString *mode;
@property(nonatomic,assign)int type;
@property(nonatomic,retain)NSMutableDictionary *userinfos;//用户数据
@property(nonatomic,assign)int projectno;


@end
