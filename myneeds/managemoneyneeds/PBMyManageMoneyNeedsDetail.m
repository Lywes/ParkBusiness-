//
//  PBMyManageMoneyNeedsDetail.m
//  ParkBusiness
//
//  Created by 上海 on 13-7-18.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBMyManageMoneyNeedsDetail.h"
#import "PBMyFinanceNeedsFeedBack.h"
#define URL [NSString stringWithFormat:@"%@admin/index/searchmyneedsfeedback", HOST]
@interface PBMyManageMoneyNeedsDetail ()

@end

@implementation PBMyManageMoneyNeedsDetail
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
        labelArr = [NSMutableArray new];
    }
    return self;
}
-(void)backHomeView{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-KNavigationBarHeight)style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_background"]];
    [self initTitleView];
    
//	// Do any additional setup after loading the view.
}
-(void)initTitleView{
    allData = [[NSArray alloc]initWithObjects:NSLocalizedString(@"_tb_lclx", nil),NSLocalizedString(@"_tb_kyzj", nil),NSLocalizedString(@"_tb_qwnhbl", nil),NSLocalizedString(@"_tb_sjzq", nil), nil];
    for (int i = 0; i<[allData count]; i++) {
        UILabel* label = [[UILabel alloc]init];
        label.text = [allData objectAtIndex:i];
        label.backgroundColor = [UIColor clearColor];
        UIFont* font = [UIFont systemFontOfSize:14];
        label.font = font;
//        label.textColor = [UIColor blueColor];
        CGSize textSize = [[allData objectAtIndex:i] sizeWithFont:[UIFont boldSystemFontOfSize:16]];
        label.frame = CGRectMake(130, 5, tableView.frame.size.width-textSize.width-50, 35);
        switch (i) {
            case 0:
                label.text = [dicData objectForKey:@"type"];
                break;
            case 1:
                label.text = [NSString stringWithFormat:@"%@ 万元",[dicData objectForKey:@"availablefund"]];
                break;
            case 2:
            {
                label.text = [dicData objectForKey:@"expectreturn"];
                label.numberOfLines = 0;
            }
                break;
            case 3:
            {
                label.text = [dicData objectForKey:@"timeperiod"];
            }
                break;
            default:
                break;
        }
        [labelArr addObject:label];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0f;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [allData count]+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    if (indexPath.section<allData.count) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.textLabel.text = [allData objectAtIndex:indexPath.section];
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
-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==allData.count) {
        [_tableView deselectRowAtIndexPath:indexPath animated:YES];
        PBMyFinanceNeedsFeedBack* feedback = [[PBMyFinanceNeedsFeedBack alloc]initWithStyle:UITableViewStyleGrouped];
        feedback.type = @"2";
        feedback.feedbackno = [dicData objectForKey:@"no"];
        [self.navigationController pushViewController:feedback animated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
