//
//  PBAddLicaiInfo.m
//  ParkBusiness
//
//  Created by 上海 on 13-9-5.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBAddLicaiInfo.h"
#define SAVEURL [NSString stringWithFormat:@"%@/admin/index/addlicaiinfo",HOST]
@interface PBAddLicaiInfo ()

@end

@implementation PBAddLicaiInfo

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewLoding
{
    NSArray* arr = [[NSArray alloc]initWithObjects:@"financename",@"earor",@"timeperiod",@"money",@"others", nil];
    self.userinfos = [[NSMutableDictionary alloc]init];
    for (NSString* key in arr) {
        [self.userinfos setObject:@"" forKey:key];
    }
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    acitivity = [[PBActivityIndicatorView alloc]initWithFrame:self.view.frame];
    titleArr = [[NSMutableArray alloc]initWithObjects:@"理财产品名称:",@"年回报率:",NSLocalizedString(@"_tb_sjzq", nil),@"金额(万元):",@"其他事项:",nil];
    timeperiod = [[NSMutableArray alloc]init];
    NSMutableArray *arry = [PBIndustryData search:@"timeperiod"];
    for (PBIndustryData * industryData in arry ) {
        if (industryData.name != NULL) {
            [timeperiod addObject:industryData.name];
        }
    }
}
-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [money resignFirstResponder];
    [others resignFirstResponder];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initPopView];
	// Do any additional setup after loading the view.
}
-(void)initPopView
{
    //弹出选择画面
    pop =[[POPView alloc]init];
    pop.delegate = self;
    pop.view.hidden = YES;
    [self.view addSubview:pop.view];
}
- (void)viewWillAppear:(BOOL)animated
{
    if ([self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
        PBUserModel* user = [PBUserModel getPasswordAndKind];
        if (user.kind!=2&&[self.datadic objectForKey:@"flag"]) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"nav_btn_sc", nil) style:UIBarButtonItemStylePlain target:self action:@selector(collectProject)];
            if ([[self.datadic objectForKey:@"flag"] isEqualToString:@"1"]) {
                //从后台获取数据，是否收藏该项目，若已经收藏则为“已收藏”，button不可用。否则收藏按钮可用
                self.navigationItem.rightBarButtonItem.title = @"已收藏";
                self.navigationItem.rightBarButtonItem.enabled = NO;
            }
        }
//        [super SearchOnServer];
    }else{//本地取数据
        if (!willAppear) {
            isedit = NO;
            [self.userinfos setObject:[self.datadic objectForKey:@"name"] forKey:@"financename"];
            [self.userinfos setObject:[self.datadic objectForKey:@"earor"] forKey:@"earor"];
            willAppear = !willAppear;
        }
    }
    [self initInputView];
    [self.tableView reloadData];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UITableViewCell *cell = (UITableViewCell *)[[textField superview]superview];
    CGRect frame = cell.frame;
    int offset = frame.origin.y - (self.view.frame.size.height-KNavigationBarHeight - 216.0);//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float heights = self.view.frame.size.height;
    if(offset > 0)
    {
        offset = offset>216?216:offset;
        CGRect rect = CGRectMake(0.0f, -offset,width,heights);
        self.view.frame = rect;
    }
    [UIView commitAnimations];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    
}
-(void)initInputView{
    for (int i = 0; i<[titleArr count]; i++){
        CGSize textSize = [[titleArr objectAtIndex:i] sizeWithFont:[UIFont boldSystemFontOfSize:16]];
        CGRect frame = CGRectMake(textSize.width+20, 2, self.tableView.frame.size.width-textSize.width-(isPad()?120:50), 35);
        if (i == 0) {
            financename = [[UILabel alloc]initWithFrame:frame];
            financename.text = [self.userinfos objectForKey:@"financename"];
        }
        if (i == 1) {
            earor = [[UILabel alloc]initWithFrame:frame];
            earor.text = [self.userinfos objectForKey:@"earor"];
        }
        if (i == 2) {
            timeperiodLabel = [[UILabel alloc]initWithFrame:frame];
            timeperiodLabel.font = [UIFont systemFontOfSize:16];
            timeperiodLabel.text = @"请选择时间周期";
            //[self.userinfos objectForKey:@"timeperiod"]
        }
        if (i == 3) {
            money = [[UITextField alloc]initWithFrame:frame];
            money.placeholder = @"请输入金额";
            money.delegate = self;
        }
        if (i == 4) {
            others = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width-(isPad()?90:20), 120)];
            others.tag = 5;
            others.backgroundColor = [UIColor clearColor];
            others.textAlignment = UITextAlignmentLeft;
            others.delegate = self;
            others.text = [self.userinfos objectForKey:@"others"];
        }
    }
    
}
#pragma mark - cell内容设置
-(void)addSubViewForCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section<4) {
        cell.textLabel.text = [titleArr objectAtIndex:indexPath.section];
    }
    if (indexPath.section == 0) {
        [[cell contentView] addSubview:financename];
    }
    if (indexPath.section == 1) {
        [[cell contentView] addSubview:earor];
    }
    if (indexPath.section == 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [[cell contentView] addSubview:timeperiodLabel];
        
    }
    if (indexPath.section == 3) {
        [[cell contentView] addSubview:money];
        
    }
    if (indexPath.section == 4) {
        [[cell contentView] addSubview:others];
        others.editable = !isedit;
        
    }
    for (UITextField* textField in [[cell contentView] subviews]) {
        if ([textField isKindOfClass:[UITextField class]]) {
            [textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            [textField setEnabled:!isedit];
            [textField setBorderStyle:UITextBorderStyleNone];
        }
    }
    if (!isedit) {
        [money setBorderStyle:UITextBorderStyleRoundedRect];
        money.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        [pop.view removeFromSuperview];
        pop._arry = timeperiod;
        pop.name = NSLocalizedString(@"_tb_sjzq", nil);
        pop.view.hidden = !pop.view.hidden;
        [pop popClickAction];
    }
}
#pragma mark -POPview delegate
- (void)popView:(POPView *)popview didSelectIndexPath:(NSIndexPath *)indexPath{
    if ([pop._arry isEqualToArray:timeperiod]) {
        timeperiodLabel.text = [popview._arry objectAtIndex:indexPath.row];
    }
}
-(void)postOtherData
{
    //    [self changePostDataFromView];
    PBdataClass *pb = [[PBdataClass alloc]init];
    pb.delegate = self;
    NSString* timeperiods = [NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:timeperiodLabel.text withKind:@"timeperiod"]];
    NSArray *a1 = [[NSArray alloc]initWithObjects:@"mode",@"no",@"userno",@"financeno",@"timeperiod",@"money",@"others",nil];
    NSArray *a2 = [[NSArray alloc]initWithObjects:@"add",
                   @"-1",
                   USERNO,
                   [self.datadic objectForKey:@"no"],
                   timeperiods,
                   money.text?money.text:@"",
                   others.text?others.text:@"",
                   nil];
    [pb dataResponse:[NSURL URLWithString:SAVEURL] postDic:[[NSDictionary alloc]initWithObjects:a2 forKeys:a1] searchOrSave:NO];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
