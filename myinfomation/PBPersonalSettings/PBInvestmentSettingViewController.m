//
//  PBInvestmentSettingViewController.m
//  ParkBusiness
//
//  Created by  on 13-3-18.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBInvestmentSettingViewController.h"
#import "PBInvestmentIndustryViewController.h"
#import "PBDetailIndustryMarketViewController.h"
#import "PBUserModel.h"

#define TOUZHIXIANGGUANSHEZHI_URL [NSString stringWithFormat:@"%@admin/index/updatesetinvest",HOST]

@implementation PBInvestmentSettingViewController

@synthesize tableView1;
@synthesize eduLabel;
@synthesize detailLabel;
@synthesize string1;
@synthesize string2;
@synthesize label5;
@synthesize arr;
@synthesize countLabel;
@synthesize label2;
@synthesize mutableDic;
@synthesize parkManager;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        edVC = [[PBEDViewController alloc] init];
        mutableDic = [[NSMutableDictionary alloc] init];
        self.arr = [[NSMutableArray alloc]init];
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

-(void)viewWillAppear:(BOOL)animated
{
    
    
    
    if (edVC.title!=NULL&&![edVC.title isEqualToString:@""]) {
        [self.mutableDic setObject:edVC.contentStr==NULL?@"":edVC.contentStr forKey:edVC.title];
    }
    
    [self.tableView1 reloadData];

}

-(void)saveData
{
    [PBTouzishezhiData SaveId:[PBUserModel getUserId] investtrade:label2.text investsubdivision:detailLabel.text annualinvestno:countLabel.text projectfund_avg:[eduLabel.text intValue] carveoutresourse:label5.text];
}

-(void)getData
{
    arry = [PBTouzishezhiData search];
    for(PBTouzishezhiData *shezhi in arry)
        {
        label2.text = shezhi.investtrade == NULL?@"":shezhi.investtrade;
        detailLabel.text = shezhi.investsubdivision == NULL?@"":shezhi.investsubdivision;
        countLabel.text = shezhi.annualinvestno == NULL?@"":shezhi.annualinvestno;
        eduLabel.text = [NSString stringWithFormat:@"%d",shezhi.projectfund_avg] == NULL ? @"" : [NSString stringWithFormat:@"%d",shezhi.projectfund_avg];
        label5.text = shezhi.carveoutresourse == NULL?@"":shezhi.carveoutresourse;
        
        }
    
}

-(void)edit
{
    isPressed = !isPressed;
    if (isPressed == NO) {
        self.tableView1.allowsSelection = NO;
        self.navigationItem.rightBarButtonItem.title = @"编辑";
        img1.hidden = YES;
        img2.hidden = YES;
        img3.hidden = YES;
        img4.hidden = YES;
        img5.hidden = YES;
        [self saveData];
        [indicator startAnimating];
        [self submitData];
    }
    else
        {
        self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"nav_btn_wc", nil);
        self.tableView1.allowsSelection = YES;
        img1.hidden = NO;
        img2.hidden = NO;
        img3.hidden = NO;
        img4.hidden = NO;
        img5.hidden = NO;
        }
    
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



-(void)textFieldAndLabel{
    
    if (isPad()) {
        labelWidth = 650.0;
        detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, labelWidth, 40)];
    }else{
        labelWidth = 270.0;
        detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, labelWidth, 40)];
    }
    
    if (isPad()) {
        labelWidth = 650.0;
        label5 = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, labelWidth, 40)];
    }else{
        labelWidth = 270.0;
        label5 = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, labelWidth, 40)];
    }
    
    
    label2 = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, labelWidth, 40)];
   
    
    if (isPad()) {
        label5.font = [UIFont boldSystemFontOfSize:PadContentFontSize];
        label2.font = [UIFont boldSystemFontOfSize:PadContentFontSize];
        eduLabel.font = [UIFont boldSystemFontOfSize:PadContentFontSize];
        countLabel.font = [UIFont boldSystemFontOfSize:PadContentFontSize];
        countLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 2, 400, 40)];
       
        eduLabel = [[UILabel alloc] initWithFrame:CGRectMake(265, 5, 400, 34)];
        
    }else{
        countLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 2, 170, 40)];
       
        eduLabel = [[UILabel alloc] initWithFrame:CGRectMake(215, 5, 90, 34)];
        
        countLabel.font = [UIFont boldSystemFontOfSize:ContentFontSize];
        eduLabel.font = [UIFont boldSystemFontOfSize:ContentFontSize];
        label2.font = [UIFont boldSystemFontOfSize:ContentFontSize];
        label5.font = [UIFont boldSystemFontOfSize:ContentFontSize];
       
    }
    detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, labelWidth, 40)];
    detailLabel.backgroundColor = [UIColor clearColor];
    label5.backgroundColor = [UIColor clearColor];
    label2.backgroundColor = [UIColor clearColor];
    countLabel.backgroundColor = [UIColor clearColor];
    eduLabel.backgroundColor = [UIColor clearColor];
    label5.numberOfLines = 0; 
    label5.textAlignment = UITextAlignmentLeft;
    label2.numberOfLines = 0; 
    label2.textAlignment = UITextAlignmentLeft;
    label2.backgroundColor = [UIColor clearColor];
   
   
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
}

