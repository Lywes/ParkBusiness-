//
//  PBLeftVC.h
//  PBParkBusiness
//
//  Created by China on 13-8-19.
//  Copyright (c) 2013年 WINSEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBdataClass.h"
#import "PBInsertDataConnect.h"
@protocol SideBarSelectDelegate;
@interface PBLeftVC : UIViewController<UITableViewDataSource,UITableViewDelegate,PBdataClassDelegate,PBInsertDataDelegate>
{
    NSArray *_dataList;
    NSArray *_imageList;
    NSIndexPath * oldindex;
    BOOL click;
}
-(BOOL)checkIdentify:(NSString*)str;
@property (retain,nonatomic)UITableView *mainTableView;
@property (assign,nonatomic)id<SideBarSelectDelegate>delegate;

@property (retain,nonatomic) NSArray *_dataList;
@property (retain,nonatomic) NSArray *_imageList;
@property (retain,nonatomic) NSArray *_image_HGList;
@property (retain,nonatomic) NSArray *_detailList;
@end
