//
//  PBDetailQAViewController.h
//  ParkBusiness
//
//  Created by  on 13-3-7.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBDetailQAViewController : UIViewController

@property (nonatomic,retain) NSMutableDictionary *data;
@property (nonatomic, retain) IBOutlet UITextView *contentTextView;
@property (nonatomic, retain) IBOutlet UILabel *QLabel;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;

@end
