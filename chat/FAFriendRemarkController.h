//
//  FAFriendRemarkController.h
//  ParkBusiness
//
//  Created by QDS on 13-5-11.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FAFriendRemarkController : UIViewController{
    UITextField* textfield;
}
@property(nonatomic,readwrite) int friendid;
@property(nonatomic,retain) NSString* remark;
@end
