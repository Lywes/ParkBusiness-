//
//  PBBusinessFiancingdetail.m
//  ParkBusiness
//
//  Created by China on 13-7-12.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#define JIEDA_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/makesolutions",HOST]]

#import "PBBusinessFiancingdetail.h"
#import "NSObject+NVBackBtn.h"
#import "NSObject+PBLableHeight.m"
#import "PBcompanyDetailVC.h"
@interface PBBusinessFiancingdetail ()

@end

@implementation PBBusinessFiancingdetail
@synthesize name,trade,funds,difficulty,answer=_answer,use,saleroom,tbview=_tbview;
@synthesize name_identification= _name_identification;
@synthesize founs_identification = _founs_identification;
@synthesize trade_identification = _trade_identification;
@synthesize salerroom_identification =_salerroom__identification;
@synthesize data_dic;
-(void)dealloc
{
    [name=nil release];
    [trade=nil release];
    [funds=nil release];
    [difficulty=nil release];
    [_answer=nil release];
    [_tbview=nil release];
    [use=nil release];
    [saleroom=nil release];
    [data_dic = nil release];
    [_sectiontitle_arr=nil release];
    [inputbar=nil release];
    RB_SAFE_RELEASE(_name_identification);
    RB_SAFE_RELEASE(_founs_identification);
    RB_SAFE_RELEASE(_trade_identification);
    RB_SAFE_RELEASE(_salerroom__identification);
    [super dealloc];
    
    
}
-(void)KitText
{
    if ([[self.data_dic objectForKey:@"answer"] isEqualToString:@""])
    {
        _arry = [[NSMutableArray alloc]initWithObjects:
                 [self.data_dic objectForKey:@"username"],
                 [self.data_dic objectForKey:@"trade"],
                 [self.data_dic objectForKey:@"fundneed"],
                 [self.data_dic objectForKey:@"yearsale"],
                 [self.data_dic objectForKey:@"period"],
                 [self.data_dic objectForKey:@"raterange"],
                  @"",
                 [self.data_dic objectForKey:@"fundused"],
                 [self.data_dic objectForKey:@"difficulty"],
                 nil];
        _sectiontitle_arr = [[NSMutableArray alloc]initWithObjects:@"姓名",@"行业",@"资金",@"年销售额",@"融资周期",@"年利率范围",NSLocalizedString(@"_tb_gsgk", nil),@"用途",@"融资困难原因", nil];
    }
    else
    {
        _arry = [[NSMutableArray alloc]initWithObjects:
                 [self.data_dic objectForKey:@"username"],
                 [self.data_dic objectForKey:@"trade"],
                 [self.data_dic objectForKey:@"fundneed"],
                 [self.data_dic objectForKey:@"yearsale"],
                 [self.data_dic objectForKey:@"period"],
                 [self.data_dic objectForKey:@"raterange"],
                 @"",
                 [self.data_dic objectForKey:@"fundused"],
                 [self.data_dic objectForKey:@"difficulty"],
                 [self.data_dic objectForKey:@"answer"],nil];
        _sectiontitle_arr = [[NSMutableArray alloc]initWithObjects:@"姓名",@"行业",@"资金",@"年销售额",@"融资周期",@"年利率范围",NSLocalizedString(@"_tb_gsgk", nil),@"用途",@"融资困难原因",@"我的回答", nil];
        self.answer.hidden = YES;
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"企业融资需求";
    [self customButtomItem:self];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"custom_button.png"] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(isPad()?200:100, 10, 100, 50)];
    [btn setTitle:@"我来回答" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(butpress:) forControlEvents:UIControlEventTouchUpInside];
    self.answer = btn;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    [view addSubview:btn];
    self.tbview.tableFooterView = view;
    [view release];
   
    [self KitText];
    //回答输入框
    inputbar = [[UIInputToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 40)];
    inputbar.delegate = self;
    inputbar.textView.placeholder = @"请输入你的回答";
    [self.view addSubview:inputbar];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_sectiontitle_arr count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    NSInteger sec = indexPath.section;
    UILabel *detailTextLabel;
    if (sec < 7) {
        cell.textLabel.text = [_sectiontitle_arr objectAtIndex:sec];
        detailTextLabel = [[UILabel alloc]init];
        detailTextLabel.backgroundColor = [UIColor clearColor];
        detailTextLabel.numberOfLines = 0;
        [detailTextLabel setFrame:CGRectMake(isPad()?250:120, 0, isPad()?350:180, 44)];
        [cell.contentView addSubview:detailTextLabel];
        [detailTextLabel release];
        if (_arry.count>0) {
            detailTextLabel.text = [_arry objectAtIndex: indexPath.section];
        }
        if (sec == 6){
            cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
        }

    }
    else{
        if (_arry.count>0) {
            cell.textLabel.text = [_arry objectAtIndex: indexPath.section];
        }
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 6) {
        PBcompanyDetailVC *vc = [[PBcompanyDetailVC alloc] initWithStyle:UITableViewStyleGrouped];
        vc.ProjectStyle = ELSEPROJECTINFO;
        vc.datadic = self.data_dic;
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = [_arry objectAtIndex:indexPath.section];
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(isPad()?480:270, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    return MAX(size.height, 44);
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSInteger a = section;
    if (_sectiontitle_arr.count>0) {
        if (a  > 6) {
            return [_sectiontitle_arr objectAtIndex:a];

        }
         return nil;

    }
    else
        return nil;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [self HeightAStr:[_arry objectAtIndex:indexPath.section]];
//}
-(void)backHomeView
{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)butpress:(id)sender
{
    [inputbar addObserverFromController:self];
    [inputbar.textView becomeFirstResponder];
}
-(void)viewWillAppear:(BOOL)animated
{
    [inputbar addObserverFromController:self];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    [inputbar removeObserverFromController:self];
}
- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    [inputbar keyboardWillShowHide:notification];
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    [inputbar keyboardWillShowHide:notification];
    [inputbar keyboardWillHide];
}
#pragma mark - 回答输入的内容，及上传所用的方法 
-(void)inputButtonPressed:(NSString *)inputText
{
    
    [_arry addObject:inputText];
    [_sectiontitle_arr addObject:@"我的回答"];
    
    PBdataClass *dataclass = [[PBdataClass alloc]init];
    dataclass.delegate = self;
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:[self.data_dic objectForKey:@"ano"],@"no",inputText,@"answer", nil];
    [dataclass dataResponse:JIEDA_URL postDic:dic searchOrSave:NO];
    [dic release];
}
-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue
{
    NSLog(@"%d",[intvalue integerValue]);
    [self.tbview reloadData];
    self.answer.hidden = YES;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"回答的通知" object:@"企业融资需求"];
    [dataclass release];
}
@end
