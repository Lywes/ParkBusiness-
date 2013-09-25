//
//  PBWebVC.h
//  PBBank
//
//  Created by lywes lee on 13-5-10.
//  Copyright (c) 2013年 shanghai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBActivityIndicatorView.h"
@interface PBWebVC : UIViewController<UIWebViewDelegate>
{
    PBActivityIndicatorView *activity;
}
@end
