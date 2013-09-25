//
//  PBProjectList.m
//  ParkBusiness
//
//  Created by lywes lee on 13-4-16.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBProjectList.h"
#import "PBProjectTypeView.h"
#import "PBWeiboCell.h"
#import "PBKbnMasterModel.h"
#import "PBFinanceAssureList.h"
#import "PBAssureCompanyInfo.h"
@interface PBProjectList ()
-(void)searchInDB;
-(void)POPAddProject;
@end

@implementation PBProjectList
@synthesize projectListArry;
@synthesize myproject;
@synthesize proname;
-(void)dealloc
{
    [self.proname release];
    [self.myproject release];
    [self.projectListArry = nil release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }	
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self searchInDB];
    [self rightBtnHidden:NO];
}
-(void)searchInDB
{
    [self.projectListArry removeAllObjects];
    NSMutableArray *arry = [PBProjectData searchAllProjectData];
    if (arry.count !=0) {
        [self.projectListArry addObjectsFromArray:arry];
        [self.tableView reloadData];
    }
//    else {
//        [self POPAddProject];
//    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.projectListArry removeAllObjects];
    [self rightBtnHidden:YES];
}
-(void)rightBtnHidden:(BOOL)show
{
    for (UIView * NavView in [self.navigationController.view subviews]) {
        if ([NavView isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)NavView;
            if ([btn.titleLabel.text isEqualToString:@"专家咨询"]) {
                btn.hidden = show;
            }
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect frame = self.tableView.frame;
    frame.size.height -= KTabBarHeight;
    self.tableView.frame = frame;
    addgroupview = [[[FAAddGroupView alloc]initWithFrame:self.navigationController.view.frame]autorelease];
    addgroupview.delegate = self;
    addgroupview.hidden = YES;
    [addgroupview retain];
    [self.view addSubview:addgroupview];
    self.projectListArry = [[[NSMutableArray alloc]init]autorelease];
    UIImage *image = [UIImage imageNamed:@"back.png"];
    UIButton *lefbt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [lefbt setBackgroundImage:image forState:UIControlStateNormal];
    [lefbt addTarget:self action:@selector(backUpView) forControlEvents:UIControlEventTouchUpInside];

//    UIBarButtonItem *rightbtn = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"nav_btn_zj", nil) style:UIBarButtonItemStylePlain target:self action:@selector(postDataOnserver)];
//    self.navigationItem.rightBarButtonItem = rightbtn;
    
    self.tableView.tableFooterView = [self footView];
//    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, image.size.height)];
//    button.backgroundColor = [UIColor redColor];
//    button.titleLabel.textColor = [UIColor blackColor];
//    [button setTitle:@"专家咨询" forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont systemFontOfSize:10];
//    button.titleLabel.textColor = [UIColor blackColor];
//    [button addTarget:self action:@selector(zhuanjiazixun:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *zixunbtn = [[UIBarButtonItem alloc]initWithCustomView:button];
//    UIBarButtonItem *zixunbtn = [[UIBarButtonItem alloc]initWithTitle:@"专家咨询" style:UIBarButtonItemStylePlain target:self action:@selector(zhuanjiazixun:)];
//    self.navigationItem.rightBarButtonItem = rightbtn;
}
//-(void)zhuanjiazixun:(id)sender
//{
//    PBAssureCompanyInfo* apply = [[PBAssureCompanyInfo alloc]initWithStyle:UITableViewStyleGrouped];
//    [apply navigatorRightButtonType:NEXT];
//    apply.mode = @"add";
//    apply.type = 2;
//    apply.GOFinacing = YES;
//    apply.title = @"企业现状";
//    [self.navigationController pushViewController:apply animated:YES];
//
//}
#pragma mark - 追加新项目
-(UIView *)footView
{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120)];
    UITextView *footview = [[[UITextView alloc]initWithFrame:CGRectMake(20, 0, self.view.frame.size.width-40, 100)]autorelease];
    footview.font = [UIFont systemFontOfSize:isPad()?16:14];
    footview.text = @"如果您还不清楚贵公司适合何种融资方式，请在'我的需求'模块中按照要求填写您的融资需求，本平台上的各家金融机构会根据您的融资需求给出具体的融资方案，供您参考与选择。您也可以拨打如下电话咨询我们的金融专家：021-53930568。";
    footview.scrollEnabled = NO;
    footview.backgroundColor = [UIColor clearColor];
    [view addSubview:footview];
    return view;
}
-(void)backUpView
{
    [self.navigationController.tabBarController.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 追加新项目
-(void)postDataOnserver
{
    [self POPAddProject];
}
-(void)POPAddProject{
    PBProjectTypeView* typeView = [[PBProjectTypeView alloc]initWithStyle:UITableViewStyleGrouped];
    PBNavigationController* nav = [[PBNavigationController alloc]initWithRootViewController:typeView];
    typeView.title = @"追加融资申请";
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"topnavigation.png"] forBarMetrics:UIBarMetricsDefault];
    [nav.navigationBar setBarStyle:UIBarStyleBlack];
    [self presentModalViewController:nav animated:YES];
//    [addgroupview addGroupViewWillShow];

}
-(BOOL)submitDidPushWithName:(NSString *)groupName{
 
    if (![groupName isEqual:@""]) {
        self.proname = groupName;
        pb = [[PBdataClass alloc]init];
        pb.delegate = self;
        NSString *userid = USERNO;
        NSArray *a1 = [[NSArray alloc]initWithObjects:@"mode",
                       @"companyno",
                       @"proname",
                       @"stage",
                       @"stdate",
                       @"trade",
                       @"introduce", 
                       nil];
        NSArray *a2 = [[NSArray alloc]initWithObjects:@"add",
                       userid,
                       groupName,
                       @"",
                       @"",
                       @"",
                       @"", 
                       nil];
        [pb dataResponse:[NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/addproject",HOST]] postDic:[[NSDictionary alloc]initWithObjects:a2 forKeys:a1] searchOrSave:NO];    
        
        return YES;
    }
    else {
        return NO;
    }

}
-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue
{
    if (dataclass == pb) {
        //上传到本地
        PBProjectData *pbprojectdata1 = [[[PBProjectData alloc]init]autorelease];
        pbprojectdata1.no = [intvalue intValue];
        pbprojectdata1.proname = self.proname;
        pbprojectdata1.imagepath = [UIImage imageNamed:@"image-2.png"];
        pbprojectdata1.companyno = [PBUserModel getUserId];
        [pbprojectdata1 saveRecord];
        [self searchInDB];
    }
    else
    {
        PBProjectData* data = [self.projectListArry objectAtIndex:numsection];
        data.no = [intvalue intValue];
        [data deleteRecord];
        self.projectListArry = [PBProjectData searchAllProjectData];
        [self.tableView reloadData];
    }
    [dataclass release];
}
- (void)viewDidUnload
{
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return [self.projectListArry count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85;
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
    
    for (UIView* view in [[cell contentView] subviews]) {
        view.frame = CGRectZero;
    }
    if([self.projectListArry count]>0){
        PBProjectData *pbprojectdata = [self.projectListArry objectAtIndex:indexPath.section];
        //设置cell位置及大小
        cell.customlabel1.font = [UIFont boldSystemFontOfSize:isPad()?18:14];//设置项目名称大小
        cell.customlabel1.frame = isPad()?CGRectMake(85, 15, 600, 30):CGRectMake(85, 0, 200, 60);
        cell.customlabel1.numberOfLines = 0;
        cell.customlabel2.font = [UIFont systemFontOfSize:isPad()?PadContentFontSize:ContentFontSize];//设置项目类型大小
        cell.customlabel2.textColor = [UIColor grayColor];
        cell.customlabel2.frame = CGRectMake(85, 45, 100, 30);
        cell.customlabel1.text = pbprojectdata.proname;//项目名称
        cell.customlabel2.text = [PBKbnMasterModel getKbnNameById:pbprojectdata.type withKind:@"projecttype"];//项目类型
        cell.imageViews = [[CustomImageView alloc]initWithFrame:CGRectMake(5, 5, 65 , 65)];
        [[cell contentView] addSubview:cell.imageViews];
        cell.imageViews.imageView.image = pbprojectdata.imagepath;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.myproject) {
         [self.myproject release];
    }
    PBProjectData* data = [self.projectListArry objectAtIndex:indexPath.section];
    if (data.type==1) {//股权融资 银行贷款
        self.myproject = [[MyProject alloc]init];
        myproject.pbprojectdata = [PBProjectData searchImagePath:data.no];
        [self.navigationController pushViewController:self.myproject animated:YES];
    }else{
        PBFinanceAssureList* list = [[PBFinanceAssureList alloc]initWithStyle:UITableViewStyleGrouped];
        list.projectno = data.no;
        list.type = data.type;
        list.title = data.proname;
        [self.navigationController pushViewController:list animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PBProjectData* data = [self.projectListArry objectAtIndex:indexPath.section];
        numsection = indexPath.section;
        deletedb  = [[PBdataClass alloc]init];
        deletedb.delegate = self;
        [deletedb dataResponse:[NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/addproject",HOST]] postDic:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",data.no],@"no",@"del",@"mode",[NSString stringWithFormat:@"%d",data.type],@"type", nil] searchOrSave:NO];
    }
}


@end
