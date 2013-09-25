//
//  PBImageScrollView.m
//  ParkBusiness
//
//  Created by 上海 on 13-7-2.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBImageScrollView.h"
#define PARK_INTRODUCEURL [NSString stringWithFormat:@"%@admin/index/searchintroduce",HOST]
@interface PBImageScrollView ()
@end

@implementation PBImageScrollView
@synthesize showno;
@synthesize nodesMutableArr;
@synthesize urlStr;
@synthesize data;
@synthesize imageScrollView;
@synthesize parkManager;
@synthesize parentsController;
@synthesize parkNoString;
-(void)dealloc
{
    [imageScrollView release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(6, 6, 25, 30);
        [btn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(popBackgoView) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = backBarBtn;
        [backBarBtn release];
        urlStr = @"";
    }
    return self;
}

-(void)popBackgoView
{
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{

    fullScreen = NO;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.wantsFullScreenLayout = YES;
    self.view.backgroundColor = [UIColor blackColor];
    CGFloat viewHeight = (isPhone5() ? 568 :480)-KTabBarHeight-KNavigationBarHeight;
    if (![urlStr isEqualToString:@""]) {
        indicator = [[PBActivityIndicatorView alloc]initWithFrame:isPad()?CGRectMake(0, 0, 768, 1024) : CGRectMake(0, 0, 320, viewHeight)];
        [self.view addSubview:indicator];
        [indicator startAnimating];
        parkManager = [[PBParkManager alloc] init];
        parkManager.delegate = self;
        [parkManager getRequestData:urlStr forValueAndKey:data];
    }else{
        [self setImageViewWithArray:nodesMutableArr];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([urlStr isEqualToString:@""]) {
        [self rightBarButton];
    }
    
    if (isPad()) {
        self.imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024-KTabBarHeight)];
    }else{
        self.imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, (isPhone5()?568:480)-KTabBarHeight)];
        
    }
    self.parentsController.view.backgroundColor =[UIColor blackColor];
    self.imageScrollView.backgroundColor=[UIColor blackColor];
    self.imageScrollView.delegate=self;
    self.imageScrollView.delaysContentTouches = YES;
    self.imageScrollView.pagingEnabled = YES;
    self.imageScrollView.multipleTouchEnabled=YES;
    self.imageScrollView.minimumZoomScale=1.0;
    self.imageScrollView.maximumZoomScale=4.0;
    self.imageScrollView.pagingEnabled = YES;
    self.imageScrollView.contentOffset = CGPointMake(0, 0);
    [self.view addSubview:self.imageScrollView];
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.imageScrollView addGestureRecognizer:tapGr];
    
}

-(void)rightBarButton
{
    
    UIBarButtonItem *rightbtn = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(deleteImage:)];
    self.navigationItem.rightBarButtonItem = rightbtn;
    [rightbtn release];
    
    
}
//点击删除图片
- (void)deleteImage:(id)sender
{
    CGPoint point = self.imageScrollView.contentOffset;
    int nowpage = point.x/(isPad()?768:320);
//    [nodesMutableArr removeObjectAtIndex:nowpage];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteimage" object:[NSString stringWithFormat:@"%d",nowpage]];
    showno = nowpage==0?0:nowpage-1;
    for (UIView* subview in [imageScrollView subviews]) {
        [subview removeFromSuperview];
    }
    if ([nodesMutableArr count]>0) {
        [self setImageViewWithArray:nodesMutableArr];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    self.parentsController.view.backgroundColor =[UIColor clearColor];
}

- (void)loadView {
	[super loadView];
    
}

#pragma mark-
#pragma mark-   PBParkManagerDelegate

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    
    fullScreen = !fullScreen;
    
    BOOL needAnimation = YES;
    
    if (needAnimation) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.3];
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:needAnimation];
    
    
//    [self.navigationController setNavigationBarHidden:fullScreen?YES:NO animated:NO];
    PBNaviViewController* parent = (PBNaviViewController *)self.parentsController;
