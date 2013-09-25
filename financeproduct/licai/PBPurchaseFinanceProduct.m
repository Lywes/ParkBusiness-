//
//  PBPurchaseFinanceProduct.m
//  ParkBusiness
//
//  Created by 上海 on 13-6-3.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBPurchaseFinanceProduct.h"
#import "PBPurchaseProductCell.h"
#import "PBQuestionListController.h"
#import "PBRemarkListController.h"
#import "PBAssureCompanyInfo.h"
#define RECORDURL [NSString stringWithFormat:@"%@/admin/index/updaterecord",HOST]
#define NICEURL [NSString stringWithFormat:@"%@admin/index/addmyfavourites", HOST]
@interface PBPurchaseFinanceProduct ()

@end

@implementation PBPurchaseFinanceProduct
@synthesize image;
@synthesize dataDic;
@synthesize hasBuy;
@synthesize rootController;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //评论
    UIButton *remarkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    remarkBtn.frame = isPad()?CGRectMake(6, 6, 42, 30):CGRectMake(6, 6, 33, 26);
    [remarkBtn setBackgroundImage:[UIImage imageNamed:@"product_re.png"] forState:UIControlStateNormal];
    [remarkBtn addTarget:self action:@selector(remark) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *remarkBtnItem = [[UIBarButtonItem alloc] initWithCustomView:remarkBtn];
    
    UIButton *questionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    questionBtn.frame = isPad()?CGRectMake(6, 6, 42, 30):CGRectMake(6, 6, 33, 26);
    [questionBtn setBackgroundImage:[UIImage imageNamed:@"product_qa.png"] forState:UIControlStateNormal];
    [questionBtn addTarget:self action:@selector(question) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *questionBtnItem = [[UIBarButtonItem alloc] initWithCustomView:questionBtn];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:remarkBtnItem, questionBtnItem, nil];
    [remarkBtnItem release];
    [questionBtnItem release];
    shoucangData = [[PBWeiboDataConnect alloc]init];
    shoucangData.delegate = self;
    zanData = [[PBWeiboDataConnect alloc]init];
    zanData.delegate = self;
    hasSC = [[self.dataDic objectForKey:@"scflag"] isEqualToString:@"1"];
    hasZan = [[self.dataDic objectForKey:@"zanflag"] isEqualToString:@"1"];
    hasBuy = [self.dataDic objectForKey:@"flag"];
    [self backButton:self];
    inputToolbar = [[UIInputToolbar alloc] initWithFrame:CGRectMake(0, isPad()?1024:(isPhone5()?568:480), isPad()?768:320, 40)];
    inputToolbar.delegate = self;
    inputToolbar.textView.placeholder = @"请输入提问";
    [self.navigationController.view addSubview:inputToolbar];
    [inputToolbar addObserverFromController:self];
}
-(void)viewDidUnload{
    [super viewDidUnload];
    [inputToolbar removeObserverFromController:self];
}
-(void)inputButtonPressed:(NSString *)inputText
{
    [indicator startAnimating];
    sendmanager = [[PBWeiboDataConnect alloc] init];
    sendmanager.delegate= self;
    if ([inputtype isEqualToString:@"question"]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"2", @"type", [NSString stringWithFormat:@"%d", [PBUserModel getUserId]], @"userno", [self.dataDic objectForKey:@"no"], @"questionno",inputText, @"question", nil];
        [sendmanager submitDataFromUrl:QUESTIONINFO postValuesAndKeys:dic];
    }else{
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"3", @"type", [NSString stringWithFormat:@"%d", [PBUserModel getUserId]], @"userno", [self.dataDic objectForKey:@"no"], @"commentno", inputText, @"content", nil];
        [sendmanager submitDataFromUrl:REMARKINFO postValuesAndKeys:dic];
    }
    
}
- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    [inputToolbar keyboardWillShowHide:notification];
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    [inputToolbar keyboardWillShowHide:notification];
    [inputToolbar keyboardWillHide];
}

