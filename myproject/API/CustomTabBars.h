//
//  CustomTabBar.h
//  UI
//
//  Created by lywes lee on 13-2-25.
//  Copyright (c) 2013年 shanghai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTabBars : UITabBarController
{
    NSMutableArray *buttons;
    int currentSelectedIndex;
    UIImageView *slideBg;
}
@property (nonatomic,assign) int currentSelectedIndex;
@property (nonatomic,retain) NSMutableArray *buttons;

- (void)hideRealTabBar;
- (void)customTabBar;
- (void)selectedTab:(UIButton *)button;
@end
