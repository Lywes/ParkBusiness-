//
//  PBActivityIndicatorView.h
//  ParkBusiness
//
//  Created by lywes lee on 13-4-8.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBActivityIndicatorView: UIView{
    UIActivityIndicatorView* indicator;
    UILabel* label;
    UIView* view;
}
-(void)setTitle:(NSString*)title;
-(void)startAnimating;
-(void)stopAnimating;
@end
