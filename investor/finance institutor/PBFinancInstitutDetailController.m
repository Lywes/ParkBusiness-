//
//  PBFinancInstitutDetailController.m
//  ParkBusiness
//
//  Created by QDS on 13-5-24.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBFinancInstitutDetailController.h"
#import "PBFinancialProductAndServeController.h"
#import "PBAllManagerController.h"
#import "PBFinancialCaseController.h"
#define kURLSTRING [NSString stringWithFormat:@"%@admin/index/searchfinancinginstitution", HOST]
#define ADDSCORE_URL [NSString stringWithFormat:@"%@/admin/index/addinstitutionappraise",HOST]
@interface PBFinancInstitutDetailController ()

@end

@implementation PBFinancInstitutDetailController
@synthesize detailTableView;
@synthesize dataDictionary;
@synthesize rootController;
@synthesize financeno;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.financeno = @"";
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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = [dataDictionary objectForKey:@"name"];
    if ([self.financeno intValue]>0) {
        indicator = [[PBActivityIndicatorView alloc]initWithFrame:self.navigationController.view.frame];
        [self.view addSubview:indicator];
        [indicator startAnimating];
        PBWeiboDataConnect* connect = [[PBWeiboDataConnect alloc]init];
        connect.delegate = self;
        
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjectsAndKeys:self.financeno,@"no",USERNO,@"userno", nil];
        [connect getXMLDataFromUrl:kURLSTRING postValuesAndKeys:dic];
    }
    NSArray *section1 = [[NSArray alloc] initWithObjects:@"name&&photo", nil];
    NSArray *section2 = [[NSArray alloc] initWithObjects:@"signature", nil];
    NSArray *section3 = [[NSArray alloc] initWithObjects:@"全部经理人", nil];
    sectionAndRowDataArray = [[NSArray arrayWithObjects:section1, section2, section3, nil] retain];
    [section1 release];
    [section2 release];
    [section3 release];
}

-(void)sucessParseXMLData:(PBWeiboDataConnect *)weiboDatas{
    [indicator stopAnimating];
    dataDictionary = [weiboDatas.parseData objectAtIndex:0];

    [self.detailTableView reloadData];
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
            CustomImageView *bossPhotoImageView = [[CustomImageView alloc] initWithFrame:CGRectMake(3, 3, 48, 48)];
            [bossPhotoImageView.imageView loadImage: URLString];
            [cell.contentView addSubview:bossPhotoImageView];
            [bossPhotoImageView release];
            
            CGFloat originX2 = isPad() ? 90 : 70;
            UIImageView *imageaView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"financinginstitution.png"]];
            imageaView1.frame = CGRectMake(originX2, 6, 21, 21);
            [cell.contentView addSubview:imageaView1];
            [imageaView1 release];
            //机构评价
            UIImageView *scoreImage = [[UIImageView alloc] initWithFrame:CGRectMake(originX2,30,90, 18)];
            [scoreImage setStarImageWithScore:[[dataDictionary objectForKey:@"score"] floatValue] isImage:YES];
            [cell.contentView addSubview:scoreImage];
            [scoreImage release];
            
            UIImageView *imageaView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trade.png"]];
            imageaView2.frame = CGRectMake(originX2, 55, 21, 21);
            [cell.contentView addSubview:imageaView2];
            [imageaView2 release];
            
            CGFloat originX3 = isPad() ? 120 : 100;
            CGFloat labelWidth = isPad() ? 280 : 180;
            UILabel *financinstituNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX3, 6, labelWidth, 21)];
            financinstituNameLabel.text = [dataDictionary objectForKey:@"name"];
            financinstituNameLabel.backgroundColor = [UIColor clearColor];
            financinstituNameLabel.font = [self getTextFont];
            [cell.contentView addSubview:financinstituNameLabel];
            [financinstituNameLabel release];
            
            UILabel *financinstituTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX3, 55, labelWidth, 21)];
            financinstituTypeLabel.text = [dataDictionary objectForKey:@"type"];
            financinstituTypeLabel.backgroundColor = [UIColor clearColor];
            financinstituTypeLabel.font = [self getTextFont];
            [cell.contentView addSubview:financinstituTypeLabel];
            [financinstituTypeLabel release];
            
            break;
        }

        case 1:
        {
            CGFloat textWidth = isPad() ? 679 : 300;
            NSString *str = [dataDictionary  objectForKey:@"businessintro"];
            UITextView *signatureTextView = [[UITextView alloc] initWithFrame:CGRectMake(isPad() ? 8 : 4, 12, textWidth, [self heightForTextView:str])];
            signatureTextView.text = str;
            signatureTextView.font = [self getTextFont];
            signatureTextView.editable = NO;
            signatureTextView.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:signatureTextView];
            [signatureTextView release];
            break;
        }

        case 2:
        {
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            NSArray *imageNameArray = [[NSArray alloc] initWithObjects:@"allmanager.png", nil];
            CGFloat originX = isPad() ? 20 : 10;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(originX, 12, 21, 21)];
            imageView.image = [UIImage imageNamed:[imageNameArray objectAtIndex:indexPath.row]];
            [cell.contentView addSubview:imageView];
            [imageView release];
            [imageNameArray release];
            
            UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(isPad() ? 80 : 40, 12, 240, 21)];
            label.backgroundColor = [UIColor clearColor];
            label.text = [NSString stringWithFormat:@"%@",[[sectionAndRowDataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
            [cell.contentView addSubview:label];
            [label release];
            break;
        }
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark
#pragma mark UITableViewDelegateMethod
- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return (section == 1) ? @"业务介绍" : nil;
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
-(void)starDidPush:(UIButton*)sender{
    int level = sender.tag+1;
    for (UIButton* btn in [starImage subviews]) {
        [btn removeFromSuperview];
    }
    [self setButtonWithLevel:level];
    PBWeiboDataConnect *submitData = [[PBWeiboDataConnect alloc]init];
    submitData.delegate = self;
    NSArray* arr1 = [NSArray arrayWithObjects:USERNO,self.financeno,[NSString stringWithFormat:@"%d",level], nil];
    NSArray* arr2 = [NSArray arrayWithObjects:@"userno",@"institutionno",@"score", nil];
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithObjects:arr1 forKeys:arr2];
    [submitData submitDataFromUrl:ADDSCORE_URL postValuesAndKeys:dic];
}
-(void)sucessSendPostData:(PBWeiboDataConnect *)weiboDatas{
    [indicator stopAnimating];
    PBAlertView* alert = [[PBAlertView alloc]initWithMessage:@"感谢您的评分!"];
    [alert show];
    [alert release];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==0) {
        return 50;
    }
    return 0;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 44.0f;
    switch (indexPath.section) {
        case 0:
        {
            height = 80.0f;
            break;
        }
        case 1:
        {
            NSString *str = [dataDictionary  objectForKey:@"businessintro"];
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
    if (indexPath.section == 2) {
        NSString *noString = [dataDictionary objectForKey:@"no"];
        switch (indexPath.row) {
            case 0:
            {
                PBAllManagerController *controller = [[PBAllManagerController alloc] init];
                controller.fnoString = noString;
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
                break;
            }
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

- (void)dealloc {
    [sectionAndRowDataArray release];
    [dataDictionary release];
    [detailTableView release];
    [indicator release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setDataDictionary:nil];
    [self setDetailTableView:nil];
    [super viewDidUnload];
}
@end
