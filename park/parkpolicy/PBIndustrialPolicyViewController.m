//
//  PBIndustrialPolicyViewController.m
//  ParkBusiness
//
//  Created by  on 13-3-4.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBIndustrialPolicyViewController.h"
#import "PBImgIndustrialViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AsyncImageView.h"
#import "PBUserModel.h"

#define kSCNavBarImageTag                   10
#define NUMBER_OF_COLUMNS                   2
#define INDUSTRIAL_POLICY_URL [NSString stringWithFormat:@"%@admin/index/searchpolicy",HOST]


@implementation PBIndustrialPolicyViewController
@synthesize parkNoString;
@synthesize parkManager;

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
    for (UIControl* control in [self.navigationController.navigationBar subviews]) {
        if ([control isKindOfClass:[UISegmentedControl class]]) {
            [control removeFromSuperview];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning
{
   
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [flowView reloadData];  
}

    //    //把读取到的图片进行解码
- (NSString *)decodeFromPercentEscapeString:(NSString *)string {
    NSMutableString* outputStr = [NSMutableString stringWithString:string];
    [outputStr replaceOccurrencesOfString:@"+" withString:@" " options:NSLiteralSearch range:NSMakeRange(0,outputStr.length)];
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

-(void)navigationBarBackgroundImage
{
    UINavigationBar *navBar = self.navigationController.navigationBar;  
    
    
    if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])  
        {  
                //if iOS 5.0 and later  
            [navBar setBackgroundImage:[UIImage imageNamed:@"topnavigation.png"] forBarMetrics:UIBarMetricsDefault];  
        }  
    else  
        {  
            UIImageView *imageView = (UIImageView *)[navBar viewWithTag:kSCNavBarImageTag];  
            if (imageView == nil)  
                {  
                    imageView = [[UIImageView alloc] initWithImage:  
                                 [UIImage imageNamed:@"topnavigation.png"]];  
                    [imageView setTag:kSCNavBarImageTag];  
                    [navBar insertSubview:imageView atIndex:0];  
                    [imageView release];  
                }  
        }  
    
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"地方政策";
    //获取parkno的值，parkno的值有两种，本地数据库获取和从园区会员中传值。当传值为空时，则从本地获取
    
    
    [self navigationBarBackgroundImage];
    indicator = [[PBActivityIndicatorView alloc]initWithFrame:isPad()?CGRectMake(0, 0, 768, 1024+49) : CGRectMake(0, 0, 320, 480)];
    [self.view addSubview:indicator];
    nodesMutableArr = [[NSMutableArray array] retain];
    CGFloat viewHeight = (isPhone5() ? 568 :480)-KNavigationBarHeight;
    if (isPad()) {
        flowView =[[WaterflowView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024-KNavigationBarHeight)];
    }else{
        flowView = [[WaterflowView alloc] initWithFrame:CGRectMake(0, 0, 320, viewHeight)];
    }   
    
    flowView.flowdatasource = self;
    flowView.flowdelegate = self;
    [self.view addSubview:flowView];
    downflg = TRUE;
    
    [self segmentedControl];
    type = 2;

    [self searchParkIntroduce:1];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    segmentedControl.hidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    segmentedControl.hidden = YES;
}
-(void)segmentedControl{
    NSArray *segArr = [NSArray arrayWithObjects:@"地方",@"市级",@"国家", nil];
    segmentedControl = [[UISegmentedControl alloc] initWithItems:segArr];
    
    segmentedControl.frame = isPad() ? CGRectMake(615, 5, 155, 34) : CGRectMake(210, 7, 105, 30);
    
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.segmentedControlStyle = UISegmentedControlStylePlain;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:isPad()?PadContentFontSize:ContentFontSmallSize],UITextAttributeFont ,nil];
    [segmentedControl setTitleTextAttributes:dic forState:UIControlStateNormal];
    segmentedControl.momentary = NO;
    [segmentedControl addTarget:self action:@selector(segmentAction:)forControlEvents:UIControlEventValueChanged]; 
    [self.navigationController.navigationBar addSubview:segmentedControl];
     
    [segmentedControl release];
}

