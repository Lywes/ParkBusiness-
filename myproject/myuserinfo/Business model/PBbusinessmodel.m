//
//  PBbusinessmodel.m
//  ParkBusiness
//
//  Created by 新平 圣 on 13-3-4.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define SEARCHPROJECTMODEL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/searchpromode",HOST]]
#import "PBbusinessmodel.h"
#import "PBProjectData.h"
#import "PBIndustryData.h"
#import "PBUserModel.h"
#import "PBKbnMasterModel.h"
@interface PBbusinessmodel()
-(void)SearchOnServer;
@end
@implementation PBbusinessmodel
@synthesize _datas,pbprojectdata,projectno;
-(void)dealloc
{
    [acitivity release];
    [self._datas release];
    [modetype release];
    [popview release];
    [productText release];
    [potentText release];
    [super dealloc];
}
-(void)viewDidUnload
{
    [super viewDidUnload];
    modetype = nil;
    self._datas = nil;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}
-(void)viewLoding
{
    self.title = @"商业模式";
    acitivity = [[PBActivityIndicatorView alloc]initWithFrame:self.view.frame];
    [acitivity retain];
    if (isPad()) {
        modetype  = [[UILabel alloc]initWithFrame:CGRectMake(RATIO*150, 4, RATIO*200, 40)];

    }
    else {
        modetype  = [[UILabel alloc]initWithFrame:CGRectMake(150, 4, 200, 40)];

    }
    productText = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width-(isPad()?90:20), 120)];
    potentText = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width-(isPad()?90:20), 120)];
    productText.backgroundColor = [UIColor clearColor];
    productText.textAlignment = UITextAlignmentLeft;
    productText.delegate = self;
    potentText.backgroundColor = [UIColor clearColor];
    potentText.textAlignment = UITextAlignmentLeft;
    potentText.delegate = self;
    productText.tag = 2;
    potentText.tag = 3;
    //本地表
    modletype = [[NSMutableArray alloc]init];   
    NSMutableArray *model = [PBIndustryData search:@"mode"];
    for (PBIndustryData *industrydata in model) {
        if (industrydata.name!=NULL) {
            [modletype addObject:industrydata.name];

        }
    }
    popview  = [[POPView alloc]init];
    popview._arry = modletype;
    popview.view.hidden = YES;
    popview.delegate = self;
    [self.view addSubview:popview.view];
    
    
}
-(void)viewApperData
{
    NSString *modetype_ = [PBKbnMasterModel getKbnNameById:pbprojectdata.modetype withKind:@"mode"];
    modetype.text = modetype_;
    self.projectjieshao.text = pbprojectdata.businessmode;
    productText.text = pbprojectdata.productadvantage;
    potentText.text = pbprojectdata.potentialrisk;
    [self.tableView reloadData];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [acitivity removeFromSuperview];
}
-(void)viewWillAppear:(BOOL)animated
{    
    [super viewWillAppear:animated];
    [self.view addSubview:acitivity];
    if (![self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
        [self navigatorRightButtonType:BIANJI];
        self.pbprojectdata = [PBProjectData searchImagePath:self.projectno];
    }
    else {
        self.pbprojectdata = [[PBProjectData alloc]init];
         self.tableView.allowsSelection = NO;
        [self SearchOnServer];
    }
    [self viewApperData];
}
-(void)SearchOnServer
{
    [acitivity startAnimating]; 
    PBdataClass *dataclass = [[PBdataClass alloc]init];
    dataclass.delegate  = self;
    [dataclass dataResponse:SEARCHPROJECTMODEL postDic:[NSDictionary dictionaryWithObjectsAndKeys:[self.datadic objectForKey:@"companyno"],@"companyno",[self.datadic objectForKey:@"no"],@"projectno", nil] searchOrSave:YES];
}
-(void)viewTapped:(UITapGestureRecognizer *)tapGr{
    [productText resignFirstResponder];
    [potentText resignFirstResponder];
    [self.projectjieshao resignFirstResponder];
}
/*
 获取失败
 */
-(void)searchFilad
{
    [self editButtonPress:self.navigationItem.rightBarButtonItem];
    [acitivity stopAnimating];
}
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{
    if (datas.count > 0) {
        NSMutableDictionary *dic = [datas objectAtIndex:0];
        NSString *str = [dic objectForKey:@"modetype"];
        self.pbprojectdata.modetype = str.intValue;
        self.pbprojectdata.businessmode = [dic objectForKey:@"businessmode"];
        self.pbprojectdata.productadvantage = [dic objectForKey:@"productadvantage"];
        self.pbprojectdata.potentialrisk = [dic objectForKey:@"potentialrisk"];
        [self viewApperData];
    }
     [acitivity stopAnimating]; 
}
#pragma mark - 编辑状态
-(void)editState
{
    self.projectjieshao_tishi.hidden = NO;
}
-(void)postDataOnserver
{
    [acitivity startAnimating];
     self.projectjieshao_tishi.hidden = YES;
    //发送到服务器
    PBdataClass *datas1 = [[PBdataClass alloc]init];
    datas1.delegate = self;
    NSArray *a1 =[NSArray arrayWithObjects:@"mode",
                  @"no",
                  @"companyno",
                  @"modetype",
                  @"businessmode",
                  @"productadvantage",
                  @"potentialrisk",
                  nil];
    NSArray *a2 =[NSArray arrayWithObjects:@"mod",
                  [NSString stringWithFormat:@"%d",self.pbprojectdata.no],
                 USERNO,
                  [NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:modetype.text withKind:@"mode"]]==NULL?@"":[NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:modetype.text withKind:@"mode"]],
                  self.projectjieshao.text==NULL?@"":self.projectjieshao.text,
                  productText.text==NULL?@"":productText.text,
                  potentText.text==NULL?@"":potentText.text,
                  nil];
    [datas1 dataResponse:[NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/addpromode",HOST]] postDic:[NSDictionary dictionaryWithObjects:a2 forKeys:a1] searchOrSave:NO];

}
-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue
{
    //发送到本地
    self.pbprojectdata.no = [intvalue intValue];
    self.pbprojectdata.businessmode = self.projectjieshao.text;
    int modetype_ = [PBKbnMasterModel getKbnIdByName:modetype.text withKind:@"mode"];
    self.pbprojectdata.modetype = modetype_;
    self.pbprojectdata.productadvantage = productText.text;
    self.pbprojectdata.potentialrisk = potentText.text;
    [self.pbprojectdata saveRecord];
     [acitivity stopAnimating];
    [self.navigationController popViewControllerAnimated:YES];
}

/*
 上传失败
 */

-(void)requestFilad
{
    [acitivity stopAnimating]; 
}
#pragma mark - 表
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 4;
}
-(void)addSubViewForCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        cell.textLabel.text = @"模式分类:";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        modetype.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:modetype];
    }
    if (indexPath.section == 1) {
        [self addTextViewForCell:cell]; //projectjieshao
    }
    if (indexPath.section == 2) {
        [cell.contentView addSubview:productText];
    }
    if (indexPath.section == 3) {
        [cell.contentView addSubview:potentText];
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return @"商业模式:";
    }else if (section == 2){
        return @"产品或服务的特点与优点（包括市场占有率）:";
    }else if (section == 3){
        return @"潜在风险（包括政策或者技术路线）";
    }
    else {
        return nil;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (![self.ProjectStyle isEqualToString:ELSEPROJECTINFO]&&section!=0) {
        labletag = section;
        return [self TishiView];
    }else{
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    if (indexPath.section == 1) {
        height =  [self textViewHeightWithView:self.projectjieshao defaultHeight:44.0f];
    }else if(indexPath.section == 2){
        height = [self textViewHeightWithView:productText defaultHeight:44.0f];
    }else if(indexPath.section == 3){
        height = [self textViewHeightWithView:potentText defaultHeight:44.0f];
    }
    else
    {
        height = 44.0f;
    }
    return height;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [popview.view removeFromSuperview];
        popview.view.hidden = !popview.view.hidden;
        [popview popClickAction];
    }
}
- (void)popView:(POPView *)popview didSelectIndexPath:(NSIndexPath *)indexPath{
    modetype.text = [modletype objectAtIndex:indexPath.row];
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
