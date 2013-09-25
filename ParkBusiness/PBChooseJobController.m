//
//  PBChooseJobController.m
//  ParkBusiness
//
//  Created by lywes lee on 13-3-29.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBChooseJobController.h"
#import "PBUserModel.h"
#import "PBchooesjigou.h"
#import "PBpersonerInfo.h"
#import "FAFriendGroupData.h"
#import "PBChooseGovernment.h"
#import "UnderLineLabel.h"
#import "PBUserProtocolView.h"
#define UPDATEURL [NSString stringWithFormat:@"%@/admin/index/updatepassword",HOST]
#define URL_jigou [NSString stringWithFormat:@"%@admin/index/searchfinancinginstitution", HOST]//机构选择，用于获取机构的url
#define URL_jigourenshi [NSString stringWithFormat:@"%@admin/index/searchotherserviceinfo", HOST]//机构选择，用于获取机构的url
@interface PBChooseJobController ()

@end

@implementation PBChooseJobController
@synthesize rowno;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
//        UIBarButtonItem* rightbtn = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
        UIBarButtonItem* rightbar = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextDidPush)];
        self.navigationItem.rightBarButtonItem = rightbar;
        [rightbar release];
         [self.navigationItem setHidesBackButton:YES];
        self.rowno = -1;//所选角色
        checked = NO;
        // Custom initialization
    }
    return self;
}
-(void)dealloc
{
    [updateData release];
    [indicator release];
    [data release];
    [super dealloc];
}