//    if (isPad()) {
//        self.navigationController.view.frame = CGRectMake(0, 0, 768, 1024);
//    }else{
//        self.navigationController.view.frame = CGRectMake(0, 0, 320,(isPhone5()?568:480));
//    }
//
    self.navigationController.navigationBar.alpha = fullScreen ? 0.0 : 1.0;
    parent.tabBar.alpha = fullScreen ? 0.0 : 1.0;
    if (needAnimation) {
        [UIView commitAnimations];
    }
    
}
//解码字符串
- (NSString *)decodeFromPercentEscapeString:(NSString *)string {
    NSMutableString* outputStr = [NSMutableString stringWithString:string];
    [outputStr replaceOccurrencesOfString:@"+" withString:@" " options:NSLiteralSearch range:NSMakeRange(0,outputStr.length)];
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
}

-(void)refreshData
{
    [img removeFromSuperview];
    [indicator stopAnimating];
    [self setImageViewWithArray:parkManager.itemNodes];
    
    
    
}
-(void)setImageViewWithArray:(NSMutableArray*)imageArr{
    if (isPad()) {
        imageScrollView.contentSize = CGSizeMake([imageArr count]*768, 1024-KTabBarHeight);
    }else{
        imageScrollView.contentSize = CGSizeMake([imageArr count]*320, (isPhone5()?568:480)-KTabBarHeight);
    }
    if (![urlStr isEqualToString:@""]) {
        for (int i = 0; i<[imageArr count]; i++) {
            NSString *imageName = [[imageArr objectAtIndex:i]objectForKey:@"imagepath"];
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOST,imageName]]]];
            CGRect frame = CGRectMake(i*320, 0, 320, (isPhone5()?568:480)-KTabBarHeight);
            if (isPad()) {
                frame = CGRectMake(i*768, 0, 768, 1024-KTabBarHeight);
            }
            UIView* subview = [[UIView alloc]initWithFrame:frame];
            UIImageView *imgViews = [[UIImageView alloc] initWithImage:image];
            imgViews.userInteractionEnabled = YES;
            if (image) {
                imgViews.frame = [self autoresizingImageViewFrame:image withframe:subview.frame];
            }
            imgViews.center = self.view.center;
            [subview addSubview:imgViews];
            [self.imageScrollView addSubview:subview];
            subview.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            [subview release];
            [imgViews release];
        }
    }else{
        for (int i = 0; i<[imageArr count]; i++) {
            UIImage *image = [imageArr objectAtIndex:i];
            UIView* subview = [[UIView alloc]init];
            UIImageView *imgViews = [[UIImageView alloc] initWithImage:image];
            if (isPad()) {
                subview.frame = CGRectMake(i*768, 0, 768, 1024-KTabBarHeight);
            }else{
                subview.frame = CGRectMake(i*320, 0, 320, (isPhone5()?568:480)-KTabBarHeight);
            }
            imgViews.userInteractionEnabled = YES;
            imgViews.frame = [self autoresizingImageViewFrame:image withframe:subview.frame];
            imgViews.center = self.view.center;
            [subview addSubview:imgViews];
            [self.imageScrollView addSubview:subview];
            [subview release];
            [imgViews release];
        }
        self.imageScrollView.contentOffset = CGPointMake(showno*(isPad()?768:320), 0);//设置偏移量
    }
    
}

-(CGRect)autoresizingImageViewFrame:(UIImage*)image withframe:(CGRect)frame{
    CGFloat width = 0.0f;
    CGFloat height = 0.0f;
    CGSize imgsize = image.size;
    CGSize subviewsize = frame.size;
    if (imgsize.width>=imgsize.height) {
        width = subviewsize.width;
        height = width/imgsize.width*imgsize.height;
    }else{
        height = subviewsize.height;
        width = height/imgsize.height*imgsize.width;
        if (width>subviewsize.width) {
            width = subviewsize.width;
            height = width/imgsize.width*imgsize.height;
        }
    }
    return CGRectMake(0, 0, width, height);
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return  YES;
}

@end
