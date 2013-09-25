//
//  PBWebViewController.h
//  ParkBusiness
//
//  Created by China on 13-9-4.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBActivityIndicatorView.h"
@interface PBWebViewController : UIViewController<UIWebViewDelegate>{
    PBActivityIndicatorView* indicator;
}
@property(nonatomic,retain)NSString* url;
@end
