//
//  FAChatView.h
//  FASystemDemo
//
//  Created by Hot Hot Hot on 12-12-21.
//  Copyright (c) 2012年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FAPush.h"
#import "FAMessageData.h"

@interface FAChatView : UITableViewController<FAPushNotificationObserver>
{
    
    
    //保存组名的数组
    NSMutableArray* key_;
    //以字典形式保存表格的数据资源
    NSMutableDictionary* dataSource_;
    
    
}
@end
