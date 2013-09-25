//
//  PBHightSC.m
//  ParkBusiness
//
//  Created by China on 13-9-3.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define GAODUANKECHEN_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/seniorclass",HOST]]
#import "PBHightSC.h"
#import "NSObject+NAV.h"
#import "PBHighCourseDetail.h"
@interface PBHightSC ()

@end

@implementation PBHightSC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(void)initdata
{
    [self toGetTheData];
}
-(void)toGetTheData
{
    [activity startAnimating];
    PBdataClass *dc = [[PBdataClass alloc]init];
    dc.delegate = self;
    self.dataclass = dc;
    [dc release];
    NSDictionary *dic= [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageno],@"pageno",USERNO,@"userno",@"1",@"flag", nil];
    [self.dataclass dataResponse:GAODUANKECHEN_URL postDic:dic searchOrSave:YES];
    [dic release];

}
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{
    self._arr = datas;
    NSLog(@"高端课程收藏:%@",self._arr);
    [activity stopAnimating];
    [self.tableview reloadData];
    
}
-(void)searchFilad
{
    [activity stopAnimating];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self._arr.count>0) {
        return self._arr.count;
    }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
    }
    if (self._arr.count>0) {
        NSDictionary *dic = [self._arr objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageNamed:@"hightcourse.png"];
        cell.textLabel.text = [dic objectForKey:@"name"];
        cell.detailTextLabel.text = [dic objectForKey:@"jgname"];
        cell.textLabel.highlightedTextColor = [UIColor blackColor];
        cell.detailTextLabel.highlightedTextColor = [UIColor blackColor];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PBHighCourseDetail *detail = [[PBHighCourseDetail alloc]initWithStyle:UITableViewStyleGrouped];
    detail.DataDic = [self._arr objectAtIndex:indexPath.row];
    [self customButtom:detail];
    [self.navigationController pushViewController:detail animated:YES];
    [detail release];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
