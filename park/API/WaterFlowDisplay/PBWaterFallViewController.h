//
//  PBWaterFallViewController.h
//  ParkBusiness
//
//  Created by  on 13-3-7.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaterflowView.h"

@interface PBWaterFallViewController : UIViewController<WaterflowViewDelegate,WaterflowViewDatasource,UIScrollViewDelegate>
{
    
    WaterflowView   *flowView;
    NSMutableArray  *imageUrlMutabArr;
    
    int currentPage;
    int count;
        //UITapGestureRecognizer

}

@property(strong, nonatomic) NSMutableArray *imageUrlMutabArr;
@property(readwrite, nonatomic) int currentPage;

//- (CGFloat)flowView:(WaterflowView *)flowView heightForCellAtIndex:(NSInteger)index;

@end
