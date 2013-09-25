//
//  FAFriendController.h
//  FASystemDemo
//
//  Created by wangzhigang on 13-2-14.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FAFriendListView.h"
#import "FAGroupListView.h"

@interface FAFriendController : UIViewController<UIScrollViewDelegate>
{
	//定义UIScrollView与UIPageControl实例变量
	UIScrollView* scrollView;
	UIPageControl* pageControl;
	//定义滚动标志
    BOOL pageControlIsChangingPage;
    
	
    int currentPage;
    FAFriendListView* friendList;
    FAGroupListView* groupList;
    UIButton *friend;
    UIButton *group;
    
}

/* UIPageControll的响应方法 */
- (void)changePage:(id)sender;

/* 内部方法，导入图片并进行UIScrollView的相关设置 */
- (void)setupPage;

@end
