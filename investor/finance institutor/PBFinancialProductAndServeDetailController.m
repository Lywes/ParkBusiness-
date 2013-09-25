//
//  PBFinancialProductAndServeDetailController.m
//  ParkBusiness
//
//  Created by QDS on 13-5-24.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define CANPINFUWUXIANGXI_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/searchfinancingservice",HOST]]
#define ADDSCORE_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/addproductappraise",HOST]]
#import "PBFinancialProductAndServeDetailController.h"
#import "CustomImageView.h"
#import "PBQuestionListController.h"
#import "PBAllReviewController.h"
#import "PBRemarkListController.h"
#import "PBAddFinanceAssure.h"
#import "PBAssureCompanyInfo.h"
#import "PBuserinfo.h"
#import "PBAddInsureInfo.h"
#import "PBFinancInstitutDetailController.h"
#import "PBFinancialCaseController.h"
#import "PBAddLicaiInfo.h"
@interface PBFinancialProductAndServeDetailController ()
-(void)dataOnSever;
@end

@implementation PBFinancialProductAndServeDetailController
@synthesize dataDictionary;
@synthesize detailTableView;
@synthesize rootController;
@synthesize no;
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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%@",self.dataDictionary);
    [inputToolbar addObserverFromController:self];
    //传过来的no不是空值
    if (self.no) {
        [self dataOnSever];
        [self.no UTF8String];
    }
    
}
#pragma mark - 检索产品的详细信息
-(void)dataOnSever
{
    [indicator startAnimating];
    PBdataClass *dataclass = [[PBdataClass alloc]init];
    dataclass.delegate = self;
    [dataclass dataResponse:CANPINFUWUXIANGXI_URL postDic:[NSDictionary dictionaryWithObjectsAndKeys:self.no,@"no", nil] searchOrSave:YES];
}
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{
    if (datas.count >0) {
        self.dataDictionary = [datas objectAtIndex:0];
        [self.detailTableView reloadData];
    }
     [indicator stopAnimating];
}
- (void) popPreView
{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //评论
//    UIButton *remarkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    remarkBtn.frame = isPad()?CGRectMake(6, 6, 42, 30):CGRectMake(6, 6, 33, 26);
//    [remarkBtn setBackgroundImage:[UIImage imageNamed:@"custom_button.png"] forState:UIControlStateNormal];
//    [remarkBtn setTitle:NSLocalizedString(@"nav_btn_pl", nil) forState:UIControlStateNormal];
//    [remarkBtn addTarget:self action:@selector(remark) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *remarkBtnItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"nav_btn_pl", nil) style:UIBarButtonItemStylePlain target:self action:@selector(remark)];
    
//    UIButton *questionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    questionBtn.frame = isPad()?CGRectMake(6, 6, 42, 30):CGRectMake(6, 6, 33, 26);
//    [questionBtn setBackgroundImage:[UIImage imageNamed:@"custom_button.png"] forState:UIControlStateNormal];
//    [questionBtn setTitle:NSLocalizedString(@"nav_btn_tw", nil) forState:UIControlStateNormal];
//    [questionBtn addTarget:self action:@selector(question) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *questionBtnItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"nav_btn_tw", nil) style:UIBarButtonItemStylePlain target:self action:@selector(question)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:remarkBtnItem, questionBtnItem, nil];
    [remarkBtnItem release];
    [questionBtnItem release];
    
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"_title_cpfwxxxx", nil);
    
    NSArray *section1 = [[NSArray alloc] initWithObjects:@"name&&photo", nil];
    NSArray *section2 = [[NSArray alloc] initWithObjects:@"introduce", nil];
    NSArray *section3 = [[NSArray alloc] initWithObjects:@"description", nil];
    NSArray *section4 = [[NSArray alloc] initWithObjects:@"telphone", nil];
    sectionAndRowDataArray = [[NSArray arrayWithObjects:section1, section2, section3, section4,NSLocalizedString(@"_tb_jrallj", nil),nil] retain];
    [section1 release];
    [section2 release];
    [section3 release];
    [section4 release];
    inputToolbar = [[UIInputToolbar alloc] initWithFrame:CGRectMake(0, isPad()?1024:(isPhone5()?568:480), isPad()?768:320, 40)];
    inputToolbar.delegate = self;
    [self.navigationController.view addSubview:inputToolbar];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewTap:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertWillShow:) name:@"showalert" object:nil];
    
    
    indicator = [[PBActivityIndicatorView alloc]initWithFrame:isPad()?CGRectMake(0, 0, 768, 1024 - KNavigationBarHeight):(isPhone5()?CGRectMake(0, 0, 320, 568- KNavigationBarHeight):CGRectMake(0, 0, 320, 480- KNavigationBarHeight))];
    [self.view addSubview:indicator];
}
-(void)alertWillShow:(NSNotification*)notification{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已成功申请！请前往我的中心查看该申请。" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
    [alert show];
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
-(void)viewTap:(UITapGestureRecognizer*)tap{
    [inputToolbar keyboardWillHide];
}
//评论
- (void) remark
{
    inputtype = @"remark";
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) destructiveButtonTitle:nil otherButtonTitles:@"我要评论",@"评论列表", nil];
    sheet.tag = 2;
    [sheet showInView:self.navigationController.view];
    [sheet release];
}


