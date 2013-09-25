//
//  NIDropDown.h
//  ParkBusiness
//
//  Created by lywes lee on 13-3-15.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PBDropDown;
@protocol NIDropDownDelegate
- (void) pbDropDownDelegateMethod: (PBDropDown *) sender;
@end 

@interface PBDropDown : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) id <NIDropDownDelegate> delegate;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* rowno;
@property (nonatomic, assign) int row;
@property (nonatomic, retain) UIImage* image;
-(void)hideDropDown:(UIButton *)b;
- (id)showDropDown:(UIButton *)b height:(CGFloat *)height arr:(NSArray *)arr imageView:(NSArray *)imgArr;
@end