-(void)segmentAction:(id)sender{
    
    NSInteger segment = segmentedControl.selectedSegmentIndex;
    
    if (segment == 0) {
        self.navigationItem.title = @"地方政策";
        type = 2;
        [nodesMutableArr removeAllObjects];
        flowView.currentPage =1;
        [self searchParkIntroduce:1];
       
       
    }
    if (segment == 1) {
        self.navigationItem.title = @"市级政策";
        type = 3;
        [nodesMutableArr removeAllObjects];
        flowView.currentPage =1;
        [self searchCityPolicy:1];
        
    }
    if (segment == 2) {
        self.navigationItem.title = @"国家政策";
        type = 1;
        [nodesMutableArr removeAllObjects];
        flowView.currentPage =1;
        [self searchGuojia:1];
       
    }
}

-(void)searchGuojia:(int)pageno
{
    [indicator startAnimating];
    self.navigationItem.title = @"国家政策";
    parkManager = [[PBParkManager alloc] init];
    parkManager.delegate = self;
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageno], @"pageno",  @"1", @"type",nil];
    [parkManager getRequestData:INDUSTRIAL_POLICY_URL forValueAndKey:dic];
    [imgIndustrialVC.navigationController popViewControllerAnimated:YES];
    [dic release];
}

-(void) searchParkIntroduce:(int)pageno
{
    [indicator startAnimating];
    self.navigationItem.title = @"地方政策";
    parkManager = [[PBParkManager alloc] init];
    parkManager.delegate = self;
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageno], @"pageno", parkNoString? parkNoString:[NSString stringWithFormat:@"%d",[PBUserModel getParkNo]], @"parkno", @"2", @"type",nil];
   
    [parkManager getRequestData:INDUSTRIAL_POLICY_URL forValueAndKey:dic];
    [imgIndustrialVC.navigationController popViewControllerAnimated:YES];
    [dic release];
}
-(void)searchCityPolicy:(int)pageno
{
    [indicator startAnimating];
    self.navigationItem.title = @"市级政策";
    parkManager = [[PBParkManager alloc] init];
    parkManager.delegate = self;
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageno], @"pageno", @"4", @"type",nil];
    [parkManager getRequestData:INDUSTRIAL_POLICY_URL forValueAndKey:dic];
    [imgIndustrialVC.navigationController popViewControllerAnimated:YES];
    [dic release];
}
- (void)refreshData
{
    [indicator stopAnimating];
    [nodesMutableArr addObjectsFromArray:parkManager.itemNodes];
    downflg = [parkManager.itemNodes count]==20?TRUE:FALSE;
    [flowView reloadData];
    
}

#pragma mark-
#pragma mark- WaterflowDataSource

- (NSInteger)numberOfColumnsInFlowView:(WaterflowView *)flowView
{
    return NUMBER_OF_COLUMNS;
}

- (NSInteger)flowView:(WaterflowView *)flowView numberOfRowsInColumn:(NSInteger)column
{
    int row;
    if ([nodesMutableArr count]==0) {
        row=0;
    }else{
        int i = [nodesMutableArr count]%2;
        row = [nodesMutableArr count]/2;
        if (i==1) {
            row +=1; 
        }
    }
    
    return 5;
}

