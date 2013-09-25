//
//  NSObject+NAV.m
//  ParkBusiness
//
//  Created by China on 13-8-22.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "NSObject+NAV.h"
#import "PBSidebarVC.h"
#import "PBinfoCenter.h"
#import <objc/runtime.h>
@implementation NSObject (NAV)

const char ZXObjectBlcok;
-(void)customNavLeft:(UIViewController *)controller withBlock:(void(^)(void))block{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(3, 1.5, 40, 40);
    btn.tag = 100;
    [btn addTarget:self action:@selector(backHomeView:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"left_back.png"] forState:UIControlStateNormal];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
    controller.navigationItem.leftBarButtonItem = barButton;
    
    
    NSMutableDictionary *eventHandlerDictionary = objc_getAssociatedObject(self,&ZXObjectBlcok);
    if(eventHandlerDictionary == nil)
    {
        eventHandlerDictionary = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, &ZXObjectBlcok, eventHandlerDictionary, OBJC_ASSOCIATION_RETAIN);
    }
    [eventHandlerDictionary setObject:block forKey:@"ZXObjectBlcok"];
    
}
-(void)customNavRight:(UIViewController *)controller{
    int64_t delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.tag = 101;
        btn1.frame = CGRectMake(3, 1.5, 40, 40);
        [btn1 addTarget:self action:@selector(backHomeView:) forControlEvents:UIControlEventTouchUpInside];
        [btn1 setBackgroundImage:[UIImage imageNamed:@"right_back.png"] forState:UIControlStateNormal];
        UIBarButtonItem *barButton1 = [[UIBarButtonItem alloc] initWithCustomView:btn1];
        controller.navigationItem.rightBarButtonItem = barButton1;
    });
}
-(void)customNav:(UINavigationController *)nav{
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"main_top.jpg"] forBarMetrics:UIBarMetricsDefault];
    nav.navigationBar.barStyle = UIBarStyleBlack;
    
}
#pragma mark - 可移动view的左右两个按钮事件
-(void)backHomeView:(UIButton *)btn{
    [btn becomeFirstResponder];
    if (btn.tag == 100) {
        NSDictionary *eventHandlerDictionary = objc_getAssociatedObject(self,&ZXObjectBlcok);
        void(^blcok)(void) = [eventHandlerDictionary objectForKey:@"ZXObjectBlcok"];
        blcok();
    }
    else{
        if ([[PBSidebarVC share] respondsToSelector:@selector(showSideBarControllerWithDirection:)] && [[PBSidebarVC share] sideBarShowing] == NO) {
            [[PBSidebarVC share] showSideBarControllerWithDirection:SideBarShowDirectionRight];
        }
        else if ([[PBSidebarVC share] sideBarShowing] == YES){
            [[PBSidebarVC share] showSideBarControllerWithDirection:SideBarShowDirectionNone];
        }
    }
}
#pragma mark - 返回按钮与nav的北京图片设置
const char ZXObjectSingleObjectDictionary;

- (UIViewController *) customButtom:(UIViewController *) viewController
{
//    NSMutableDictionary *eventHandlerDictionary = objc_getAssociatedObject(self,&ZXObjectSingleObjectDictionary);

         NSMutableDictionary * eventHandlerDictionary = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, &ZXObjectSingleObjectDictionary, eventHandlerDictionary, OBJC_ASSOCIATION_RETAIN);
    
    [eventHandlerDictionary setObject:viewController forKey:@"ZXObjectSingleObjectDictionary"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(7, 7, 25, 30);
    [btn addTarget:self action:@selector(backHomeView1) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
    viewController.navigationItem.leftBarButtonItem = barButton;
    [barButton release];
    return viewController;
    
    

}
-(void)backHomeView1
{
    NSDictionary *eventHandlerDictionary = objc_getAssociatedObject(self,&ZXObjectSingleObjectDictionary);
    UIViewController *controller = [eventHandlerDictionary objectForKey:@"ZXObjectSingleObjectDictionary"];
    if (controller.navigationController.viewControllers.count>1) {
        [controller.navigationController popViewControllerAnimated:YES];
    }
    else
        [controller dismissModalViewControllerAnimated:YES];
    
 
}

#pragma mark - 保存输入界面的text
const char ZXObjectSaveDictionary;
static NSMutableDictionary *even = nil;
-(void)SaveTextDic:(NSDictionary *)dic{
   even = objc_getAssociatedObject(self,&ZXObjectSaveDictionary);
    if(even == nil)
    {
        even = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, &ZXObjectSaveDictionary, even, OBJC_ASSOCIATION_RETAIN);
    }
    
    [even setObject:dic forKey:@"ZXObjectSaveDictionary"];

}
-(NSDictionary *)getTextDic{
    if (even != nil) {
        NSDictionary * dic = [even objectForKey:@"ZXObjectSaveDictionary"];
        return dic;
    }
    else
    {
        return 0;
    }
}
@end
