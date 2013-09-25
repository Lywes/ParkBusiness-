//
//  PBSidebarVC.m
//  PBParkBusiness
//
//  Created by China on 13-8-19.
//  Copyright (c) 2013年 WINSEN. All rights reserved.
//
#import "PBinfoCenter.h"
#import <QuartzCore/QuartzCore.h>
#import "PBinfocenterLeftVC.h"
#import "PBRightVC.h"

@interface PBinfoCenter ()
{
    UIViewController  *_currentMainController;
    UITapGestureRecognizer *_tapGestureRecognizer;
    UIPanGestureRecognizer *_panGestureReconginzer;
    //    BOOL sideBarShowing;
    CGFloat currentTranslate;
}
@property (strong,nonatomic)PBinfocenterLeftVC *leftSideBarViewController;
@property (strong,nonatomic)PBRightVC *rightSideBarViewController;

-(void)left_right;
@end

@implementation PBinfoCenter
@synthesize leftSideBarViewController,rightSideBarViewController,contentView,navBackView,sideBarShowing,justShowLeftBar;
@synthesize pangesBlock;

static PBinfoCenter *rootViewCon;
const int ContentOffset1 = 280;
const int ContentOffset_ipad1 = 380;
const int ContentMinOffset1=60;
const float MoveAnimationDuration1 = 0.3;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

+ (id)share
{
    return rootViewCon;
}
-(void)viewWillAppear:(BOOL)animated{
}
-(void)viewWillDisappear:(BOOL)animated{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (rootViewCon) {
        rootViewCon = nil;
    }
	rootViewCon = self;
    
    sideBarShowing = NO;
    justShowLeftBar = YES;
    currentTranslate = 0;
    
    self.navigationController.navigationBarHidden = YES;
    
    //左右两个vc的根试图
    UIView *_navBackView = [[UIView alloc] initWithFrame: self.view.frame];
    self.navBackView = _navBackView;
    [_navBackView release];
    [self.view addSubview:self.navBackView];
    
    //中间试图
    UIView *_contentview = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.contentView = _contentview;
    [_contentview release];
    self.contentView.layer.shadowOffset = CGSizeMake(0, 0);
    self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.contentView.layer.shadowOpacity = 1;
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.contentView];
    
    //左右两个试图
    [self left_right];
    
    /*
    _panGestureReconginzer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panInContentView:)];
    [self.contentView addGestureRecognizer:_panGestureReconginzer];
     */
    
    pangesBlock = [^(UIPanGestureRecognizer *panGestureReconginzer){
        if (panGestureReconginzer.state == UIGestureRecognizerStateChanged)
        {            
            CGFloat translation = [panGestureReconginzer translationInView:self.contentView].x;
            
            if (justShowLeftBar) {
                
                if (self.contentView.frame.origin.x ==0 && translation<0) {
                    
                }
                else{
                    self.contentView.transform = CGAffineTransformMakeTranslation(translation+currentTranslate, 0);
                    
                }
            }
            else
            {
                self.contentView.transform = CGAffineTransformMakeTranslation(translation+currentTranslate, 0);
                
            }
            UIView *view ;
            if (translation+currentTranslate>0)
            {
                view = self.leftSideBarViewController.view;
            }else
            {
                view = self.rightSideBarViewController.view;
            }
            [self.navBackView bringSubviewToFront:view];
            
        }
        
        else if (panGestureReconginzer.state == UIGestureRecognizerStateEnded)
        {
            currentTranslate = self.contentView.transform.tx;
            NSLog(@"......%f",self.contentView.transform.tx);
            if (!sideBarShowing) {
                if (fabs(currentTranslate)<ContentMinOffset1) {
                    [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration1];
                }else if(currentTranslate>ContentMinOffset1)
                {
                    [self moveAnimationWithDirection:SideBarShowDirectionLeft duration:MoveAnimationDuration1];
                }else
                {
                    [self moveAnimationWithDirection:SideBarShowDirectionRight duration:MoveAnimationDuration1];
                }
            }else
            {
                if (fabs(currentTranslate)<ContentOffset1-ContentMinOffset1) {
                    [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration1];
                    
                }else if(currentTranslate>ContentOffset1-ContentMinOffset1)
                {
                    
                    [self moveAnimationWithDirection:SideBarShowDirectionLeft duration:MoveAnimationDuration1];
                    
                }else
                {
                    [self moveAnimationWithDirection:SideBarShowDirectionRight duration:MoveAnimationDuration1];
                }
            }
            
            
        }

    } copy];
}
-(void)left_right{
    
    PBinfocenterLeftVC *_leftCon = [[PBinfocenterLeftVC alloc] init];
    _leftCon.delegate = self;
    self.leftSideBarViewController = _leftCon;
    [_leftCon release];
    
    [self addChildViewController:self.leftSideBarViewController];
    self.leftSideBarViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.navBackView addSubview:self.leftSideBarViewController.view];
}
- (void)contentViewAddTapGestures
{
    if (_tapGestureRecognizer) {
        [self.contentView   removeGestureRecognizer:_tapGestureRecognizer];
        _tapGestureRecognizer = nil;
    }
    
    _tapGestureRecognizer = [[UITapGestureRecognizer  alloc] initWithTarget:self action:@selector(tapOnContentView:)];
    [self.contentView addGestureRecognizer:_tapGestureRecognizer];
}