- (WaterFlowCell *)flowView:(WaterflowView *)flowView_ cellForRowAtIndex:(NSInteger)index{
    static NSString *CellIdentifier = @"Cell";
	WaterFlowCell *cell = [flowView_ dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if(cell == nil)
        {
		cell  = [[[WaterFlowCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
        AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectZero];
        [cell addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleToFill;
		imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
		imageView.layer.borderWidth = 1;
		[imageView release];
		imageView.tag = 1001;
        }
	
        //CGFloat height = [self flowView:nil heightForRowAtIndexPath:index];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.tag = index;
    [btn addTarget:self action:@selector(goNextView:) forControlEvents:UIControlEventTouchUpInside];
   	AsyncImageView *imageView = (AsyncImageView *)[cell viewWithTag:1001];
    if (isPad()) {
        imageView.frame = CGRectMake(0, 0, 384, 500.0);
    }else{
        imageView.frame = CGRectMake(0, 0, 160, 200.0);

    }
    btn.frame = imageView.frame;
    [imageView addSubview:btn];
    if ([nodesMutableArr count]>0) {
        NSString *pictureStr = [NSString stringWithFormat:@"%@%@", HOST, [self decodeFromPercentEscapeString:[[nodesMutableArr objectAtIndex:index] objectForKey:@"picture"]]];
        [imageView loadImage:pictureStr];
        
    }
    
    imageView.userInteractionEnabled = YES;
	return cell;
    
}

- (WaterFlowCell*)flowView:(WaterflowView *)flowView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
	WaterFlowCell *cell = [flowView_ dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if(cell == nil)
        {
		cell  = [[[WaterFlowCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
        AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectZero];
        [cell addSubview:imageView];
        imageView.contentMode = UIViewContentModeScaleToFill;
		imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
		imageView.layer.borderWidth = 1;
		[imageView release];
		imageView.tag = 1001;
        }
	
    float height = [self flowView:nil heightForRowAtIndexPath:indexPath];
   	AsyncImageView *imageView = (AsyncImageView *)[cell viewWithTag:1001];
	
    if (isPad()) {
        imageView.frame = CGRectMake(0, 0, 384, 500.0);
    }else{
        imageView.frame = CGRectMake(0, 0, 160, height);
    }
    int index = indexPath.row*2 + indexPath.section;
    if ([nodesMutableArr count]>0) {
        NSString *pictureStr = [NSString stringWithFormat:@"%@%@", HOST, [self decodeFromPercentEscapeString:[[nodesMutableArr objectAtIndex:index] objectForKey:@"picture"]]];
        
        [imageView loadImage:pictureStr];
        
    }
    imageView.userInteractionEnabled = YES;
    
	return cell;
    
}

#pragma mark-
#pragma mark- WaterflowDelegate

- (void)flowView:(WaterflowView *)_flowView willLoadData:(int)page
{    
    
    if (downflg) {

        if (type == 2) {
            [self searchParkIntroduce:page];
           
        }
        else if(type ==1)
            {
              [self searchGuojia:page];
                
            }
        else if(type ==3){
            [self searchCityPolicy:page];
        }
        
        
    }
    
}
- (CGFloat)flowView:(WaterflowView *)flowView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	float height = 0;
    
    if (isPad()) {
        return height = 500.0;
    }else{
        return height = 200.0;
    }
    
}

- (CGFloat)flowView:(WaterflowView *)flowView heightForCellAtIndex:(NSInteger)index{
    CGFloat height = 0;
    
    if (isPad()) {
        return height = 500.0;
    }else{
        return height = 200.0;
    }
}

-(NSInteger)numberOfData{
    
    return [nodesMutableArr count];
    
}

- (void)goNextView:(id)sender
{
    
    UIButton *btn = (UIButton *)sender;
    if (!imgIndustrialVC) {
        imgIndustrialVC = [[PBImgIndustrialViewController alloc] init];
    }
    imgIndustrialVC.data = [nodesMutableArr objectAtIndex:btn.tag];
    imgIndustrialVC.parkNoString = self.parkNoString;
    [self.navigationController pushViewController:imgIndustrialVC animated:YES];
    
}
- (void)viewDidUnload
{
    [self setParkNoString:nil];
    [super viewDidUnload];
}

- (void) dealloc
{
    [parkNoString release];
    [segmentedControl release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


@end