-(void)submitData
{
    parkManager = [[PBParkManager alloc]init];
    parkManager.delegate = self;
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:label2.text, @"investtrade", detailLabel.text, @"investsubdivision",countLabel.text,@"annualinvestno" ,eduLabel.text,@"projectfund_avg",label5.text,@"carveoutresourse",nil];
    [parkManager submitDataFromUrl:TOUZHIXIANGGUANSHEZHI_URL postValuesAndKeys:dic];
}

-(void)sucessSendPostData:(NSObject *)Data{
    [indicator stopAnimating];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.title = @"投资相关设置";
    [super viewDidLoad];
    indicator = [[PBActivityIndicatorView alloc]initWithFrame:isPad()?CGRectMake(0, 0, 768, 1024+49) : CGRectMake(0, 0, 320, 480-KTabBarHeight-KNavigationBarHeight)];
    [self.view addSubview:indicator];
    [self rightBtn];
    [self textFieldAndLabel];
    self.tableView1.allowsSelection = NO;
    [self sectionContent];
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    [self getData];
    tableView1.frame = CGRectMake(0, 0, 320, 460);
    [self img];
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    
}

-(void)sectionContent
{
           
    NSArray *section1 = [[NSArray alloc] initWithObjects:@"", nil];
    NSArray *section2 = [[NSArray alloc] initWithObjects:@"", nil];
    NSArray *section3 = [[NSArray alloc] initWithObjects: @"年投资项目数:",nil];
    NSArray *section4 = [[NSArray alloc] initWithObjects:@"年投资平均额度（万元）:", nil];
    NSArray *section5 = [[NSArray alloc] initWithObjects: @"", nil];
    
    sectionArr = [[NSMutableArray arrayWithObjects:section1, section2, section3,section4, section5, nil] retain];
    
    [section1 release];
    [section2 release];
    [section3 release];
    [section4 release];
    [section5 release];
    
}