- (void)tapOnContentView:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration1];
}
- (int)wei:(int)a
{
    int sum = 0;
    while(a>=1)
    {
        a=a/10;
        sum++;
    }
    return sum;
}
/*
-(void)panGesture:(UIPanGestureRecognizer *)panGestureReconginzer{
    
}
- (void)panInContentView:(UIPanGestureRecognizer *)panGestureReconginzer
{
    
	    
    
}
*/
#pragma mark - nav con delegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if ([navigationController.viewControllers count]>1) {
        [self removepanGestureReconginzerWhileNavConPushed:YES];
    }else
    {
        [self removepanGestureReconginzerWhileNavConPushed:NO];
    }
    
    
}

- (void)removepanGestureReconginzerWhileNavConPushed:(BOOL)push
{
    if (push) {
        if (_panGestureReconginzer) {
            [self.contentView removeGestureRecognizer:_panGestureReconginzer];
            _panGestureReconginzer = nil;
        }
    }else
    {
        if (!_panGestureReconginzer) {
            _panGestureReconginzer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panInContentView:)];
            [self.contentView addGestureRecognizer:_panGestureReconginzer];
        }
    }
}
#pragma mark - side bar select delegate
- (void)leftSideBarSelectWithController:(UIViewController *)controller
{
    if ([controller isKindOfClass:[UINavigationController class]]) {
        [(UINavigationController *)controller setDelegate:self];
    }
    if (_currentMainController == nil) {
		controller.view.frame = self.contentView.bounds;
		_currentMainController = controller;
		[self addChildViewController:_currentMainController];
		[self.contentView addSubview:_currentMainController.view];
		[_currentMainController didMoveToParentViewController:self];
         [self showSideBarControllerWithDirection:SideBarShowDirectionLeft];
	} else if (_currentMainController != controller && controller !=nil) {
		controller.view.frame = self.contentView.bounds;
		[_currentMainController willMoveToParentViewController:nil];
		[self addChildViewController:controller];
		self.view.userInteractionEnabled = NO;
		[self transitionFromViewController:_currentMainController
						  toViewController:controller
								  duration:0
								   options:UIViewAnimationOptionTransitionNone
								animations:^{}
								completion:^(BOOL finished){
									self.view.userInteractionEnabled = YES;
									[_currentMainController removeFromParentViewController];
									[controller didMoveToParentViewController:self];
									_currentMainController = controller;
								}
         ];
        [self showSideBarControllerWithDirection:SideBarShowDirectionNone];
	}
}


- (void)rightSideBarSelectWithController:(UIViewController *)controller
{
    
}

- (void)showSideBarControllerWithDirection:(SideBarShowDirection)direction
{
    
    if (direction!=SideBarShowDirectionNone) {
        UIView *view ;
        if (direction == SideBarShowDirectionLeft)
        {
            view = self.leftSideBarViewController.view;
        }else
        {
            view = self.rightSideBarViewController.view;
        }
        [self.navBackView bringSubviewToFront:view];
    }
    [self moveAnimationWithDirection:direction duration:MoveAnimationDuration1];
}



#pragma animation

- (void)moveAnimationWithDirection:(SideBarShowDirection)direction duration:(float)duration
{
    void (^animations)(void) = ^{
		switch (direction) {
            case SideBarShowDirectionNone:
            {
                self.contentView.transform  = CGAffineTransformMakeTranslation(0, 0);
            }
                break;
            case SideBarShowDirectionLeft:
            {
                self.contentView.transform  = CGAffineTransformMakeTranslation(isPad()?ContentOffset_ipad1: ContentOffset1, 0);
            }
                break;
            case SideBarShowDirectionRight:
            {
                self.contentView.transform  = CGAffineTransformMakeTranslation(-ContentOffset1, 0);
            }
                break;
            default:
                break;
        }
	};
    void (^complete)(BOOL) = ^(BOOL finished) {
        self.contentView.userInteractionEnabled = YES;
        self.navBackView.userInteractionEnabled = YES;
        
        if (direction == SideBarShowDirectionNone) {
            
            if (_tapGestureRecognizer) {
                [self.contentView removeGestureRecognizer:_tapGestureRecognizer];
                _tapGestureRecognizer = nil;
            }
            sideBarShowing = NO;
            
            
        }else
        {
            [self contentViewAddTapGestures];
            sideBarShowing = YES;
        }
        currentTranslate = self.contentView.transform.tx;
	};
    self.contentView.userInteractionEnabled = NO;
    self.navBackView.userInteractionEnabled = NO;
    [UIView animateWithDuration:duration animations:animations completion:complete];
}

@end