-(void)nextDidPush{
    if (self.rowno>= 0&&checked) {
        NSUserDefaults* userData = [NSUserDefaults standardUserDefaults];
        [userData setInteger:self.rowno== 0?0:-1 forKey:@"kind"];
        [indicator startAnimating];
        NSString *userId = USERNO;
        NSString *kind = [NSString stringWithFormat:@"%d",self.rowno];
        NSArray* arr1 = [NSArray arrayWithObjects:userId, kind, nil];
        NSArray* arr2 = [NSArray arrayWithObjects:@"no",@"kind" , nil];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjects:arr1 forKeys:arr2];
        [updateData submitDataFromUrl:UPDATEURL postValuesAndKeys:dic];
        [dic release];
    }else {
        if (self.rowno< 0) {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择用户类型" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }else if(!checked){
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请同意用户协议" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        
    }
}
-(void)sucessSendPostData:(PBWeiboDataConnect *)weiboDatas{
    [indicator stopAnimating];
    [PBUserModel updateKind:self.rowno];
//    if(self.rowno==0){
//        PBpersonerInfo *personal = [[PBpersonerInfo alloc]initWithStyle:UITableViewStyleGrouped];
//        personal.headArr = [[NSMutableArray alloc]initWithObjects:@"真实姓名",@"性别", nil];
//        [self.navigationController pushViewController:personal animated:YES];
//        [personal release];
//    }
//    else
    FAFriendGroupData* group = [[FAFriendGroupData alloc]init];
    group.name = @"金融机构";
    group.idx = 0;
    group.no = 2;
    [group saveRecord];
    group.name = @"政府机关";
    group.idx = 1;
    group.no = 3;
    [group saveRecord];
    [group release];
    if(self.rowno==0){//游客
        PBpersonerInfo *personal = [[PBpersonerInfo alloc]initWithStyle:UITableViewStyleGrouped];
//        personal.headArr = [[NSMutableArray alloc]initWithObjects:@"真实姓名",@"性别", nil];
        [self.navigationController pushViewController:personal animated:YES];
        [personal release];
    }
    else if(self.rowno==1){//政府公职人员
        PBChooseGovernment* company = [[PBChooseGovernment alloc]init];//跳转公司
        company.title = @"选择政府公职部门";
        [self.navigationController setNavigationBarHidden:NO];
        company.LoginOrSeting = @"login";
        [self.navigationController pushViewController:company animated:YES];
        [company release];
    }
    else if(self.rowno==2){//企业家
        PBCompanyChoose* company = [[PBCompanyChoose alloc]init];//跳转公司
        company.title = @"选择所属公司";
        [self.navigationController setNavigationBarHidden:NO];
        company.LoginOrSeting = @"login";
        [self.navigationController pushViewController:company animated:YES];
        [company release];
    }
    else if(self.rowno==3){//金融机构
        PBchooesjigou *jigou = [[PBchooesjigou alloc]init];
        jigou.LoginOrSeting = @"login";
        jigou.postURL_str = URL_jigou;
        [self.navigationController pushViewController:jigou animated:YES];
        [jigou release];
    }
    else if(self.rowno==4){//其它认证机构人士
        PBchooesjigou *jigou = [[PBchooesjigou alloc]init];
        jigou.LoginOrSeting = @"login";
        jigou.postURL_str = URL_jigourenshi;
        [self.navigationController pushViewController:jigou animated:YES];
        [jigou release];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_background"]];
    updateData = [[PBWeiboDataConnect alloc]init];
    updateData.delegate = self;
    data = [[NSArray alloc]initWithObjects:@"游客",@"政府公职人员",@"认证企业人士",@"金融经理人",@"其它认证机构人士", nil];
    UIBarButtonItem* rightbar = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextDidPush)];
    self.navigationController.navigationItem.rightBarButtonItem = rightbar;
    [rightbar release];
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, isPad()?80:50)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:20];
    label.text = @"请选择您的用户类型";
    label.textAlignment = UITextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:80.0/255.0 green:41.0/255.0 blue:10.0/255.0 alpha:1.0];
    self.tableView.tableHeaderView = label;
    self.tableView.tableFooterView = [self initTableFooterView];
    indicator = [[PBActivityIndicatorView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:indicator];
}
-(UIView*)initTableFooterView{
    UIView* footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, isPad()?80:60)];
    UIButton* checkbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    checkbtn.layer.cornerRadius = 5.0;
    checkbtn.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:164.0/255.0 blue:51.0/255.0 alpha:1.0];
    [checkbtn addTarget:self action:@selector(checkDidPush:) forControlEvents:UIControlEventTouchUpInside];
    [checkbtn setBackgroundImage:[UIImage imageNamed:@"choose_checked"] forState:UIControlStateSelected];
    checkbtn.frame = isPad()?CGRectMake(240, 40, 40, 40):CGRectMake(60, 15, 25, 25);
    [checkbtn setSelected:checked];
    UnderLineLabel* label = [[UnderLineLabel alloc]initWithFrame:CGRectMake(2*checkbtn.frame.size.width+checkbtn.frame.origin.x, checkbtn.frame.origin.y, 250, checkbtn.frame.size.height)];
    label.text = @"同意  《用户协议》";
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:isPad()?20:16];
    UIControl* delegate = [[UIControl alloc]initWithFrame:label.frame];
    [delegate addTarget:self action:@selector(viewTapped:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:checkbtn];
    [footerView addSubview:label];
    [footerView addSubview:delegate];
    return footerView;
}
-(void)viewTapped:(UITapGestureRecognizer*)tap{
    PBUserProtocolView* view = [[PBUserProtocolView alloc]init];
    PBNavigationController* navi = [[PBNavigationController alloc]initWithRootViewController:view];
    view.title = @"用户协议";
    [navi.navigationBar setBackgroundImage:[UIImage imageNamed:@"topnavigation.png"] forBarMetrics:UIBarMetricsDefault];
    navi.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController presentModalViewController:navi animated:YES];
}
-(void)checkDidPush:(UIButton*)sender{
    checked = !checked;
    [sender setSelected:checked];
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
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [data count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isPad()) {
        return 70;
    }
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the cell...
    cell.textLabel.text = [data objectAtIndex:indexPath.section];
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    cell.textLabel.textColor = [UIColor whiteColor];
    if (self.rowno==indexPath.section) {
        cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"choose_customcell_selected"]];
    }else{
        cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"choose_customcell"]];
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
    self.rowno = indexPath.section;
    
    [self.tableView reloadData];
}

@end
