//
//  PBParkMicroblogViewController.m
//  ParkBusiness
//
//  Created by  on 13-3-4.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBParkMicroblogViewController.h"
#import "PBParkMicroblogCell.h"
#import "PBPersonalBlogViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "PBUserModel.h"

#define kSCNavBarImageTag                   10
#define PARK_WEIBO_URL [NSString stringWithFormat:@"%@admin/index/searchweibo",HOST]

@implementation PBParkMicroblogViewController

@synthesize parkManager;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
   
    [super didReceiveMemoryWarning];
    
}

    //解码字符串
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

    //自定义UITableView
- (void)tableViewInit {
   
    CGFloat viewWidth = isPad() ? 768 : 320;
    CGFloat viewHeight = (isPad() ? 1024 : (isPhone5() ? 568 :480)) - KTabBarHeight - KNavigationBarHeight;
    
        //下拉显示
    pullController = [[PBPullTableViewController alloc]initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    pullController.delegate =self;
    pullController.tableViews.delegate = self;
    pullController.tableViews.dataSource = self;
	pullController.tableViews.backgroundColor=[UIColor clearColor];
	[self.view addSubview:pullController.tableViews];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self tableViewInit];
    [self navigationBarBackgroundImage];
    [self.view addSubview:pullController.indicator];
    [self requestData:@"1"];
  
}
    //实现下拉更新操作
-(void)getDataSource:(EGORefreshTableHeaderView *)view{
    [self requestData:@"1"];
}
    //点击查看更多按钮
-(void)getMoreButtonDidPush:(EGORefreshTableHeaderView *)view{
    [self requestData:[NSString stringWithFormat:@"%d",pullController.pageno]];
}

    //拖动时调用方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[pullController._refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}
    //完成拖动时调用方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[pullController._refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}


-(void)popBackgoView
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)requestData:(NSString *)value
{
    if ([value isEqualToString:@"1"]) {
        [pullController.allData removeAllObjects];
    }
    [pullController.indicator startAnimating];
    parkManager = [[PBParkManager alloc] init];
    parkManager.delegate = self;
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",[PBUserModel getParkNo]], @"parkno", value, @"pageno",nil];
    [parkManager getRequestData:PARK_WEIBO_URL forValueAndKey:dic];
    [dic release];
    
}

#pragma mark-
#pragma mark-   PBParkManagerDelegate

-(void)refreshData
{
    nodesMutableArr = [[NSArray arrayWithArray:parkManager.itemNodes] retain];
    [pullController successGetXmlData:pullController withData:nodesMutableArr withNumber:10];
    
}

       //返回多少行
- (NSInteger)tableView:(UITableView *)tableView_ numberOfRowsInSection:(NSInteger)section
{
    return [pullController.allData count];
}

    //单元格重用
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static BOOL nibsRegisted = NO;
    static NSString *identifier = @"CellIdentifier";
    
    PBParkMicroblogCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        nibsRegisted = NO;
    }
    if (!nibsRegisted) {
        NSString *nibName = isPad() ? @"PBIpadParkMicroblogCell" : @"PBParkMicroblogCell";
        UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:identifier];
        nibsRegisted = YES;
    }
    if (cell==nil) {
        cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
        
    }else{
        [cell.imageViews removeFromSuperview];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;    
    if([pullController.allData count]>0){
        [pullController customLabelFontWithView:[cell contentView]];
        //加载boss头像应该用异步方式
        NSString *blogPhotoURLStr = [NSString stringWithFormat:@"%@%@", HOST, [self decodeFromPercentEscapeString:[[pullController.allData objectAtIndex:indexPath.row] objectForKey:@"urlimg"]]];
        cell.imageViews = [[CustomImageView alloc]initWithFrame:CGRectMake(5, 5, 60 , 60)];
        [[cell contentView] addSubview:cell.imageViews];
        [cell.imageViews.imageView loadImage:blogPhotoURLStr];
        cell.dateLabelView.text = [[pullController.allData objectAtIndex:indexPath.row] objectForKey:@"cdate"];
        cell.renQiLabelView.text = [[pullController.allData objectAtIndex:indexPath.row] objectForKey:@"count"];
        cell.themeLabelView.text = [[pullController.allData objectAtIndex:indexPath.row] objectForKey:@"theme"];
        
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    personalBlogVC = [[PBPersonalBlogViewController alloc] init];
    personalBlogVC.data = [parkManager.itemNodes objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:personalBlogVC animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
