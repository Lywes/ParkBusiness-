//
//  PBDropManage.h
//  ParkBusiness
//
//  Created by QDS on 13-5-30.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PBDropManage;
@protocol DropDelegate
- (void) dropDelegateMethod: (PBDropManage *) sender;
@end

@interface PBDropManage : UIView <UITableViewDelegate, UITableViewDataSource>{
    BOOL isAsync;
}

@property (nonatomic, retain) id <DropDelegate> delegate;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* rowno;
@property (nonatomic, retain) UIImage* image;
@property (nonatomic, assign) int row;
-(void)hideDropDown:(UIButton *)b;
- (id)showDropDown:(UIButton *)b height:(CGFloat *)height arr:(NSArray *)arr imageView:(NSArray *)imgArr isAsync:(BOOL)is;
@end