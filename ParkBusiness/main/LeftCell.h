//
//  LeftCell.h
//  ParkBusiness
//
//  Created by China on 13-8-21.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftCell : UITableViewCell
@property(nonatomic,retain) IBOutlet UIImageView *titleimage;
@property(nonatomic,retain) IBOutlet UILabel *titlestr;
@property(nonatomic,retain) IBOutlet UIImageView *cellLine;
@property(nonatomic,retain) IBOutlet UIImageView *accstory;
@property(nonatomic,retain) IBOutlet UILabel *detail_lb;
@property(nonatomic,retain) IBOutlet UIButton *unreadmessage;
@end
