//
//  PBFinanceProductList.m
//  ParkBusiness
//
//  Created by 上海 on 13-5-30.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBSearchFinanceProduct.h"
#import "PBFinanceProductCell.h"
#import "PBPurchaseFinanceProduct.h"
#define URL [NSString stringWithFormat:@"%@/admin/index/searchfinancingproduct",HOST]
@interface PBSearchFinanceProduct ()

@end

@implementation PBSearchFinanceProduct
@synthesize recommend;
@synthesize rootController;
-(void)dealloc{
    [super dealloc];
    [indexDic release];
    [weiboData release];
    [pullController release];
    [searchSearchBar release];
}
- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.recommend = @"";
        indexDic = [[NSMutableDictionary alloc]init];
    }
    return self;
}
-(void)dismissModalView{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //搜索条
    searchSearchBar=[[UISearchBar alloc] init];
    searchSearchBar.frame=CGRectMake(0, 0, self.view.bounds.size.width, 40);
    searchSearchBar.delegate=self;
    [searchSearchBar sizeToFit];
    searchSearchBar.placeholder = @"请输入产品名称";
    searchSearchBar.backgroundColor=[UIColor clearColor];
    [[searchSearchBar.subviews objectAtIndex:0]removeFromSuperview];
    for (UIView *subview in searchSearchBar.subviews)
    {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")])
        {
            [subview removeFromSuperview];
            break;
        }
    }
    [self.view addSubview:searchSearchBar];
    //下拉显示
    CGFloat height = self.view.frame.size.height-KTabBarHeight-KNavigationBarHeight;
    pullController = [[PBPullTableViewController alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width, height-60)];
    pullController.delegate =self;
    pullController.tableViews.delegate = self;
    pullController.tableViews.dataSource = self;
    pullController.tableViews.separatorStyle = UITableViewCellSeparatorStyleNone;
    pullController.tableViews.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
    [self.view addSubview:pullController.tableViews];
    weiboData = [[PBWeiboDataConnect alloc]init];
    weiboData.delegate = self;
    weiboData.indicator = pullController.indicator;
    [self.view addSubview:pullController.indicator];
    pullController.pageno = 1;
    
    //    [self backButton];
}
//-(void)backButton
//{
//    UIImage *image = [UIImage imageNamed:@"product_ba.png"];
//    UIButton *lefbt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
//    [lefbt setBackgroundImage:image forState:UIControlStateNormal];
//    [lefbt addTarget:self action:@selector(backUpViews) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *leftbutton = [[[UIBarButtonItem alloc]initWithCustomView:lefbt]autorelease];
//    self.navigationItem.leftBarButtonItem = leftbutton;
//}
//-(void)backUpViews
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (searchSearchBar.text) {
        [self getXmlData:@"1"];
    }
}
#pragma mark SearchBarDelegateMethod
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchSearchBar resignFirstResponder];
    [pullController.allData removeAllObjects];
    [self getXmlData:@"1"];
}
-(void)getXmlData:(NSString*)page{
    [pullController.indicator startAnimating];
    if ([page isEqualToString:@"1"]) {
        [pullController.allData removeAllObjects];
    }
    NSArray* arr1 = [NSArray arrayWithObjects:page,searchSearchBar.text?searchSearchBar.text:@"",[NSString stringWithFormat:@"%d",[PBUserModel getCompanyno]], nil];
    NSArray* arr2 = [NSArray arrayWithObjects:@"pageno",@"name", @"companyno",nil];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjects:arr1 forKeys:arr2];
    [weiboData getXMLDataFromUrl:URL postValuesAndKeys:dic];
}
//实现下拉更新操作
- (void)getDataSource:(PBPullTableViewController*)view{
    [self getXmlData:@"1"];
}
-(void)sucessParseXMLData:(PBWeiboDataConnect *)weiboDatas{
    [pullController successGetXmlData:pullController withData:weiboData.parseData withNumber:10];
    
}
-(void)getMoreButtonDidPush:(PBRefreshTableHeaderView *)view{
    [self getXmlData:[NSString stringWithFormat:@"%d",pullController.pageno]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[pullController._refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[pullController._refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

-(void)closePopTextView{//点击取消操作
    btnPressed = !btnPressed;
    self.navigationItem.rightBarButtonItem.enabled = YES;
}
//控制字数
-(void)popupTextView:(YIPopupTextView *)textView didChangeWithText:(NSString *)text{
    if([text length]>0){
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }else{
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [pullController.allData count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return isPad()?120:100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    PBFinanceProductCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [tableView registerNib:[UINib nibWithNibName:isPad()?@"PBFinanceProductCell_ipad":@"PBFinanceProductCell" bundle:nil]forCellReuseIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }else {
        [cell.productimage removeFromSuperview];
    }
    
    if([weiboData.parseData count]>0){
        
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"product_cell.png"]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSMutableDictionary* dic = [pullController.allData objectAtIndex:indexPath.row];
        cell.productname.text = [dic objectForKey:@"name"];//产品名称
        cell.briefintro.text = [dic objectForKey:@"briefintro"];//简介
        cell.originalprice.text = [dic objectForKey:@"originalprice"];//原价
        cell.currentprice.text = [dic objectForKey:@"currentprice"];//现价
        cell.nownumber.text = [dic objectForKey:@"number"];//人数
        cell.enddate.text = [dic objectForKey:@"showenddate"];//时间
        [cell.briefintro sizeToFit];
        [cell.buybutton addTarget:self action:@selector(buyProduct:) forControlEvents:UIControlEventTouchUpInside];
        cell.buybutton.tag = indexPath.row;
        CGSize currentsize = [cell.currentprice.text sizeWithFont:[UIFont systemFontOfSize:isPad()?14:12]];
        CGFloat originwidth = cell.currentprice.frame.origin.x;
        CGRect frame = cell.originalprice.frame;
        frame.origin.x = originwidth+currentsize.width+3;
        cell.originalprice.frame = frame;
        CGSize originalsize = [cell.originalprice.text sizeWithFont:[UIFont systemFontOfSize:isPad()?12:10]];
        UILabel* line = [[UILabel alloc]initWithFrame:CGRectMake(2, 5, originalsize.width, 1)];
        line.backgroundColor = [UIColor redColor];
        [cell.originalprice addSubview:line];
        [line release];
        NSString *urlStr = [NSString stringWithFormat:@"%@%@", HOST,[dic objectForKey:@"imagepath"]];
        cell.productimage = [[CustomImageView alloc]initWithFrame:isPad()?CGRectMake(15, 5, 200 , 100):CGRectMake(5, 10, 110 , 75) withBackColor:[UIColor whiteColor]];
        [[cell contentView] addSubview:cell.productimage];
        [cell.productimage.imageView loadImage:urlStr];
        [indexDic setObject:indexPath forKey:[NSString stringWithFormat:@"%d",indexPath.row]];
    }
    // Configure the cell...
    
    return cell;
}

-(void)buyProduct:(UIButton*)sender{
    NSIndexPath* indexPath = [indexDic objectForKey:[NSString stringWithFormat:@"%d",sender.tag]];
    [self pushDetailController:indexPath];
}
-(void)pushDetailController:(NSIndexPath*)indexPath{
    PBFinanceProductCell* cell = (PBFinanceProductCell*)[pullController.tableViews cellForRowAtIndexPath:indexPath];
    NSMutableDictionary* dic = [pullController.allData objectAtIndex:indexPath.row];
    PBPurchaseFinanceProduct *detailViewController = [[PBPurchaseFinanceProduct alloc] init];
    detailViewController.title = [dic objectForKey:@"name"];
    detailViewController.dataDic = dic;
    detailViewController.rootController = self.rootController;
    detailViewController.image = cell.productimage.imageView.image;
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(indexPath.row == [self.allData count]-1){
//        self.tableViews.tableFooterView = _refreshFooterView;
//    }else {
//        self.tableViews.tableFooterView = nil;
//    }
//}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    if ([pullController.allData count]>0) {
        [self pushDetailController:indexPath];
    }
}

@end
