//
//  PBParkActivityViewController.m
//  ParkBusiness
//
//  Created by  on 13-3-4.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBParkActivityViewController.h"
#import "PBDetailActivityViewController.h"
#import "PBParkActivityCell.h"
#import "EGORefreshTableHeaderView.h"
#import "PBUserModel.h"
#import "PBActivityReview.h"
#define kSCNavBarImageTag                   10
#define PARK_ACTIVITY_URL [NSString stringWithFormat:@"%@admin/index/searchnotice",HOST]

@implementation PBParkActivityViewController


@synthesize searchBar1;
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

    //自定义UITableView
- (void)tableViewInit {
    
    CGFloat viewWidth = isPad() ? 768 : 320;
    CGFloat viewHeight = (isPad() ? 1024 : (isPhone5() ? 568 :480)) - KTabBarHeight - KNavigationBarHeight;
    
        //下拉显示
    pullController = [[PBPullTableViewController alloc]initWithFrame:CGRectMake(0, 44, viewWidth, viewHeight - 44)];
        
    pullController.delegate =self;
    pullController.tableViews.delegate = self;
    pullController.tableViews.dataSource = self;
    
    pullController.tableViews.backgroundColor=[UIColor clearColor];
	[self.view addSubview:pullController.tableViews];
}

    //自定义UISearchBar
