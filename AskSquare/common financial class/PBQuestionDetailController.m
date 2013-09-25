//
//  PBQuestionDetailController.m
//  ParkBusiness
//
//  Created by QDS on 13-5-29.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBQuestionDetailController.h"
#import "CustomImageView.h"
#import "PBStarEntrepreneursDetail.h"
#define kURLSTRING [NSString stringWithFormat:@"%@admin/index/searchquestioninfobyno", HOST]

@interface PBQuestionDetailController ()

@end

static CGFloat questionHeight, answerHeight;

@implementation PBQuestionDetailController
@synthesize detailTableView, noString, manager, indicator, dataDictionary;

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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"问题详细";

    
    CGFloat viewWidth = 320;
    CGFloat viewHeight = (isPhone5() ? 568 :480)-KNavigationBarHeight;
    if (isPad()) {
        viewHeight = 1024-KNavigationBarHeight;
        viewWidth = 768;
    }
    
    indicator = [[PBActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    [self.view addSubview:indicator];
    [indicator startAnimating];
    
    NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys: noString, @"no", nil];
    manager = [[PBManager alloc] init];
    manager.delegate = self;
    [manager requestBackgroundXMLData:kURLSTRING forValueAndKey:dataDic];
    
    manager.acIndicator = indicator;
}

#pragma mark -
#pragma mark ParseDataDelegateMethod
- (void) sucessParseXMLData
{
    [indicator stopAnimating];
    if (manager.parseData.count > 0) {
        dataDictionary = [[NSDictionary dictionaryWithDictionary: [manager.parseData objectAtIndex:0]] retain];
        [detailTableView reloadData];
    }
}


//根据设备的不同得到不同的字体大小
- (UIFont *) getTextFont
{
    return [UIFont systemFontOfSize:(isPad() ? PadContentFontSize : ContentFontSize)];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *DetailIdentifier = @"DetailIdentifier";
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DetailIdentifier] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.section) {
        case 0:
        {
            UIImageView *typeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 21, 21)];
            typeImageView.image = [UIImage imageNamed:@"institutetype.png"];
            [cell.contentView addSubview:typeImageView];
            [typeImageView release];
            
            UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(45.0, 12.0, 200, 21)];
            [typeLabel setFont:[self getTextFont]];
            typeLabel.text = [self getTypeName];
            typeLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:typeLabel];
            [typeLabel release];
            UIImageView *idImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 45, 21, 21)];
            idImageView.image = [UIImage imageNamed:@"useridno.png"];
            [cell.contentView addSubview:idImageView];
            [idImageView release];
            
            UILabel *idLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 45, 200, 21)];
            [idLabel setFont:[self getTextFont]];
            idLabel.text = [dataDictionary objectForKey:@"userno"];
            idLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:idLabel];
            [idLabel release];
            //详细按钮
            UIButton* detailbtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [detailbtn setBackgroundImage:[UIImage imageNamed:@"custom_button.png"] forState:UIControlStateNormal];
//            [detailbtn setBackgroundImage:[UIImage imageNamed:@"custom_button"] forState:UIControlStateNormal];
            detailbtn.frame = CGRectMake(100, 45, 40, 21);
            [detailbtn setTitle:@"详细" forState:UIControlStateNormal];
            detailbtn.titleLabel.font = [self getTextFont];
//            [detailbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            detailbtn.titleLabel.text = @"详细";
            detailbtn.titleLabel.textColor = [UIColor whiteColor];
            [detailbtn addTarget:self action:@selector(showUserInfo:) forControlEvents:UIControlEventTouchUpInside];
            
            [cell.contentView addSubview:detailbtn];
            
            UIImageView *cdateImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 78, 21, 21)];
            cdateImageView.image = [UIImage imageNamed:@"time.png"];
            [cell.contentView addSubview:cdateImageView];
            [cdateImageView release];
            
            UILabel *cdateLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 78, 200, 21)];
            [cdateLabel setFont:[self getTextFont]];
            cdateLabel.text = [dataDictionary objectForKey:@"cdate"];
            cdateLabel.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:cdateLabel];
            [cdateLabel release];

            break;
        }
        case 1:
        {
            CGFloat width = isPad() ? 660 : 280;
            NSString *questionString = [dataDictionary objectForKey:@"question"];
            questionHeight = [self getAdaptLabelHeight:questionString];
            UILabel *questionLabel = [self customLabel:questionString :10 :10 :width :questionHeight];
            [cell.contentView addSubview:questionLabel];
            break;
        }
        case 2:
        {
            NSString *answerString = [dataDictionary objectForKey:@"answer"];
            answerHeight = [self getAdaptLabelHeight:answerString];
            UILabel *answerLabel = [self customLabel:answerString :10 :10 :isPad() ? 660 : 280 :answerHeight];
            [cell.contentView addSubview:answerLabel];
            break;
        }
        default:
            break;
    }
    
    return cell;
}
-(void)showUserInfo:(UIButton*)sender{
    PBStarEntrepreneursDetail *controller = [[PBStarEntrepreneursDetail alloc] init];
    controller.no = [dataDictionary objectForKey:@"userno"];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}
//自定义table
- (UILabel *) customLabel:(NSString *) str :(CGFloat) x : (CGFloat) y : (CGFloat) width : (CGFloat) height
{
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)]autorelease];
//    [[label layer] setBorderWidth:1.0];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 0;
    label.frame = CGRectMake(x, y, width, height);
    label.text = str;
    [label setFont:[self getTextFont]];
    return label;
}

//得到问题类型的字符串表示
- (NSString *) getTypeName
{
    NSString *typeName = @"";
    int type = [[dataDictionary objectForKey:@"type"] intValue];
    switch (type) {
        case 1:
            typeName = @"金融政策";
            break;
        case 2:
            typeName = @"金融产品";
            break;
        case 3:
            typeName = NSLocalizedString(@"_title_cpfwxxxx", nil);
            break;
            
        default:
            break;
    }
    return typeName;
}

//返回label自适应后的高度
- (CGFloat) getAdaptLabelHeight:(NSString *) str
{
    CGFloat height = 21.0f;
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)]autorelease];
    label.numberOfLines = 0;
    CGSize labelSize = [str sizeWithFont:[self getTextFont] constrainedToSize:CGSizeMake(isPad() ? 660 :280, 2000) lineBreakMode:UILineBreakModeCharacterWrap];
    height = MAX(21.0, labelSize.height) ;
    return  height;
}

#pragma mark -
#pragma mark TableViewDelegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 111.0;
    switch (indexPath.section) {
        case 0:
            height =111.0;
            break;
        case 1:
            height = 20 + [self getAdaptLabelHeight:[dataDictionary objectForKey:@"question"]];
            break;
        case 2:
            height = 20 + [self getAdaptLabelHeight:[dataDictionary objectForKey:@"answer"]];
            break;
            
        default:
            break;
    }
    return height;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title = nil;
    switch (section) {
        case 1:
            title = @"提问：";
            break;
        case 2:
            title = @"回答：";
            break;
            
        default:
            break;
    }
    return title;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [dataDictionary release];
    [indicator release];
    [manager release];
    [noString release];
    [detailTableView release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setDataDictionary:nil];
    [self setIndicator:nil];
    [self setManager:nil];
    [self setNoString:nil];
    [self setDetailTableView:nil];
    [super viewDidUnload];
}
@end