-(void)rightBtn
{    
    rightbtn = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(edit)];
    self.navigationItem.rightBarButtonItem = rightbtn;
    [rightbtn release];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int row = 0;
    if (section == 0) {
        row = 1;
    }
    
    if (section == 1) {
        row = 1;
    }
    
    if (section == 2) {
        row = 1;
    }
    if (section == 3) {
        row = 1;
    }
    if (section == 4) {
        row = 1;
    }
    
    return row;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sectionArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    PBTouzishezhiData *data1 = [arry objectAtIndex:0];
    switch (indexPath.section) {
        case 0:
        {
       
        
        label2.font = [self getTextFont];
            if (self.string1) {
                self.label2.text = self.string1;
            }
             
        label2.numberOfLines = 0;
        labelSize = [self.label2.text sizeWithFont:[self getTextFont] constrainedToSize:CGSizeMake(250, 1000) lineBreakMode:UILineBreakModeCharacterWrap];
        if (labelSize.height > 35) {
            label2.frame = CGRectMake(5, 0, labelWidth,  MAX(45.0, labelSize.height));
        } else if (labelSize.height > 20) {
            label2.frame = CGRectMake(5, 0, labelWidth, labelSize.height);
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        [cell.contentView addSubview:label2];
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
            
        
        detailLabel.font = [self getTextFont];
            if (self.string2) {
                self.detailLabel.text = self.string2;
            }
        
        detailLabel.numberOfLines = 0;
        labelSize = [self.detailLabel.text sizeWithFont:[self getTextFont] constrainedToSize:CGSizeMake(250, 1000) lineBreakMode:UILineBreakModeCharacterWrap];
        if (labelSize.height > 35) {
            detailLabel.frame = CGRectMake(5, 0, labelWidth,  MAX(45.0, labelSize.height));
        } else if (labelSize.height > 20) {
            detailLabel.frame = CGRectMake(5, 0, labelWidth, labelSize.height);
        }

        cell.textLabel.text = [[sectionArr objectAtIndex:1] objectAtIndex:indexPath.row];
        
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
        [cell.contentView addSubview:detailLabel];
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
        NSString *count = [self.mutableDic objectForKey:[[sectionArr objectAtIndex:2] objectAtIndex:indexPath.row]];
        countLabel.text = count==NULL?(data1.annualinvestno == NULL||[data1.annualinvestno isEqualToString:@"0"]?@"":data1.annualinvestno):count;
        cell.textLabel.text = [[sectionArr objectAtIndex:2] objectAtIndex:indexPath.row];
            
        [cell addSubview:countLabel];
            if (isPad()) {
                img3.frame = CGRectMake(700, 17, 13, 13);
            }else{
                img3.frame = CGRectMake(288, 17, 13, 13);
            }
        [cell addSubview:img3];
            break;
        }    

        case 3:
        {
        NSString *edu = [self.mutableDic objectForKey:[[sectionArr objectAtIndex:3] objectAtIndex:indexPath.row]];
        eduLabel.text = edu==NULL?([NSString stringWithFormat:@"%d",data1.projectfund_avg] == NULL||data1.projectfund_avg == 0?@"":[NSString stringWithFormat:@"%d",data1.projectfund_avg]):edu;
        
        cell.textLabel.text = [[sectionArr objectAtIndex:3] objectAtIndex:indexPath.row];
        [cell addSubview:eduLabel];
            if (isPad()) {
                img4.frame = CGRectMake(700, 17, 13, 13);
            }else{
                img4.frame = CGRectMake(288, 17, 13, 13);
            }
        [cell addSubview:img4];
            break;
        }    

        case 4:
        {
        
        label5.font = [self getTextFont];
        label5.numberOfLines = 0;
        
            if (isPad()) {
                if (![edit2VC.popStr isEqualToString:@""] && edit2VC!=NULL) {
                    labelSize = [edit2VC.popStr sizeWithFont:[self getTextFont] constrainedToSize:CGSizeMake(550, 1000) lineBreakMode:UILineBreakModeCharacterWrap];
                }else{//shezhiData.carveoutresourse 
                    labelSize = [label5.text sizeWithFont:[self getTextFont] constrainedToSize:CGSizeMake(550, 1000) lineBreakMode:UILineBreakModeCharacterWrap];
                    NSLog(@"%@",shezhiData.carveoutresourse);
                }
            }else{
                if (![edit2VC.popStr isEqualToString:@""] && edit2VC!=NULL) {
                    labelSize = [edit2VC.popStr sizeWithFont:[self getTextFont] constrainedToSize:CGSizeMake(250, 1000) lineBreakMode:UILineBreakModeCharacterWrap];
                }else{
                    labelSize = [label5.text  sizeWithFont:[self getTextFont] constrainedToSize:CGSizeMake(250, 1000) lineBreakMode:UILineBreakModeCharacterWrap];
                }
            }

        
        if (labelSize.height > 35) {
            label5.frame = CGRectMake(5, 0, labelWidth,  MAX(45.0, labelSize.height));
        } else if (labelSize.height > 20) {
            label5.frame = CGRectMake(5, 0, labelWidth, labelSize.height);
        }
            if (edit2VC.popStr) {
                label5.text =edit2VC.popStr;
            }
            if (isPad()) {
                if ([label5.text isEqualToString:@""]) {
                    img5.frame = CGRectMake(700, 17, 13, 13);
                }else{
                    img5.frame = CGRectMake(700, labelSize.height/2, 13, 13);
                }
            }else{
                if ([label5.text isEqualToString:@""]) {
                    img5.frame = CGRectMake(288, 17, 13, 13);
                }else{
                    img5.frame = CGRectMake(288, labelSize.height/2, 13, 13);
                }
            }


        cell.textLabel.text = [[sectionArr objectAtIndex:4] objectAtIndex:indexPath.row];
        
        [cell.contentView addSubview:label5];
        [cell addSubview:img5];
            break;
        }     

        default:
            break;
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section 
{
    UIView* customView = [[[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 100.0, 26.0)] autorelease];
    
    headerLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor grayColor];
    headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:14];
    if (isPad()) {
        headerLabel.frame = CGRectMake(56.0, 0.0, 200.0, 26.0);
    }else{
         headerLabel.frame = CGRectMake(20.0, 0.0, 200.0, 26.0);
    }
       
    if (section == 0) {
        headerLabel.text = @"投资行业:";
    }    
    [customView addSubview:headerLabel];
    if (section == 1) {
        headerLabel.text = @"关注的细分市场:";
    }    
    [customView addSubview:headerLabel];
    if (section == 4) {
        headerLabel.text = @"为创业者提供的其他资源:";
    }    
    [customView addSubview:headerLabel];
    
    return customView;    
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    int r = 10;
    if (section == 0) {
        r = 25.0;
    }
    if (section == 1) {
        r = 25.0;
    }
    if (section == 4) {
        r = 25.0;
    }
    return r;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float section = 44.0;
    if (indexPath.section == 0) {
        NSString *str = self.string1;
        section = [self heightForTextView:str];
    }
    if (indexPath.section == 1) {
        NSString *str = self.string2;
        section = [self heightForTextView:str];
    }
    if (indexPath.section == 4) {
       if (![edit2VC.popStr isEqualToString:@""]&&edit2VC!=NULL) {
            NSString *str = edit2VC.popStr;
            section = [self heightForTextView:str];
        }else{//shezhiData.carveoutresourse
            NSString *str = label5.text;
            section = [self heightForTextView:str];
        }

    }

    return section;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        PBInvestmentIndustryViewController *iTVC = [[PBInvestmentIndustryViewController alloc] init];
            //模态传值时，记得写这一句
        iTVC.setting = self;
        PBNavigationController* navi = [[PBNavigationController alloc]initWithRootViewController:iTVC];
        [navi.navigationBar setBackgroundImage:[UIImage imageNamed:@"topnavigation.png"] forBarMetrics:UIBarMetricsDefault];
        iTVC.title = @"选择投资行业";
        [self presentModalViewController:navi animated:YES];
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
        [iTVC release];
        [navi release];
    }
    if (indexPath.section == 1) {
        
        PBDetailIndustryMarketViewController *dIMVC = [[[PBDetailIndustryMarketViewController alloc] init] autorelease];
        dIMVC.arr = self.arr;
        dIMVC.setting = self;
        [self.navigationController pushViewController:dIMVC animated:YES];
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    }
    if (indexPath.section == 2) {
        [self.navigationController pushViewController:edVC animated:YES];
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
        edVC.title = [[sectionArr objectAtIndex:2] objectAtIndex:indexPath.row];
    }
    if (indexPath.section == 3) {
        [self.navigationController pushViewController:edVC animated:YES];
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
        edVC.title = [[sectionArr objectAtIndex:3] objectAtIndex:indexPath.row];
    }
    if (indexPath.section == 4) {
        if (!edit2VC) {
            edit2VC = [[PBEDITViewController alloc] init];
        }
        edit2VC.title = @"为创业者提供的其他资源:";
        edit2VC.popStr = self.label5.text;
        [self.navigationController pushViewController:edit2VC animated:YES];
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    }
}

-(void)setAnimation:(NSTimeInterval)duration view:(UIView *)changeView frame:(CGRect)frame
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration];
    changeView.frame = frame;
    [UIView commitAnimations];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (isPad()) {
        [self setAnimation:0.3 view:self.tableView1 frame:CGRectMake(0,0,768,self.tableView1.frame.size.height-203)];
    }else{
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

- (void)viewDidUnload
{
    [super viewDidUnload];
 
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
