//
//  PBhuodongyugaoVC.m
//  PBBank
//
//  Created by lywes lee on 13-5-6.
//  Copyright (c) 2013年 shanghai. All rights reserved.
//
#define DORPVIEWHEIGHT 40
#define SEARCHACTIVITY [NSURL URLWithString:[NSString stringWithFormat:@"%@admin/index/searchactivity",UNION]]
#import "PBhuodongyugaoVC.h"
#import "PBHuodongyugaoCell.h"
#import "PBhuodongyugao.h"
@interface PBhuodongyugaoVC ()
-(void)dropView;//下拉页面
-(void)Pullview;//tableview
-(void)initData;//初始化本页相关数据
@end

@implementation PBhuodongyugaoVC
@synthesize DataArr;
@synthesize stylename;
-(void)dealloc
{
    [self.DataArr release];
    [dataclass release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self dropView];
    [self Pullview];
    [self initData];
}
//两个下拉页面
-(void)dropView
{
    CGFloat width = self.view.frame.size.width;
    UIView *dropview = [[[UIView alloc]initWithFrame:CGRectMake(0, 0, width, DORPVIEWHEIGHT)]autorelease];
    UIButton *stypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    stypeBtn.frame = CGRectMake(0, 0, width/2,DORPVIEWHEIGHT);
    stypeBtn.tag = DORPVIEWHEIGHT;
    [stypeBtn addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *adressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    adressBtn.frame = CGRectMake(width/2, 0, width/2,DORPVIEWHEIGHT);
    adressBtn.tag = DORPVIEWHEIGHT + 1;
    [adressBtn addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *stypeimagview = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:isPad()?@"dropstyle_ipad.png":@"dropstyle.png"]]autorelease];
    fangxiang1 = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dropselect.png"]]autorelease];
    if (isPad()) {
        fangxiang1.frame = CGRectMake(348, 14, fangxiang1.frame.size.width, fangxiang1.frame.size.height);
    }
    else {
        fangxiang1.frame = CGRectMake(130, 14, fangxiang1.frame.size.width, fangxiang1.frame.size.height);
    }
    [stypeimagview addSubview:fangxiang1];
    stypeimagview.frame = stypeBtn.frame;
    UIImageView *adressimagview = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:isPad()?@"dropstyle_ipad.png":@"dropstyle.png"]]autorelease];
    fangxiang2 = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dropselect.png"]]autorelease];
    if (isPad()) {
        fangxiang2.frame = CGRectMake(348, 14, fangxiang2.frame.size.width, fangxiang2.frame.size.height);
    }
    else {
        fangxiang2.frame = CGRectMake(130, 14, fangxiang2.frame.size.width, fangxiang2.frame.size.height);
    }
    [adressimagview addSubview:fangxiang2];
    adressimagview.frame = adressBtn.frame;
    [dropview addSubview:stypeimagview];
    [dropview addSubview:adressimagview];
    [self.view addSubview:dropview];
    [dropview addSubview:stypeBtn];
    [dropview addSubview:adressBtn];
}
-(void)buttonPress:(UIButton *)btn
{
    if (btn.tag == DORPVIEWHEIGHT) {
         CGFloat f = isPad()?440:200;
        NSMutableArray * arr = [[NSMutableArray alloc] initWithObjects:@"全部",@"1", nil];
        if (dropview1 == nil) {
            dropview1 = [[PBDropDown alloc]showDropDown:btn height:&f arr:arr imageView:nil];
            dropview1.delegate = self;
            fangxiang1.transform = CGAffineTransformMakeRotation(M_PI_2 * 2);
            
            [dropview2 hideDropDown:(UIButton *)[self.view viewWithTag:DORPVIEWHEIGHT + 1]];
            fangxiang2.transform = CGAffineTransformMakeRotation(M_PI_2 * 0);
            dropview2 = nil;
        }
        else {
             fangxiang1.transform = CGAffineTransformMakeRotation(M_PI_2 * 0);
            [dropview1 hideDropDown:btn];
            dropview1 = nil;
        }
        
    }
    if (btn.tag == DORPVIEWHEIGHT + 1) {
        CGFloat f = isPad()?440:200;
        NSMutableArray * arr = [[NSMutableArray alloc] initWithObjects:@"全部",@"2", nil];
        if (dropview2 == nil) {
            dropview2 = [[PBDropDown alloc]showDropDown:btn height:&f arr:arr imageView:nil];
            dropview2.delegate = self;
            fangxiang2.transform = CGAffineTransformMakeRotation(M_PI_2 * 2);
            
            [dropview1 hideDropDown:(UIButton *)[self.view viewWithTag:DORPVIEWHEIGHT]];
            fangxiang1.transform = CGAffineTransformMakeRotation(M_PI_2 * 0);
            dropview1 = nil;
        }
        else {
            fangxiang2.transform = CGAffineTransformMakeRotation(M_PI_2 * 0);
            [dropview2 hideDropDown:btn];
            dropview2 = nil;
        }
        
    }
}
#pragma mark - dropview delegate
//下拉列表返回方法
- (void) pbDropDownDelegateMethod: (PBDropDown *) sender
{
    
    if (sender == dropview1) {
        [pulltableview.indicator startAnimating];
        UIButton *btn = (UIButton *)[self.view viewWithTag:DORPVIEWHEIGHT];
        [btn setTitle:sender.title forState:UIControlStateNormal];
        fangxiang1.transform = CGAffineTransformMakeRotation(M_PI_2 * 0);
        pageno = 1;
        NSString * flag;
        if ([self.stylename  isEqualToString:@"huigu"]) {
            flag = @"2";
        }
        else {
            flag = @"1";
        }
        NSDictionary *postdic = [NSDictionary dictionaryWithObjectsAndKeys:flag,@"flag",[NSString stringWithFormat:@"%d",pageno],@"pageno",@"金融对接会",@"type", nil];
        [dataclass dataResponse:SEARCHACTIVITY postDic:postdic searchOrSave:YES];
        [self.DataArr removeAllObjects];
        
    }
    if (sender == dropview2) {
        [pulltableview.indicator startAnimating];
        UIButton *btn = (UIButton *)[self.view viewWithTag:DORPVIEWHEIGHT + 1];
        [btn setTitle:sender.title forState:UIControlStateNormal];
    }
}
//表
-(void)Pullview
{
    CGFloat height = self.view.frame.size.height-KTabBarHeight-KNavigationBarHeight-DORPVIEWHEIGHT;
    pulltableview = [[PBPullTableViewController alloc]initWithFrame:CGRectMake(0, DORPVIEWHEIGHT, self.view.frame.size.width, height)];
    pulltableview.delegate = self;
    pulltableview.tableViews.delegate = self;
    pulltableview.tableViews.dataSource = self;
    [self.view addSubview:pulltableview.tableViews];
    [self.view addSubview:pulltableview.indicator];
}
//初始化数据
-(void)initData
{
    self.DataArr = [[[NSMutableArray alloc]init]autorelease];
    dataclass = [[PBdataClass alloc]init];
    dataclass.delegate = self;
    pageno = 1;
    NSString * flag;
    if ([self.stylename  isEqualToString:@"huigu"]) {
        flag = @"2";
    }
    else {
        flag = @"1";
    }
    [pulltableview.indicator startAnimating];
    NSDictionary *postdic = [NSDictionary dictionaryWithObjectsAndKeys:flag,@"flag",[NSString stringWithFormat:@"%d",pageno],@"pageno", nil];
    [dataclass dataResponse:SEARCHACTIVITY postDic:postdic searchOrSave:YES];
}
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{
    NSLog(@"活动预告:%@",datas);
    [self.DataArr addObjectsFromArray:datas];
    [pulltableview.tableViews reloadData];
    [pulltableview.indicator stopAnimating];
    [pulltableview successGetXmlData:pulltableview withData:self.DataArr withNumber:10];
}
-(void)searchFilad
{
    NSLog(@"获取失败");
}
#pragma mark - 当前页面表的代理方法
-(void)getDataSource:(PBPullTableViewController *)view
{
    [pulltableview.indicator startAnimating];
    pageno = 1;
    NSString * flag;
    if ([self.stylename  isEqualToString:@"huigu"]) {
        flag = @"2";
    }
    else {
        flag = @"1";
    }
    NSDictionary *postdic = [NSDictionary dictionaryWithObjectsAndKeys:flag,@"flag",[NSString stringWithFormat:@"%d",pageno],@"pageno", nil];
    [dataclass dataResponse:SEARCHACTIVITY postDic:postdic searchOrSave:YES];
    [self.DataArr removeAllObjects];
}
-(void)getMoreButtonDidPush:(PBRefreshTableHeaderView *)view{
//    [self getXmlData:[NSString stringWithFormat:@"%d",pulltableview.pageno] trade:self.tradeNo sort:self.sortNo];
    NSDictionary *postdic = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"flag",[NSString stringWithFormat:@"%d",pulltableview.pageno],@"pageno", nil];
    [dataclass dataResponse:SEARCHACTIVITY postDic:postdic searchOrSave:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[pulltableview._refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[pulltableview._refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [DataArr count]>0?[DataArr count]:1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    PBHuodongyugaoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [tableView registerNib:[UINib nibWithNibName:isPad()?@"PBHuodongyugaoCell_ipad":@"PBHuodongyugaoCell" bundle:nil]forCellReuseIdentifier:CellIdentifier];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }else {
        [cell.imageViews removeFromSuperview];
    }
    if (self.DataArr.count>0) {
        NSDictionary *dic = [DataArr objectAtIndex:indexPath.row];
        cell.customlabel1.text = [dic objectForKey:@"name"];//主题
        cell.customlabel2.text =  [dic objectForKey:@"stdate"];//时间
        cell.customlabel4.text = [dic objectForKey:@"address"];
    }
    else {
         cell.hidden = YES;
    }

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath  animated:YES];
    PBhuodongyugao *huodong  = [[PBhuodongyugao alloc]initWithStyle:UITableViewStyleGrouped];
    if (![self.stylename isEqualToString:@"huigu"]) {
        [huodong navigatorRightButtonType:BAOMING];
    }
    else {
        huodong.stylename = @"huigu";
    }
    huodong.no = [[self.DataArr objectAtIndex:indexPath.row]objectForKey:@"no"];
    [self.navigationController pushViewController:huodong animated:YES];
    [huodong release];
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
