//
//  PBSidebarVC.m
//  PBParkBusiness
//
//  Created by China on 13-8-19.
//  Copyright (c) 2013年 WINSEN. All rights reserved.
//
#import "PBSidebarVC.h"
#import <QuartzCore/QuartzCore.h>
#import "PBLeftVC.h"
#import "PBRightVC.h"
#import "FAMainChatController.h"
#define Joininapply_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/joininapply",HOST]]
@interface PBSidebarVC ()
{
    UIViewController  *_currentMainController;
    UITapGestureRecognizer *_tapGestureRecognizer;
    UIPanGestureRecognizer *_panGestureReconginzer;
//    BOOL sideBarShowing;
    CGFloat currentTranslate;
}
@property (strong,nonatomic)PBLeftVC *leftSideBarViewController;
@property (strong,nonatomic)PBRightVC *rightSideBarViewController;
-(void)left_right;
@end

@implementation PBSidebarVC
@synthesize leftSideBarViewController,rightSideBarViewController,contentView,navBackView,sideBarShowing,justShowLeftBar,btn_friend;
@synthesize pangesBlock;

static PBSidebarVC *rootViewCon = nil;
const int ContentOffset = 280;
const int ContentOffset_ipad = 530;
const int ContentMinOffset=60;
const float MoveAnimationDuration = 0.3;

