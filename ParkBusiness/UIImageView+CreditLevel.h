//
//  UIImageView+CreditLevel.h
//  ParkBusiness
//
//  Created by 上海 on 13-8-27.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView(CreditLevel)
-(int)getLevelWithScore:(float)score;
-(void)setStarImageWithCredit:(int)credit;
-(void)setStarImageWithScore:(float)score isImage:(BOOL)isimage;
@end
