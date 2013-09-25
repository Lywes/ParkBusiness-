//
//  PBHelpView.h
//  ParkBusiness
//
//  Created by lywes lee on 13-4-21.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBHelpView : UIViewController<UIWebViewDelegate>
{
    
}
@property(nonatomic,retain)UIWebView *webview;
@property(nonatomic,retain)UIActivityIndicatorView *activity;
@end
