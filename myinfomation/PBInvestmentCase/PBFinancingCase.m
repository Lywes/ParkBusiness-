//
//  PBFinancingCase.m
//  ParkBusiness
//
//  Created by China on 13-8-1.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/insertbankfinancingcase",HOST]]
#define _STRPOST_(x) x  == NULL? @"":x
#import "PBFinancingCase.h"
#import "PBChooseNormal VC.h"
#import "PBFinancingCaseOUT.h"
#import "PBChooselianjie.h"
#import "DBFinancingCase.h"
#import "PBKbnMasterModel.h"
#import "NSObject+NVBackBtn.h"
@interface PBFinancingCase ()

@end

@implementation PBFinancingCase
@synthesize productno;
@synthesize Mod_Add;
-(void)dealloc
{
    RB_SAFE_RELEASE(name_textfield);
    RB_SAFE_RELEASE(activity);
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSMutableArray *content = [[NSMutableArray alloc]initWithObjects:
                                   [NSMutableArray arrayWithObjects:@"",@"",@"",@"", nil],
                                   [NSMutableArray arrayWithObjects:@"", nil],
                                   [NSMutableArray arrayWithObjects:@"点击选择/查看", nil],
                                   nil];
        self.DataArr = content;
        [content  release];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    name_textfield = [self addtextfield];
    name_textfield.frame = CGRectMake(isPad()?250:100, 0, isPad()?250:200, 44);
    [name_textfield setBorderStyle:UITextBorderStyleRoundedRect];

    
    [self navigatorRightButtonType:WANCHENG];
    NSMutableArray *front = [[NSMutableArray alloc]initWithObjects:
                             [NSArray arrayWithObjects:@"案例名称",@"案例类型",@"行业划分",NSLocalizedString(@"_tb_gsgk", nil), nil],
                             [NSArray arrayWithObjects:NSLocalizedString(@"_tb_alxx", nil), nil],
                             [NSArray arrayWithObjects:NSLocalizedString(@"_tb_jrcplj", nil), nil],
                             nil];
    self.headArr = front;
    [front  release];
    
      
    [self customButtomItem:self];
    activity  = [[PBActivityIndicatorView alloc]initWithFrame:self.navigationController.view.frame];
    [self.view addSubview:activity];

}
-(void)backHomeView
{
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissModalViewControllerAnimated:YES];
}
#pragma mark - 追加按钮
-(void)NvBtnPress:(id)sender
{

    [activity startAnimating];
    PBdataClass *dataclass = [[PBdataClass alloc]init];
    dataclass.delegate = self;
    self.dataclass = dataclass;
    [dataclass release];
    NSString *str;
    str = Mod_Add;
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
      str,@"mode",
      [NSString stringWithFormat:@"%d",self.projectno],@"no",
                         
     USERNO,@"userno",
                         
    [[self.DataArr objectAtIndex:0] objectAtIndex:0],@"name",
                         
    [NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:[[self.DataArr objectAtIndex:0] objectAtIndex:1] withKind:@"projecttype"]],@"type",
                         
    [NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:[[self.DataArr objectAtIndex:0] objectAtIndex:1] withKind:@"industry"]],@"trade",
                         
     [[self.DataArr objectAtIndex:1] objectAtIndex:0],@"casedetail",
    
    [NSString stringWithFormat:@"%d",self.productno],@"productno",
                         
     [[self.DataArr objectAtIndex:0] objectAtIndex:3],@"companyinfo",
    nil];
    [self.dataclass dataResponse:URL postDic:dic searchOrSave:NO];
    [dic release];
}
-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue
{

    DBFinancingCase *db = [[DBFinancingCase alloc]init];
    db.no = [intvalue integerValue];
    db.name = _STRPOST_([[self.DataArr objectAtIndex:0] objectAtIndex:0]);
    db.type =  [PBKbnMasterModel getKbnIdByName:[[self.DataArr objectAtIndex:0] objectAtIndex:1] withKind:@"projecttype"];
    db.trade =  [PBKbnMasterModel getKbnIdByName:[[self.DataArr objectAtIndex:0] objectAtIndex:2] withKind:@"industry"];
    db.casedetail = _STRPOST_([[self.DataArr objectAtIndex:1] objectAtIndex:0]);
    
    db.productno  = self.productno?self.productno:0;
    db.companyinfo = _STRPOST_([[self.DataArr objectAtIndex:0] objectAtIndex:3]);
    [db save];
    [db release];
    [activity stopAnimating];
    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)searchFilad
{
    [activity stopAnimating];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 4;
        case 1:
            return 1;
        case 2:
            return 1;
            
        default:
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier]autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section !=1) {
        cell.textLabel.text = [[self.headArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }
    if (indexPath.section==0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel *lable = [self addshortLable];
        [cell.contentView addSubview:lable];
        lable.text = [[self.DataArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        CGSize a = STRSIZE(lable.text);
        CGRect rect = lable.frame;
        rect.size.height =MAX(44.0f, a.height - 50);
        lable.frame = rect;
    }
    else if (indexPath.section == 1)
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.text = [[self.DataArr objectAtIndex:1] objectAtIndex:0];
    }
    else if(indexPath.section == 2){
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
         cell.detailTextLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.text = [[self.DataArr objectAtIndex:2] objectAtIndex:0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    CGFloat a = section;
    if (a == 1) {
        return [[self.headArr objectAtIndex:1] objectAtIndex:0];
    }
    else
        return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PBChooseNormal_VC *vc = [[PBChooseNormal_VC alloc]init];
    vc.financingcase = self;
    vc.indexpath = indexPath;
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    PBFinancingCaseOUT *financingcaseou = [[PBFinancingCaseOUT alloc]initWithStyle:UITableViewStyleGrouped];
                    financingcaseou.financingcase = self;
                    financingcaseou.ClassTitle = @"案例名称";
                    financingcaseou.indexpath = indexPath;
                    [self.navigationController pushViewController:financingcaseou animated:YES];
                    [financingcaseou release];
                }
                    break;
                case 1:
                {
                    [vc KBMaster:@"projecttype" type:nil];
                    vc.title = @"案例类型选择";
                    [self.navigationController pushViewController:vc animated:YES];
                    [vc release];
                }

                    break;
                case 2:
                {
                    [vc KBMaster:@"industry" type:nil];
                    vc.title = @"行业划分界面";
                    [self.navigationController pushViewController:vc animated:YES];
                    [vc release];
                }
                    break;
                case 3:
                {
                    PBFinancingCaseOUT *financingcaseou = [[PBFinancingCaseOUT alloc]initWithStyle:UITableViewStyleGrouped];
                    financingcaseou.financingcase = self;
                    financingcaseou.ClassTitle = NSLocalizedString(@"_tb_gsgk", nil);
                    financingcaseou.indexpath = indexPath;
                    [self.navigationController pushViewController:financingcaseou animated:YES];
                    [financingcaseou release];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            PBFinancingCaseOUT *financingcaseou = [[PBFinancingCaseOUT alloc] initWithStyle:UITableViewStyleGrouped];
            financingcaseou.ClassTitle = NSLocalizedString(@"_tb_alxx", nil);
            financingcaseou.financingcase = self;
            financingcaseou.indexpath = indexPath;
            [self.navigationController pushViewController:financingcaseou animated:YES];
            [financingcaseou release];
        }
            break;
        case 2:
        {
            PBChooselianjie *financingcaseou = [[PBChooselianjie alloc] init];
            financingcaseou.financingcase = self;
            financingcaseou.indexpath = indexPath;
            [self.navigationController pushViewController:financingcaseou animated:YES];
            [financingcaseou release];
        }
            break;
        default:
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 3) {
        NSString *str = [[self.DataArr objectAtIndex:0]  objectAtIndex:3];
         CGSize a =  STRSIZE(str);
        
        return MAX(44.0f, a.height- 50);
    }
    else if(indexPath.section == 1){
        NSString *str = [[self.DataArr objectAtIndex:1]  objectAtIndex:0];
        CGSize a =  STRSIZE(str);
        
        return MAX(44.0f, a.height - 50);
    }
        return 44.0f;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
