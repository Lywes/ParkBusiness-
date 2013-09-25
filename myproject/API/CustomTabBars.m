//
//  CustomTabBar.m
//  UI
//
//  Created by lywes lee on 13-2-25.
//  Copyright (c) 2013年 shanghai. All rights reserved.
//
#define VIEWCONT 3
#import "CustomTabBars.h"

@implementation CustomTabBars

@synthesize currentSelectedIndex;
@synthesize buttons;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //背景
    slideBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottomtabbar.png"]];
    [self.view addSubview:slideBg];
    [self hideRealTabBar];
    [self customTabBar];
}


- (void)hideRealTabBar{
    for(UIView *view in self.view.subviews){
        if([view isKindOfClass:[UITabBar class]]){
            view.hidden = YES;
            break;
        }
    }
}

- (void)customTabBar{

    slideBg.frame = CGRectMake(0, self.tabBar.frame.origin.y, slideBg.image.size.width, slideBg.image.size.height);

    //创建按钮
    self.buttons = [NSMutableArray arrayWithCapacity:VIEWCONT];
    double _width = 320 / VIEWCONT;
    if (isPad()) {
        slideBg.frame = CGRectMake(0, self.tabBar.frame.origin.y, 768, 1024); 
        _width = 768/VIEWCONT;
    }
    double _height = self.tabBar.frame.size.height;
    for (int i = 0; i < VIEWCONT; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage :[UIImage imageNamed:[NSString stringWithFormat:@"image-%d",i+1]] forState:UIControlStateNormal];
        btn.frame = CGRectMake(i*_width,self.tabBar.frame.origin.y, _width, _height);
        [btn addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [self.buttons addObject:btn];
        [self.view  addSubview:btn];
     
    }
    [self selectedTab:[self.buttons objectAtIndex:self.currentSelectedIndex]];
    
}

- (void)selectedTab:(UIButton *)button{
    if (self.currentSelectedIndex == button.tag) {

    }
    
    self.currentSelectedIndex = button.tag;

    //tag值 传给 selectedIndex（每个tabbaritem对应一个index）
    self.selectedIndex = self.currentSelectedIndex;
    if (self.selectedIndex == button.tag) {
        if (isPad()) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"按钮效果%d.png",button.tag]];
            [button setImage:image forState:UIControlStateNormal];
        }
        else {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"按钮效果%d.png",button.tag+3]];
            [button setImage:image forState:UIControlStateNormal];
        }
    }
    for (UIButton *btn in self.buttons) {
        if (btn !=button) {
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"image-%d.png",btn.tag+1]] forState:UIControlStateNormal];
        }
        
    }
    
    [self performSelector:@selector(slideTabBg:) withObject:button];
}

- (void)slideTabBg:(UIButton *)btn{
    [UIView beginAnimations:nil context:nil];  
    [UIView setAnimationDuration:0.20];  
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

@end
