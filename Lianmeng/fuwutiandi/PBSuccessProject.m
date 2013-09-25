//
//  PBSuccessProject.m
//  ParkBusiness
//
//  Created by 上海 on 13-5-14.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBSuccessProject.h"
#import "PBKbnMasterModel.h"
@interface PBSuccessProject ()

@end

@implementation PBSuccessProject
@synthesize cellTitleArr;
@synthesize section2;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"_tb_alxq", nil);
        [self backUpView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    cellTitleArr = [[NSMutableArray alloc]initWithObjects:@"行业",@"融资额度",@"融资单位",@"银行贷款",@"出让股权比例",@"其他", nil];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 3;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.section2 = [NSMutableArray arrayWithObjects:
                     [PBKbnMasterModel getKbnNameById:[[self.DataDic objectForKey:@"trade"] intValue] withKind:@"industry"],
                     [self.DataDic objectForKey:@"financingamount"],
                     [PBKbnMasterModel getKbnNameById:[[self.DataDic objectForKey:@"amountunit"] intValue] withKind:@"unit"],
                     [self.DataDic objectForKey:@"bankloan"],
                     [PBKbnMasterModel getKbnNameById:[[self.DataDic objectForKey:@"rate"] intValue] withKind:@"rate"],
                     [self.DataDic objectForKey:@"others"],
                      nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 2) {
        return 6;
    }
    else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.section) {
        case 0:
        {
            UIImage *image = [UIImage imageNamed:@"avatarslogo.png"];
            UIImageView *imageview = [[UIImageView alloc]initWithImage:image];
            imageview.frame = CGRectMake(130, 7, image.size.width, image.size.height);
            [cell.contentView addSubview:imageview];
            
            UIImage *image1 = [UIImage imageNamed:@"time"];
            UIImageView *imageview1 = [[UIImageView alloc]initWithImage:image1];
            imageview1.frame = CGRectMake(130, image.size.height + 20, image.size.width, image.size.height);
            [cell.contentView addSubview:imageview1];
            
            UILabel *proname;
            UILabel *time;
            if (isPad()) {
                proname = [[UILabel alloc]initWithFrame:CGRectMake(250, 5, 250, 30)];
                time = [[UILabel alloc]initWithFrame:CGRectMake(250, 40, 250, 30)];
                proname.font = [UIFont systemFontOfSize:PadContentFontSize];
                time.font = [UIFont systemFontOfSize:PadContentFontSize];
            }
            else {
                proname = [[UILabel alloc]initWithFrame:CGRectMake(100, 5, 150, 30)];
                time = [[UILabel alloc]initWithFrame:CGRectMake(100, 40, 150, 30)];
                proname.font = [UIFont systemFontOfSize:ContentFontSize];
                time.font = [UIFont systemFontOfSize:ContentFontSize];
            }
            proname.backgroundColor = [UIColor clearColor];
            time.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:time];
            [cell.contentView addSubview:proname];
            time.text = [self.DataDic objectForKey:@"stdate"];
            proname.text = [self.DataDic objectForKey:@"proname"];

        }
            break;
        case 1:
        {
            UITextView *textview = [self addtextview];
            [cell.contentView addSubview:textview];
            textview.text = [self.DataDic objectForKey:@"introduce"];
        }
             break;
        case 2:
        {
            cell.textLabel.text = [cellTitleArr objectAtIndex:indexPath.row];
            UILabel *lable = [self addshortLable];
            lable.tag = 320;
            lable.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:lable];
            lable.text = [self.section2 objectAtIndex:indexPath.row];
        }
             break;
        default:
            break;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            
            return 80;
            
        default:
            return 44;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 1:
        {
            NSString *str = @"介绍";
            return str;
        }
        default:
            return nil;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
