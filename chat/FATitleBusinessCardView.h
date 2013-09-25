//
//  FATitleBusinessCardView.h
//  FASystemDemo
//
//  Created by wangzhigang on 12-12-26.
//  Copyright (c) 2012年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FAChatManager.h"
#import "FAFriendData.h"

@interface FATitleBusinessCardView : UITableViewController<FAChatManagerDelegate>
{
    UIImageView* imageView;
    UILabel* label;
    NSMutableArray *groupArr;
    NSMutableArray* dataSource_;
    FAFriendData *frienddata;
    UILabel *signature;
    
}
@property(nonatomic,readwrite) int friendid;
@property(nonatomic,readwrite) BOOL friendflg;
@end
