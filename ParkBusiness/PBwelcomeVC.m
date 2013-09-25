//
//  PBwelcomeVC.m
//  ParkBusiness
//
//  Created by China on 13-8-13.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBwelcomeVC.h"
@interface PBwelcomeVC ()

@end
@implementation UIScrollView(TOUCH)
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
    if(!self.dragging) {
        [[self nextResponder] touchesBegan:touches withEvent:event];
    }
    [super touchesBegan:touches withEvent:event];
}
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    if(!self.dragging) {
        [[self nextResponder] touchesEnded:touches withEvent:event];
    }
    [super touchesEnded:touches withEvent:event];
}
@end

@implementation PBwelcomeVC
-(void)dealloc{
    RB_SAFE_RELEASE(scrollview);
    RB_SAFE_RELEASE(pageControl);
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //定义scrollview 
    scrollview = [[UIScrollView alloc ]initWithFrame:self.view.frame];
    scrollview.contentSize = CGSizeMake(self.view.frame.size.width * 5, self.view.frame.size.height);
    scrollview.delegate = self;
    scrollview.showsVerticalScrollIndicator = NO;
//    scrollview.canCancelContentTouches = YES;
    scrollview.showsHorizontalScrollIndicator = NO;
    
    //myScrollView.clipsToBounds = YES;
    
    scrollview.delegate = self;
    
    scrollview.scrollEnabled = YES;
    
    scrollview.pagingEnabled = YES; //使用翻页属性
    
    scrollview.bounces = NO;
    [scrollview setCanCancelContentTouches:YES];
    
    //滚动的时候是否可以除边界，即到边界的时候是否可以多看到一点内容
    [scrollview setBounces:NO];
    
    // 当值是NO 立即调用 touchesShouldBegin:withEvent:inContentView 看是否滚动 scroll
    [scrollview setDelaysContentTouches:NO];
    for (NSInteger i = 0; i<5; i++) {
        
        if (i == 4) {
            UIViewController *controller = [[UIViewController alloc] init];
            controller.view.frame = CGRectMake(i*self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
            UIImageView * imageview;
            if (isPad()) {
                imageview= [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"pad%d",i+1]]];
            }
            else
            {
                imageview  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%dpsd",i+1]]];
            }
            imageview.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [controller.view addSubview:imageview];
            [imageview release];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            //            UIImage *image = [UIImage imageNamed:@"star.png"];
            //            [btn setImage:image forState:UIControlStateNormal];
            //            [btn setFrame:CGRectMake(self.view.frame.size.width/2-image.size.width/4, isPad()?700:300, image.size.width/2, image.size.height/2)];
            //            [btn setBackgroundColor:[UIColor redColor]];
            [btn setFrame:CGRectMake(self.view.frame.size.width/2-300/2, isPad()?880:395, 300, 90)];
            [btn addTarget:self action:@selector(didLable:) forControlEvents:UIControlEventTouchDown];
            [controller.view addSubview:btn];
            [scrollview addSubview:controller.view];
            [controller release];
        }
        else{
            UIImageView * imageview;
            if (isPad()) {
                imageview= [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"pad%d",i+1]]];
            }
            else
            {
                imageview  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%dpsd",i+1]]];
            }
            imageview.frame = CGRectMake(i*self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height);
            [scrollview addSubview:imageview];
            [imageview release];
            
        }
        
        
        
    }
   //定义PageControll
    
    pageControl = [[PBPageControl alloc] init];
    
    CGFloat a = isPad()?(self.view.frame.size.height - 100):(self.view.frame.size.height - 50);
    pageControl.frame = CGRectMake(self.view.frame.size.width/2 - 50, a, 100, 20);//指定位置大小
        
    pageControl.numberOfPages = 5;//指定页面个数
//    if (IOS6) {
//        pageControl.pageIndicatorTintColor = [UIColor grayColor];
//    }
    pageControl.currentPage = 0;//指定pagecontroll的值，默认选中的小白点（第一个）
    
    [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
    //添加委托方法，当点击小白点就执行此方法
    
    [self.view addSubview:scrollview];
    
    [self.view addSubview:pageControl];
}
//scrollview的委托方法，当滚动时执行

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    int page = scrollview.contentOffset.x / self.view.frame.size.width;//通过滚动的偏移量来判断目前页面所对应的小白点
    
    pageControl.currentPage = page;//pagecontroll响应值的变化
    
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    
    
}
- (void)changePage:(id)sender {
    
    int page = pageControl.currentPage;//获取当前pagecontroll的值
    
    [scrollview setContentOffset:CGPointMake(self.view.frame.size.width * page, 0)];//根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
    
}
-(void)didLable:(id)tap{

    [self dismissModalViewControllerAnimated:NO];
//    [self.navigationController popViewControllerAnimated:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