#pragma mark - 提问，提问上传的参数是type,questionno,userid和question。。在这里提问获取的questionno是什么
- (void) question
{
    inputtype = @"question";
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) destructiveButtonTitle:nil otherButtonTitles:@"我要提问",@"提问列表", nil];
    sheet.tag = 1;
    [sheet showInView:self.navigationController.view];
    [sheet release];
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag==1) {
        switch (buttonIndex) {
            case 0:
                inputToolbar.textView.placeholder = @"请输入提问";
                [inputToolbar.textView becomeFirstResponder];
                break;
            case 1:{
                PBQuestionListController *contrllor = [[PBQuestionListController alloc] init];
                contrllor.titleString = @"提问列表";
                contrllor.typeString = @"2";
                contrllor.qaNoString = [dataDictionary objectForKey:@"no"];
                [self.navigationController pushViewController:contrllor animated:YES];
                [contrllor release];
            }
                break;
            default:
                break;
        }
    }else if(actionSheet.tag == 2){
        switch (buttonIndex) {
            case 0:
                inputToolbar.textView.placeholder = @"请输入评论";
                [inputToolbar.textView becomeFirstResponder];
                break;
            case 1:{
                PBRemarkListController *controller = [[PBRemarkListController alloc] init];
                //需要传递一些参数过去
                NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:dataDictionary];
                [dic setObject:@"3" forKey:@"remarktype"];
                controller.infoDic = dic;
                [self.navigationController pushViewController: controller animated:YES];
                [controller release];

            }
                break;
            default:
                break;
        }
    }else{
        if (buttonIndex==0) {
            NSString* num = [NSString stringWithFormat:@"tel://%@",[actionSheet buttonTitleAtIndex:buttonIndex]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]];
        }
    }
}
-(void)inputButtonPressed:(NSString *)inputText
{
    [indicator startAnimating];
    sendmanager = [[PBWeiboDataConnect alloc] init];
    sendmanager.delegate= self;
    if ([inputtype isEqualToString:@"question"]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"2", @"type", USERNO, @"userno", [dataDictionary objectForKey:@"no"], @"questionno",inputText, @"question", nil];
        [sendmanager submitDataFromUrl:QUESTIONINFO postValuesAndKeys:dic];
    }else{
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"3", @"type",USERNO, @"userno", [self.dataDictionary objectForKey:@"no"], @"commentno", inputText, @"content", nil];
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
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"APPLYJOININ" object:self];
    }
}
#pragma mark - 申请
- (void) applySeverceOrProduct
{
    if ([PBUserModel getPasswordAndKind].kind == 0) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您必须成为融商正式会员后才能使用此功能！" delegate:self cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) otherButtonTitles:@"申请正式加盟", nil];
        [alert show];
        [alert release];
        return;
    }
    int type = [[dataDictionary objectForKey:@"type"] intValue];
    int productno = [[dataDictionary objectForKey:@"no"] intValue];
    PBuserinfo* userinfo  = [[PBuserinfo alloc]initWithStyle:UITableViewStyleGrouped];
    switch (type) {
        case 1:
            [userinfo navigatorRightButtonType:BIANJI];
            userinfo.mode = @"add";
            userinfo.title = @"新项目";
            userinfo.productno = productno;
            userinfo.type = type;
            [self pushNextViewController:userinfo];
            break;
        case 2:
            [userinfo navigatorRightButtonType:NEXT];
            userinfo.mode = @"add";
            userinfo.type = type;
            userinfo.productno = productno;
            userinfo.title = @"银行贷款申请";
            [self pushNextViewController:userinfo];
            break;
        case 3:{
            PBAssureCompanyInfo* company = [[PBAssureCompanyInfo alloc]initWithStyle:UITableViewStyleGrouped];
            [company navigatorRightButtonType:NEXT];
            company.mode = @"add";
            company.type = type;
            company.productno = productno;
            company.title = @"企业基本信息";
            [self pushNextViewController:company];
        }
            break;
        case 4:{
            PBAddFinanceAssure* assure = [[PBAddFinanceAssure alloc]initWithStyle:UITableViewStyleGrouped];
            [assure navigatorRightButtonType:NEXT];
            assure.mode = @"add";
            assure.type = type;
            assure.productno = productno;
            assure.title = @"金融担保申请";
            [self pushNextViewController:assure];
        }
            break;
        case 5:{
            PBAssureCompanyInfo* company = [[PBAssureCompanyInfo alloc]initWithStyle:UITableViewStyleGrouped];
            [company navigatorRightButtonType:NEXT];
            company.mode = @"add";
            company.type = type;
            company.productno = productno;
            company.title = @"企业基本信息";
            [self pushNextViewController:company];
        }
            break;
        case 6:{
            PBAddInsureInfo* insure = [[PBAddInsureInfo alloc]initWithStyle:UITableViewStyleGrouped];
            [insure navigatorRightButtonType:WANCHEN];
            insure.mode = @"add";
            insure.type = type;
            insure.title = @"保险单信息";
            insure.datadic = dataDictionary;
            [self pushNextViewController:insure];
        }
            break;
        case 7:{
            PBAddLicaiInfo* insure = [[PBAddLicaiInfo alloc]initWithStyle:UITableViewStyleGrouped];
            [insure navigatorRightButtonType:WANCHEN];
            insure.mode = @"add";
            insure.type = type;
            insure.title = @"理财信息";
            insure.datadic = dataDictionary;
            [self pushNextViewController:insure];
        }
            break;
        default:
            break;
    }
    [userinfo release];
}

