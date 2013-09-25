//
//  CustomTabBar.h
//  CustomTabBar
//
//  Created by Peter Boctor on 1/2/11.
//
// Copyright (c) 2011 Peter Boctor
// 

@class CustomTabBar;
@protocol CustomTabBarDelegate
- (UIImage*) imageFor:(CustomTabBar*)tabBar atIndex:(NSUInteger)itemIndex;
- (NSString*) titleFor:(CustomTabBar*)tabBar atIndex:(NSUInteger)itemIndex;

- (UIImage*) backgroundImage;
- (UIImage*) selectedItemBackgroundImage;
- (UIImage*) selectedItemImage;
- (UIImage*) tabBarArrowImage;


@optional
- (void) touchUpInsideItemAtIndex:(NSUInteger)itemIndex;
- (void) touchDownAtItemAtIndex:(NSUInteger)itemIndex;
@end

@interface CustomTabBar:UIView
{
  NSMutableArray* buttons;
}

@property (nonatomic, retain) NSMutableArray* buttons;
@property (nonatomic, retain) NSObject <CustomTabBarDelegate> *delegate;
- (id) initWithItemCount:(NSUInteger)itemCount itemSize:(CGSize)itemSize tag:(NSInteger)objectTag delegate:(NSObject <CustomTabBarDelegate>*)customTabBarDelegate;
- (void) selectItemAtIndex:(NSInteger)index;

@end
