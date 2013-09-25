//
//  PBParkIntroduceController.m
//  ParkBusiness
//
//  Created by QDS on 13-5-21.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBParkIntroduceController.h"
#import "CustomImageView.h"
#import "PBParkEnvironmentViewController.h"
#import "PBIndustrialPolicyViewController.h"
#import "PBParkQAViewController.h"
#import "PBParkCompanysController.h"

@interface PBParkIntroduceController ()

@end

@implementation PBParkIntroduceController
@synthesize dataDictionary;
@synthesize parkIntroduceTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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

- (void) popPreView {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"园区介绍";
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    return 3;
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int num = 1;
    switch (section) {
        case 2:
            num = 4;
            break;
            
        default:
            break;
    }
    return num;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.section) {
        //包括园区名称和LOGO
        case 0:
        {
            CustomImageView *parkLogoView = [[CustomImageView alloc] initWithFrame:CGRectMake(isPad() ? 6 : 3, 3, 48, 48)];
            [parkLogoView.imageView loadImage:[NSString stringWithFormat:@"%@%@", HOST, [dataDictionary objectForKey:@"imagepath"]]];
            [cell.contentView addSubview:parkLogoView];
            [parkLogoView release];
            
            UILabel *parkNameLael = [[UILabel alloc] initWithFrame:CGRectMake(isPad() ? 80 :64, 20, isPad() ? 400 : 200, 21)];
            parkNameLael.backgroundColor = [UIColor clearColor];
            parkNameLael.text = [dataDictionary objectForKey:@"name"];
            parkNameLael.font = [UIFont systemFontOfSize:isPad() ? 18 : 17];
            [cell.contentView addSubview:parkNameLael];
            [parkNameLael release];
            
            break;
        }
        //园区介绍
        case 1:
        {
            CGFloat textWidth = isPad() ? 679 : 300;
            NSString *str = [dataDictionary  objectForKey:@"introduce"];
            UITextView *signatureTextView = [[UITextView alloc] initWithFrame:CGRectMake(isPad() ? 8 : 4, 12, textWidth, [self heightForTextView:str])];
            signatureTextView.text = str;
            signatureTextView.font = [self getTextFont];
            signatureTextView.editable = NO;
            signatureTextView.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:signatureTextView];
            [signatureTextView release];
            break;
        }
        //园区环境、政策、Q/A、企业家
        case 2:
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            NSArray *imageNameArray = [[NSArray alloc] initWithObjects:@"environment.png", @"financpolicy.png", @"QA.png", @"allmanager.png", nil];
            NSArray *array = [[NSArray alloc] initWithObjects:@"园区环境", @"园区政策", @"园区招商Q/A", @"园区企业家", nil];
                        
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(isPad() ? 20 : 10, 8, 28, 28)];
            imageView.image = [UIImage imageNamed:[imageNameArray objectAtIndex:indexPath.row]];
            [cell.contentView addSubview:imageView];
            [imageView release];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(isPad() ? 84 : 54, 12, 200, 21)];
            label.backgroundColor = [UIColor clearColor];
            label.text = [array objectAtIndex:indexPath.row];
            [cell.contentView addSubview:label];
            [label release];
            
            [array release];
            [imageNameArray release];
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
    return (section == 1) ? @"园区介绍" : nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 44.0f;
    switch (indexPath.section) {
        case 0:
        {
            height = 60.0f;
            break;
        }
        case 1:
        {
            NSString *str = [dataDictionary  objectForKey:@"introduce"];
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
        NSString *parkNo = [dataDictionary objectForKey:@"no"];
        switch (indexPath.row) {
            case 0:
            {
                PBParkEnvironmentViewController *envirController = [[PBParkEnvironmentViewController alloc] init];
                envirController.parkNoString = parkNo;
                [self.navigationController pushViewController:envirController animated:YES];
                [envirController release];
                break;
            }
            case 1:
            {
                PBIndustrialPolicyViewController *policyController = [[PBIndustrialPolicyViewController alloc] init];
                policyController.parkNoString = parkNo;
                [self.navigationController pushViewController:policyController animated:YES];
                [policyController release];
                break;
            }
            case 2:
            {
                PBParkQAViewController *qaController = [[PBParkQAViewController alloc] initWithNibName:isPad()?@"PBParkQAViewController_pad":@"PBParkQAViewController" bundle:nil];
                qaController.parkNoString = parkNo;
                [self.navigationController pushViewController:qaController animated:YES];
                [qaController release];
                break;
            }
            case 3:
            {
                PBParkCompanysController *pcController = [[PBParkCompanysController alloc] init];
                pcController.parkNoString = parkNo;
                [self.navigationController pushViewController:pcController animated:YES];
                [pcController release];
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

- (void) dealloc {
    [dataDictionary release];
    [parkIntroduceTableView release];
    [super dealloc];
}

- (void) viewDidUnload
{
    [self setDataDictionary:nil];
    [self setParkIntroduceTableView:nil];
    [super viewDidUnload];
}

@end
