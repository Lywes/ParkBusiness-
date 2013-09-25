//
//  UIImageView+CreditLevel.m
//  ParkBusiness
//
//  Created by 上海 on 13-8-27.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "UIImageView+CreditLevel.h"

@implementation UIImageView(CreditLevel)

-(int)getLevelWithCredit:(int)credit{
    int level = 1;
    if (credit<100) {//一级会员
        
    }else if(credit<1000){//二级会员
        level = 2;
    }else if(credit<2000){//三级会员
        level = 3;
    }else if(credit<5000){//四级会员
        level = 4;
    }else {//五级会员
        level = 5;
    }
    return level;
}
-(int)getLevelWithScore:(float)score{
    int level = 0;
    if (score<1.0) {//一级
    }else if (score<2.0) {//一级
        level = 1;
    }else if(score<3.0){//二级
        level = 2;
    }else if(score<4.0){//三级
        level = 3;
    }else if(score<5.0){//四级
        level = 4;
    }else {//五级
        level = 5;
    }
    return level;
}
-(void)setStarImageWithCredit:(int)credit{
    int level = [self getLevelWithCredit:credit];
    [self setimageWithLevel:level];
}
-(void)setStarImageWithScore:(float)score isImage:(BOOL)isimage{
    int level = [self getLevelWithScore:score];
    if (isimage) {
        [self setimageWithLevel:level];
    }
}

-(void)setimageWithLevel:(int)level{
    CGFloat height = self.frame.size.height;
    for (int i = 0; i<level; i++) {
        UIImageView* starImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"levelstar_highlight"]];
        starImage.frame = CGRectMake(i*height, 0, height, height);
        [self addSubview:starImage];
    }
    for (int i = 0; i<5-level; i++) {
        UIImageView* starImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"levelstar_normal"]];
        starImage.frame = CGRectMake((level+i)*height, 0, height, height);
        [self addSubview:starImage];
    }

}

@end
