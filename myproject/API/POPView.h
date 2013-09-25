//
//  POPView.h
//  ParkBusiness
//
//  Created by 新平 圣 on 13-3-24.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPopoverListView.h"
@class POPView;
@protocol UIListViewDelegate
@optional
- (void)popView:(POPView *)popview didSelectIndexPath:(NSIndexPath *)indexPath;
@end
@interface POPView : UIViewController<UIPopoverListViewDataSource, UIPopoverListViewDelegate>
@property(nonatomic,retain)NSMutableArray *_arry;
@property(nonatomic,retain)NSString *name;
@property(nonatomic,assign)id<UIListViewDelegate>delegate;
- (void)popClickAction;
@end
