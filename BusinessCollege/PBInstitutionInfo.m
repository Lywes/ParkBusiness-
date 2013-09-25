//
//  PBInstitutionInfo.m
//  ParkBusiness
//
//  Created by China on 13-7-2.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define JIGOUJIANJIE_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/seniorclassorgan",HOST]]
#import "PBInstitutionInfo.h"
#import "UIImageView+WebCache.h"
#import "NSObject+PBLableHeight.h"
@interface PBInstitutionInfo ()
@end

@implementation PBInstitutionInfo

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"机构简介";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    PBActivityIndicatorView *ac =[[PBActivityIndicatorView alloc] initWithFrame:self.view.frame];
    self.activity = ac;
    [ac release];
    [self.view addSubview:self.activity];
    [self initdata];
	NSArray *s1 = [[NSArray alloc]initWithObjects:@"地点",NSLocalizedString(@"_tb_zxdh", nil),@"机构主页", nil];
    NSArray *s2 = [[NSArray alloc]initWithObjects:@"机构简介", nil];
    self.headArr = [[[NSMutableArray alloc]initWithObjects:s1,s2, nil]autorelease];
    [s1 release];
    [s2 release];
    
}
#pragma mark - 网络请求数据
-(void)initdata
{
    [self.activity startAnimating];
    PBdataClass *dataclass = [[PBdataClass alloc]init];
    dataclass.delegate = self;
    self.dataclass = dataclass;
    [dataclass release];
    NSDictionary *dic= [[NSDictionary alloc]initWithObjectsAndKeys:[self.DataDic objectForKey:@"userno"],@"userno", nil];
    [self.dataclass dataResponse:JIGOUJIANJIE_URL postDic:dic searchOrSave:YES];
    [dic release];
}
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{
    NSLog(@"机构简介:%@",datas);
    self.DataDic = [datas objectAtIndex:0];
    NSArray *a0 = [[NSArray alloc]initWithObjects:[self.DataDic objectForKey:@"name"],nil];
    
    NSArray *a1 = [[NSArray alloc]initWithObjects:[self.DataDic objectForKey:@"address"],
                   [self.DataDic objectForKey:@"tel"],
                   [self.DataDic objectForKey:@"homeurl"],
                   nil];
    NSArray *a2 = [[NSArray alloc]initWithObjects:[self.DataDic objectForKey:@"introduce"],nil];

    NSMutableArray *arry = [[NSMutableArray alloc]initWithObjects:a0,a1,a2, nil];
    self.DataArr = arry;
    [arry release];
    [a0 release];
    [a1 release];
    [a2 release];
    [self.tableView reloadData];
    [self.activity stopAnimating];

}

-(void)searchFilad
{
    [self showAlertViewWithMessage:@"网络状况不好"];
     [self.activity stopAnimating];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier]autorelease];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;        
        if (indexPath.section == 1) {
            cell.textLabel.text = [[self.headArr objectAtIndex:indexPath.section - 1] objectAtIndex:indexPath.row];
        }
        if (indexPath.section != 2) {
            UILabel *detailTextLabel;
            detailTextLabel = [[UILabel alloc]init];
            detailTextLabel.backgroundColor = [UIColor clearColor];
            detailTextLabel.numberOfLines = 0;
            detailTextLabel.tag = 100;
            [cell.contentView addSubview:detailTextLabel];
            [detailTextLabel release];
        }
    }
    
    
    UILabel *detailTextLabel = (UILabel *)[cell.contentView viewWithTag:100];
    detailTextLabel.text = [[self.DataArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    CGSize a = [detailTextLabel.text sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(isPad() ? 480 : 100, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    [detailTextLabel setFrame:CGRectMake(isPad()?250:120, 0, isPad()?350:180, MAX(a.height, 44))];

    if (self.DataDic) {
        if (indexPath.section == 0) {            
            UIImageView * imageview = [[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 32, 32)]autorelease];
            NSString *imagepath = [NSString stringWithFormat:@"%@%@",HOST,[self.DataDic objectForKey:@"imagepath"]];
            [imageview setImageWithURL:[NSURL URLWithString:imagepath]];
            imageview.layer.shadowRadius = 5.0f;
            imageview.layer.masksToBounds = YES;
            imageview.layer.cornerRadius = 5.0f;
            [cell.contentView addSubview:imageview];
            
        }
         else if (indexPath.section == 2)
        {
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.text  = [self.DataDic objectForKey:@"introduce"];
        }
    }


    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = 0;
    switch (section) {
        case 0:
            num = 1;
            break;
        case 1:
            num = 3;
            break;
        case 2:
            num = 1;
            break;
        default:
            break;
    }
    return num;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
      return  MAX([self HeightAStr:[self.DataDic objectForKey:@"introduce"]] , 44);
    }
    else
    {
        NSString *str = [[self.DataArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        CGSize a = [str sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(isPad() ? 480 : 100, 1000) lineBreakMode:NSLineBreakByWordWrapping];
        return MAX(a.height, 44.0f);
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
