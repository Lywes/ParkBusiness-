//
//  PBAddFinanceData.m
//  ParkBusiness
//
//  Created by 上海 on 13-5-22.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBAddFinanceData.h"
#define URL [NSString stringWithFormat:@"%@/admin/index/searchfinancingleaseaccount",HOST]
#define SAVEURL [NSString stringWithFormat:@"%@/admin/index/addfinancingleaseaccount",HOST]
@interface PBAddFinanceData ()
-(void)postOtherData;
-(void)SearchOnServer;
-(PBAddFinanceData *)dataZhuanhuan:(NSMutableDictionary *)dic;
@end

@implementation PBAddFinanceData
@synthesize userinfos;
@synthesize pbfinanceData;
@synthesize projectno;
@synthesize mode;
@synthesize type;
@synthesize year;
-(void)dealloc
{
    [othersView release];
    [titleArr release];
    [acitivity release];
    [projectjieshao_tishi=nil release];
    [userinfos release];
    [companyname release];
    [super dealloc];
}
- (void)viewLoding
{
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    acitivity = [[PBActivityIndicatorView alloc]initWithFrame:self.view.frame];

    titleArr = [[NSMutableArray alloc]initWithObjects:@"资产总额（万元）:",@"负责总额（万元）:",@"净资产（万元）:",@"资产负债率（%）:",@"销售收入（万元）:",@"所得税前利润（万元）:",@"所得税后利润（万元）:",@"经营活动现金净流量（万元）:",@"备注说明",nil];
    textFieldArr = [[NSMutableArray alloc]init];
    for (int i=0; i<[titleArr count]-1; i++) {
        UITextField* text = [[UITextField alloc]init];
        [textFieldArr addObject:text];
    }
    othersView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width-(isPad()?90:20), 120)];
    othersView.backgroundColor = [UIColor clearColor];
    othersView.textAlignment = UITextAlignmentLeft;
    othersView.delegate = self;
    [self backButton];
}


-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    for (UITextField* text in textFieldArr) {
        [text resignFirstResponder];
        [othersView resignFirstResponder];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [acitivity removeFromSuperview];
    [self viewTapped:nil];
    self.textViewAndtextFieldHidden = YES;
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view addSubview:acitivity];
//    if ([self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
//        self.tableView.allowsSelection = NO;
//        [self SearchOnServer];
    if (![self.ProjectStyle isEqualToString:ELSEPROJECTINFO]){//本地取数据
        if ([self.mode isEqualToString:@"add"]) {
            self.pbfinanceData = [[PBFinanceAccountData alloc]init];
            isedit = NO;
        }
    }
    [self changeViewFromPostData];
    [self.tableView reloadData];
    
    
}

#pragma mark -编辑状态
-(void)editState
{
    [self.tableView reloadData];
}
#pragma mark - 从服务器服务器取数据
-(void)SearchOnServer
{
    [acitivity startAnimating];
    PBdataClass *pb = [[PBdataClass alloc]init];
    pb.delegate = self;
    [pb dataResponse:[NSURL URLWithString:URL] postDic:[NSDictionary dictionaryWithObjectsAndKeys:[self.userinfos objectForKey:@"projectno"],@"projectno", nil]searchOrSave:YES];
    
}
/*
 获取失败
 */
-(void)searchFilad
{
    [acitivity stopAnimating];
}
/*
 上传成功
 */
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas
{
    if (datas.count > 0) {
        [self dataZhuanhuan:[datas objectAtIndex:0]];
    }
    [acitivity stopAnimating];
}
/*
 上传失败
 */
-(void)requestFilad
{
    [acitivity stopAnimating];
}
-(PBFinanceAccountData *)dataZhuanhuan:(NSMutableDictionary *)dic
{
    self.pbfinanceData.assetamount = [[dic objectForKey:@"assetamount"] intValue];
    self.pbfinanceData.responseamount = [[dic objectForKey:@"responseamount"] intValue];
    self.pbfinanceData.netasset = [[dic objectForKey:@"netasset"] intValue];
    self.pbfinanceData.assetdebtrate = [[dic objectForKey:@"assetdebtrate"] intValue];
    self.pbfinanceData.salesrevenue = [[dic objectForKey:@"salesrevenue"] intValue];
    self.pbfinanceData.pretaxprofit = [[dic objectForKey:@"pretaxprofit"] intValue];
    self.pbfinanceData.aftertaxprofit = [[dic objectForKey:@"aftertaxprofit"] intValue];
    self.pbfinanceData.activitycashflow = [[dic objectForKey:@"activitycashflow"] intValue];
    self.pbfinanceData.others = [dic objectForKey:@"others"] ;
    [self changeViewFromPostData];
    [self.tableView reloadData];
    return self.pbfinanceData;
}
#pragma mark - 数据上传到服务器
-(void)postDataOnserver
{
    [acitivity startAnimating];
    [self postOtherData];
}