- (void)searchBarInit {
    
    if (isPad()) {
         searchBar1 = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 768.0f, 44.0f)];
        
    }else{
        searchBar1 = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    }
    self.searchBar1.autocorrectionType = UITextAutocorrectionTypeNo;
	self.searchBar1.autocapitalizationType = UITextAutocapitalizationTypeNone;
	self.searchBar1.keyboardType = UIKeyboardTypeDefault;
	self.searchBar1.backgroundColor=[UIColor clearColor];
	searchBar1.translucent=YES;
	self.searchBar1.placeholder=@"搜索";
	self.searchBar1.delegate = self;
	self.searchBar1.barStyle=UIBarStyleDefault;
    [self.view addSubview:searchBar1];
    
    
    [[[searchBar1 subviews] objectAtIndex:0] removeFromSuperview];  
    UIImage *img = [[UIImage imageNamed:@"sousuolan.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:0];  
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];  
    imgView.frame= searchBar1.frame;  
    [searchBar1 insertSubview:imgView atIndex:0];
    [imgView release];
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

-(void)viewWillAppear:(BOOL)animated
{
    [self requestData:@"1"];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [self navigationBarBackgroundImage];
    [self keyboardDown];
    [self tableViewInit];
    [self searchBarInit];
    [self.view addSubview:pullController.indicator];
    
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
-(void)requestData:(NSString *)pageno
{
    if ([pageno isEqualToString:@"1"]) {
        [pullController.allData removeAllObjects];
    }
    [pullController.indicator startAnimating];
    parkManager = [[PBParkManager alloc] init];
    parkManager.delegate = self;
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:pageno, @"pageno", [NSString stringWithFormat:@"%d",[PBUserModel getParkNo]], @"parkno", USERNO,@"user",nil];
    [parkManager getRequestData:PARK_ACTIVITY_URL forValueAndKey:dic];
    [dic release];

}

-(void)keyboardDown
{
        //我添加的代码，此代码可以让keyboard消失
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    [tapGr release];
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [searchBar1 resignFirstResponder];
}

#pragma mark-
#pragma mark-   PBParkManagerDelegate
-(void)refreshData
{
    nodesMutableArr = [[NSArray arrayWithArray:parkManager.itemNodes] retain];
    [pullController successGetXmlData:pullController withData:nodesMutableArr withNumber:10];

}

#pragma mark-
#pragma mark-   UITableViewDataSource

      //返回多少行
- (NSInteger)tableView:(UITableView *)tableView_ numberOfRowsInSection:(NSInteger)section
{
         return [pullController.allData count];
       
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self heightForRow:[[pullController.allData objectAtIndex:indexPath.row] objectForKey:@"name"] defaultHeight:45.0f]+25.0f;
}
-(CGFloat)heightForRow:(NSString*)content defaultHeight:(CGFloat)height{
    CGFloat contentWidth = isPad()?610:210;
    UIFont *font = [UIFont systemFontOfSize:isPad()?16:14];
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:UILineBreakModeWordWrap];
    return MAX(size.height, height);
}
    //单元格重用(用的cell是自己定制的)
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static BOOL nibsRegisted = NO;
    static NSString *identifier = @"CellIdentifier";
    
    PBParkActivityCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        nibsRegisted = NO;
    }
    if (!nibsRegisted) {
        NSString *nibName = isPad() ? @"PBIpadParkActivityCell" :@"PBParkActivityCell";
        UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
        [_tableView registerNib:nib forCellReuseIdentifier:identifier];
        nibsRegisted = YES;
    }
    if (cell==nil) {
        cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleBlue;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; 
    if([pullController.allData count]>0){
        [pullController customLabelFontWithView:cell.customLabel];
        [pullController customLabelFontWithView:cell.labelView];
        //自适应文字高度设置
        CGFloat height = [self heightForRow:[[pullController.allData objectAtIndex:indexPath.row] objectForKey:@"name"] defaultHeight:45.0f];
        //设置标题布局
        CGRect frame = cell.customLabel.frame;
        frame.size.height = height;
        cell.customLabel.frame = frame;
        cell.customLabel.text = [[pullController.allData objectAtIndex:indexPath.row] objectForKey:@"name"];
        //设置时间和参会人数布局
        frame = cell.customView.frame;
        frame.origin.y = height;
        cell.customView.frame = frame;
        //设置回顾布局
        CGPoint center = cell.hgbtn.center;
        center.y = (height+25.0f)/2;
        cell.hgbtn.center = center;
        cell.amountLabel.text = [[pullController.allData objectAtIndex:indexPath.row] objectForKey:@"amount"];
        cell.labelView.text = [[[pullController.allData objectAtIndex:indexPath.row] objectForKey:@"enddate"] substringFromIndex:5];
            NSDateFormatter* fommatter = [[NSDateFormatter alloc]init];
            [fommatter setDateFormat:@"yyyy-MM-dd hh:mm"];
            NSDate *enddate = [fommatter dateFromString:[[pullController.allData objectAtIndex:indexPath.row] objectForKey:@"enddate"]];
            if ( enddate==[enddate earlierDate:[NSDate date]]) {
                cell.imageView.image = [UIImage imageNamed:@"hdCell.png"];
                int type = [[[pullController.allData objectAtIndex:indexPath.row] objectForKey:@"type"] intValue];
                if (type==2||type==3) {
                    cell.hgbtn.hidden = NO;
                }else{
                    cell.hgbtn.hidden = YES;
                }
                cell.hgbtn.tag = indexPath.row;
                [cell.hgbtn addTarget:self  action:@selector(huiguDidPush:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                cell.hgbtn.hidden = YES;
                cell.imageView.image = [UIImage imageNamed:@"hdcelling.png"];
            }
        [fommatter release];

    }
    
        
    return cell;
    
}

-(void)huiguDidPush:(UIButton*)sender{
    PBActivityReview *huodong  = [[PBActivityReview alloc]initWithStyle:UITableViewStyleGrouped];
    huodong.stylename = @"huigu";
    huodong.DataDic = [pullController.allData objectAtIndex:sender.tag];
    huodong.no = [[pullController.allData objectAtIndex:sender.tag]objectForKey:@"no"];
    [self.navigationController pushViewController:huodong animated:YES];
//    [huodong release];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:searchBar1.text, @"searchstr", @"1", @"pageno",[NSString stringWithFormat:@"%d",[PBUserModel getParkNo]],@"parkno",USERNO,@"user", nil];
    parkManager = [[PBParkManager alloc] init];
    parkManager.delegate = self;
    [pullController.allData removeAllObjects];
    [parkManager getRequestData:PARK_ACTIVITY_URL forValueAndKey:dic];
    [dic release];
    [searchBar1 resignFirstResponder];
    
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
        //搜索条输入文字修改时触发
    if([searchText length]==0)
        {
            //如果无文字输入
            [self requestData:@"1"];
            return;
        }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    detailActVC  = [[PBDetailActivityViewController alloc]init];
    detailActVC.data = [pullController.allData objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailActVC animated:YES];
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
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
