//
//  PBWaterFallViewController.m
//  ParkBusiness
//
//  Created by  on 13-3-7.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBWaterFallViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AsyncImageView.h"

#define NUMBER_OF_COLUMNS                   2

@implementation PBWaterFallViewController
@synthesize imageUrlMutabArr;
@synthesize currentPage;
-(CGFloat)flowView:(WaterflowView *)flowView heightForCellAtIndex:(NSInteger)index{
    return 0;
}
- (WaterFlowCell *)flowView:(WaterflowView *)flowView cellForRowAtIndex:(NSInteger)index{
    return nil;
}
- (NSInteger)numberOfData{
    return 0;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    flowView = [[WaterflowView alloc] initWithFrame:self.view.frame];
    flowView.flowdatasource = self;
    flowView.flowdelegate = self;
    [self.view addSubview:flowView];
    
    self.currentPage = 1;
    
    self.imageUrlMutabArr = [[NSMutableArray array]init];
    self.imageUrlMutabArr = [NSArray arrayWithObjects:@"http://img.topit.me/l/201008/11/12815218412635.jpg",@"http://photo.l99.com/bigger/22/1284013907276_zb834a.jpg",@"http://www.webdesign.org/img_articles/7072/BW-kitten.jpg",@"http://www.raiseakitten.com/wp-content/uploads/2012/03/kitten.jpg",@"http://imagecache6.allposters.com/LRG/21/2144/C8BCD00Z.jpg",nil];
   
    
}

- (void)viewDidAppear:(BOOL)animated
{
        [flowView reloadData];  //safer to do it here, in case it may delay viewDidLoad
}

#pragma mark-
#pragma mark- WaterflowDataSource

- (NSInteger)numberOfColumnsInFlowView:(WaterflowView *)flowView
{
    return NUMBER_OF_COLUMNS;
}

- (NSInteger)flowView:(WaterflowView *)flowView numberOfRowsInColumn:(NSInteger)column
{
    return 6;
}

//- (WaterFlowCell *)flowView:(WaterflowView *)flowView_ cellForRowAtIndex:(NSInteger)index
//{
//    static NSString *CellIdentifier = @"Cell";
//	WaterFlowCell *cell = [flowView_ dequeueReusableCellWithIdentifier:CellIdentifier];
//	
//	if(cell == nil)
//    {
//		cell  = [[[WaterFlowCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
//		AsyncImageView *imageView = [[AsyncImageView alloc] initWithFrame:CGRectZero];
//        [cell addSubview:imageView];
//        imageView.contentMode = UIViewContentModeScaleToFill;
//		imageView.layer.borderColor = [[UIColor redColor] CGColor];
//		imageView.layer.borderWidth = 1;
//		[imageView release];
//		imageView.tag = 1001;
//    }
//    
//    float height = [self flowView:nil heightForCellAtIndex:index];
//    AsyncImageView *imageView  = (AsyncImageView *)[cell viewWithTag:1001];
//	imageView.frame = CGRectMake(0, 0, self.view.frame.size.width / NUMBER_OF_COLUMNS, height);
//    [imageView loadImage:[self.imageUrlMutabArr objectAtIndex:index % 5]];
//	
//	return cell;
//    
//}

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
	
        //float height = [self flowView:nil heightForRowAtIndexPath:indexPath];
	UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(goNextView) forControlEvents:UIControlEventTouchUpInside];
   	AsyncImageView *imageView  = (AsyncImageView *)[cell viewWithTag:1001];
	imageView.frame = CGRectMake(0, 0, self.view.frame.size.width / 2, 200);
    btn.frame = imageView.frame;
    [imageView addSubview:btn];
    [imageView loadImage:[self.imageUrlMutabArr objectAtIndex:(indexPath.row + indexPath.section) % 5]];
	imageView.userInteractionEnabled = YES;
	return cell;
    
}
    //此方法供两个子类继承调用
- (void)goNextView
{
        
}

#pragma mark-
#pragma mark- WaterflowDelegate

//- (CGFloat)flowView:(WaterflowView *)flowView heightForCellAtIndex:(NSInteger)index
//{
//    float height = 0;
//	switch (index  % 5) {
//		case 0:
//			height = 127;
//			break;
//		case 1:
//			height = 100;
//			break;
//		case 2:
//			height = 87;
//			break;
//		case 3:
//			height = 114;
//			break;
//		case 4:
//			height = 140;
//			break;
//		case 5:
//			height = 158;
//			break;
//		default:
//			break;
//	}
//	
//	return height;
//}

- (CGFloat)flowView:(WaterflowView *)flowView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
	float height = 0;
//	switch ((indexPath.row + indexPath.section )  % 5) {
//		case 0:
//			height = 100;
//			break;
//		case 1:
//			height = 100;
//			break;
//		case 2:
//			height = 100;
//			break;
//		case 3:
//			height = 100;
//			break;
//		case 4:
//			height = 100;
//			break;
//		case 5:
//			height = 100;
//			break;
//		default:
//			break;
//	}
//	
//	height += indexPath.row + indexPath.section;
	
	return height = 200.0;
    
}

- (void)flowView:(WaterflowView *)flowView didSelectAtCell:(WaterFlowCell *)cell ForIndex:(int)index
{

}

- (void)flowView:(WaterflowView *)_flowView willLoadData:(int)page
{
   
    [flowView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
