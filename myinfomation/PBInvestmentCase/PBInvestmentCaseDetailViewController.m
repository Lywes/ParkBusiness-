//
//  PBInvestmentCaseDetailViewController.m
//  ParkBusiness
//
//  Created by  on 13-3-13.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBInvestmentCaseDetailViewController.h"
#import "PBIndustryClassificationViewController.h"
#import "PBUserModel.h"
#import "PBIndustryDB.h"
#import "PBSearchsProjectsViewController.h"
#import "PBDetailAnLiData.h"
#import "PBProjectStageViewController.h"
#import "PBKbnMasterModel.h"
#define INVESTMENT_CASE_DETAIL_URL [NSString stringWithFormat:@"%@admin/index/searchprojectbyno2",HOST]

#define INVESTMENT_CASE_CHANGE_URL [NSString stringWithFormat:@"%@admin/index/updateprojectbyno",HOST]

@implementation PBInvestmentCaseDetailViewController

@synthesize tableView1;
@synthesize parkManager;
@synthesize datepicker;
@synthesize data;
@synthesize label1;
@synthesize label2;
@synthesize label4;
@synthesize tradeDic;
@synthesize nameLabel;
@synthesize rongziLabel;
@synthesize labeljieshao;
@synthesize mutableDic;
@synthesize dateTextField;
@synthesize addAnli;
@synthesize projectLabel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        edVC = [[PBEDViewController alloc] init];
        self.mutableDic = [[NSMutableDictionary alloc]init];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(6, 6, 25, 30);
        [btn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(popBackgoView) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = backBarBtn;
        [backBarBtn release];
       
        
    }
    return self;
}

-(void)popBackgoView
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

-(void)tableViewInit
{
    
    if (isPad()) {
        tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024-KTabBarHeight-KNavigationBarHeight) style:UITableViewStyleGrouped];
    }else{
        tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, (isPhone5()?568:480)-KTabBarHeight-KNavigationBarHeight) style:UITableViewStyleGrouped];
    }
    tableView1.delegate = self;
    tableView1.dataSource = self;
    [self.view addSubview:tableView1];
}

-(void)setAnimation:(NSTimeInterval)duration view:(UIView *)changeView frame:(CGRect)frame
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    changeView.frame = frame;
    [UIView commitAnimations];
}

-(void)viewWillAppear:(BOOL)animated
{
    if (edVC.title!=NULL&&![edVC.title isEqualToString:@""]) {
        [self.mutableDic setObject:edVC.contentStr==NULL?@"":edVC.contentStr forKey:edVC.title];
    }
    
    if (psVC!=NULL) {
        self.label4.text = psVC.str;
    }
    [self.tableView1 reloadData];
    self.projectLabel.text = spVC.projectname;
}

-(void)keyboardDown
{
    //我添加的代码，此代码可以让keyboard消失
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}

-(void)viewTapped{
    [dateTextField resignFirstResponder];
}

-(void)editBtn
{
    rightButton = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(edit)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [rightButton release];
}

-(void)edit
{
    
    btnPressed = !btnPressed;
    if (btnPressed == YES) {
        rightButton.title = NSLocalizedString(@"nav_btn_wc", nil);
        self.tableView1.allowsSelection = YES;
        img1.hidden = NO;
        img2.hidden = NO;
        img3.hidden = NO;
        img4.hidden = NO;
        img5.hidden = NO;
        img6.hidden = NO;
        img7.hidden = NO;
        img8.hidden = NO;
        [dateTextField setEnabled:YES];
        [self.tableView1 reloadData];
    }
    else{
        [self saveData];
        [indicator startAnimating];
        rightButton.title = @"编辑";
        self.tableView1.allowsSelection = NO;
        [self viewTapped];
        [self caseChange];
        img1.hidden = YES;
        img2.hidden = YES;
        img3.hidden = YES;
        img4.hidden = YES;
        img5.hidden = YES;
        img6.hidden = YES;
        img7.hidden = YES;
        img8.hidden = YES;
        [dateTextField setEnabled:NO];
    }
}

