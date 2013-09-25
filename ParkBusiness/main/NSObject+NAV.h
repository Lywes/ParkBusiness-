//
//  NSObject+NAV.h
//  ParkBusiness
//
//  Created by China on 13-8-22.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSObject (NAV)

-(void)customNavLeft:(UIViewController *)controller withBlock:(void(^)(void))block;
-(void)customNavRight:(UIViewController *)controller;
-(void)customNav:(UINavigationController *)nav;
- (UIViewController *) customButtom:(UIViewController *) viewController;
-(void)SaveTextDic:(NSDictionary *)dic;
-(NSDictionary *)getTextDic;
@end
