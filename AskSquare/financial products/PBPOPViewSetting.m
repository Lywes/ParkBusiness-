//
//  PBPOPViewSetting.m
//  ParkBusiness
//
//  Created by China on 13-7-18.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBPOPViewSetting.h"
#import "PBPOPViewSetingDetail.h"
#import "PBFinancalProductsController.h"
#define STRING(x)        [NSString stringWithFormat:@"%@",(x>0?x:-1) == -1 ? @"":[NSString stringWithFormat:@"%d",x]]
@interface PBPOPViewSetting ()

@end
@implementation PBPOPViewSetting
@synthesize fin,DataArr,headArr,maintableView,subtableView,projecttype,licaiArr;
-(void)dealloc
{
    RB_SAFE_RELEASE(fin);
    RB_SAFE_RELEASE(mainArr);
    RB_SAFE_RELEASE(maintableView);
    RB_SAFE_RELEASE(subtableView);
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"搜索融资产品";
        maintableView = [[UITableView alloc]init];
        maintableView.delegate  =self;
        maintableView.dataSource = self;
        UIImageView *mainbg =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jrcs_searchBg1.png"]];
        maintableView.backgroundView = mainbg;
        [mainbg release];
        maintableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        subtableView = [[UITableView alloc]init];
        UIImageView *subbg =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jrcs_searchBg.png"]];
        subtableView.backgroundView = subbg;
        [subbg release];
        subtableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        subtableView.delegate  =self;
        subtableView.dataSource = self;
        [self.view addSubview:subtableView];
        [self.view addSubview:maintableView];
        mainArr = [[NSMutableArray alloc]init];
        NSArray* arr = [PBKbnMasterModel getKbnInfoByKind:@"projecttype"];
        for (PBKbnMasterModel* model in arr) {
            [mainArr addObject:model.name];
        }
        projecttype = -1;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.subtableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableArray *arry = [[NSMutableArray alloc]initWithObjects:@"需求资金量",@"企业发展阶段",@"固定资产规模",@"企业年销售额", @"行业",nil];
    self.headArr = arry;
    arry = [[NSMutableArray alloc]initWithObjects:NSLocalizedString(@"_tb_lclx", nil),@"年回报率",NSLocalizedString(@"_tb_sjzq", nil),nil];
    self.licaiArr = arry;
    [arry release];
    
    NSMutableArray *arry1 = [[NSMutableArray alloc]initWithObjects:@"点击选择",@"点击选择",@"点击选择",@"点击选择", @"点击选择",nil];
    self.DataArr = arry1;
    [arry1 release];
    
    UIBarButtonItem *rightbar = [[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(rightbarPress:)];
    self.navigationItem.rightBarButtonItem = rightbar;
    [rightbar release];
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"nav_btn_qx", nil) style:UIBarButtonItemStylePlain target:self action:@selector(leftbarPress:)];
    self.navigationItem.leftBarButtonItem = left;
    [left release];
	// Do any additional setup after loading the view.
}
-(void)rightbarPress:(id)sender
{
    NSArray* arr1 = [NSArray new];
    NSArray* arr2 = [NSArray new];
    if (projecttype==6) {
        arr1 = [NSArray arrayWithObjects:
                         USERNO,
                         STRING([PBKbnMasterModel getKbnIdByName:[self.DataArr objectAtIndex:0] withKind:@"mmtype"]),
                         STRING([PBKbnMasterModel getKbnIdByName:[self.DataArr objectAtIndex:1] withKind:@"earor"]),
                         STRING([PBKbnMasterModel getKbnIdByName:[self.DataArr objectAtIndex:2] withKind:@"timeperiod"]),
                         STRING(projecttype+1),
                         nil];
        
        arr2 = [NSArray arrayWithObjects:
                         @"userno",
                         @"fund",
                         @"companystage",
                         @"asset",
                         @"type",
                         nil];
    }else{
        arr1 = [NSArray arrayWithObjects:
                         USERNO,
                         STRING([PBKbnMasterModel getKbnIdByName:[self.DataArr objectAtIndex:0] withKind:@"fund"]),
                         STRING([PBKbnMasterModel getKbnIdByName:[self.DataArr objectAtIndex:1] withKind:@"companystage"]),
                         STRING([PBKbnMasterModel getKbnIdByName:[self.DataArr objectAtIndex:2] withKind:@"asset"]),
                         STRING([PBKbnMasterModel getKbnIdByName:[self.DataArr objectAtIndex:3] withKind:@"yearsale"]),
                         STRING([PBKbnMasterModel getKbnIdByName:[self.DataArr objectAtIndex:4] withKind:@"industry"]),
                         STRING(projecttype+1),
                         nil];
        
        arr2 = [NSArray arrayWithObjects:
                         @"userno",
                         @"fund",
                         @"companystage",
                         @"asset",
                         @"yearsale",
                         @"industry",
                         @"type",
                         nil];
    }
    
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjects:arr1 forKeys:arr2];
    [self.fin getOtherXmlData:@"1" dic:dic];
    [self dismissModalViewControllerAnimated:YES];
}
-(void)leftbarPress:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == subtableView) {
        return projecttype>=0?(projecttype==6?[licaiArr count]:[headArr count]):0;
    }
    return [mainArr count];
}
/*
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual: maintableView]) {
        cell.backgroundColor = [UIColor grayColor];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
//    if (tableView==subtableView&&projecttype>=0) {
//        if (indexPath.row%2==1) {
//            cell.backgroundColor = [UIColor grayColor];
//        }
//    }
}
 */
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier]autorelease];
        
    }
    if (!isPad()) {
        cell.textLabel.font = [UIFont boldSystemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }
    if ([_tableView isEqual: maintableView]) {
        //选中背景
        UIImageView *cellbg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jrcs_searchcellSel.png"]];
        cell.selectedBackgroundView = cellbg;
        [cellbg release];
        
        //分割线
        UIImageView *cellline = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jrcs_searchceellLine.png"]];
        cellline.frame = CGRectMake(0, cell.frame.size.height-1, cell.frame.size.width, 2);
        [cell.contentView addSubview:cellline];
        [cellline release];
        
        
        cell.textLabel.text = [mainArr objectAtIndex:indexPath.row];
        cell.textLabel.highlightedTextColor = [UIColor blackColor];
        if(indexPath.row == 0||indexPath.row == 1||indexPath.row == 4||indexPath.row == 6){
            UIImageView *cellac = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jrcs_searchceellAc1.png"]];
            cell.accessoryView = cellac;
            [cellac release];
        }
    }
    if ([_tableView isEqual: subtableView]&&projecttype>=0) {
        cell.textLabel.text = projecttype==6?[self.licaiArr objectAtIndex:indexPath.row]:[self.headArr objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [self.DataArr objectAtIndex:indexPath.row];
        cell.detailTextLabel.numberOfLines = 0;
        UIImageView *cellac = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jrcs_searchceellAc.png"]];
        cell.accessoryView = cellac;
        [cellac release];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tableView==maintableView){
        projecttype = indexPath.row;
        NSMutableArray *arry1 = [[NSMutableArray alloc]initWithObjects:@"",@"",@"",@"", @"",nil];
        self.DataArr = arry1;
        [arry1 release];
        if (indexPath.row == 0||indexPath.row == 1||indexPath.row == 4||indexPath.row == 6) {
            [self.subtableView reloadData];
        }else{
            [self rightbarPress:nil];
        }
    }
    if (_tableView == subtableView) {
        PBPOPViewSetingDetail*detail = [[PBPOPViewSetingDetail alloc]init];
        detail.title =  [NSString stringWithFormat:@"选择%@",[self.headArr objectAtIndex:indexPath.row]];
        detail.replaceno = indexPath.row;
        detail.seting = self;
        [self.navigationController pushViewController:detail animated:YES];
        [detail release];
    }


}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