-(void)textFieldAndLabel
{
   
    if (isPad()) {
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 12, 530, 24)];
        rongziLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 12, 550, 24)];
        dateTextField= [[UITextField alloc] initWithFrame:CGRectMake(140, 12, 560, 25)];
        label1 = [[UILabel alloc] initWithFrame:CGRectMake(140, 10, 560, 25)];
        label2 = [[UILabel alloc] initWithFrame:CGRectMake(140, 10, 560, 25)];
        
        label4 = [[UILabel alloc] initWithFrame:CGRectMake(140, 10, 560, 25)];
        projectLabel = [[UILabel alloc] initWithFrame:CGRectMake(140, 10, 560, 25)];
    }else{
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(135, 12, 150, 24)];
        rongziLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 12, 180, 24)];
        label1 = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 190, 25)];
        label2 = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 190, 25)];
        
        label4 = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 190, 25)];
       dateTextField= [[UITextField alloc] initWithFrame:CGRectMake(100, 10, 180, 25)];
        projectLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 10, 180, 25)];


    }
    [dateTextField setEnabled:NO];
    dateTextField.delegate = self;
    rongziLabel.backgroundColor = [UIColor clearColor];
    nameLabel.backgroundColor = [UIColor clearColor];
    label1.backgroundColor = [UIColor clearColor];
    label2.backgroundColor = [UIColor clearColor];
    projectLabel.backgroundColor = [UIColor clearColor];
    label4.backgroundColor = [UIColor clearColor];

    
}
-(void)questData{
    
}
-(void)getData{
    
}
-(void)saveData
{
    NSString* trade = [NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:label1.text withKind:@"industry"]];
    NSString* projectstage = [NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:label4.text withKind:@"projectstage"]];
    [PBDetailAnLiData SaveId:addAnli.no name:nameLabel.text trade:trade projectintroduce:labeljieshao.text projectstage:projectstage starttime:dateTextField.text money:[rongziLabel.text intValue] moneyunit:[PBKbnMasterModel getKbnIdByName:label2.text withKind:@"unit"] ycno:[spVC.str intValue] projectinfono:[spVC.projectinfonoStr intValue]];
}

- (UIFont *) getTextFont
{
    return [UIFont systemFontOfSize: isPad() ? PadContentFontSize : ContentFontSize];
}

-(CGFloat) heightForTextView:(NSString*)contentStr
{
    CGSize size = [contentStr sizeWithFont:[self getTextFont] constrainedToSize:CGSizeMake(isPad() ? 480 : 210, 1000) lineBreakMode:UILineBreakModeWordWrap];
    return MAX(42.0, size.height);
}

-(void)img
{
    img1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qianjin.png"]];
    img1.hidden = YES;
    img2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qianjin.png"]];
    img2.hidden = YES;
    img3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qianjin.png"]];
    img3.hidden = YES;
    img4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qianjin.png"]];
    img4.hidden = YES;
    img5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qianjin.png"]];
    img5.hidden = YES;
    img6 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qianjin.png"]];
    img6.hidden = YES;
    img7 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qianjin.png"]];
    img7.hidden = YES;
    img8 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qianjin.png"]];
    img8.hidden = YES;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"_tb_alxx", nil);
    indicator = [[PBActivityIndicatorView alloc]initWithFrame:isPad()?CGRectMake(0, 0, 768, 1024+49) : CGRectMake(0, 0, 320, 480-KTabBarHeight-KNavigationBarHeight)];
    [self.view addSubview:indicator];
    [self editBtn];
    [self sections];
    [self keyboardDown];
    [self textFieldAndLabel];
    [self tableViewInit];
    self.tableView1.allowsSelection = NO;
    
    if (isPad()) {
        self.datepicker = [[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 200, 768, 250)]autorelease];
    }else{
        self.datepicker = [[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 200, 320, 250)]autorelease];
    }
    datepicker.datePickerMode = UIDatePickerModeDate;
    [datepicker addTarget:self action:@selector(datePickerSeclect:) forControlEvents:UIControlEventValueChanged];
    NSDate *today = [[NSDate alloc] init];
    [datepicker setDate: today animated: YES];
    [self img];
    label2.text = [PBKbnMasterModel getKbnNameById:addAnli.moneyunit withKind:@"unit"];
    label4.text = addAnli.projectstage!=NULL&&[addAnli.projectstage isEqualToString:@""]?[PBKbnMasterModel getKbnNameById:[addAnli.projectstage intValue] withKind:@"projectstage"]:@"";
}

