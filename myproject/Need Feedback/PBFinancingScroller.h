//
//  PBFinancing.h
//  ParkBusiness
//
//  Created by China on 13-7-10.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBFinancingScroller : UIScrollView<UIScrollViewDelegate>
@property (nonatomic, retain) NSArray *viewNameArray;

+ (PBFinancingScroller *)shareInstance;

@end
