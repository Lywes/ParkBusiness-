//
//  PBFinancialCaseDetailController.m
//  ParkBusiness
//
//  Created by QDS on 13-5-27.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBFinancialCaseDetailController.h"
#import "CustomImageView.h"
#import "PBQuestionListController.h"
#import "PBFinancInstitutDetailController.h"
#import "PBTextViewController.h"
#import "PBAssureCompanyInfo.h"
#import "PBFinancialProductAndServeDetailController.h"
#define CASEURLSTRING [NSString stringWithFormat:@"%@admin/index/searchbankfinancingcase", HOST]
@interface PBFinancialCaseDetailController ()

@end

@implementation PBFinancialCaseDetailController
@synthesize dataDictionary, detailTableView;
@synthesize caseno;
@synthesize flag;
@synthesize shoucang;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(7, 7, 25, 30);
        [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(popPreView) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = item;
        [item release];
    }
    return self;
}

- (void) popPreView
{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"_title_alxxxx", nil);
    indicator = [[PBActivityIndicatorView alloc]initWithFrame:self.navigationController.view.frame];
    [self.view addSubview:indicator];
//    UIButton *questionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    questionBtn.frame = isPad()?CGRectMake(6, 6, 42, 30):CGRectMake(6, 6, 33, 26);
//    [questionBtn setBackgroundImage:[UIImage imageNamed:@"product_qa.png"] forState:UIControlStateNormal];
//    [questionBtn addTarget:self action:@selector(question) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *questionBtnItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"nav_btn_tw", nil) style:UIBarButtonItemStylePlain target:self action:@selector(question)];
    self.navigationItem.rightBarButtonItem = questionBtnItem;
    [questionBtnItem release];
    // Do any additional setup after loading the view from its nib.
    NSArray *section1 = [[NSArray alloc] initWithObjects:@"name&&photo", nil];
    NSArray *section2 = [[NSArray alloc] initWithObjects:NSLocalizedString(@"_tb_gsgk", nil), nil];
    NSArray *section3 = [[NSArray alloc] initWithObjects:@"signature", nil];
    sectionAndRowDataArray = [[NSMutableArray arrayWithObjects:section1, section2, section3, nil] retain];
    if ([[dataDictionary objectForKey:@"productno"] intValue]>0) {
        NSArray *section4 = [[NSArray alloc] initWithObjects:NSLocalizedString(@"_tb_jrcplj", nil), nil];
        [sectionAndRowDataArray addObject:section4];
    }
    if (caseno) {
        [indicator startAnimating];
        PBWeiboDataConnect* connect = [[PBWeiboDataConnect alloc]init];
        connect.delegate = self;
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:caseno,@"no", nil];
        [connect getXMLDataFromUrl:CASEURLSTRING postValuesAndKeys:dic];
    }
    [section1 release];
    [section2 release];
    [section3 release];
    inputToolbar = [[UIInputToolbar alloc] initWithFrame:CGRectMake(0, isPad()?1024:(isPhone5()?568:480), isPad()?768:320, 40)];
    inputToolbar.delegate = self;
    inputToolbar.textView.placeholder = @"请输入提问";
    [self.navigationController.view addSubview:inputToolbar];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTap:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
}
-(void)viewDidUnload{
    [super viewDidUnload];
    [self setDataDictionary:nil];
    [self setDetailTableView:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [inputToolbar removeObserverFromController:self];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [inputToolbar addObserverFromController:self];
}
-(void)viewTap:(UITapGestureRecognizer*)tap{
    [inputToolbar keyboardWillHide];
}

-(void)sucessParseXMLData:(PBWeiboDataConnect *)weiboDatas{
    [indicator stopAnimating];
    dataDictionary = [weiboDatas.parseData objectAtIndex:0];
    [self.detailTableView reloadData];
}

//提问，提问上传的参数是type,questionno,userno和question。。在这里提问获取的questionno是什么
- (void) question
{
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) destructiveButtonTitle:nil otherButtonTitles:@"我要提问",@"提问列表", nil];
    [sheet showInView:self.navigationController.view];
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [inputToolbar.textView becomeFirstResponder];
            break;
        case 1:{
            PBQuestionListController *controller = [[PBQuestionListController alloc] init];
            controller.titleString = @"提问列表";
            controller.typeString = @"3";
            controller.qaNoString = [dataDictionary objectForKey:@"no"];
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        }
            break;
        default:
            break;
    }
}
-(void)inputButtonPressed:(NSString *)inputText
{
    [indicator startAnimating];
    sendmanager = [[PBWeiboDataConnect alloc] init];
    sendmanager.delegate= self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"3", @"type", [NSString stringWithFormat:@"%d", [PBUserModel getUserId]], @"userno", [dataDictionary objectForKey:@"no"], @"questionno",inputText, @"question", nil];
    [sendmanager submitDataFromUrl:QUESTIONINFO postValuesAndKeys:dic];
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
//自定义textView显示高度
-(CGFloat) heightForTextView:(NSString*)contentStr
{
    CGSize size = [contentStr sizeWithFont:[self getTextFont] constrainedToSize:CGSizeMake(isPad() ? 480 : 210, 1000) lineBreakMode:UILineBreakModeWordWrap];
    return MAX(42.0, size.height);
}

