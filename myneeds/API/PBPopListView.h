//
//  PBPopListView.h
//  ParkBusiness
//
//  Created by 上海 on 13-7-16.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PBPopListView;

@protocol PBPopoverListViewDataSource <NSObject>
@required

- (UITableViewCell *)popoverListView:(PBPopListView *)popoverListView
                    cellForIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)popoverListView:(PBPopListView *)popoverListView
       numberOfRowsInSection:(NSInteger)section;
@optional
-(NSInteger)popoverNumberOfSectionsListView:(PBPopListView *)popoverListView;
- (NSString*)popoverListView:(PBPopListView *)popoverListView
       titleForHeaderInSection:(NSInteger)section;
@end

@protocol PBPopoverListViewDelegate <NSObject>
@optional
- (void)submitBtnDidPush;

- (void)popoverListView:(PBPopListView *)popoverListView
     didSelectIndexPath:(NSIndexPath *)indexPath;

- (void)popoverListViewCancel:(PBPopListView *)popoverListView;

- (CGFloat)popoverListView:(PBPopListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface PBPopListView : UIView <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_listView;
    UILabel     *_titleView;
    UIControl   *_overlayView;
    UIButton* submitBtn;
    
    id<PBPopoverListViewDataSource> _datasource;
    id<PBPopoverListViewDelegate>   _delegate;
    
}

@property (nonatomic, assign) id<PBPopoverListViewDataSource> datasource;
@property (nonatomic, assign) id<PBPopoverListViewDelegate>   delegate;

@property (nonatomic, retain) UITableView *listView;

- (void)setTitle:(NSString *)title;

- (void)show;
- (void)dismiss;

@end
