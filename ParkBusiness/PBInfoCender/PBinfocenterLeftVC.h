//
//  PBinfocenterLeftVC.h
//  ParkBusiness
//
//  Created by China on 13-8-26.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBLeftVC.h"
#import "PBWeiboDataConnect.h"
//@class PBinfocenterLeftVC;
//@protocol PBInfoCenterDataSource <NSObject>
//-(void)get
//
//@end
@protocol SideBarSelectDelegate;
@interface PBinfocenterLeftVC : PBLeftVC<PBWeiboDataDelegate>
@property (assign,nonatomic)id<SideBarSelectDelegate>delegate;

@end
