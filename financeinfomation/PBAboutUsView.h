//
//  PBAboutUsView.h
//  ParkBusiness
//
//  Created by 上海 on 13-7-3.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBActivityIndicatorView.h"
@interface PBAboutUsView : UIViewController<UIWebViewDelegate>
{
    PBActivityIndicatorView* indicator;
}
@property(nonatomic,retain)UIWebView *webview;

@end
