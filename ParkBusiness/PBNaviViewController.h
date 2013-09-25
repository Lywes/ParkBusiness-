//
//  PBNaviViewController.h
//  ParkBusiness
//
//  Created by wangzhigang on 13-4-3.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTabBar.h"

@interface PBNaviViewController : UITabBarController<CustomTabBarDelegate>{
    int tag;
}

//@property (nonatomic, retain) CustomTabBar *tabBar;
@property (nonatomic, retain) NSArray *tabBarItems;

- (UIViewController *) customButtomItem:(UIViewController *) viewController;
@end
