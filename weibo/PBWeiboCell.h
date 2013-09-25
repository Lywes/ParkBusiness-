//
//  PBWeiboCell.h
//  ParkBusiness
//
//  Created by lywes lee on 13-3-13.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomImageView.h"
@interface PBWeiboCell : UITableViewCell
-(void)initCellFrame;
@property(nonatomic,readwrite,retain)IBOutlet CustomImageView* imageViews;
@property(nonatomic,readwrite,retain)IBOutlet UITextView* textView;
@property(nonatomic,readwrite,retain)IBOutlet UIImageView* customImage1;
@property(nonatomic,readwrite,retain)IBOutlet UIImageView* customImage2;
@property(nonatomic,readwrite,retain)IBOutlet UILabel* customlabel1;
@property(nonatomic,readwrite,retain)IBOutlet UILabel* customlabel2;
@property(nonatomic,readwrite,retain)IBOutlet UILabel* customlabel3;
@property(nonatomic,readwrite,retain)IBOutlet UILabel* customlabel4;
@property(nonatomic,readwrite,retain)IBOutlet UILabel* customlabel5;
@property(nonatomic,readwrite,retain)IBOutlet UIButton* custombutton1;
@property(nonatomic,readwrite,retain)IBOutlet UIButton* custombutton2;
@property(nonatomic,readwrite,retain)IBOutlet UIButton* custombutton3;
@end
