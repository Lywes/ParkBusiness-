//
//  CustomImageView.h
//  ParkBusiness
//
//  Created by QDS on 13-4-1.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AsyncImageView.h"
@interface CustomImageView : UIView
- (id)initWithFrame:(CGRect)frame withBackColor:(UIColor*)color;
@property (nonatomic, retain) AsyncImageView *imageView;
@end
