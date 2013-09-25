//
//  FAFriendController.m
//  FASystemDemo
//
//  Created by wangzhigang on 13-2-14.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "FAFriendController.h"
#import "UIImage+Scale.h"

@interface FAFriendController ()

@end

@implementation FAFriendController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIImage* image=[[UIImage imageNamed:@"btn_loan.png"] scaleToSize:CGSizeMake(40.0f, 40.0f)];
        
        UIView *tools = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
        friend = [UIButton buttonWithType:UIButtonTypeCustom];
        [friend sizeToFit];
        UIImage *friendImg1 = [UIImage imageNamed:@"tab2_normal.png"];
        UIImage *friendImg2 = [UIImage imageNamed:@"tab2_over.png"];
        
        [friend setImage:friendImg1 forState:UIControlStateNormal];
        [friend setImage:friendImg2 forState:UIControlStateDisabled];
        
        [friend setFrame:CGRectMake(0, 0, 30, 30)];
        UIImage *groupImg1 = [UIImage imageNamed:@"tab3_normal.png"];
        UIImage *groupImg2 = [UIImage imageNamed:@"tab3_over.png"];
        
        group = [UIButton buttonWithType:UIButtonTypeCustom];
        [group sizeToFit];
        
        [group setImage:groupImg1 forState:UIControlStateNormal];
        [group setImage:groupImg2 forState:UIControlStateDisabled];
        
        [group setFrame:CGRectMake(35, 0, 30, 30)];
        [friend addTarget:self
                   action:@selector(changePageByClickFriend:)
         forControlEvents:UIControlEventTouchUpInside];
        [group addTarget:self
                   action:@selector(changePageByClickGroup:)
         forControlEvents:UIControlEventTouchUpInside];
        [tools addSubview:friend];
        [tools addSubview:group];
        UIBarButtonItem* rightButton=[[UIBarButtonItem alloc] initWithCustomView:tools];
        [tools release];

        
        UIButton *btnView = [ UIButton buttonWithType:UIButtonTypeCustom];
        [btnView setImage:image forState:UIControlStateNormal];
        [btnView sizeToFit];
        [btnView addTarget:self action:@selector(backDidPush) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* leftButton=[[UIBarButtonItem alloc] initWithCustomView:btnView];
        
        
        self.navigationItem.leftBarButtonItem=leftButton;
        
        self.navigationItem.rightBarButtonItem=rightButton;
        self.navigationItem.leftBarButtonItem=leftButton;
        // Custom initialization
        self.tabBarItem=[[[UITabBarItem alloc] initWithTitle:@"好友列表" image:[UIImage imageNamed:@"friend_info_add.png"] tag:0]autorelease];
        [friend setEnabled:NO];
        [group setEnabled:YES];
        self.title = @"好友列表";
        [rightButton release];
        [leftButton release];
    }
    return self;
}
-(void)backDidPush{
    
    [self.parentViewController.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
	//初始化UIScrollView及UIPageControl实例，为了给UIPageControl控件流出显示位置，将起点坐标定为(0, 344)
    friendList=[[FAFriendListView alloc] init];
    groupList=[[FAGroupListView alloc] init];
    CGRect rect = friendList.view.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    
	scrollView = [[UIScrollView alloc] initWithFrame:rect];
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 344, 320, 36)];
    //将UIScrollView及UIPageControl实例追加到画面中
	[self.view addSubview:scrollView];
    [self setupPage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidUnload
{
	
	[scrollView release];
	[pageControl release];
}


- (void)dealloc
{
    [super dealloc];
    [friendList release];
    [groupList release];
}

#pragma mark -
#pragma mark The Guts
- (void)setupPage
{
	//设置UIScrollView实例各显示特性
	//设置委托类为自身，其中必须实现UIScrollViewDelegate协议中定义的scrollViewDidScroll:及scrollViewDidEndDecelerating:方法
	scrollView.delegate = self;
	[scrollView setBackgroundColor:[UIColor blackColor]];
	[scrollView setCanCancelContentTouches:NO];
	//设置滚动条类型
	scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	scrollView.clipsToBounds = YES;
	scrollView.scrollEnabled = YES;
	//只有pagingEnabled为YES时才可进行画面切换
	scrollView.pagingEnabled = YES;
	scrollView.directionalLockEnabled =NO;
	//隐藏滚动条设置
	scrollView.alwaysBounceVertical=NO;
	scrollView.alwaysBounceHorizontal =NO;
	scrollView.showsVerticalScrollIndicator=NO;
	scrollView.showsHorizontalScrollIndicator=NO;
    
	NSUInteger nimages = 0;
	CGFloat cx = 0;
    
    //设置各UIImageView实例位置，及UIImageView实例的frame属性值
    CGRect rect = scrollView.frame;
    rect.size.height = scrollView.frame.size.height;
    rect.size.width = scrollView.frame.size.width;
    rect.origin.x = cx;
    rect.origin.y = 0;
    friendList.view.frame = rect;
    //将图片内容的显示模式设置为自适应模式
    friendList.view.contentMode = UIViewContentModeScaleAspectFill;
    
    [scrollView addSubview:friendList.view];
    //移动左边准备导入下一图片
    cx += scrollView.frame.size.width;
    nimages++;
    
    rect.size.height = scrollView.frame.size.height;
    rect.size.width = scrollView.frame.size.width;
    rect.origin.x = cx;
    rect.origin.y = 0;
    groupList.view.frame = rect;
    //将图片内容的显示模式设置为自适应模式
    groupList.view.contentMode = UIViewContentModeScaleAspectFill;
    
    [scrollView addSubview:groupList.view];
    cx += scrollView.frame.size.width;
    //移动左边准备导入下一图片
    nimages++;
	//NSLog(@"count=%d",nimages);
	
	//注册UIPageControl实例的响应方法（事件为UIControlEventValueChanged）
	[pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
	//设置总页数
	pageControl.numberOfPages = nimages;
	//默认当前页为第1页
	pageControl.currentPage =0;
	pageControl.tag=0;
	
	//重置UIScrollView的尺寸
	[scrollView setContentSize:CGSizeMake(cx, [scrollView bounds].size.height)];
}

//实现UIScrollViewDelegate 中定义的方法
//滚动时调用的方法，其中判断画面滚动时机
- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    //NSLog(@"scrollViewDidScroll");
    if (pageControlIsChangingPage) {
        return;
    }
    
	/*
	 *	画面拖动到超过50%时，进行切换
	 */
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    //NSLog(@"page=%d",page);
    pageControl.currentPage = page;
    if (pageControl.currentPage==0) {
        [friend setEnabled:NO];
        [group setEnabled:YES];
        self.title = @"好友列表";
    }else{
        [group setEnabled:NO];
        [friend setEnabled:YES];
        self.title = @"群组列表";
    }
}
//滚动完成时调用的方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{
    pageControlIsChangingPage = NO;
}
-(void)changePageByClickFriend:(id)sender{
    pageControl.currentPage=0;
    [friend setEnabled:NO];
    [group setEnabled:YES];
    self.title = @"好友列表";
    [self changePage:sender];
}
-(void)changePageByClickGroup:(id)sender{
    pageControl.currentPage=1;
    [group setEnabled:NO];
    [friend setEnabled:YES];
    self.title = @"群组列表";
    [self changePage:sender];
}
//UIPageControl实例的响应方法（事件为UIControlEventValueChanged）
- (void)changePage:(id)sender
{
    //NSLog(@"currentpage=%d",pageControl.currentPage);
	/*
	 *	改变页面
	 */
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
	
    [scrollView scrollRectToVisible:frame animated:YES];
	
	/*
	 *	设置滚动标志，滚动（或称页面改变）完成时，会调用scrollViewDidEndDecelerating 方法，其中会将其置为off的
	 */
    pageControlIsChangingPage = YES;
}

@end