-(void)caseChange
{
    parkManager = [[PBParkManager alloc]init];
    parkManager.delegate = self;
    NSString* tradeName = [[nodesMutableArr objectAtIndex:0] objectForKey:@"trade"];
    NSString* tradeId = [PBIndustryDB searchKbnIdByName:tradeName];
    NSString* projectstage = [NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:label4.text?label4.text:@"" withKind:@"projectstage"]];
    if([iCVC.tradeArr count]>0){
        tradeId = [iCVC.tradeArr objectForKey:@"id"];
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",addAnli.no],@"no",nameLabel.text?nameLabel.text:@"", @"name", tradeId, @"trade",labeljieshao.text?labeljieshao.text:@"",@"projectintroduce",projectstage,@"projectstage", dateTextField.text?dateTextField.text:@"",@"starttime",rongziLabel.text?rongziLabel.text:@"",@"money",[NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:label2.text?label2.text:@"" withKind:@"unit"]],@"moneyunit",spVC.str,@"ycno",spVC.projectinfonoStr,@"projectinfono",nil];
    [parkManager submitDataFromUrl:INVESTMENT_CASE_CHANGE_URL postValuesAndKeys:dic];
    [dic release];
    
}

-(void)sucessSendPostData:(NSObject *)Data{
    [indicator stopAnimating];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)datePickerSeclect:(id)sender
{
    UIDatePicker* control = (UIDatePicker*)sender;
    
    NSDate *date = control.date;
    NSDateFormatter *formatter = [[[NSDateFormatter alloc]init]autorelease];
    [formatter setDateFormat:@"yyyy-MM"];
    NSString *str = [[NSString alloc]initWithFormat:@"%@",[formatter stringFromDate:date]];
    
    dateTextField.text = str;
}

-(void)sections
{
    NSArray *section1 = [[NSArray alloc] initWithObjects:@"投资案例名称:", nil];
    NSArray *section2 = [[NSArray alloc] initWithObjects:@"行业划分:", nil];
    NSArray *section3 = [[NSArray alloc] initWithObjects:@"", nil];
    NSArray *section8 = [[NSArray alloc] initWithObjects:@"融资阶段:", nil];
    NSArray *section4 = [[NSArray alloc] initWithObjects:@"融资时间:", nil];
    NSArray *section5 = [[NSArray alloc] initWithObjects:@"融资额度:", nil];
    NSArray *section6 = [[NSArray alloc] initWithObjects:@"金额单位:", nil];
    NSArray *section7 = [[NSArray alloc] initWithObjects:@"项目选择:", nil];
    sectionArr = [[NSArray arrayWithObjects:section1, section2, section3,section8, section4, section5, section6,section7, nil] retain];
    [section1 release];
    [section2 release];
    [section3 release];
    [section4 release];
    [section5 release];
    [section6 release];
    [section7 release];
    [section8 release];
    
}