-(void)postOtherData
{
    PBdataClass *pb = [[PBdataClass alloc]init];
    pb.delegate = self;
    [self changePostDataFromView];
    NSArray *a1 = [[NSArray alloc]initWithObjects:@"mode",@"no",@"type",@"projectno",@"year",@"assetamount",@"responseamount",@"netasset",@"assetdebtrate",@"salesrevenue",@"pretaxprofit",@"aftertaxprofit",@"activitycashflow",@"others", nil];
    NSArray *a2 = [[NSArray alloc]initWithObjects:self.mode,
                   [NSString stringWithFormat:@"%d",self.pbfinanceData.no],
                   [NSString stringWithFormat:@"%d",self.pbfinanceData.type],
                   [NSString stringWithFormat:@"%d",self.pbfinanceData.projectno],
                   [NSString stringWithFormat:@"%d",self.pbfinanceData.year],
                   [NSString stringWithFormat:@"%d",self.pbfinanceData.assetamount],
                   [NSString stringWithFormat:@"%d",self.pbfinanceData.responseamount],
                   [NSString stringWithFormat:@"%d",self.pbfinanceData.netasset],
                   [NSString stringWithFormat:@"%d",self.pbfinanceData.assetdebtrate],
                   [NSString stringWithFormat:@"%d",self.pbfinanceData.salesrevenue],
                   [NSString stringWithFormat:@"%d",self.pbfinanceData.pretaxprofit],
                   [NSString stringWithFormat:@"%d",self.pbfinanceData.aftertaxprofit],
                   [NSString stringWithFormat:@"%d",self.pbfinanceData.activitycashflow],
                   othersView.text?othersView.text:@"",
                   nil];
    [pb dataResponse:[NSURL URLWithString:SAVEURL] postDic:[[NSDictionary alloc]initWithObjects:a2 forKeys:a1] searchOrSave:NO];
}
-(void)changePostDataFromView{
    if ([self.mode isEqualToString:@"add"]) {
        self.pbfinanceData.year = self.year;
        self.pbfinanceData.projectno = self.projectno;
    }
    for (int i=0; i<[textFieldArr count]; i++) {
        UITextField* textField = [textFieldArr objectAtIndex:i];
        switch (i) {
            case 0:
                self.pbfinanceData.assetamount = [textField.text intValue];
                break;
            case 1:
                self.pbfinanceData.responseamount = [textField.text intValue];
                break;
            case 2:
                self.pbfinanceData.netasset = [textField.text intValue];
                break;
            case 3:
                self.pbfinanceData.assetdebtrate = [textField.text intValue];
                break;
            case 4:
                self.pbfinanceData.salesrevenue = [textField.text intValue];
                break;
            case 5:
                self.pbfinanceData.pretaxprofit = [textField.text intValue];
                break;
            case 6:
                self.pbfinanceData.aftertaxprofit = [textField.text intValue];
                break;
            case 7:
                self.pbfinanceData.activitycashflow = [textField.text intValue];
                break;
                
            default:
                break;
        }
    }
    self.pbfinanceData.type = self.type;
    self.pbfinanceData.others = othersView.text;
    
}

-(void)changeViewFromPostData{
    for (int i=0; i<[textFieldArr count]; i++) {
        UITextField* textField = [textFieldArr objectAtIndex:i];
        switch (i) {
            case 0:
                textField.text = [NSString stringWithFormat:@"%d",self.pbfinanceData.assetamount];
                break;
            case 1:
                textField.text = [NSString stringWithFormat:@"%d",self.pbfinanceData.responseamount];
                break;
            case 2:
                textField.text = [NSString stringWithFormat:@"%d",self.pbfinanceData.netasset];
                break;
            case 3:
                textField.text = [NSString stringWithFormat:@"%d",self.pbfinanceData.assetdebtrate];
                break;
            case 4:
                textField.text = [NSString stringWithFormat:@"%d",self.pbfinanceData.salesrevenue];
                break;
            case 5:
                textField.text = [NSString stringWithFormat:@"%d",self.pbfinanceData.pretaxprofit];
                break;
            case 6:
                textField.text = [NSString stringWithFormat:@"%d",self.pbfinanceData.aftertaxprofit];
                break;
            case 7:
                textField.text = [NSString stringWithFormat:@"%d",self.pbfinanceData.activitycashflow];
                break;
                
            default:
                break;
        }
    }
    othersView.text = self.pbfinanceData.others;
    
}

-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue
{
    
    //上传到本地
    self.pbfinanceData.no = [intvalue intValue];
    [self.pbfinanceData saveRecord];
    [acitivity stopAnimating];
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return [titleArr count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section > [textFieldArr count]-2) {
        return [titleArr objectAtIndex:section];
    }
    return nil;

}

#pragma mark - cell内容设置
-(void)addSubViewForCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section<[textFieldArr count]-1) {
        cell.textLabel.text = [titleArr objectAtIndex:indexPath.section];
    }
    if (indexPath.section < [textFieldArr count] ) {
        CGSize textSize = [cell.textLabel.text sizeWithFont:[UIFont boldSystemFontOfSize:16]];
        CGRect frame = CGRectMake((textSize.width+20)>20?textSize.width+20:10, 5, self.tableView.frame.size.width-textSize.width-(isPad()?120:50), 35);
        UITextField* textField = [textFieldArr objectAtIndex:indexPath.section];
        textField.frame = frame;
        [[cell contentView] addSubview:textField];
    }else{
        [[cell contentView] addSubview:othersView];
        othersView.editable = !isedit;
    }
    
    for (UITextField* textField in [[cell contentView] subviews]) {
        if ([textField isKindOfClass:[UITextField class]]) {
            [textField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            [textField setEnabled:!isedit];
            if (isedit) {
                [textField setBorderStyle:UITextBorderStyleNone];
            }else{
                [textField setBorderStyle:UITextBorderStyleRoundedRect];
                textField.keyboardType = UIKeyboardTypeNumberPad;
            }
        }
    }
}


#pragma mark - IPAD 调试
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == [titleArr count]-1) {
        height = [self textViewHeightWithView:othersView defaultHeight:44.0f];
    }
    else {
        height = 44.0f;
    }
    return height;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}



@end
