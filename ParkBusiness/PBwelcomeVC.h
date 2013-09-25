//
//  PBwelcomeVC.h
//  ParkBusiness
//
//  Created by China on 13-8-13.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBPageControl.h"
@interface PBwelcomeVC : UIViewController<UIScrollViewDelegate>
{
    UIScrollView *scrollview;
    PBPageControl * pageControl;
}
@end
@interface UIScrollView(TOUCH)
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event;
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event;
@end