//
//  PBShowWeiboController.m
//  ParkBusiness
//
//  Created by lywes lee on 13-3-12.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBShowWeiboController.h"
#import "QuartzCore/QuartzCore.h"
#import "PBWeiboCell.h"
#import "PBTutorWeiboController.h"
#define URL [NSString stringWithFormat:@"%@/admin/index/searchtweibo",HOST]
#define TRADEURL [NSString stringWithFormat:@"%@/admin/index/tradekinds",HOST]
@interface PBShowWeiboController ()

@end

@implementation PBShowWeiboController
@synthesize tradekinds,sortkinds,tutorflag,tradeNo,sortNo;
-(void)dealloc{
    [super dealloc];
    [dropDown1 release];
    [dropDown2 release];
    [tradeView release];
    [lastestView release];
    [weiboData1 release];
    [weiboData2 release];
    [tradeImageName release];
    [sortImageName release];
}
- (id)init
{
    self = [super init];
    if (self) {
        self.tradekinds = [[NSMutableArray alloc]init];
        self.sortkinds = [[NSMutableArray alloc]initWithObjects:@"人气",@"最新", nil];
        self.tradeNo = @"";
        self.sortNo = @"";
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
    sortImageName = [[NSArray alloc]initWithObjects:@"sortdrop1.png",@"sortdrop2.png", nil];
//   UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
//    CGFloat width = headView.frame.size.width/2;
//    //设置下拉按钮
//    tradebtn = [self setSelectButton:CGRectMake(0, 0, width, headView.frame.size.height)];
//    [tradebtn addTarget:self action:@selector(tradeSelectClicked:) forControlEvents:UIControlEventTouchUpInside];
//    lastestbtn = [self setSelectButton:CGRectMake(width,0 , width, headView.frame.size.height)];
//    [lastestbtn addTarget:self action:@selector(lastSelectClicked:) forControlEvents:UIControlEventTouchUpInside];
//    //设置下拉图片
//    tradeView = [[PBCustomDropView alloc]initWithFrame:CGRectMake(0, 0, width, headView.frame.size.height)];
//    lastestView = [[PBCustomDropView alloc]initWithFrame:CGRectMake(width,0 , width, headView.frame.size.height)];
//    [tradeView setSelectViewWithTitle:@"行业分类" image:[UIImage imageNamed:@"tradedrop.png"]];
//    [lastestView setSelectViewWithTitle:@"默认排序" image:[UIImage imageNamed:@"sortdrop.png"]];
//    [headView addSubview:tradeView];
//    [headView addSubview:lastestView];
//    [headView addSubview:tradebtn];
//    [headView addSubview:lastestbtn];
    weiboData1 = [[PBWeiboDataConnect alloc]init];
    weiboData1.delegate = self;
    weiboData1.indicator = pullController.indicator;
    weiboData2 = [[PBWeiboDataConnect alloc]init];
    weiboData2.delegate = self;
    weiboData2.indicator = pullController.indicator;
    //获取行业数据
    [weiboData2 getXMLDataFromUrl:TRADEURL postValuesAndKeys:[NSMutableDictionary dictionary]];
    //下拉显示
//    CGFloat height = self.view.frame.size.height-KTabBarHeight-KNavigationBarHeight-headView.frame.size.height;
    pullController = [[PBPullTableViewController alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-88)];
    pullController.delegate =self;
    pullController.tableViews.delegate = self;
    pullController.tableViews.dataSource = self;
//    [self.view addSubview:headView];
    [self.view addSubview:pullController.tableViews];
    [self.view addSubview:pullController.indicator];
    [pullController.indicator startAnimating];
    pullController.pageno = 1;
    [self getXmlData:@"1" trade:self.tradeNo sort:self.sortNo];
    
}


//实现下拉更新操作
-(void)getDataSource:(PBRefreshTableHeaderView *)view{
    [self getXmlData:@"1" trade:self.tradeNo sort:self.sortNo];
}
-(void)getMoreButtonDidPush:(PBRefreshTableHeaderView *)view{
    [self getXmlData:[NSString stringWithFormat:@"%d",pullController.pageno] trade:self.tradeNo sort:self.sortNo];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[pullController._refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[pullController._refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}
//设置下拉列表button
-(UIButton*)setSelectButton:(CGRect)frame{
    UIButton *btnSelect = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSelect.backgroundColor = [UIColor clearColor];
    btnSelect.frame = frame;
    return btnSelect;
    
}
//行业分类下拉列表选项
- (void)tradeSelectClicked:(id)sender {
    NSMutableArray * arr = [[NSMutableArray alloc] initWithObjects:@"全部", nil];
    [arr addObjectsFromArray:self.tradekinds];
    lastestView.imageView2.image = [UIImage imageNamed:@"dropselect.png"];
    if(dropDown1 == nil) {
        tradeView.imageView2.image = [UIImage imageNamed:@"dropselected.png"];
        CGFloat f = isPad()?440:200;
        dropDown1 = [[PBDropDown alloc]showDropDown:sender height:&f arr:arr imageView:tradeImageName];
        dropDown1.delegate = self;
        [dropDown2 hideDropDown:lastestbtn];
        dropDown2 = nil;
    }
    else {
        tradeView.imageView2.image = [UIImage imageNamed:@"dropselect.png"];
        [dropDown1 hideDropDown:sender];
        dropDown1 = nil;
    }
}
//最新下拉列表选项
- (void)lastSelectClicked:(id)sender {
    tradeView.imageView2.image = [UIImage imageNamed:@"dropselect.png"];
    if(dropDown2 == nil) {
        lastestView.imageView2.image = [UIImage imageNamed:@"dropselected.png"];
        CGFloat f = isPad()?440:200;;
        dropDown2 = [[PBDropDown alloc]showDropDown:sender height:&f arr:self.sortkinds imageView:sortImageName];
        dropDown2.delegate = self;
        [dropDown1 hideDropDown:tradebtn];
        dropDown1 = nil;
    }
    else {
        lastestView.imageView2.image = [UIImage imageNamed:@"dropselect.png"];
        [dropDown2 hideDropDown:sender];
        dropDown2 = nil;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
//
-(void)viewWillDisappear:(BOOL)animated{
    [dropDown1 hideDropDown:tradebtn];
    [dropDown2 hideDropDown:lastestbtn];
    dropDown1 = nil;
    dropDown2 = nil;
}

-(void)getXmlData:(NSString*)page trade:(NSString*)trade sort:(NSString*)sort{
    [pullController.indicator startAnimating];
    if ([page isEqualToString:@"1"]) {
        [pullController.allData removeAllObjects];
    }
    NSArray* arr1 = [NSArray arrayWithObjects:page,trade,sort,nil];
    NSArray* arr2 = [NSArray arrayWithObjects:@"pageno",@"trade",@"sort", nil];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjects:arr1 forKeys:arr2];
    [weiboData1 getXMLDataFromUrl:URL postValuesAndKeys:dic];
}
//成功获取xml数据
-(void)sucessParseXMLData:(PBWeiboDataConnect *)weiboDatas{
    if(weiboDatas==weiboData1){
        [pullController successGetXmlData:pullController withData:weiboData1.parseData withNumber:10];
    }else{
            for(NSMutableDictionary* dic in weiboData2.parseData){
            [self.tradekinds addObject:[weiboData2 decodeFromPercentEscapeString: [dic objectForKey:@"name"]]];
        }
    }
    
}
//选择行业信息
- (void) pbDropDownDelegateMethod: (PBDropDown *) sender {
    [pullController.indicator startAnimating];
    if(sender==dropDown1){
        [tradeView setSelectViewWithTitle:[sender.title isEqualToString:@"全部"]?@"行业分类":sender.title image:[tradeImageName objectAtIndex:[sender.rowno intValue]]];
        self.tradeNo = [sender.title isEqualToString:@"全部"]?@"":sender.title;
        [self getXmlData:@"1" trade:self.tradeNo sort:self.sortNo];
    }else if (sender==dropDown2) {
        [lastestView setSelectViewWithTitle:sender.title image:[sortImageName objectAtIndex:[sender.rowno intValue]]];
        self.sortNo = sender.rowno;
        [self getXmlData:@"1" trade:self.tradeNo sort:self.sortNo];
    }
     dropDown1 = nil;
     dropDown2 = nil;
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
    if([pullController.allData count]>0){
        [pullController customLabelFontWithView:[cell contentView]];;//设置文字大小
        cell.customlabel1.font = [UIFont systemFontOfSize:isPad()?PadContentFontSize:ContentFontSize];//设置标题大小
        NSMutableDictionary* dic = [pullController.allData objectAtIndex:indexPath.row];
        cell.customlabel1.text = [weiboData1 decodeFromPercentEscapeString:[dic objectForKey:@"theme"]];//主题
        cell.customlabel2.text = [weiboData1 decodeFromPercentEscapeString:[dic objectForKey:@"name"]];//姓名
        cell.customlabel3.text = [weiboData1 decodeFromPercentEscapeString:[dic objectForKey:@"trade"]];//行业
        cell.customlabel4.text = [dic objectForKey:@"cdate"];//最新回复时间
        cell.customlabel5.text = [dic objectForKey:@"count"];//人气
        cell.imageViews = [[CustomImageView alloc]initWithFrame:CGRectMake(5, 10, 65 , 65)];
        [[cell contentView] addSubview:cell.imageViews];
        //加载boss头像应该用异步方式
        NSString *tutorURLStr = [NSString stringWithFormat:@"%@%@", HOST, [weiboData1 decodeFromPercentEscapeString:[dic objectForKey:@"urlimg"]]];
//        cell.imageViews.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:tutorURLStr]]];
        [cell.imageViews.imageView loadImage:tutorURLStr];
    }
    
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


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
     if ([pullController.allData count]>0) {
         PBTutorWeiboController *detailViewController = [[PBTutorWeiboController alloc] init];
         detailViewController.title = [weiboData1 decodeFromPercentEscapeString:[[pullController.allData objectAtIndex:indexPath.row] objectForKey:@"theme"]];
         detailViewController.data = [pullController.allData objectAtIndex:indexPath.row];
         detailViewController.tutorflag = self.tutorflag;
         detailViewController.type = [[pullController.allData objectAtIndex:indexPath.row] objectForKey:@"type"];
         [self.navigationController pushViewController:detailViewController animated:YES];
         [detailViewController release];
     }
}

@end
