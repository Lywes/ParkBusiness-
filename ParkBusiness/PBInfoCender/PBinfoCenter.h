//
//  PBinfoCenter.h
//  ParkBusiness
//
//  Created by China on 13-8-26.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SideBarSelectedDelegate.h"
typedef void (^PANGes_infoCenter)(UIPanGestureRecognizer *);
@interface PBinfoCenter : UIViewController<SideBarSelectDelegate,UINavigationControllerDelegate>

@property (strong,nonatomic) UIView *contentView;
@property (strong,nonatomic) UIView *navBackView;
@property (assign,nonatomic) BOOL sideBarShowing;
@property (assign,nonatomic) BOOL justShowLeftBar;
@property (assign,nonatomic) PANGes_infoCenter pangesBlock; //左右滑动事件

+ (id)share;
- (void)moveAnimationWithDirection:(SideBarShowDirection)direction duration:(float)duration
;
@end