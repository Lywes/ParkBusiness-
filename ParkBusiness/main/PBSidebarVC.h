//
//  PBSidebarVC.h
//  PBParkBusiness
//
//  Created by China on 13-8-19.
//  Copyright (c) 2013年 WINSEN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SideBarSelectedDelegate.h"
#import "PBdataClass.h"
#import "MoveButton.h"
typedef void (^PANGes)(UIPanGestureRecognizer *);
@interface PBSidebarVC : UIViewController<SideBarSelectDelegate,UINavigationControllerDelegate,PBdataClassDelegate,MoveButtonDelegate>

@property (strong,nonatomic) UIView *contentView;
@property (strong,nonatomic) UIView *navBackView;
@property (strong,nonatomic) MoveButton *btn_friend;
@property (assign,nonatomic) BOOL sideBarShowing;
@property (assign,nonatomic) BOOL justShowLeftBar;
@property (assign,nonatomic) PANGes pangesBlock;
+ (id)share;
- (void)moveAnimationWithDirection:(SideBarShowDirection)direction duration:(float)duration
;
@end