- (UIFont *) getTextFont
{
    return [UIFont systemFontOfSize:isPad() ? PadContentFontSize : ContentFontSize];
}

#pragma mark
#pragma mark UITableViewDataSourceMethod
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return sectionAndRowDataArray.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[sectionAndRowDataArray objectAtIndex:section] count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.section) {
            
        case 0:
        {
            NSString *URLString = [NSString stringWithFormat:@"%@%@", HOST, [dataDictionary objectForKey:@"imagepath"]];
            
            CustomImageView *bossPhotoImageView = [[CustomImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
            [bossPhotoImageView.imageView loadImage: URLString];
            [cell.contentView addSubview:bossPhotoImageView];
            [bossPhotoImageView release];
            
            CGFloat originX2 = isPad() ? 90 : 70;
            UIImageView *imageaView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"projectname.png"]];
            imageaView1.frame = CGRectMake(originX2, 8, 21, 21);
            [cell.contentView addSubview:imageaView1];
            [imageaView1 release];
            
            UIImageView *imageaView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trade.png"]];
            imageaView2.frame = CGRectMake(originX2, 42, 21, 21);
            [cell.contentView addSubview:imageaView2];
            [imageaView2 release];
            
            CGFloat originX3 = isPad() ? 120 : 100;
            CGFloat labelWidth = isPad() ? 500 : 130;
            UILabel *bossNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX3, isPad()?2:-2   , labelWidth,isPad() ?30: 40)];
            bossNameLabel.numberOfLines = 0;
            bossNameLabel.text = [dataDictionary objectForKey:@"name"];
            bossNameLabel.backgroundColor = [UIColor clearColor];
            bossNameLabel.font = [self getTextFont];
            [cell.contentView addSubview:bossNameLabel];
            [bossNameLabel release];
            
            UILabel *bossIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX3, 35, labelWidth, 35)];
            bossIDLabel.text = [dataDictionary objectForKey:@"financename"];
            bossIDLabel.numberOfLines = 0;
            bossIDLabel.backgroundColor = [UIColor clearColor];
            bossIDLabel.font = [self getTextFont];
            [cell.contentView addSubview:bossIDLabel];
            [bossIDLabel release];
            //添加2个button，一个收藏，一个查看
            CGFloat buttonOriginX1 = isPad() ? 570 : 240;
            CGFloat buttonOriginY = isPad() ? 40 : 40;
            if (!self.shoucang) {
                UIButton *scButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [scButton addTarget:self action:@selector(collectProject:) forControlEvents:UIControlEventTouchUpInside];
                scButton.tag = 88;
                if ([flag isEqualToString:@"1"]){
                    [scButton setTitle:@"已收藏" forState:UIControlStateNormal];
                    scButton.enabled = NO;
                }else{
                    [scButton setTitle:NSLocalizedString(@"nav_btn_sc", nil) forState:UIControlStateNormal];
                }
                scButton.titleLabel.font = [self getTextFont];
                scButton.titleLabel.textColor = [UIColor blackColor];
                scButton.frame = CGRectMake(buttonOriginX1, buttonOriginY-(isPad()?35:33), isPad() ? 65 : 50, 25);
                [scButton setBackgroundImage:[UIImage imageNamed:@"custom_button.png"] forState:UIControlStateNormal];
                [cell.contentView addSubview:scButton];
            }
            UIButton *applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [applyButton addTarget:self action:@selector(showFinanceInfo:) forControlEvents:UIControlEventTouchUpInside];
                [applyButton setTitle:NSLocalizedString(@"_btn_chakan", nil) forState:UIControlStateNormal];
                applyButton.titleLabel.font = [self getTextFont];
                applyButton.titleLabel.textColor = [UIColor blackColor];
                applyButton.frame = CGRectMake(buttonOriginX1, buttonOriginY, isPad() ? 65 : 50, 25);
            [applyButton setBackgroundImage:[UIImage imageNamed:@"custom_button.png"] forState:UIControlStateNormal];
                [cell.contentView addSubview:applyButton];
            break;
        }
                  
        case 1:
        {
            
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"companysituation.png"]];
            imageView.frame = CGRectMake(isPad() ? 20 : 10, 8, 28, 28);
            [cell.contentView addSubview:imageView];
            [imageView release];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(isPad() ? 80 : 40, 12, 200, 21)];
            label.text = [[sectionAndRowDataArray objectAtIndex:1] objectAtIndex:indexPath.row];
            label.font = [self getTextFont];
            label.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label];
            [label release];
            //当公司信息不为空时，公司概况链接才有用，否则显示为灰色

            if ([(NSString *)[dataDictionary objectForKey:@"companyinfo"] length]> 0) {
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
            } else {
                UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
                [imageView setImage:[[UIImage imageNamed:@"fillcell.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
                cell.backgroundView = imageView;
                [imageView release];
            }
                
            break;
        }
            
        case 2:
        {
            CGFloat textWidth = isPad() ? 679 : 300;
            NSString *str = [dataDictionary  objectForKey:@"casedetail"];
            UITextView *signatureTextView = [[UITextView alloc] initWithFrame:CGRectMake(isPad() ? 8 : 4, 12, textWidth, [self heightForTextView:str])];
            signatureTextView.text = str;
            signatureTextView.font = [self getTextFont];
            signatureTextView.editable = NO;
            signatureTextView.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:signatureTextView];
            [signatureTextView release];
            break;
        }
        case 3:{
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"financproduct.png"]];
            imageView.frame = CGRectMake(isPad() ? 20 : 10, 8, 28, 28);
            [cell.contentView addSubview:imageView];
            [imageView release];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(isPad() ? 80 : 40, 12, 200, 21)];
            label.text = [[sectionAndRowDataArray objectAtIndex:3] objectAtIndex:indexPath.row];
            label.font = [self getTextFont];
            label.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:label];
            [label release];
        }
        default:
            break;
    }
    
    return cell;
}
//收藏
- (void)collectProject:(UIButton*)sender
{
    shoucangbtn = sender;
    shoucangbtn.enabled = NO;
    [indicator startAnimating];
    PBWeiboDataConnect  *collectData= [[PBWeiboDataConnect alloc] init];
    collectData.delegate = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[dataDictionary objectForKey:@"no"], @"projectno", [NSString stringWithFormat:@"%d", [PBUserModel getUserId]], @"personno", @"10",@"type",nil];
    [collectData submitDataFromUrl:FAVOURITES postValuesAndKeys:dic];
}
-(void)sucessSendPostData:(PBWeiboDataConnect *)weiboDatas{
    [indicator stopAnimating];
    if (sendmanager==weiboDatas) {
        [indicator stopAnimating];
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"提问信息已提交" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCaseData" object:nil];
        [shoucangbtn setTitle:@"已收藏" forState:UIControlStateNormal];
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已成功收藏" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}
//查看金融机构信息
-(void)showFinanceInfo:(id)sender{
    PBFinancInstitutDetailController *controller = [[PBFinancInstitutDetailController alloc] init];
    controller.financeno = [dataDictionary objectForKey:@"financeno"];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[dataDictionary objectForKey:@"financename"],@"name", nil];
    controller.dataDictionary = dic;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}
#pragma mark
#pragma mark UITableViewDelegateMethod
- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return (section == 2) ? NSLocalizedString(@"_tb_alxx", nil) : nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 44.0f;
    switch (indexPath.section) {
        case 0:
        {
            height = 80.0f;
            break;
        }
        case 2:
        {
            NSString *str = [dataDictionary  objectForKey:@"casedetail"];
            height = [self heightForTextView:str] + 23;
            break;
        }
        default:
            break;
    }
    return height;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //当公司信息不为空时，公司概况链接才有用，否则显示为灰色
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        //公司概况链接
        if ([[dataDictionary objectForKey:@"companyno"] intValue] > 0) {
            PBAssureCompanyInfo* company = [[PBAssureCompanyInfo alloc]initWithStyle:UITableViewStyleGrouped];
            company.ProjectStyle = ELSEPROJECTINFO;
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[dataDictionary objectForKey:@"companyno"],@"no", nil];
            company.datadic = dic;
            company.title = NSLocalizedString(@"_tb_gsgk", nil);
            company.type = 1;
            [self.navigationController pushViewController:company animated:YES];
            [company release];
            [dic release];
        }else if ([[dataDictionary objectForKey:@"companyinfo"] length] > 0) {
            PBTextViewController *text = [[PBTextViewController alloc]init];
            text.title = NSLocalizedString(@"_tb_gsgk", nil);
            text.textview.editable = NO;
            text.textview.text = [dataDictionary objectForKey:@"companyinfo"];
            [self.navigationController pushViewController:text animated:YES];
        }
    }
    if (indexPath.section==3) {
        PBFinancialProductAndServeDetailController* detail = [[PBFinancialProductAndServeDetailController alloc]init];
        detail.no = [dataDictionary objectForKey:@"productno"];
        [self.navigationController pushViewController:detail animated:YES];
        [detail release];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [dataDictionary release];
    [detailTableView release];
    [super dealloc];
}

@end
