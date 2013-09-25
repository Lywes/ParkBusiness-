//
//  PBsixin.m
//  ParkBusiness
//
//  Created by lywes lee on 13-3-6.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBsixin.h"
#import "PBUserModel.h"
#import "PBsixinVC.h"
#import "NSObject+NAV.h"
@interface PBsixin ()
@end
@implementation PBsixin
@synthesize sixin_did;
@synthesize sixin_dis,sixin_didpost,_arry,dataOfSixin;

static int btnTag = 20;
-(void)dealloc
{
    [self.dataOfSixin= nil release];
    [sixin_didpost=nil release];
    [self.tableview =nil release];
    [self.sixin_did=nil release];
    [self.sixin_dis=nil release];
    [self._arry=nil release];
    [super dealloc];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    //button
    NSArray *text = [NSArray arrayWithObjects:@"未阅读",@"已阅读",@"发信箱", nil];
    [self initTopViewNumBtn:3 BtnNameArr:text];
    //arry
    self.sixin_dis = [[[NSMutableArray alloc]init]autorelease];
    self.sixin_did = [[[NSMutableArray alloc]init]autorelease];
    self.sixin_didpost = [[[NSMutableArray alloc]init]autorelease];
    self._arry = [[[NSMutableArray alloc]init]autorelease];
    isselect = NO;
    wantChange = NO;
}
-(BOOL)TopViewHidden{
    return NO; //default return YES
}
-(void)initdata
{

    [self toGetTheData];
    
    
}

-(void)toGetTheData{
    [activity startAnimating];
    inbox = [[PBdataClass alloc]init];
    inbox.delegate = self;
    NSString *userid = USERNO;
    [inbox dataResponse:[NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/searchmessage",HOST]] postDic:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageno],@"pageno",@"1",@"flag",userid,@"userno", nil] searchOrSave:YES];
    outbox = [[PBdataClass alloc]init];
    outbox.delegate = self;
    [outbox dataResponse:[NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/searchmessage",HOST]] postDic:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",pageno],@"pageno",@"0",@"flag",userid,@"userno", nil] searchOrSave:YES];
}
#pragma mark - API delegate
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{
    [activity stopAnimating];
    if ([dataclass isEqual: outbox]) {
        [self.sixin_didpost removeAllObjects];
        self.sixin_didpost = datas;
    }
    else
    {
        self.dataOfSixin = datas;
        [self.sixin_did removeAllObjects];
        for (NSMutableDictionary *dic in self.dataOfSixin) {
            if ([[dic objectForKey:@"flag"]  isEqualToString:@"0"]) {
                [self.sixin_dis addObject:dic];
 
            }
            else {
                
                [self.sixin_did addObject:dic];
            }
        }
        [self._arry removeAllObjects];
        [self._arry addObjectsFromArray:self.sixin_dis];
    }
    
    //防止下拉刷新数据问题，可注释测试看看情况。
    UIButton *btn = (UIButton *)[self.view viewWithTag:btnTag];
    [self buttonPress:btn];
    [self.tableview reloadData];
}
-(void)searchFilad
{
    [activity stopAnimating];
}
-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue
{
    [self._arry removeAllObjects];
    [self.sixin_did removeAllObjects];
    [self.sixin_dis removeAllObjects];
    [self.sixin_didpost removeAllObjects];
    [self toGetTheData];
    
}
#pragma mark - buttonPress
-(void)buttonPress:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    btnTag = btn.tag;           //静态变量
    [self BtnImageChange:sender];
    switch (btn.tag) {
        case 20:
            
            if (![self._arry isEqualToArray:self.sixin_dis]) {
                [self._arry removeAllObjects];
                [self._arry addObjectsFromArray:self.sixin_dis];
                [self.tableview reloadData];
            }

            break;
        case 21:
            [self._arry removeAllObjects];
            [self._arry addObjectsFromArray:self.sixin_did];
            [self.tableview reloadData];

            break;
        case 22:
            Tag = 22;
            [self._arry removeAllObjects];
            [self._arry addObjectsFromArray:self.sixin_didpost];
            [self.tableview reloadData];

            break;
        default:
            break;
    }
    if (self._arry.count>=10) {
        self.tableview.tableFooterView.hidden = NO;
    }
    else {
        self.tableview.tableFooterView.hidden = YES;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self._arry count];
      
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
    if ([self._arry count]>0) {
        cell.textLabel.text = [[self._arry objectAtIndex:indexPath.row] objectForKey:@"title"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"姓名:%@        时间:%@",[[self._arry objectAtIndex:indexPath.row] objectForKey:@"ruser"],[[self._arry objectAtIndex:indexPath.row] objectForKey:@"time"]];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 70.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PBsixinVC*  controller = [[PBsixinVC alloc]initWithStyle:UITableViewStyleGrouped];
    controller.sixin = [self._arry objectAtIndex:indexPath.row];
    if ([self.sixin_dis containsObject:controller.sixin]) {
        [self changeFlageOfMessageatIndePath:indexPath];
    }
    [self customButtom:controller];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    //        [self.navigationController pushViewController:pbsixinvc animated:NO];
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}
-(void)changeFlageOfMessageatIndePath:(NSIndexPath *)indexpath
{
    PBdataClass *pbdataclass = [[PBdataClass alloc]init];    
    pbdataclass.delegate = self;    
    [pbdataclass dataResponse:[NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/updatemessageflag",HOST]] postDic:[NSDictionary dictionaryWithObjectsAndKeys:[[self.sixin_dis objectAtIndex:indexpath.row] objectForKey:@"no"],@"no", nil] searchOrSave:NO];
}

@end
