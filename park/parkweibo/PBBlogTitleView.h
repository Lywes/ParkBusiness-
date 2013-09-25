//
//  PBBlogTitleView.h
//  ParkBusiness
//
//  Created by  on 13-3-26.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomImageView.h"
@interface PBBlogTitleView : UIView

@property(nonatomic,retain)UITextView *introduceTextView;
@property(nonatomic,readwrite,retain)UILabel *customlb1;
@property(nonatomic,readwrite,retain)UILabel *customlb2;
@property(nonatomic,readwrite,retain)UILabel *customlb3;
@property(nonatomic,readwrite,retain)UIButton *custombtn1;
@property(nonatomic,readwrite,retain)UIButton *custombtn2;
@property(nonatomic,readwrite,retain)CustomImageView *imageView;

@end
