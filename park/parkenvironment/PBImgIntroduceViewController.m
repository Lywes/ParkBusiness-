//
//  PBImgIntroduceViewController.m
//  ParkBusiness
//
//  Created by  on 13-3-6.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBImgIntroduceViewController.h"
#define INSERT_QUESTION_URL [NSString stringWithFormat:@"%@admin/index/insertquestion",HOST]
#define PARK_INTRODUCEURL [NSString stringWithFormat:@"%@admin/index/searchintroduce",HOST]

@implementation PBImgIntroduceViewController

@synthesize data;
@synthesize imageScrollView;
@synthesize parkManager;
@synthesize parentsController;
@synthesize inputToolbar;
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
    [self.inputToolbar addObserverFromController:self];
    fullScreen = NO;
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    self.wantsFullScreenLayout = YES;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    CGFloat viewHeight = (isPhone5() ? 568 :480)-KTabBarHeight-KNavigationBarHeight;
    self.title = [self.data objectForKey:@"name"];
    
    indicator = [[PBActivityIndicatorView alloc]initWithFrame:isPad()?CGRectMake(0, 0, 768, 1024+49) : CGRectMake(0, 0, 320, viewHeight)];
    [self.view addSubview:indicator];
    [indicator startAnimating];    
    parkManager = [[PBParkManager alloc] init];
    parkManager.delegate = self;
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[self.data objectForKey:@"no"], @"introduceno", nil];
    [parkManager getRequestData:PARK_INTRODUCEURL forValueAndKey:dic];
    [dic release];  
   

}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self rightBarButton];
   
    if (isPad()) {
        self.imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)];
    }else{
        self.imageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, (isPhone5()?568:480))];
        
    }
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
    
    UIBarButtonItem *rightbtn = [[UIBarButtonItem alloc] initWithTitle:@"电话咨询" style:UIBarButtonItemStylePlain target:self action:@selector(questionView:)];
    self.navigationItem.rightBarButtonItem = rightbtn;
    [rightbtn release];
    self.inputToolbar = [[UIInputToolbar alloc] initWithFrame:CGRectMake(0, isPad()?1024:(isPhone5()?568:480), isPad()?768:320, 40)];
    inputToolbar.delegate = self;
    inputToolbar.textView.placeholder = @"请输入提问";
    [self.navigationController.view addSubview:self.inputToolbar];
    
}
//进入提问页面
- (void)questionView:(id)sender
{
//    [self.inputToolbar.textView becomeFirstResponder];
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:@"点击拨打电话" delegate:self cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) destructiveButtonTitle:@"021-65442341" otherButtonTitles: nil];
    [sheet showFromTabBar:self.tabBarController.tabBar];
    [sheet release];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        NSString* num = [NSString stringWithFormat:@"tel://%@",[actionSheet buttonTitleAtIndex:buttonIndex]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
    }
}
-(void)inputButtonPressed:(NSString *)inputText
{
    [indicator startAnimating];
    NSArray *arr1 = [NSArray arrayWithObjects:parkNoString,inputText,USERNO, nil];
    NSArray *arr2 = [NSArray arrayWithObjects:@"parkno",@"question", @"personno",nil];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithObjects:arr1 forKeys:arr2];
    [parkManager submitDataFromUrl:INSERT_QUESTION_URL postValuesAndKeys:dic];
}

-(void)sucessSendPostData:(NSObject *)Data{
    [indicator stopAnimating];
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"提问信息已提交" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [self.inputToolbar removeObserverFromController:self];
}
- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    [self.inputToolbar keyboardWillShowHide:notification];
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    [self.inputToolbar keyboardWillShowHide:notification];
    [self.inputToolbar keyboardWillHide];
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
   

    [self.navigationController setNavigationBarHidden:fullScreen?YES:NO animated:NO];
    PBNaviViewController* parent = (PBNaviViewController *)self.parentsController;
    if (isPad()) {
        self.navigationController.view.frame = CGRectMake(0, 0, 768, 1024);
    }else{
        self.navigationController.view.frame = CGRectMake(0, 0, 320,(isPhone5()?568:480));
    }
    
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
    
    nodesMutableArr = [[NSMutableArray arrayWithArray:parkManager.itemNodes] retain];
    
    if (isPad()) {
        imageScrollView.contentSize = CGSizeMake([nodesMutableArr count]*768, 1024);
    }else{
        imageScrollView.contentSize = CGSizeMake([nodesMutableArr count]*320, (isPhone5()?568:480));
    }

    for (int i = 0; i<[nodesMutableArr count]; i++) {
        
        NSString *imageName = [[nodesMutableArr objectAtIndex:i]objectForKey:@"picture"];
       
        UIImage *imageViews = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOST,imageName]]]];
        img = [[UIImageView alloc] initWithImage:imageViews];
        
        if (isPad()) {
           
            img.frame = CGRectMake(i*768, 0, 768, 1024);
            
        }else{
            img.frame = CGRectMake(i*320, 0, 320, (isPhone5()?568:480));
           
        }
        img.userInteractionEnabled = YES;
        [img setUserInteractionEnabled:YES];  
        [imageScrollView addSubview:img]; 
        
        [img release];

    }   
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return  YES;
}

@end
