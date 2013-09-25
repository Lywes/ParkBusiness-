//
//  PBChooselianjie.m
//  ParkBusiness
//
//  Created by China on 13-8-2.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define URL [NSString stringWithFormat:@"%@/admin/index/searchfinancingservice",HOST]

#import "PBChooselianjie.h"
#import "PBWeiboCell.h"
#import "PBFinancingCase.h"
@interface PBChooselianjie ()

@end

@implementation PBChooselianjie
@synthesize indexpath;
@synthesize financingcase;
-(void)dealloc{
    RB_SAFE_RELEASE(financingcase);
    RB_SAFE_RELEASE(indexpath);
//    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
//    [nc removeObserver:self];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"产品链接选择";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isSelect = NO;
}

- (void) requestData:(NSString *)pageno
{
    if ([pageno isEqualToString:@"1"]) {
        [pullController.allData removeAllObjects];
    }
    [pullController.indicator startAnimating];
    //下面这句代码为特例
    NSString* searchStr = searchBar.text?searchBar.text:@"";
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:searchStr, @"name", pageno, @"pageno", nil];
    [companyData getXMLDataFromUrl:URL postValuesAndKeys:dic];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    PBWeiboCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [tableView registerNib:[UINib nibWithNibName:@"PBWeiboCell" bundle:nil]forCellReuseIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }else {
        [cell.imageViews removeFromSuperview];
    }
    for (UIView* view in [[cell contentView] subviews]) {
        view.frame = CGRectZero;
    }
    if (![self.LoginOrSeting isEqualToString:@"login"]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    // Configure the cell...
    if ([pullController.allData count]>0) {
        NSMutableDictionary* dic = [pullController.allData objectAtIndex:indexPath.row];
        //设置cell位置及大小
        cell.customlabel1.font = [UIFont boldSystemFontOfSize:16];//设置姓名大小
        cell.customlabel1.frame = CGRectMake(85, 10, 200, 40);
        cell.customlabel2.font = [UIFont systemFontOfSize:isPad()?PadContentFontSize:ContentFontSize];//设置ID大小
        cell.customlabel2.textColor = [UIColor grayColor];
        cell.customlabel2.frame = CGRectMake(85, 45, 200, 30);
        cell.customlabel1.text = [dic objectForKey:@"name"];//姓名
        cell.customlabel1.numberOfLines = 0;
        cell.customlabel2.text = [dic objectForKey:@"financename"];//园区
        //加载boss头像应该用异步方式
        NSString *imgStr = [NSString stringWithFormat:@"%@%@", HOST, [dic objectForKey:@"imagepath"]];
        cell.imageViews = [[CustomImageView alloc]initWithFrame:CGRectMake(5, 5, 65 , 65)];
        [[cell contentView] addSubview:cell.imageViews];
        [cell.imageViews.imageView loadImage:imgStr];
 
        if ((indexPath.row == oldint.row && oldint != nil)) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        if ([[dic objectForKey:@"no"] isEqualToString:[NSString stringWithFormat:@"%d",self.financingcase.productno]]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.indexpath = indexPath;
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *defaultCell = [tableView cellForRowAtIndexPath:self.indexpath];
    defaultCell.accessoryType = UITableViewCellAccessoryNone;
    self.financingcase.productno = -1;
        int oldRow = (oldint == nil)?-1:oldint.row;
        int currentRow = indexPath.row;
        if (currentRow != oldRow ) {
            UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
            newCell.accessoryType = UITableViewCellAccessoryCheckmark;
            UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:oldint];
            oldCell.accessoryType = UITableViewCellAccessoryNone;

            oldint = [indexPath retain];
        }
    index = indexPath.row;
    self.indexpath = indexPath;
    isSelect = YES;
}
-(void)rightbutton{

    UIBarButtonItem *btn = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"nav_btn_wc", nil) style:UIBarButtonItemStylePlain target:self action:@selector(nextDidPush)];
    self.navigationItem.rightBarButtonItem = btn;
    [btn release];
}
-(void)nextDidPush
{
    
   // NSMutableArray *arr = [self.financingcase.DataArr objectAtIndex:indexpath.section];
   // [arr replaceObjectAtIndex:indexpath.row withObject:[[pullController.allData objectAtIndex:index] objectForKey:@"name"]];
    if (isSelect) {
        self.financingcase.productno = [[[pullController.allData objectAtIndex:index] objectForKey:@"no"] intValue];

    }
 //   [self.financingcase.tableView reloadData];
     
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
