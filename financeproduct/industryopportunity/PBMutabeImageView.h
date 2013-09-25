//
//  PBMutabeImageView.h
//  ParkBusiness
//
//  Created by 上海 on 13-7-1.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PBMutabeImageView;
@protocol PBMutabeImageDelegate <NSObject>
@optional
-(void)addImage;
-(void)goNextView:(int)index;
@end
@interface PBMutabeImageView : UIView{
    UIButton* addBtn;
}
-(void)resetImageView;
@property(nonatomic,assign)id<PBMutabeImageDelegate> delegate;
@property(nonatomic,retain)NSMutableArray* imageArr;
@end