-(void)backButton:(UIViewController*)controller
{
    UIImage *images = [UIImage imageNamed:@"back.png"];
    UIButton *lefbt = [[UIButton alloc]initWithFrame:isPad()?CGRectMake(0, 0, images.size.width+5, images.size.height+5):CGRectMake(0, 0, images.size.width, images.size.height)];
    [lefbt setBackgroundImage:images forState:UIControlStateNormal];
    [lefbt addTarget:controller action:@selector(backUpViews) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftbutton = [[[UIBarButtonItem alloc]initWithCustomView:lefbt]autorelease];
    controller.navigationItem.leftBarButtonItem = leftbutton;
}
-(void)backUpViews
{
    [self.navigationController popViewControllerAnimated:YES];
}

//评论
- (void) remark
{
    inputtype = @"remark";
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) destructiveButtonTitle:nil otherButtonTitles:@"我要评论",@"评论列表", nil];
    sheet.tag = 2;
    [sheet showInView:self.navigationController.view];
    
}

//提问，提问上传的参数是type,questionno,userno和question。。在这里提问获取的questionno是什么
- (void) question
{
    inputtype = @"question";
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) destructiveButtonTitle:nil otherButtonTitles:@"我要提问",@"提问列表", nil];
    sheet.tag = 1;
    [sheet showInView:self.navigationController.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag==1) {
        switch (buttonIndex) {
            case 0:
                [inputToolbar.textView becomeFirstResponder];
                break;
            case 1:{
                PBQuestionListController *contrllor = [[PBQuestionListController alloc] init];
                contrllor.titleString = @"提问列表";
                contrllor.typeString = @"2";
                contrllor.qaNoString = [self.dataDic objectForKey:@"productno"];
                [self.navigationController pushViewController:contrllor animated:YES];
                [contrllor release];
            }
                break;
            default:
                break;
        }
    }else{
        switch (buttonIndex) {
            case 0:
                [inputToolbar.textView becomeFirstResponder];
                break;
            case 1:{
                PBRemarkListController *controller = [[PBRemarkListController alloc] init];
                //需要传递一些参数过去
                NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:self.dataDic];
                [dic setObject:@"3" forKey:@"remarktype"];
                controller.infoDic = dic;
                [self.navigationController pushViewController: controller animated:YES];
                [controller release];
            }
                break;
            default:
                break;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return isPad()?1024:480;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    PBPurchaseProductCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    [tableView registerNib:[UINib nibWithNibName:isPad()?@"PBPurchaseProductCell_ipad":@"PBPurchaseProductCell" bundle:nil]forCellReuseIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.productname.text = [dataDic objectForKey:@"name"];//产品名称
    cell.introduce.text = [dataDic objectForKey:@"introduce"];//简介
    cell.originalprice.text = [dataDic objectForKey:@"originalprice"];//原价
    cell.currentprice.text = [dataDic objectForKey:@"currentprice"];//现价
    cell.nownumber.text = [NSString stringWithFormat:@"%@人已购",[dataDic objectForKey:@"number"]];//人数
    cell.limitnumber.text = [NSString stringWithFormat:@"最低购买人数:%@人",[dataDic objectForKey:@"lowestnumber"]];//人数
    [cell.introduce sizeToFit];
    if (hasSC) {
        cell.scbutton.enabled = NO;
        [cell.scbutton setBackgroundImage:[UIImage imageNamed:isPad()?@"product_yscpad.png":@"product_ysc.png"] forState:UIControlStateNormal];
    }else{
        [cell.scbutton addTarget:self action:@selector(shoucangDidPush:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (hasZan) {
        
        cell.zanbutton.enabled = NO;
        [cell.zanbutton setBackgroundImage:[UIImage imageNamed:isPad()?@"product_yzanpad.png":@"product_yzan.png"] forState:UIControlStateNormal];
    }else{
        [cell.zanbutton addTarget:self action:@selector(zanDidPush:) forControlEvents:UIControlEventTouchUpInside];
    }
    if ([hasBuy isEqualToString:@"1"]) {
        cell.buybutton.enabled = NO;
    }else{
        [cell.buybutton addTarget:self action:@selector(buyProduct) forControlEvents:UIControlEventTouchUpInside];
    }
    index = indexPath;
    endLabel = cell.enddate;
    cell.enddate.text = [self updateLabel].text ;//时间
    //设置原价中横线
    CGSize currentsize = [cell.currentprice.text sizeWithFont:[UIFont systemFontOfSize:isPad()?28:20]];
    CGFloat originwidth = cell.currentprice.frame.origin.x;
    CGRect frame = cell.originalprice.frame;
    frame.origin.x = originwidth+currentsize.width+3;
    cell.originalprice.frame = frame;
    CGSize originalsize = [cell.originalprice.text sizeWithFont:[UIFont systemFontOfSize:isPad()?22:14]];
    UILabel* line = [[UILabel alloc]initWithFrame:CGRectMake(2, originalsize.height/2+1, originalsize.width, 1)];
    line.backgroundColor = [UIColor whiteColor];
    [cell.originalprice addSubview:line];
    [line release];
    cell.productimage.image = image;
    // Configure the cell...
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateLabel) userInfo:nil repeats:YES];
    // Timer运行开始
	NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
	[runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
    return cell;
}
//倒计时
-(UILabel*)updateLabel
{
//    PBPurchaseProductCell *cell = (PBPurchaseProductCell*)[self.tableView cellForRowAtIndexPath:index];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* enddate = [formatter dateFromString:[dataDic objectForKey:@"enddate"]];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    int units = NSDayCalendarUnit | NSHourCalendarUnit| NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *components = [calendar components:units fromDate:[NSDate date] toDate:enddate options:0];
    
    [endLabel setText:[NSString stringWithFormat:@"%d天%d小时%d分%d秒", [components day], [components hour], [components minute], [components second]]];
    [endLabel sizeToFit];
    return endLabel;
}
//点击收藏
-(void)shoucangDidPush:(UIButton*)sender{
    sender.enabled = NO;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self.dataDic objectForKey:@"no"], @"projectno", [NSString stringWithFormat:@"%d", [PBUserModel getCompanyno]], @"personno", @"7",@"type",nil];
    [shoucangData submitDataFromUrl:FAVOURITES postValuesAndKeys:dic];
}
-(void)sucessSendPostData:(PBWeiboDataConnect *)weiboDatas{
    if (weiboDatas == shoucangData) {
        hasSC = YES;
    }
    if (weiboDatas == zanData) {
        hasZan = YES;
    }
    if (sendmanager==weiboDatas) {
        [indicator stopAnimating];
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[inputtype isEqualToString:@"question"]?@"提问信息已提交":@"评论信息已提交" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
    }
    [self.tableView reloadData];
}
//点击赞
-(void)zanDidPush:(UIButton*)sender{
    sender.enabled = NO;
    NSArray* arr1 = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",[PBUserModel getCompanyno]],[self.dataDic objectForKey:@"no"],@"2", @"1",nil];
    NSArray* arr2 = [NSArray arrayWithObjects:@"userno",@"no", @"type",@"flag",nil];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjects:arr1 forKeys:arr2];
    [zanData submitDataFromUrl:RECORDURL postValuesAndKeys:dic];
}
//点击抢购
-(void)buyProduct{
    
    PBAssureCompanyInfo* company = [[PBAssureCompanyInfo alloc]initWithStyle:UITableViewStyleGrouped];
    [company navigatorRightButtonType:WANCHEN];
    company.mode = @"add";
    company.type = 6;
    company.title = @"企业基本信息";
    company.userinfos = self.dataDic;
    company.popController = self;
    [self backButton:company];
    PBNavigationController* nav = [[PBNavigationController alloc]initWithRootViewController:company];
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"topnavigation.png"] forBarMetrics:UIBarMetricsDefault];
    [nav.navigationBar setBarStyle:UIBarStyleBlack];
    [self.rootController presentModalViewController:nav animated:YES];
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
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