-(void)dealloc{
    RB_SAFE_RELEASE(contentView);
    RB_SAFE_RELEASE(navBackView);
    RB_SAFE_RELEASE(_currentMainController);
    RB_SAFE_RELEASE(leftSideBarViewController);
    RB_SAFE_RELEASE(rightSideBarViewController);
    [super dealloc];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

+ (id)share
{
    return rootViewCon;
}
-(void)viewWillAppear:(BOOL)animated{
    [self.btn_friend setTitleWithUnreadCount];
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
    justShowLeftBar = NO;
    currentTranslate = 0;
    
    self.navigationController.navigationBarHidden = YES;

    
    //左右两个vc的根视图
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
    
    //左右两个视图
    [self left_right];
    
    
    //朋友圈按钮
    MoveButton *btn = [[MoveButton alloc]initWithFrame:CGRectMake(0, 100, 35, 80)];
    btn.delegate = self;
//    [btn setBackgroundImage:[UIImage imageNamed:@"icon_friendquan_button"] forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(0, 100, 35, 80);
    self.btn_friend = btn;
    [btn release];
    [self.view addSubview:self.btn_friend];
    [self.btn_friend setBackgroundImage:[UIImage imageNamed:@"icon_friendquan_button"] forState:UIControlStateNormal];
//    UIPanGestureRecognizer * btn_firend_pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(btn_firend_pan:)];
//    [self.btn_friend addGestureRecognizer:btn_firend_pan];
//    [self.btn_friend addTarget:self action:@selector(btn_firend_Press:) forControlEvents:UIControlEventTouchUpInside];
    
    //可移动界面的手势
//    _panGestureReconginzer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panInContentView:)];
//    [self.contentView addGestureRecognizer:_panGestureReconginzer];
    
#pragma mark - UIPanGestureRecognizer ^block
    pangesBlock = [^(UIPanGestureRecognizer *panGestureReconginzer){
        if (panGestureReconginzer.state == UIGestureRecognizerStateChanged)
        {
//            [self panGesture:panGestureReconginzer];
            
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
                if (fabs(currentTranslate)<ContentMinOffset) {
                    [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
                }else if(currentTranslate>ContentMinOffset)
                {
                    [self moveAnimationWithDirection:SideBarShowDirectionLeft duration:MoveAnimationDuration];
                }else
                {
                    [self moveAnimationWithDirection:SideBarShowDirectionRight duration:MoveAnimationDuration];
                }
            }else
            {
                if (fabs(currentTranslate)<ContentOffset-ContentMinOffset) {
                    [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
                    
                }else if(currentTranslate>ContentOffset-ContentMinOffset)
                {
                    
                    [self moveAnimationWithDirection:SideBarShowDirectionLeft duration:MoveAnimationDuration];
                    
                }else
                {
                    [self moveAnimationWithDirection:SideBarShowDirectionRight duration:MoveAnimationDuration];
                }
            }
            
            
        }
        
    } copy];
}
#pragma mark - 左右两个菜单
-(void)left_right{
    PBRightVC *_rightCon = [[PBRightVC alloc] initWithNibName:isPad()?@"PBRightVC_iPad":(isPhone5()?@"PBRightVC_i5":@"PBRightVC") bundle:nil];
    self.rightSideBarViewController = _rightCon;
    _rightCon.delegate = self;
    [_rightCon release];
    
    PBLeftVC *_leftCon = [[PBLeftVC alloc] init];
    _leftCon.delegate = self;
    self.leftSideBarViewController = _leftCon;
    [_leftCon release];
    [self addChildViewController:self.rightSideBarViewController];
    [self addChildViewController:self.leftSideBarViewController];

    self.leftSideBarViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.rightSideBarViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.navBackView addSubview:self.rightSideBarViewController.view];
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
    [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
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

//    pangesBlock();
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
            [_panGestureReconginzer release];
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
//        self.contentView = _currentMainController.view;
		[_currentMainController didMoveToParentViewController:self];
        [_currentMainController release];
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
        
        /*另外一种方法
        [_currentMainController.view removeFromSuperview];
        _currentMainController = controller;
        [self.contentView addSubview:_currentMainController.view];
         */
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
    [self moveAnimationWithDirection:direction duration:MoveAnimationDuration];
}



#pragma  mark - animation

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
                self.contentView.transform  = CGAffineTransformMakeTranslation(isPad()?VIEWSIZE.width/2+50:ContentOffset, 0);
            }
                break;
            case SideBarShowDirectionRight:
            {
                self.contentView.transform  = CGAffineTransformMakeTranslation(isPad()?-ContentOffset_ipad:-ContentOffset, 0);
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


#pragma mark - 朋友圈
//static int aa = 0;
//static int bb = 0;
//-(void)touchUpInside:(UIButton *)sender{
//
//    if (pan.state == UIGestureRecognizerStateChanged)
//    {
//        CGFloat translationX = [pan translationInView:self.btn_friend].x;
//        CGFloat translationY = [pan translationInView:self.btn_friend].y;
//        self.btn_friend.transform = CGAffineTransformMakeTranslation(translationX+aa, translationY+bb);
//    }
//    if (pan.state == UIGestureRecognizerStateEnded) {
//        aa = self.btn_friend.transform.tx;
//        bb = self.btn_friend.transform.ty;
//    }
//}
//朋友圈按钮协议方法
-(void)touchUpInside:(UIButton *)sender{
    if ([PBUserModel getPasswordAndKind].kind > 0) {
        FAMainChatController *controller = [[FAMainChatController alloc] init];
        controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self.navigationController presentModalViewController:controller animated:YES];
        [controller release];
    }else{
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您必须成为融商正式会员后才能使用此功能！" delegate:self cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) otherButtonTitles:@"申请正式加盟", nil];
        [alert show];
        [alert release];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        PBdataClass *dataclass = [[PBdataClass alloc] init];
        dataclass.delegate = self;
        [dataclass dataResponse:Joininapply_URL postDic:[NSDictionary dictionaryWithObjectsAndKeys:USERNO,@"userno",[PBUserModel getTel],@"tel", nil] searchOrSave:NO];
    }
    
}
-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString *)intvalue{
    if ([intvalue integerValue] ==  1) {
        UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"申请成功" message:@"申请加盟成功,稍后有服务人员与你联系" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [alt show];
        [alt release];
        [self performSelector:@selector(dismissAlt:) withObject:alt afterDelay:2.0];
    }
    [dataclass release];
}
-(void)dismissAlt:(UIAlertView *)alt{
    [alt dismissWithClickedButtonIndex:0 animated:YES];
}

@end

