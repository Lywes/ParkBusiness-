//
//  PBBankFinanceNeeds.m
//  ParkBusiness
//
//  Created by QDS on 13-5-15.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBBankFinanceNeeds.h"
#import "PBIndustryData.h"
#import "PBUserModel.h"
#import "PBKbnMasterModel.h"
#define BANKURL [NSString stringWithFormat:@"%@/admin/index/searchbankloan",HOST]
#define SAVEURL [NSString stringWithFormat:@"%@/admin/index/addfinanceneeds",HOST]
@interface PBBankFinanceNeeds ()
-(void)initPopView;
-(void)postOtherData;
-(void)SearchOnServer;
-(PBBankLoanData *)dataZhuanhuan:(NSMutableDictionary *)dic;
@end

@implementation PBBankFinanceNeeds
@synthesize userinfos;
@synthesize pbbankloandata;
@synthesize projectno;
@synthesize mode;
@synthesize type;
-(void)dealloc
{
    [applyloan release];
    [loanlimit release];
    [others release];
    [yearraterange release];
    [loanuselabel release];
    [securedform release];
    [acitivity release];
    [assure release];
    [raterange release];
    [userinfos release];
    [loanuse release];
    [titleArr release];
    [super dealloc];
}
- (void)viewLoding
{
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    acitivity = [[PBActivityIndicatorView alloc]initWithFrame:self.view.frame];
    titleArr = [[NSMutableArray alloc]initWithObjects:@"担保形式:",@"申请贷款额（万元）:",@"借贷期限(年):",@"年利率范围（%）:", @"贷款用途:",@"其他事项:",nil];
    
    [self initPopView];
    //本地取数据
    assure = [[NSMutableArray alloc]init];
    NSMutableArray *arry1 = [PBIndustryData search:@"assure"];
    for (PBIndustryData * industryData in arry1 ) {
        if (industryData.name != NULL) {
            [assure addObject:industryData.name];
        }
    }
    raterange = [[NSMutableArray alloc]init];
    NSMutableArray *arry2 = [PBIndustryData search:@"raterange"];
    for (PBIndustryData * industryData in arry2 ) {
        if (industryData.name != NULL) {
            [raterange addObject:industryData.name];
        }
    }
    loanuse = [[NSMutableArray alloc]init];
    NSMutableArray *arry3 = [PBIndustryData search:@"loanuse"];
    for (PBIndustryData * industryData in arry3 ) {
        if (industryData.name != NULL) {
            [loanuse addObject:industryData.name];
        }
    }
    [self backButton];
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [applyloan resignFirstResponder];
    [loanlimit resignFirstResponder];
    [others resignFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated{
    [acitivity removeFromSuperview];
    [self viewTapped:nil];	
    self.textViewAndtextFieldHidden = YES;
}
-(void)initPopView
{
    //弹出选择画面
    pop =[[POPView alloc]init];
    pop.delegate = self;
    pop.view.hidden = YES;
    [self.view addSubview:pop.view];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view addSubview:acitivity];
    if ([self.ProjectStyle isEqualToString:ELSEPROJECTINFO]) {
        self.tableView.allowsSelection = NO;
        self.pbbankloandata = [[PBBankLoanData alloc]init];
        [self SearchOnServer];
    }else{//本地取数据
        self.pbbankloandata = [PBBankLoanData searchData:self.projectno];
    }
    
    [self initInputView];
    [self.tableView reloadData];
    if ([self.mode isEqualToString:@"add"]) {
        [super editButtonPress:self.navigationItem.rightBarButtonItem];
    }
    
}

-(void)initInputView{
    for (int i = 0; i<[titleArr count]; i++){
        CGSize textSize = [[titleArr objectAtIndex:i] sizeWithFont:[UIFont boldSystemFontOfSize:16]];
        CGRect frame = CGRectMake(textSize.width+20, 5, self.tableView.frame.size.width-textSize.width-(isPad()?120:50), 35);
        if (i == 0) {
            securedform = [[UILabel alloc]initWithFrame:frame];
            securedform.backgroundColor = [UIColor clearColor];
            securedform.text = [PBKbnMasterModel getKbnNameById:self.pbbankloandata.securedform withKind:@"assure"];
        }
        if (i == 1) {
            applyloan = [[UITextField alloc]initWithFrame:frame];
            applyloan.text = [NSString stringWithFormat:@"%d",self.pbbankloandata.applyloan];
            
        }
        if (i == 2) {
            loanlimit = [[UITextField alloc]initWithFrame:frame];
            loanlimit.text = [NSString stringWithFormat:@"%d",self.pbbankloandata.loanlimit];
            
        }
        if (i == 3) {
            yearraterange = [[UILabel alloc]initWithFrame:frame];
            yearraterange.backgroundColor = [UIColor clearColor];
            yearraterange.text = [PBKbnMasterModel getKbnNameById:self.pbbankloandata.yearraterange withKind:@"raterange"];
        }
        if (i == 4) {
            loanuselabel = [[UILabel alloc]initWithFrame:frame];
            loanuselabel.backgroundColor = [UIColor clearColor];
            loanuselabel.text = [PBKbnMasterModel getKbnNameById:self.pbbankloandata.loanuse withKind:@"loanuse"];
        }
        if (i == 5) {
            others = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width-(isPad()?90:20), 120)];
            others.backgroundColor = [UIColor clearColor];
            others.textAlignment = UITextAlignmentLeft;
            others.delegate = self;
            others.text = self.pbbankloandata.others;
            others.tag = 5;
        }
    }
    
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
    [pb dataResponse:[NSURL URLWithString:BANKURL] postDic:[NSDictionary dictionaryWithObjectsAndKeys:[self.datadic objectForKey:@"no"],@"projectno", nil]searchOrSave:YES];
    
}
/*
 获取失败
 */