-(void)pushNextViewController:(UIViewController*)controller{
    PBNavigationController* nav = [[PBNavigationController alloc]initWithRootViewController:controller];
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"topnavigation.png"] forBarMetrics:UIBarMetricsDefault];
    [nav.navigationBar setBarStyle:UIBarStyleBlack];
    [self presentModalViewController:nav animated:YES];
}
//自定义textView显示高度
-(CGFloat) heightForTextView:(NSString*)contentStr
{
    CGSize size = [contentStr sizeWithFont:[self getTextFont] constrainedToSize:CGSizeMake(isPad() ? 679 : 300, 1000) lineBreakMode:UILineBreakModeWordWrap];
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
    if (section==4) {
        int casecount = [[dataDictionary objectForKey:@"casecount"] intValue];
        return casecount>0?1:0;
    }
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
            CustomImageView *bossPhotoImageView = [[CustomImageView alloc] initWithFrame:isPad()?CGRectMake(8,8,75,75):CGRectMake(3,12,56,56)];
            [bossPhotoImageView.imageView loadImage: URLString];
            [cell.contentView addSubview:bossPhotoImageView];
            [bossPhotoImageView release];
            
            CGFloat originX2 = isPad() ? 110 : 70;
            UIImageView *imageaView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"projectname.png"]];
            imageaView1.frame = CGRectMake(originX2, 0, isPad() ?25:21, isPad() ?25:21);
            [cell.contentView addSubview:imageaView1];
            [imageaView1 release];
            
            UIImageView *imageaView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trade.png"]];
            imageaView2.frame = CGRectMake(originX2, isPad() ?43:39, isPad() ?25:21, isPad() ?25:21);
            [cell.contentView addSubview:imageaView2];
            [imageaView2 release];
            //产品评价
            UIImageView *scoreImage = [[UIImageView alloc] initWithFrame:CGRectMake(originX2,isPad() ?26: 23, isPad() ?90:75, isPad() ?18:15)];
            [scoreImage setStarImageWithScore:[[dataDictionary objectForKey:@"score"] floatValue] isImage:YES];
            [cell.contentView addSubview:scoreImage];
            [scoreImage release];
            
            UIImageView *imageaView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"financinginstitution.png"]];
            imageaView3.frame = CGRectMake(originX2, 72, isPad() ?25:21, isPad() ?25:21);
            [cell.contentView addSubview:imageaView3];
            [imageaView3 release];
            
            CGFloat originX3 = isPad() ? 150 : 100;
            CGFloat labelWidth = isPad() ? 250 : 120;
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX3, isPad() ? 5:0, labelWidth, 21)];
            nameLabel.text = [dataDictionary objectForKey:@"name"];
            nameLabel.backgroundColor = [UIColor clearColor];
            nameLabel.font = [self getTextFont];
            [cell.contentView addSubview:nameLabel];
            [nameLabel release];
            
            UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX3, isPad() ? 46:40, labelWidth, 21)];
            typeLabel.text = [dataDictionary objectForKey:@"typename"];
            typeLabel.backgroundColor = [UIColor clearColor];
            typeLabel.font = [self getTextFont];
            [cell.contentView addSubview:typeLabel];
            [typeLabel release];
            
            UILabel *organNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX3, isPad() ? 68:65, labelWidth, 35)];
            organNameLabel.text = [dataDictionary objectForKey:@"financename"];
            organNameLabel.backgroundColor = [UIColor clearColor];
            organNameLabel.font = [self getTextFont];
            organNameLabel.numberOfLines = 0;
            [cell.contentView addSubview:organNameLabel];
            [organNameLabel release];
            
            //添加2个button，一个加为好友，一个发送私信
            CGFloat buttonOriginX1 = isPad() ? 570 : 240;
            CGFloat buttonOriginY = isPad() ? 40 : 40;
            if (!self.no) {
                UIButton *scButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [scButton setBackgroundImage:[UIImage imageNamed:@"custom_button.png"] forState:UIControlStateNormal];
                [scButton addTarget:self action:@selector(collectProject:) forControlEvents:UIControlEventTouchUpInside];
                scButton.tag = 88;
                if ([[dataDictionary objectForKey:@"flag"] isEqualToString:@"1"]){
                    [scButton setTitle:@"已收藏" forState:UIControlStateNormal];
                    scButton.enabled = NO;
                }else{
                    [scButton setTitle:NSLocalizedString(@"nav_btn_sc", nil) forState:UIControlStateNormal];
                }
                scButton.titleLabel.font = [self getTextFont];
                scButton.titleLabel.textColor = [UIColor blackColor];
                scButton.frame = CGRectMake(buttonOriginX1, buttonOriginY-(isPad()?35:30), isPad() ? 70 : 50, isPad() ? 30 : 25);
                [cell.contentView addSubview:scButton];
            }
            if ([PBUserModel getPasswordAndKind].kind !=3||[[dataDictionary objectForKey:@"type"] intValue]==7) {
                UIButton *applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [applyButton setBackgroundImage:[UIImage imageNamed:@"custom_button.png"] forState:UIControlStateNormal];
                [applyButton addTarget:self action:@selector(applySeverceOrProduct) forControlEvents:UIControlEventTouchUpInside];
                [applyButton setTitle:@"申请" forState:UIControlStateNormal];
                applyButton.titleLabel.font = [self getTextFont];
                applyButton.titleLabel.textColor = [UIColor blackColor];
                applyButton.frame = CGRectMake(buttonOriginX1, buttonOriginY, isPad() ? 70 : 50, isPad() ? 30 : 25);
                [cell.contentView addSubview:applyButton];
            }
            UIButton *showButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [showButton setBackgroundImage:[UIImage imageNamed:@"custom_button.png"] forState:UIControlStateNormal];
            [showButton addTarget:self action:@selector(showFinanceInfo:) forControlEvents:UIControlEventTouchUpInside];
            [showButton setTitle:NSLocalizedString(@"_btn_chakan", nil) forState:UIControlStateNormal];
            showButton.titleLabel.font = [self getTextFont];
            showButton.titleLabel.textColor = [UIColor blackColor];
            showButton.frame = CGRectMake(buttonOriginX1, buttonOriginY+(isPad()?35:30), isPad() ? 70 : 50, isPad() ? 30 : 25);
            [cell.contentView addSubview:showButton];
            break;
        }
            
        case 1:
        {
            CGFloat textWidth = isPad() ? 679 : 300;
            NSString *str = [dataDictionary  objectForKey:@"introduce"];
            UITextView *introduceTextView = [[UITextView alloc] initWithFrame:CGRectMake(isPad() ? 8 : 4, 12, textWidth, [self heightForTextView:str])];
            introduceTextView.text = str;
            introduceTextView.font = [self getTextFont];
            introduceTextView.editable = NO;
            introduceTextView.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:introduceTextView];
            [introduceTextView release];
            break;
        }
            
        case 2:
        {
            CGFloat textWidth = isPad() ? 679 : 300;
            NSString *str = [dataDictionary  objectForKey:@"description"];
            UITextView *descriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(isPad() ? 8 : 4, 12, textWidth, [self heightForTextView:str])];
            descriptionTextView.text = str;
            descriptionTextView.font = [self getTextFont];
            descriptionTextView.editable = NO;
            descriptionTextView.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:descriptionTextView];
            [descriptionTextView release];
            break;
        }
        case 3:
        {
            cell.textLabel.text = NSLocalizedString(@"_tb_zxdh", nil);
            NSString *str = [dataDictionary  objectForKey:@"tel"];
            UILabel *tel = [[UILabel alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width/2,5, cell.contentView.frame.size.width/2,30 )];
            tel.text = str;
            tel.font = [self getTextFont];
            tel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:tel];
            [tel release];
            break;
        }
        case 4:
        {
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            NSArray *imageNameArray = [[NSArray alloc] initWithObjects:@"financingcase.png", nil];
            CGFloat originX = isPad() ? 20 : 10;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, 12, 21, 21)];
            imageView.image = [UIImage imageNamed:[imageNameArray objectAtIndex:indexPath.row]];
            [cell.contentView addSubview:imageView];
            [imageView release];
            [imageNameArray release];
            
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(isPad() ? 80 : 40, 12, 240, 21)];
            label.backgroundColor = [UIColor clearColor];
            label.text = [sectionAndRowDataArray objectAtIndex:indexPath.section];
            [cell.contentView addSubview:label];
            [label release];
            break;
        }
        default:
            break;
    }
    
    return cell;
}

