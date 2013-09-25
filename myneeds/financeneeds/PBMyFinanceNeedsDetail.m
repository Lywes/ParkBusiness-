//
//  PBMyFinanceNeedsDetail.m
//  ParkBusiness
//
//  Created by 上海 on 13-7-14.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBMyFinanceNeedsDetail.h"
#import "PBMyFinanceNeedsFeedBack.h"
#define URL [NSString stringWithFormat:@"%@admin/index/searchmyneedsfeedback", HOST]
@interface PBMyFinanceNeedsDetail ()

@end

@implementation PBMyFinanceNeedsDetail
@synthesize dicData;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(7, 7, 25, 30);
        [btn addTarget:self action:@selector(backHomeView) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = barButton;
    }
    return self;
}

-(void)backHomeView{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
//    for (id key in dicData) {
//        if (![dicData objectForKey:key]) {
//            [dicData setObject:@"" forKey:key];
//        }
//    }
    titleArr = [[NSArray alloc]initWithObjects:@"资金需求(万元):",@"所在行业:",@"年销售额(万元):",@"融资困难原因:",@"融资周期:",@"年利率范围(%):",@"资金用途:", nil];
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-KNavigationBarHeight) style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_background"]];
    [self initTitleView];
    [self.view addSubview:tableView];
}
-(void)initTitleView{
    labelArr = [NSMutableArray new];
    for (int i = 0; i<[titleArr count]; i++) {
        UILabel* label = [[UILabel alloc]init];
        label.text = [titleArr objectAtIndex:i];
        label.backgroundColor = [UIColor clearColor];
//        label.textColor = [UIColor blueColor];
        UIFont* font = [UIFont systemFontOfSize:isPad()?16:14];
        label.font = font;
        CGRect frame = CGRectZero;
        if (i!=3&&i!=6) {
            CGSize textSize = [[titleArr objectAtIndex:i] sizeWithFont:[UIFont boldSystemFontOfSize:16]];
            frame = CGRectMake(130, 5, tableView.frame.size.width-textSize.width-(isPad()?120:50), 35);
        }else{
            frame = CGRectMake(0, 0, tableView.frame.size.width-20, 35);
            label.numberOfLines = 0;
        }
        
        label.frame = frame;
        switch (i) {
            case 0:
                label.text = [PBKbnMasterModel getKbnNameById:[[dicData objectForKey:@"fundneed"] intValue] withKind:@"fund"];
                break;
            case 1:
            {
                label.text = [dicData objectForKey:@"trade"];
            }
                break;
            case 2:
            {
                 label.text = [dicData objectForKey:@"yearsale"];
            }
                break;
            case 3:
            {
                label.text = [dicData objectForKey:@"difficulty"];
                frame.origin.x = 2;
                frame.size.height = [self HeightAStr:[dicData objectForKey:@"difficulty"]];
                label.frame = frame;
            }
                break;
            case 4:
            {
                label.text = [dicData objectForKey:@"period"];
               
            }
                break;
            case 5:
            {
                label.text = [dicData objectForKey:@"raterange"];
            }
                break;
            case 6:{
                label.text = [dicData objectForKey:@"fundused"];
                frame.origin.x = 5;
                frame.size.width = tableView.frame.size.width-40;
                frame.size.height = [self HeightAStr:[dicData objectForKey:@"fundused"]];
                label.frame = frame;
            }
                
                break;
                
            default:
                break;
        }
        [labelArr addObject:label];
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==3) {
        return [self HeightAStr:[dicData objectForKey:@"difficulty"]];
    }
    if (indexPath.section==6) {
        return [self HeightAStr:[dicData objectForKey:@"fundused"]];
    }
    return 44.0f;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [titleArr count]+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

    if (indexPath.section<titleArr.count) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section!=3&&indexPath.section!=6) {
            cell.textLabel.text = [titleArr objectAtIndex:indexPath.section];
        }
        UILabel* label = (UILabel*)[labelArr objectAtIndex:indexPath.section];
        [cell.contentView addSubview:label];
    }else{
        cell.textLabel.text = @"点击查看需求反馈";
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = [UIColor blueColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    // Configure the cell...
    
    return cell;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 3||section==6) {
        return [titleArr objectAtIndex:section];
    }
    return nil;
}
-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==titleArr.count) {
        [_tableView deselectRowAtIndexPath:indexPath animated:YES];
        PBMyFinanceNeedsFeedBack* feedback = [[PBMyFinanceNeedsFeedBack alloc]initWithStyle:UITableViewStyleGrouped];
        feedback.type = @"1";
        feedback.feedbackno = [dicData objectForKey:@"no"];
        [self.navigationController pushViewController:feedback animated:YES];
    }
}
-(CGFloat)HeightAStr:(NSString *)str
{
    UIFont *font = [UIFont systemFontOfSize:isPad()?16:14];
    CGSize tag = [str sizeWithFont:font constrainedToSize:CGSizeMake(self.view.frame.size.width-30, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    return MAX(35.0f, tag.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
