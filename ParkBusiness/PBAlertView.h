//
//  PBAlertView.h
//  ParkBusiness
//
//  Created by 上海 on 13-8-11.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBAlertView : UIView{
    UILabel* label;
    UIView* view;
}
-(void)show;
-(id)initWithMessage:(NSString*)message;
@end
