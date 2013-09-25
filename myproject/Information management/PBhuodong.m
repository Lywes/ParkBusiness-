//
//  PBhuodong.m
//  ParkBusiness
//
//  Created by lywes lee on 13-3-6.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBhuodong.h"
#import "PBUserModel.h"
@interface PBhuodong ()
-(void)toGetTheData;
@end
@implementation PBhuodong
@synthesize huodong_arry;
-(void)dealloc
{
    [self.huodong_arry=nil release];
    [super dealloc];
}
-(void)viewDidLoad{
    [super viewDidLoad];
}
-(void)initdata
{   
    //data
    self.huodong_arry = [[[NSMutableArray alloc]init]autorelease];
    [self toGetTheData];
}
-(void)toGetTheData
{
    [activity startAnimating];
    PBdataClass *pbdataclass1 = [[PBdataClass alloc]init];
    pbdataclass1.delegate = self;
    [pbdataclass1 dataResponse:[NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/searchmeeting",HOST]] postDic:[NSDictionary dictionaryWithObjectsAndKeys:USERNO,@"user", nil] searchOrSave:YES];
}
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{
    NSLog(@"我参加的活动:%@",datas);
     [activity stopAnimating];
    self.huodong_arry = datas;
    [self.tableview reloadData];
}
-(void)searchFilad{
     [activity stopAnimating];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.huodong_arry count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier]autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
    }
    UILabel*name;
    UILabel *time;
    if (isPad()) {
        name = [[[UILabel alloc]initWithFrame:CGRectMake(50, 0, 300, 44)]autorelease];
        time = [[[UILabel alloc]initWithFrame:CGRectMake(500, 0, 80, 44)]autorelease];
        name.font = [UIFont systemFontOfSize:PadContentFontSize];
        time.font = [UIFont systemFontOfSize:PadContentFontSize];
    }
    else {
        name = [[[UILabel alloc]initWithFrame:CGRectMake(35, 0, 210, 44)]autorelease];
        time = [[[UILabel alloc]initWithFrame:CGRectMake(320-70, 0, 65, 44)]autorelease];
        name.font = [UIFont systemFontOfSize:ContentFontSize];
        time.font = [UIFont systemFontOfSize:ContentFontSize];
    }
    time.backgroundColor = [UIColor clearColor];
    name.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:time];
    [cell.contentView addSubview:name];
    cell.imageView.image = [UIImage imageNamed:@"hdcell.png"];
    name.text = [[self.huodong_arry objectAtIndex:indexPath.row]objectForKey:@"name"];
    time.text = [[self.huodong_arry objectAtIndex:indexPath.row]objectForKey:@"enddate"];
    NSDateFormatter *formatter = [[[NSDateFormatter alloc]init]autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:time.text];
    NSDate * equeldate = [date earlierDate:[NSDate date]];
    if (![date isEqualToDate:equeldate]) {
        cell.imageView.image = [UIImage imageNamed:@"hdcelling.png"];
    }
    return cell;
}

@end
