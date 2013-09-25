//
//  FABusinessCardView.h
//  FASystemDemo
//
//  Created by Hot Hot Hot on 12-12-24.
//  Copyright (c) 2012年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FATitleBusinessCardView.h"
#import "FAConentViewViewController.h"


@interface FABusinessCardView : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UINavigationController* navigation1;
    UINavigationController* navigation2;
    FAConentViewViewController* conentView;
    FATitleBusinessCardView* titleView;
    
    NSArray* sections_;
    NSArray* dataSource_;
}

@end
