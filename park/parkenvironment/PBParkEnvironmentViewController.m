    //
    //  PBParkEnvironmentViewController.m
    //  ParkBusiness
    //
    //  Created by  on 13-3-4.
    //  Copyright (c) 2013年 wangzhigang. All rights reserved.
    //

#import "PBParkEnvironmentViewController.h"
#import "PBImgIntroduceViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AsyncImageView.h"
#import "PBUserModel.h"

#define kSCNavBarImageTag                   10
#define NUMBER_OF_COLUMNS                   2
#define PARKINTRODUCE_URL [NSString stringWithFormat:@"%@admin/index/searparkintroduce",HOST]
@interface PBParkEnvironmentViewController ()
-(void) searchParkIntroduce:(int)pageno;
@end


@implementation PBParkEnvironmentViewController
@synthesize parkNoString;
@synthesize parkManager;
@synthesize parentsController;

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
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
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
    self.title = @"园区环境";
    [self navigationBarBackgroundImage];
    indicator = [[PBActivityIndicatorView alloc]initWithFrame:isPad()?CGRectMake(0, 0, 768, 1024+49) : CGRectMake(0, 0, 320, 480-KTabBarHeight-KNavigationBarHeight)];
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
    [self searchParkIntroduce:1];    
}

-(void) searchParkIntroduce:(int)pageno
{
    [indicator startAnimating];
    parkManager = [[PBParkManager alloc] init];
    parkManager.delegate = self;
    
    //判断parkno是否有传值，若有，取该值；否则从本地数据库获取本园区parkno
    parkNoString = (parkNoString.length == 0) ? [NSString stringWithFormat:@"%d",[PBUserModel getParkNo]] : parkNoString;
    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageno], @"pageno", parkNoString, @"parkno",nil];
    [parkManager getRequestData:PARKINTRODUCE_URL forValueAndKey:dic];
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
        imageView.frame = CGRectMake(0, 0, self.view.frame.size.width / 2, 200.0);
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
        imageView.frame = CGRectMake(0, 0, 384, height);
    }else{
        imageView.frame = CGRectMake(0, 0, self.view.frame.size.width / 2, height);
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
        [self searchParkIntroduce:page];
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
        return height = 500;
    }else{
        return height = 200.0;
    }
}

-(NSInteger)numberOfData{
    
    return [nodesMutableArr count];
    
}

- (void)goNextView:(id)sender
{    
    UIButton *btn = (UIButton*)sender;
    imgVC = [[[PBImgIntroduceViewController alloc] init] autorelease];
    imgVC.data = [nodesMutableArr objectAtIndex:btn.tag];
    imgVC.parentsController = self.parentsController;
    imgVC.parkNoString = self.parkNoString;
    [self.navigationController pushViewController:imgVC animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) dealloc {
    [parkNoString release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [self setParkNoString:nil];
    [super viewDidUnload];
}
@end
