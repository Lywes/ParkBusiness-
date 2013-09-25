//
//  PBpersonerInfo.m
//  ParkBusiness
//
//  Created by China on 13-7-19.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define updateuserbasicinfo_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/updateuserbasicinfo",HOST]]
#define RECTMARK CGRectMake(isPad()?230:130, 0, isPad()?500:220, 44)
#import "PBpersonerInfo.h"
#import "NSObject+NVBackBtn.h"
#import "PBSidebarVC.h"
#import "PBShezhiData.h"
#import "PBCompanyData.h"
@interface PBpersonerInfo ()

@end

@implementation PBpersonerInfo
-(void)dealloc
{
    RB_SAFE_RELEASE(_hangye);
    RB_SAFE_RELEASE(_xingbie);
    RB_SAFE_RELEASE(_name);
    RB_SAFE_RELEASE(_companyname);
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"个人信息";
        NSMutableArray *he = [[NSMutableArray alloc]initWithObjects:@"真实姓名",@"公司",@"职务",@"性别", nil];
        self.headArr = he;
        [he release];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customButtomItem:self];
   
    
    
    
    pop =[[POPView alloc]init];
    pop.delegate = self;
    pop.view.hidden = YES;
    [self.view addSubview:pop.view];
    
    
    NSMutableArray *arry1 = [[NSMutableArray alloc]init];
    self.DataArr = arry1;
    [arry1 release];
    
    _hangye = [[UILabel alloc]initWithFrame:RECTMARK];
    _hangye.backgroundColor = [UIColor clearColor];
    _xingbie = [[UILabel alloc]initWithFrame:RECTMARK];
    _xingbie.backgroundColor = [UIColor clearColor];
    UITextField *text = [self addtextfield];
    text.frame = CGRectMake(isPad()?230:100, 0, isPad()?560:210, 44);
    text.borderStyle = UITextBorderStyleNone;
    [text retain];
    _name = text;
    
    
    UITextField *text1 = [self addtextfield];
    text1.frame = CGRectMake(isPad()?230:100, 0, isPad()?560:210, 44);
    text1.borderStyle = UITextBorderStyleNone;
    [text1 retain];
    _companyname = text1;
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextDidPush)];
    [self.navigationItem.rightBarButtonItem release];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignKeyBoard:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    self.tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_background.png"]];
    
}
-(void)resignKeyBoard:(UITapGestureRecognizer*)tap{
    [_name resignFirstResponder];
}
-(void)backHomeView
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)nextDidPush
{
    PBdataClass *oo = [[PBdataClass alloc]init];
    oo.delegate = self;
    self.dataclass = oo;
    [oo release];
    
    NSDictionary *dic;
    if (self.headArr.count>2) {
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             _name.text,@"name",
                            _companyname.text,@"companyname",
                             [NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:_xingbie.text  withKind:@"sex"] ],@"sex",
                             [NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:_hangye.text withKind:@"job"]],@"companyjob",
                             USERNO,@"no",
                             nil];
    }
    else
        dic = [NSDictionary dictionaryWithObjectsAndKeys:
               _name.text,@"name",
               [NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:_xingbie.text  withKind:@"sex"] ],@"sex",
               USERNO,@"no",
               nil];

    [self.dataclass dataResponse:updateuserbasicinfo_URL postDic:dic searchOrSave:NO];


}
-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue
{
    NSLog(@"%d",[intvalue integerValue]);
    NSMutableArray *DBdata = [PBShezhiData searchBy:[PBUserModel getUserId]];
    PBShezhiData *xx = [DBdata objectAtIndex:0];
    
    [PBShezhiData SaveId:xx.no
                    name:_name.text
                     sex:[PBKbnMasterModel getKbnIdByName:_xingbie.text  withKind:@"sex"]
               signature:xx.signature
               companyno:[intvalue integerValue]>0?[intvalue integerValue]:xx.companyno
              companyjob:[PBKbnMasterModel getKbnIdByName:_hangye.text  withKind:@"job"]
                   trade:xx.trade
            emailaddress:xx.emailaddress
                      qq:xx.qq city:xx.city
                sinablog:xx.signature
                linkedin:xx.linkedin
                   skype:xx.skype
                     msn:xx.msn];
    [dataclass release];
    if ([intvalue integerValue]>0) {
        PBCompanyData *data = [[PBCompanyData alloc]init];
        data.parkno = [PBUserModel getParkNo];
        data.no = [intvalue intValue];
        data.name = _companyname.text;
        [data saveRecord];
    }
    
    
    PBSidebarVC* home = [[PBSidebarVC alloc] init];
    [self.navigationController pushViewController:home animated:YES];
    [home release];
}
-(void)searchFilad
{
    
}
#pragma mark - KBmaster表取数
-(void)forListString:(NSString *)str
{
    NSMutableArray *arr = [PBKbnMasterModel getKbnInfoByKind:str];
    [self.DataArr removeAllObjects];
    for (PBKbnMasterModel * industryData in arr) {
        if (industryData.name != NULL) {
            [self.DataArr addObject:industryData.name];
        }
    }
    [arr release];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.headArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return isPad()?80.0f:44.0f;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"choose_back.png"]];
        cell.backgroundView = image;
        [image release];