-(void)searchFilad
{
    [self editButtonPress:self.navigationItem.rightBarButtonItem];
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
    [self initInputView];
    [acitivity stopAnimating];
}
/*
 上传失败
 */
-(void)requestFilad
{
    [acitivity stopAnimating];
}
-(PBBankLoanData *)dataZhuanhuan:(NSMutableDictionary *)dic
{
    self.pbbankloandata.securedform = [[dic objectForKey:@"securedform"] intValue];
    self.pbbankloandata.applyloan = [[dic objectForKey:@"applyloan"] intValue];
    self.pbbankloandata.yearraterange = [[dic objectForKey:@"yearraterange"] intValue];
    self.pbbankloandata.loanuse = [[dic objectForKey:@"loanuse"] intValue];
    self.pbbankloandata.loanlimit = [[dic objectForKey:@"loanlimit"] intValue];
    self.pbbankloandata.others = [dic objectForKey:@"others"];
    [self.tableView reloadData];
    return self.pbbankloandata;
}
#pragma mark - 数据上传到服务器
-(void)postDataOnserver
{
    [acitivity startAnimating];
    [self postOtherData];
    
}


-(void)postOtherData
{
    [self changePostDataFromView];
    PBdataClass *pb = [[PBdataClass alloc]init];
    pb.delegate = self;
    NSString *modes = self.pbbankloandata.no>0?@"mod":@"add";
    NSArray *a1 = [[NSArray alloc]initWithObjects:@"mode", @"no",@"projectno",@"securedform",@"applyloan",@"loanlimit",@"yearraterange",@"loanuse",@"others",nil];
    NSArray *a2 = [[NSArray alloc]initWithObjects:modes,
                   [NSString stringWithFormat:@"%d",self.pbbankloandata.no],
                   [NSString stringWithFormat:@"%d",self.pbbankloandata.projectno],
                   [NSString stringWithFormat:@"%d",self.pbbankloandata.securedform],
                   applyloan.text?applyloan.text:@"",
                   loanlimit.text?loanlimit.text:@"",
                   [NSString stringWithFormat:@"%d",self.pbbankloandata.yearraterange],
                   [NSString stringWithFormat:@"%d",self.pbbankloandata.loanuse],
                   self.pbbankloandata.others,
                   nil];
    [pb dataResponse:[NSURL URLWithString:SAVEURL] postDic:[[NSDictionary alloc]initWithObjects:a2 forKeys:a1] searchOrSave:NO];
 
}
-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue
{
    
    //上传到本地
    self.pbbankloandata.no = [intvalue intValue];
    [self.pbbankloandata saveRecord];
    [acitivity stopAnimating];
    if ([self.mode isEqualToString:@"add"]) {
        [self dismissModalViewControllerAnimated:YES];
        if (self.productno>0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showalert" object:nil];
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }

}
-(void)changePostDataFromView{
    self.pbbankloandata.projectno = self.projectno;
    self.pbbankloandata.applyloan = [applyloan.text intValue];
    self.pbbankloandata.loanlimit = [loanlimit.text intValue];
    self.pbbankloandata.others = others.text?others.text:@"";
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
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (![self.ProjectStyle isEqualToString:ELSEPROJECTINFO]&&section==5) {
        labletag = section;
        return [self TishiView];
    }else{
        return nil;
    }
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==titleArr.count-1) 
       return [titleArr objectAtIndex:section];
    return nil;
}
#pragma mark - cell内容设置
-(void)addSubViewForCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section<titleArr.count-1) {
        cell.textLabel.text = [titleArr objectAtIndex:indexPath.section];
    }
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [[cell contentView] addSubview:securedform];
    }
    if (indexPath.section == 1) {
        [[cell contentView] addSubview:applyloan];
        
    }
    if (indexPath.section == 2) {
        [[cell contentView] addSubview:loanlimit];
        
    }
    if (indexPath.section == 3) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [[cell contentView] addSubview:yearraterange];
    }
    if (indexPath.section == 4) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [[cell contentView] addSubview:loanuselabel];
    }
    if (indexPath.section == 5) {
        [[cell contentView] addSubview:others];
        others.editable = !isedit;
        
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
    if (indexPath.section == titleArr.count-1) {
        return [self textViewHeightWithView:others defaultHeight:44.0f];
    }
    return 44.0f;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [pop.view removeFromSuperview];
        pop._arry = assure;
        pop.name = @"担保形式";
        pop.view.hidden = !pop.view.hidden;
        [pop popClickAction];
    }
    if (indexPath.section ==3) {
        [pop.view removeFromSuperview];
        pop.name = @"年利率范围";
        pop._arry = raterange;
        pop.view.hidden = !pop.view.hidden;
        [pop popClickAction];
    }
    if (indexPath.section ==4) {
        [pop.view removeFromSuperview];
        pop.name = @"贷款用途";
        pop._arry = loanuse;
        pop.view.hidden = !pop.view.hidden;
        [pop popClickAction];
    }
}
#pragma mark -POPview delegate
- (void)popView:(POPView *)popview didSelectIndexPath:(NSIndexPath *)indexPath{
    if ([pop._arry isEqualToArray:assure]) {
        securedform.text = [popview._arry objectAtIndex:indexPath.row];
        self.pbbankloandata.securedform = indexPath.row+1;
    }else if([pop._arry isEqualToArray:raterange]){
        yearraterange.text = [popview._arry objectAtIndex:indexPath.row];
        self.pbbankloandata.yearraterange = indexPath.row+1;
    }else{
        loanuselabel.text = [popview._arry objectAtIndex:indexPath.row];
        self.pbbankloandata.loanuse = indexPath.row+1;
    }
}
@end
