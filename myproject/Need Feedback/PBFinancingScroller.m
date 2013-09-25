//
//  PBFinancing.m
//  ParkBusiness
//
//  Created by China on 13-7-10.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define BTN_TAG 100
#import "PBFinancingScroller.h"
#import "PBFinancingNeedVC.h"
#import "PBLicaiNeedVC.h"
#import "PBGongqiufabuVC.h"

@interface PBFinancingScroller(private)
@end
@implementation PBFinancingScroller
+ (PBFinancingScroller *)shareInstance
{
    static PBFinancingScroller *_financing;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _financing=[[self alloc] initWithFrame:CGRectMake(0, 44, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height-44*3)];
    });
    return _financing;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        
        self.pagingEnabled = YES;
        self.userInteractionEnabled = YES;
        self.bounces = NO;
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        self.contentSize = CGSizeMake(self.bounds.size.width*3, self.bounds.size.height);
        PBFinancingNeedVC *_finnancingvc = [[PBFinancingNeedVC alloc]init];
         _finnancingvc.view.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);;
        PBLicaiNeedVC *_Licaineedvc = [[PBLicaiNeedVC alloc]init];
        _Licaineedvc.view.frame = CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        PBGongqiufabuVC *_gongqiufabuvc = [[PBGongqiufabuVC alloc]init];
        _gongqiufabuvc.view.frame = CGRectMake(self.frame.size.width*2, 0, self.frame.size.width, self.frame.size.height);
        [self addSubview:_gongqiufabuvc.view];
        [self addSubview:_Licaineedvc.view];
        [self addSubview:_finnancingvc.view];
       // 内存问题
//        [_finnancingvc release];
//        [_Licaineedvc release];
//        [_gongqiufabuvc release];


    }
    return self;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x == 0) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"selectBtn" object:[NSNumber numberWithInt:BTN_TAG]];
    }
    else if (scrollView.contentOffset.x == self.bounds.size.width)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"selectBtn" object:[NSNumber numberWithInt:BTN_TAG+ 1]];
    }
    else if (scrollView.contentOffset.x == self.bounds.size.width*2)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"selectBtn" object:[NSNumber numberWithInt:BTN_TAG+ 2]];
    }         
}


@end