//        cell.backgroundView = [
        if (indexPath.section != 0) {
            switch (indexPath.section) {
                    
                case 1:{
                       [cell.contentView addSubview:_companyname];
                    UILabel *lable = [[UILabel alloc] initWithFrame:isPad()? CGRectMake(50, 0, 200, 44):CGRectMake(10, 0, 100, 44)];
                    lable.text = @"公司名称";
                    lable.backgroundColor = [UIColor clearColor];
                    lable.font = [UIFont systemFontOfSize:isPad()?30:18];
                    lable.textColor = [UIColor whiteColor];
                    [cell.contentView addSubview:lable];
                }
                    break;
                case 2:{
                    self.headArr.count>2?[cell.contentView addSubview:_hangye]:[cell.contentView addSubview:_xingbie];
                    UIImageView *accessoryview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jiantou.png"]];
                    cell.accessoryView = accessoryview;
                    [accessoryview release];
                    
                    UILabel *lable = [[UILabel alloc] initWithFrame:isPad()? CGRectMake(50, 0, 200, 44):CGRectMake(10, 0, 100, 44)];
                    lable.text = self.headArr.count>2?@"职务":@"性别";
                    lable.backgroundColor = [UIColor clearColor];
                    lable.font = [UIFont systemFontOfSize:isPad()?30:18];
                    lable.textColor = [UIColor whiteColor];
                    [cell.contentView addSubview:lable];
                    
                }

                    break;
                case 3:
                {
                    [cell.contentView addSubview:_xingbie];

                    UILabel *lable = [[UILabel alloc] initWithFrame:isPad()? CGRectMake(50, 0, 200, 44):CGRectMake(10, 0, 100, 44)];
                    lable.text = @"性别";
                    lable.backgroundColor = [UIColor clearColor];
                    lable.font = [UIFont systemFontOfSize:isPad()?30:18];
                    lable.textColor = [UIColor whiteColor];
                    [cell.contentView addSubview:lable];
                    
                    UIImageView *accessoryview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jiantou.png"]];
                    cell.accessoryView = accessoryview;
                    [accessoryview release];


                }
                    
                    break;
                    
                default:
                    break;
            }
        }
        else
        {
            [cell.contentView addSubview:_name];
            
            UILabel *lable = [[UILabel alloc] initWithFrame:isPad()? CGRectMake(50, 0, 200, 44):CGRectMake(10, 0, 100, 44)];
            lable.text = @"真实姓名";
            lable.backgroundColor = [UIColor clearColor];
            lable.font = [UIFont systemFontOfSize:isPad()?30:18];
            lable.textColor = [UIColor whiteColor];
            [cell.contentView addSubview:lable];

        }

    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section>0) {
        [_name resignFirstResponder];
    }
    switch (indexPath.section) {
        case 1:
             [_companyname resignFirstResponder];
            break;
        case 2:
            [pop.view removeFromSuperview];
            [self forListString:self.headArr.count>2? @"job":@"sex"];
            pop._arry = self.DataArr;
            pop.name = self.headArr.count>2?@"职务":@"性别";
            pop.view.hidden = !pop.view.hidden;
            [pop popClickAction];
            break;
        case 3:
            [pop.view removeFromSuperview];
            [self forListString:@"sex"];
            pop._arry = self.DataArr;
            pop.name = @"性别";
            pop.view.hidden = !pop.view.hidden;
            [pop popClickAction];
            break;

        default:
            break;
    }
}
#pragma mark -POPview delegate
- (void)popView:(POPView *)popview didSelectIndexPath:(NSIndexPath *)indexPath{
    if ([pop.name isEqualToString:@"职务"]) {
        _hangye.text = [pop._arry objectAtIndex:indexPath.row];
    }
    if ([pop.name isEqualToString:@"性别"]) {
        _xingbie.text = [pop._arry objectAtIndex:indexPath.row];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
