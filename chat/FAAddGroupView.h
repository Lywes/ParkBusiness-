//
//  FAAddGroupView.h
//  ParkBusiness
//
//  Created by lywes lee on 13-4-12.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FAAddGroupViewDelegete;
@interface FAAddGroupView : UIView
-(void)addGroupViewWillShow;
@property(nonatomic,assign) id <FAAddGroupViewDelegete> delegate;
@property(nonatomic,retain)UIView* labelView;@property(nonatomic,retain)UITextField* groupText;
@property(nonatomic,retain)UILabel* groupLabel;
@end
@protocol FAAddGroupViewDelegete
- (BOOL)submitDidPushWithName:(NSString*)groupName;
@end