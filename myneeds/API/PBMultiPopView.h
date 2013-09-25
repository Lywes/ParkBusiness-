//
//  PBMultiPopView.h
//  ParkBusiness
//
//  Created by 上海 on 13-7-16.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBPopListView.h"
@class PBMultiPopView;
@protocol PBListViewDelegate
@optional
- (void)popView:(PBMultiPopView *)popview;
- (void)popView:(PBMultiPopView *)popview didSelectIndexPath:(NSIndexPath *)indexPath;
@end
@interface PBMultiPopView : UIViewController<PBPopoverListViewDataSource, PBPopoverListViewDelegate,UITextFieldDelegate>{
    NSMutableArray* checkArr;
    UITextField * otherReason;
    PBPopListView *poplistview;
}
@property(nonatomic,retain)NSMutableArray *_arry;
@property(nonatomic,retain)NSString *dataStr;
@property(nonatomic,retain)NSString *name;
@property(nonatomic,assign)id<PBListViewDelegate>delegate;
- (void)popClickAction;
@end