#pragma mark - 收藏
- (void)collectProject:(UIButton*)sender
{
    [indicator startAnimating];
    shoucangbtn = sender;
    shoucangbtn.enabled = NO;
    PBWeiboDataConnect  *collectData= [[PBWeiboDataConnect alloc] init];
    collectData.delegate = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[dataDictionary objectForKey:@"no"], @"projectno", USERNO, @"personno", @"9",@"type",nil];
    [collectData submitDataFromUrl:FAVOURITES postValuesAndKeys:dic];
}
-(void)sucessSendPostData:(PBWeiboDataConnect *)weiboDatas{
    [indicator stopAnimating];
    if (sendmanager==weiboDatas) {
        [indicator stopAnimating];
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[inputtype isEqualToString:@"question"]?@"提问信息已提交":@"评论信息已提交" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshProductData" object:nil];
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
    //titleForHeaderStr必须赋初始值，不然return时会报错。
    NSString *titleForHeaderStr = nil;
    switch (section) {
        case 1:
        {
            titleForHeaderStr = NSLocalizedString(@"_tb_xxjs", nil);
            break;
        }
        case 2:
        {
            titleForHeaderStr = NSLocalizedString(@"_tb_gmsm", nil);
            break;
        }
        default:
            break;
    }
    return titleForHeaderStr;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==0) {
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
        label.center = view.center;
        CGRect frame = label.frame;
        frame.origin.x = isPad()?55:10;
        label.frame = frame;
        label.text = NSLocalizedString(@"_tb_wdpf", nil);
        label.backgroundColor = [UIColor clearColor];
        starImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 125, 25)];
        starImage.center = view.center;
        starImage.userInteractionEnabled  =YES;
        [self setButtonWithLevel:[starImage getLevelWithScore:[[dataDictionary objectForKey:@"myscore"] floatValue]]];
        [view addSubview:label];
        [view addSubview:starImage];
        return view;
    }
    return nil;
}
-(void)setButtonWithLevel:(int)level{
    CGFloat height = starImage.frame.size.height;
    for (int i = 0; i<level; i++) {
        UIButton* starBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [starBtn setBackgroundImage:[UIImage imageNamed:@"levelstar_highlight"] forState:UIControlStateNormal];
        starBtn.tag = i;
        [starBtn addTarget:self action:@selector(starDidPush:) forControlEvents:UIControlEventTouchUpInside];
        starBtn.frame = CGRectMake(i*height, 0, height, height);
        [starImage addSubview:starBtn];
    }
    for (int i = 0; i<5-level; i++) {
        UIButton* starBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [starBtn setBackgroundImage:[UIImage imageNamed:@"levelstar_normal"] forState:UIControlStateNormal];
        starBtn.tag = i+level;
        [starBtn addTarget:self action:@selector(starDidPush:) forControlEvents:UIControlEventTouchUpInside];
        starBtn.frame = CGRectMake((level+i)*height, 0, height, height);
        [starImage addSubview:starBtn];
    }
    
}
#pragma mark - 评分
-(void)starDidPush:(UIButton*)sender{
    int level = sender.tag+1;
    for (UIButton* btn in [starImage subviews]) {
        [btn removeFromSuperview];
    }
    [self setButtonWithLevel:level];
    [indicator startAnimating];
    PBdataClass *dataclass = [[PBdataClass alloc]init];
    dataclass.delegate = self;
    NSArray* arr1 = [NSArray arrayWithObjects:USERNO,[dataDictionary objectForKey:@"no"],[NSString stringWithFormat:@"%d",level], nil];
    NSArray* arr2 = [NSArray arrayWithObjects:@"userno",@"productno",@"score", nil];
    NSDictionary* dic = [NSDictionary dictionaryWithObjects:arr1 forKeys:arr2];
    [dataclass dataResponse:ADDSCORE_URL postDic:dic searchOrSave:NO];
}
-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue{
    [indicator stopAnimating];
    PBAlertView* alert = [[PBAlertView alloc]initWithMessage:@"感谢您的评分!"];
    [alert show];
    [alert release];
}
#pragma mark - tableviewdelegate
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 50;
    }
    return 0;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.0f;
    switch (indexPath.section) {
        case 0:
        {
            height = isPad()?120.0f:100.0f;
            break;
        }
        case 1:
        {
            NSString *str = [dataDictionary  objectForKey:@"introduce"];
            height = [self heightForTextView:str] + 23;
            break;
        }
        case 2:
        {
            NSString *str = [dataDictionary  objectForKey:@"description"];
            height = [self heightForTextView:str] + 23;
            break;
        }
        case 3:
        {
            height = 44.0f;
            break;
        }
        case 4:
            height = 44.0f;
            break;
        default:
            break;
    }
    return height;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==3) {
        UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:@"点击拨打电话" delegate:self cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) destructiveButtonTitle:[dataDictionary  objectForKey:@"tel"] otherButtonTitles: nil];
        [sheet showInView:self.view];
        [sheet release];
    }
    if (indexPath.section==4) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        PBFinancialCaseController *controller = [[PBFinancialCaseController alloc] init];
        controller.pnoString = [dataDictionary  objectForKey:@"no"];
        PBNavigationController* navi = [[PBNavigationController alloc]initWithRootViewController:controller];
        [navi.navigationBar setBackgroundImage:[UIImage imageNamed:@"topnavigation.png"] forBarMetrics:UIBarMetricsDefault];
        navi.navigationBar.barStyle = UIBarStyleBlack;
        [self.navigationController presentModalViewController:navi animated:YES];
        [controller release];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) dealloc {
    [sectionAndRowDataArray release];
    [dataDictionary release];
    [detailTableView release];
    [super dealloc];
}

@end