#pragma mark-
#pragma mark-   PBParkManagerDelegate
-(void)refreshData
{
    nodesMutableArr = [[NSArray arrayWithArray:parkManager.itemNodes] retain];
    [tableView1 reloadData];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return [[sectionArr objectAtIndex:section] count];    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
     
    switch (indexPath.section) {
        case 0:
        {
        cell.textLabel.text = [[sectionArr objectAtIndex:0] objectAtIndex:0];
         NSString* name = [self.mutableDic objectForKey:[[sectionArr objectAtIndex:0] objectAtIndex:indexPath.row]];
        nameLabel.text = name==NULL?(addAnli.name == NULL?@"":addAnli.name):name;
            [cell addSubview:nameLabel];
            if (isPad()) {
                 img1.frame = CGRectMake(700, 17, 13, 13);
            }else{
                 img1.frame = CGRectMake(288, 17, 13, 13);
            }
        
        [cell addSubview:img1];
            break;
        }
        case 1:
        {
        
        label1.text = iCVC==NULL?(addAnli.trade == NULL||[addAnli.trade isEqualToString:@""]?@"":[PBKbnMasterModel getKbnNameById:[addAnli.trade intValue] withKind:@"industry"]):iCVC.hangyeStr;
            NSLog(@"label=%@",label1.text);
            NSLog(@"addAnli.trade=%@",addAnli.trade);
             NSLog(@"[addAnli.trade intValue]=%d",[addAnli.trade intValue]);
        [cell addSubview:label1];
        cell.textLabel.text = [[sectionArr objectAtIndex:1] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            if (isPad()) {
                img2.frame = CGRectMake(700, 17, 13, 13);
            }else{
                img2.frame = CGRectMake(288, 17, 13, 13);
            }
        [cell addSubview:img2];
        break;
        }
        case 2:
        {
            
       
        CGSize labelSize;
            if (isPad()) {
                 labelWidth = 650.0;
                labeljieshao = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, labelWidth, 40)];
            }else{
                labelWidth = 270.0;
                labeljieshao = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, labelWidth, 40)];
            }
        
        labeljieshao.backgroundColor = [UIColor clearColor];
        labeljieshao.font = [self getTextFont];
        labeljieshao.numberOfLines = 0;
            
            if (isPad()) {
                if (![edit2VC.popStr isEqualToString:@""] && edit2VC!=NULL) {
                    labelSize = [edit2VC.popStr sizeWithFont:[self getTextFont] constrainedToSize:CGSizeMake(550, 1000) lineBreakMode:UILineBreakModeCharacterWrap];
                }else{
                    labelSize = [addAnli.projectintroduce sizeWithFont:[self getTextFont] constrainedToSize:CGSizeMake(550, 1000) lineBreakMode:UILineBreakModeCharacterWrap];
                }
            }else{
                if (![edit2VC.popStr isEqualToString:@""] && edit2VC!=NULL) {
                    labelSize = [edit2VC.popStr sizeWithFont:[self getTextFont] constrainedToSize:CGSizeMake(250, 1000) lineBreakMode:UILineBreakModeCharacterWrap];
                }else{
                    labelSize = [addAnli.projectintroduce sizeWithFont:[self getTextFont] constrainedToSize:CGSizeMake(250, 1000) lineBreakMode:UILineBreakModeCharacterWrap];
                }
            }
        
       
            
        if (labelSize.height > 35) {
            labeljieshao.frame = CGRectMake(5, 0, labelWidth,  MAX(45.0, labelSize.height));
        } else if (labelSize.height > 20) {
            labeljieshao.frame = CGRectMake(5, 0, labelWidth, labelSize.height);
        }
        
        labeljieshao.text =edit2VC.popStr==NULL?(addAnli.projectintroduce == NULL?@"":addAnli.projectintroduce):edit2VC.popStr;
       
        
            if (isPad()) {
                if ([labeljieshao.text isEqualToString:@""]) {
                    img7.frame = CGRectMake(700, 17, 13, 13);
                }else{
                    img7.frame = CGRectMake(700, labelSize.height/2, 13, 13);
                }
            }else{
                if ([labeljieshao.text isEqualToString:@""]) {
                    img7.frame = CGRectMake(288, 17, 13, 13);
                }else{
                    img7.frame = CGRectMake(288, labelSize.height/2, 13, 13);
                }
            }
            
        [cell addSubview:img7];
        [cell.contentView addSubview:labeljieshao];                       
            break;
        }
        case 3:
        {
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.textLabel.text = [[sectionArr objectAtIndex:3] objectAtIndex:0];
            if (isPad()) {
                img3.frame = CGRectMake(700, 17, 13, 13);
            }else{
                img3.frame = CGRectMake(288, 17, 13, 13);
            }
            [cell addSubview:img3];
        [cell addSubview:label4];
        break;
        }

        case 4:
        {
        
        dateTextField.text = addAnli.starttime == NULL?@"":addAnli.starttime;
        
        [cell addSubview:dateTextField];
        cell.textLabel.text = [[sectionArr objectAtIndex:4] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (isPad()) {
                img8.frame = CGRectMake(700, 17, 13, 13);
            }else{
                img8.frame = CGRectMake(288, 17, 13, 13);
            }
        [cell addSubview:img8];

            break;
        }
        case 5:
        { 
            NSString  *rongzi = [self.mutableDic objectForKey:[[sectionArr objectAtIndex:5] objectAtIndex:indexPath.row]];
            rongziLabel.text = rongzi==NULL?([NSString stringWithFormat:@"%d",addAnli.money] == NULL ||addAnli.money == 0? @"" : [NSString stringWithFormat:@"%d",addAnli.money]):rongzi;
        cell.textLabel.text = [[sectionArr objectAtIndex:5] objectAtIndex:0];
            if (isPad()) {
                img4.frame = CGRectMake(700, 17, 13, 13);
            }else{
                img4.frame = CGRectMake(288, 17, 13, 13);
            }
        [cell addSubview:img4];
        [cell addSubview:rongziLabel];
                      
            break;
        }
        case 6:
        {
        cell.textLabel.text = [[sectionArr objectAtIndex:6] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            if (isPad()) {
                img5.frame = CGRectMake(700, 17, 13, 13);
            }else{
                img5.frame = CGRectMake(288, 17, 13, 13);
            }
        [cell addSubview:img5];
        [cell addSubview:label2];
            break;
        }
        case 7:
        {

        cell.textLabel.text = [[sectionArr objectAtIndex:7] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            if (isPad()) {
                img6.frame = CGRectMake(700, 17, 13, 13);
            }else{
                img6.frame = CGRectMake(288, 17, 13, 13);
            }
        [cell addSubview:projectLabel];
        [cell addSubview:img6];
        if (btnPressed == YES) {
            cell.hidden = NO;
        }else{
            cell.hidden = YES;
        }

            break;
        }
            
        default:
            break;
    }
    
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (isPad()) {
        customView = [[[UIView alloc] initWithFrame:CGRectMake(40.0, 0.0, 100.0, 26.0)] autorelease];
    }else{
        customView = [[[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 100.0, 26.0)] autorelease];
    }
    
    
    UILabel * headerLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor grayColor];
    headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:17];
    if (isPad()) {
        headerLabel.frame = CGRectMake(56.0, 0.0, 100.0, 26.0);
    }else
    {
        headerLabel.frame = CGRectMake(20.0, 0.0, 100.0, 26.0);
    }
    
    
    if (section == 2) {
        headerLabel.text =  @"项目概要:";
    }
    [customView addSubview:headerLabel];
    
    return customView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    int r = 10;
    if (section == 2) {
        r = 26.0;
    }
    return r;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
         return [sectionArr count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
        [self.navigationController pushViewController:edVC animated:YES];
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
        edVC.title = [[sectionArr objectAtIndex:0] objectAtIndex:indexPath.row];
        break;
        }
        case 1:
        {
         
            iCVC = [[PBIndustryClassificationViewController alloc] init];
            [self.navigationController pushViewController:iCVC animated:YES];
            [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
            break;
        }
        case 2:
        {
        if (!edit2VC) {
            edit2VC = [[PBEDITViewController alloc] init];
        }
        edit2VC.popStr = self.labeljieshao.text;
        edit2VC.title = @"项目概要";
        [self.navigationController pushViewController:edit2VC animated:YES];
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
        break;
        }
        case 3:
        {
        psVC = [[PBProjectStageViewController alloc]init];
        [self.navigationController pushViewController:psVC animated:YES];
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
            break;
        }
        case 5:
        {
        [self.navigationController pushViewController:edVC animated:YES];
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
        edVC.title = [[sectionArr objectAtIndex:5] objectAtIndex:indexPath.row];
        break;
        }
        case 6:
        {
            amountUnitVC = [[PBAmountUnitViewController alloc] init];
            amountUnitVC.icdVC =self;
            [self.navigationController pushViewController:amountUnitVC animated:YES];
            [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
            break;
        }
        case 7:
        {
        spVC = [[PBSearchsProjectsViewController alloc] init];
        [self.navigationController pushViewController:spVC animated:YES];
            [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
            break;
        }
            
        default:
            break;
    }
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat section = 44;

        if (indexPath.section == 2) {
            if (![edit2VC.popStr isEqualToString:@""]&&edit2VC!=NULL) {
                NSString *str = edit2VC.popStr;
                section = [self heightForTextView:str];
            }else{
                NSString *str = addAnli.projectintroduce;
                section = [self heightForTextView:str];
            }
           
        }

    return section;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == dateTextField) {
        textField.inputView = self.datepicker;
        
        if (isPad()) {
            toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 460, 768, 44)];
        }else{
            toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 460, 320, 44)];
        }
        UIBarButtonItem* btn = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"nav_btn_wc", nil)
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(donePush:)];
        UIBarButtonItem* btn1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        toolBar.items = [NSArray arrayWithObjects:btn1,btn, nil];
        textField.inputAccessoryView = toolBar;
    }
    
    if (isPad()) {
        [self setAnimation:0.3 view:self.tableView1 frame:CGRectMake(0,0,768,self.tableView1.frame.size.height)];
    }else
    {
        [self setAnimation:0.3 view:self.tableView1 frame:CGRectMake(0,0,320,self.tableView1.frame.size.height-203)];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if (isPad()) {
        self.tableView1.frame = CGRectMake(0,0,768,1024);
    }else{
        self.tableView1.frame = CGRectMake(0,0,320,390);
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
    if (isPad()) {
        [self setAnimation:0.3 view:self.tableView1 frame:CGRectMake(0,0,768,self.tableView1.frame.size.height-5)];
    }else{
        [self setAnimation:0.3 view:self.tableView1 frame:CGRectMake(0,0,320,self.tableView1.frame.size.height-5)];
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    
    if (isPad()) {
        self.tableView1.frame = CGRectMake(0,0,768,1024);
    }else{
        self.tableView1.frame = CGRectMake(0,0,320,390);
    }
}

-(void)donePush:(id)sender
{
    [dateTextField resignFirstResponder];
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
