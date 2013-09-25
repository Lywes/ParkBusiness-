//
//  PBCustomDropView.h
//  ParkBusiness
//
//  Created by QDS on 13-4-15.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBCustomDropView : UIView
-(void)setSelectViewWithTitle:(NSString*)title image:(UIImage*)image;
@property(nonatomic,readwrite,retain)UILabel* customlb;
@property(nonatomic,readwrite,retain)UIImageView* backGroundView;
@property(nonatomic,readwrite,retain)UIImageView* imageView1;
@property(nonatomic,readwrite,retain)UIImageView* imageView2;
@end
