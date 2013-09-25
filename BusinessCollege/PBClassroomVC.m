//
//  PBClassroomVC.m
//  ParkBusiness
//
//  Created by QDS on 13-7-1.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define ZHISHIKETANG_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/knowledgeclasslist",HOST]]
#define HEIGHTCELL     [[[[self.dataArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"] sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(isPad()?480:150, 1000) lineBreakMode:NSLineBreakByCharWrapping];

#import "PBClassroomVC.h"
#import "UIImageView+WebCache.h"
#import "NSObject+CellLine.h"
#import "NSObject+NAV.h"
#import "PBClassRoomDeatil.h"
#import "UITableViewCell+CellShadows.h"
@interface PBClassroomVC ()

@end

@implementation PBClassroomVC
@synthesize zsfb_btn;
-(void)dealloc{
    RB_SAFE_RELEASE(zsfb_btn);
    [super dealloc];
}
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
    [self initRefreshView];//下拉刷新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selector:) name:nil object:nil];
}
#pragma mark – 重新加载页面数据的通知
-(void)selector:(NSNotification *)noti
{
    if ([noti.name isEqualToString:@"收藏"]) {
        [self  initdata];
    }
}
-(void)initSearchBar{}
-(void)initTableView
{
    UITableView *tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-KNavigationBarHeight) style:UITableViewStyleGrouped];
    tab.delegate = self;
    tab.dataSource = self;
    self.tableview = tab;
    self.tableview.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_background"]];
    [self.view addSubview:self.tableview];
    [tab release];
    
    /*  资讯发表按钮 
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self.tableview.frame.size.width - 50, 5, 30, 30);
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    [btn setBackgroundImage:[UIImage imageNamed:@"zixun_publish"] forState:UIControlStateNormal];
//    [btn setTitle:@"资讯发表" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightBarButtonItemPress:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.zsfb_btn = btn;
    [self.view addSubview:self.zsfb_btn];
     *****/
}
-(void)InvestTableview
{
//    self.tableview.backgroundView = nil;
//    self.view.backgroundColor = [UIColor colorWithRed:249/255 green:249/255 blue:249/255 alpha:0.1];
}
-(void)initdata
{
    [ac startAnimating];
    PBdataClass *dataclass = [[PBdataClass alloc]init];
    dataclass.delegate = self;
    self.dataclass = dataclass;
    [dataclass release];
    NSDictionary *dic= [[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageno],@"pageno",USERNO,@"userno", nil];
    [self.dataclass dataResponse:ZHISHIKETANG_URL postDic:dic searchOrSave:YES];
    [dic release];
}
-(void)searchFilad{
    [ac stopAnimating];
}
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{
    NSLog(@"金融资讯：%@",datas);
    if (pageno == 1) {
        [self.dataArr removeAllObjects];
    }
    [ac stopAnimating];
    if (datas.count>0) {
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        NSMutableArray* array = [[NSMutableArray alloc]initWithObjects:[datas objectAtIndex:0], nil];
        if (self.dataArr.count>0) {
            NSMutableArray* lastDayArr = [self.dataArr lastObject];
            NSDictionary* lastDayDic = [lastDayArr objectAtIndex:0];
            NSDictionary *firstDic = [datas objectAtIndex:0];
            if ([[lastDayDic objectForKey:@"cdate"] isEqualToString:[firstDic objectForKey:@"cdate"]]) {
                [array insertObjects:lastDayArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [lastDayArr count])]];
            }
            [self.dataArr removeLastObject];
        }
        for (int i = 0;i<[datas count];i++) {
            NSDictionary *dic = [datas objectAtIndex:i];
            if (![dic isEqualToDictionary:[datas lastObject]]) {
                NSDictionary *dic1 = [datas objectAtIndex:i+1];
                if ([[dic objectForKey:@"cdate"] isEqualToString:[dic1 objectForKey:@"cdate"]]) {
                    [array addObject:dic1];
                }else{
                    [arr addObject:array];
                    array = [[NSMutableArray alloc]init];
                    [array addObject:dic1];

                }
            }
            
            
        }
        [arr addObject:array];
        [array release];
        [self.dataArr addObjectsFromArray:arr];
        [self.tableview reloadData];
        [arr release];
    }



}


#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOWMAINVIEW" object:[[self.dataArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    [cell addShadowToCellInTableView:tableView atIndexPath:indexPath];

    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier]autorelease];

            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImageView *imageview = [[UIImageView alloc]init];
                imageview.tag = 11;
                imageview.layer.masksToBounds = YES;
                [imageview.layer setCornerRadius:7.0f];
                [cell.contentView addSubview:imageview];
                [imageview release];
        });
        
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            UILabel *name = [[UILabel alloc]init];
            name.backgroundColor = [UIColor clearColor];
            name.numberOfLines = 0;
            name.tag = 12;
            if (!isPad()) {
                name.font = [UIFont systemFontOfSize:14];
            }
            [cell.contentView addSubview:name];
            [name release];
        });

       
    }
    
        UIImageView *imageview = (UIImageView *)[cell.contentView viewWithTag:11];
        UILabel *name = (UILabel *)[cell.contentView viewWithTag:12];
    
        CGSize a = CGSizeZero;
        if (self.dataArr.count>0) {
            NSString *str = [[[self.dataArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"imagepath"];
            [imageview setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOST, str]]];
            name.text = [[[self.dataArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"];
            a = HEIGHTCELL;
        }
     
//        if (indexPath.row == 0) {
//            imageview.frame = CGRectMake(0, 0, isPad()?678:300, isPad()?678*150/300:150);
//            name.backgroundColor = [UIColor blackColor];
//            name.frame = CGRectMake(0, isPad()?678*150/300-35:150-35, isPad()?678:300, 35);
//            name.textColor = [UIColor whiteColor];
//            name.text = [NSString stringWithFormat:@"  %@",name.text];
//            name.alpha = 0.8f;
//        }
//        else
//        {
            CGFloat b = isPad()?60:44;
            imageview.frame =  CGRectMake((isPad()?678:300)-b, 0, b, b);
            name.frame = CGRectMake(8, 0, isPad()?600:240,b);
            name.textColor = [UIColor blackColor];
            name.alpha = 1;
//        }
  
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.row == 0) {
//        return isPad()?678*150/300:150;
//    }
//    else
//    {
        if (self.dataArr.count>0) {
//            CGSize a = HEIGHTCELL;
            return isPad()?60:44;
        }
        else
            return 44.0f;
//    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [self.dataArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[self.dataArr objectAtIndex:section] count];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[[UIView alloc]init]autorelease];
    NSString *str = [[[self.dataArr objectAtIndex:section] objectAtIndex:0] objectForKey:@"cdate"];
    CGSize a =  [str sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(480, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-(a.width+20)/2, 0, a.width+20, 30)];
    imageview.image = [[UIImage imageNamed:@"sharemore_fromapp"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    [view addSubview:imageview];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-(a.width+20)/2, 0, a.width+20, 30)];
    [view addSubview:lable];
    lable.text = str;
    lable.backgroundColor = [UIColor clearColor];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor whiteColor];
    [imageview release];
    [lable release];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
