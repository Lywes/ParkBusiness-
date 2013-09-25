//
//  PBSuperWeiboController.m
//  ParkBusiness
//
//  Created by lywes lee on 13-3-12.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBSuperWeiboController.h"
#import "PBWeiboCell.h"
#import "PBTutorWeiboController.h"
#define URL [NSString stringWithFormat:@"%@/admin/index/searchtweibo",HOST]
@interface PBSuperWeiboController ()

@end

@implementation PBSuperWeiboController
@synthesize tutorflag;
-(void)dealloc{
    [super dealloc];
//    [weiboData release];
//    [popupTextView release];
}
- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
               
    }
    return self;
}
-(void)dismissModalView{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //下拉显示
    CGFloat height = self.view.frame.size.height-KTabBarHeight-KNavigationBarHeight;
    pullController = [[PBPullTableViewController alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, height)];
    pullController.delegate =self;
    pullController.tableViews.delegate = self;
    pullController.tableViews.dataSource = self;
    [self.view addSubview:pullController.tableViews];
    weiboData = [[PBWeiboDataConnect alloc]init];
    weiboData.delegate = self;
    weiboData.indicator = pullController.indicator;
    [self.view addSubview:pullController.indicator];
    pullController.pageno = 1;
    [self getXmlData:@"1"];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)getXmlData:(NSString*)page{
    [pullController.indicator startAnimating];
    if ([page isEqualToString:@"1"]) {
        [pullController.allData removeAllObjects];
    }
    NSArray* arr1 = [NSArray arrayWithObjects:page,@"1", nil];
    NSArray* arr2 = [NSArray arrayWithObjects:@"pageno",@"flag", nil];
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
    return 110;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    PBWeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [tableView registerNib:[UINib nibWithNibName:isPad()?@"PBWeiboCell_ipad":@"PBWeiboCell" bundle:nil]forCellReuseIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }else {
        [cell.imageViews removeFromSuperview];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if([weiboData.parseData count]>0){
        [pullController customLabelFontWithView:[cell contentView]];//设置文字大小
        cell.customlabel1.font = [UIFont systemFontOfSize:isPad()?PadContentFontSize:ContentFontSize];//设置标题大小
        NSMutableDictionary* dic = [pullController.allData objectAtIndex:indexPath.row];
        cell.customlabel1.text = [weiboData decodeFromPercentEscapeString:[dic objectForKey:@"theme"]];//主题
        cell.customlabel2.text = [weiboData decodeFromPercentEscapeString:[dic objectForKey:@"name"]];//姓名
        cell.customlabel3.text = [weiboData decodeFromPercentEscapeString:[dic objectForKey:@"trade"]];//行业
        cell.customlabel4.text = [dic objectForKey:@"cdate"];//最新回复时间
         cell.customlabel5.text = [dic objectForKey:@"count"];//人气
        
        //加载boss头像应该用异步方式
        NSString *tutorURLStr = [NSString stringWithFormat:@"%@%@", HOST, [weiboData decodeFromPercentEscapeString:[dic objectForKey:@"urlimg"]]];
        cell.imageViews = [[CustomImageView alloc]initWithFrame:CGRectMake(5, 10, 65 , 65)];
        [[cell contentView] addSubview:cell.imageViews];
        [cell.imageViews.imageView loadImage:tutorURLStr];
    }
    // Configure the cell...
    
    return cell;
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
        PBTutorWeiboController *detailViewController = [[PBTutorWeiboController alloc] init];
        detailViewController.title = [weiboData decodeFromPercentEscapeString:[[pullController.allData objectAtIndex:indexPath.row] objectForKey:@"theme"]];
        detailViewController.data = [pullController.allData objectAtIndex:indexPath.row];
        detailViewController.tutorflag = self.tutorflag;
        detailViewController.type = [[pullController.allData objectAtIndex:indexPath.row] objectForKey:@"type"];
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
    }
}

@end
