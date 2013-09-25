//
//  PBBusinessPlanText.m
//  ParkBusiness
//
//  Created by lywes lee on 13-4-22.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBBusinessPlanText.h"
#import "PBUserModel.h"
#import "PBProjectData.h"
#import "UIImageView+WebCache.h"
#import "MyProject.h"
#import "NSObject+NAV.h"
@implementation PBBusinessPlanText
@synthesize businesstextarry;

-(void)viewDidLoad{
    [super viewDidLoad];
}
-(void)initdata
{   
    //data
    self.businesstextarry = [[[NSMutableArray alloc]init]autorelease];
    [self toGetTheData];
}
-(void)toGetTheData
{
    [activity startAnimating];
    PBdataClass *pbdataclass1 = [[PBdataClass alloc]init];
    pbdataclass1.delegate = self;
    
    [pbdataclass1 dataResponse:[NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/searchmybusinessplan",HOST]] postDic:[NSDictionary dictionaryWithObjectsAndKeys:USERNO,@"invsetno", nil] searchOrSave:YES];
}
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{
    NSLog(@"商业计划书:%@",datas);
    [activity stopAnimating];
    self.businesstextarry = datas;
    [self.tableview reloadData];
}
-(void)searchFilad{
    [activity stopAnimating];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.businesstextarry count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
    }
    
    while ([cell.contentView.subviews lastObject] != nil) {
        [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    
    
    UIImageView *imageview;
    UIImageView *timeimage;
    UILabel *name;
    UILabel *time;
    if (isPad()) {
        name  = [[[UILabel alloc]initWithFrame:CGRectMake(50, 0, 100, 44)]autorelease];
        time  = [[[UILabel alloc]initWithFrame:CGRectMake(400, 0, 150, 44)]autorelease];
        timeimage = [[[UIImageView alloc]initWithFrame:CGRectMake(370, 9, 21, 21)]autorelease];
        name.font = [UIFont systemFontOfSize:PadContentFontSize];
        time.font = [UIFont systemFontOfSize:PadContentFontSize];
    }
    else {
        name  = [[[UILabel alloc]initWithFrame:CGRectMake(40, 0, 90, 44)]autorelease];
        time  = [[[UILabel alloc]initWithFrame:CGRectMake(160, 0, 80, 44)]autorelease];
        timeimage = [[[UIImageView alloc]initWithFrame:CGRectMake(140, 9, 21, 21)]autorelease];
        name.font = [UIFont systemFontOfSize:ContentFontSize];
        time.font = [UIFont systemFontOfSize:ContentFontSize];
    }
    imageview = [[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 32, 32)]autorelease];
    NSString *imagepath = [NSString stringWithFormat:@"%@%@",HOST,[[self.businesstextarry objectAtIndex:indexPath.row] objectForKey:@"imagepath"]];
    [imageview setImageWithURL:[NSURL URLWithString:imagepath]];
    [cell.contentView addSubview:imageview];
    name.text = [[self.businesstextarry objectAtIndex:indexPath.row] objectForKey:@"projectname"];
    time.text = [[self.businesstextarry objectAtIndex:indexPath.row] objectForKey:@"sendtime"];
    timeimage.image = [UIImage imageNamed:@"time.png"];
    imageview.layer.shadowRadius = 5.0f;
    imageview.layer.masksToBounds = YES;
    imageview.layer.cornerRadius = 5.0f;
    name.backgroundColor = [UIColor clearColor];
    time.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:name];
    [cell.contentView addSubview:time];
    [cell.contentView addSubview:timeimage];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyProject *controller = [[MyProject alloc] init];
    controller.dic = [self.businesstextarry objectAtIndex:indexPath.row];
    controller.ProjectStyle = ELSEPROJECTINFO;
    
    [self customButtom:controller];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

@end
