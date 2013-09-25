//
//  PBJoinBusinessUnionVC.m
//  ParkBusiness
//
//  Created by China on 13-9-4.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBJoinBusinessUnionVC.h"
#import "PBCustonTextVC.h"
#import "NSObject+NAV.h"
#define APPlYURL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/financialmanagersapply",HOST]]
@interface PBJoinBusinessUnionVC ()
{
    NSMutableArray *keys;
    NSMutableArray * keys_Eng;
    NSMutableArray *values;
    NSInteger index;
}
@end

@implementation PBJoinBusinessUnionVC
-(void)dealloc{
    RB_SAFE_RELEASE(keys);
    RB_SAFE_RELEASE(values);
    RB_SAFE_RELEASE(keys_Eng);
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:@"申请" style:UIBarButtonItemStylePlain target:self action:@selector(applyDidPush)]];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    NSDictionary *dic = [self getTextDic];
    if (dic) {
        [self.DataDic setValue:[dic valueForKey:[[dic allKeys] objectAtIndex:0]] forKey:[[dic allKeys] objectAtIndex:0]];
        [self.tableView reloadData];
    }

}
- (void)viewDidLoad
{
    [super viewDidLoad];
   keys =[[NSMutableArray alloc] initWithObjects:
                    @"所在机构名称",
                    @"机构介绍",
                    @"机构logo",
                    @"个人姓名",
                    @"联系电话",
                    @"职务",
                    @"性别",
                    @"所在城市",
                    @"自我介绍",
                    @"身份证照",
                    @"名片照",
                    nil];
   keys_Eng =[[NSMutableArray alloc] initWithObjects:
                               @"institution_name",
                               @"institution_introduce",
                               @"institution_logo_filename",
                               @"person_name",
                               @"tel",
                               @"job",
                               @"sex",
                               @"city",
                               @"selfintroduction",
                               @"idcardpic_filename",
                               @"carllcard_filename",
                               nil];
    values =[[NSMutableArray alloc] initWithObjects:
                           @"",
                           @"",
                           @"",
                           @"",
                           @"",
                           @"",
                           @"",
                           @"",
                           @"",
                           @"",
                           @"",
                           nil];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjects:values forKeys:keys_Eng];
    self.DataDic = dic;
    [dic release];
    
    
//    //本地表
//    NSMutableArray *job = [[[NSMutableArray alloc]init]autorelease];
//    NSMutableArray *job1 =  [PBIndustryData search:@"job"];
//    for(PBIndustryData *industrydata in job1)
//    {
//        if (industrydata.name != NULL) {
//            [job addObject:industrydata.name];
//        }
//    }
    pop = [[POPView alloc]init];
    pop.delegate = self;
    pop.view.hidden = YES;
    [self.view addSubview:pop.view];
    indicator= [[PBActivityIndicatorView alloc]initWithFrame:isPad()?CGRectMake(0, 0, 768, 1024):CGRectMake(0, 0, 320, isPhone5()?568:480)];
    [self.view addSubview:indicator];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [[self.DataDic allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
    if (indexPath.section !=1 && indexPath.section !=8) {
        cell.textLabel.text = [keys objectAtIndex:indexPath.section];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section != 2
        &&indexPath.section != 9
        &&indexPath.section != 10
        &&indexPath.section != 1
        &&indexPath.section != 8) {
        
        UILabel *detailTextLabel;
        detailTextLabel = [[UILabel alloc]init];
        detailTextLabel.tag = 100;
        detailTextLabel.backgroundColor = [UIColor clearColor];
        detailTextLabel.numberOfLines = 0;
            [detailTextLabel setFrame:CGRectMake(isPad()?250:120, 0, isPad()?350:180,  44)];
        [cell.contentView addSubview:detailTextLabel];
        [detailTextLabel release];
    }
    else if (indexPath.section == 2
                 ||indexPath.section == 9
                ||indexPath.section == 10)
        {
            UIImageView * imageview = [[[UIImageView alloc]initWithFrame:CGRectMake(isPad()?250:150, 11, 58, 58)]autorelease];
            imageview.tag = 101;
            imageview.layer.shadowRadius = 5.0f;
            imageview.layer.masksToBounds = YES;
            imageview.layer.cornerRadius = 5.0f;
            [cell.contentView addSubview:imageview];
        }
    

    UILabel *detailTextLabel = (UILabel *)[cell.contentView viewWithTag:100];
    UIImageView *imageview = (UIImageView *)[cell.contentView viewWithTag:101];
    switch (indexPath.section) {
        case 0:
            detailTextLabel.text = [self.DataDic objectForKey:@"institution_name"];
            break;
        case 1:
        {
            cell.textLabel.text = [self.DataDic objectForKey:@"institution_introduce"];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.numberOfLines = 0;
        }
            break;
        case 2:
            if ([[[self.DataDic objectForKey: @"institution_logo_filename"] class] isEqual:[UIImage class]]) {
                imageview.image = [self.DataDic objectForKey: @"institution_logo_filename"];
                
            }
            break;
        case 3:
            detailTextLabel.text = [self.DataDic objectForKey:@"person_name"];
            break;
        case 4:
            detailTextLabel.text = [self.DataDic objectForKey:@"tel"];
            break;
       case 5:
             detailTextLabel.text = [self.DataDic objectForKey: @"job"];
            break;
        case 6:
            detailTextLabel.text = [self.DataDic objectForKey: @"sex"];
            break;
        case 7:
            detailTextLabel.text = [self.DataDic objectForKey: @"city"];
            break;
        case 8:
        {
            cell.textLabel.text = [self.DataDic objectForKey:@"selfintroduction"];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.numberOfLines = 0;
        }
        case 9:
            if ([[[self.DataDic objectForKey: @"idcardpic_filename"] class] isEqual:[UIImage class]]) {
                imageview.image = [self.DataDic objectForKey: @"idcardpic_filename"];

            }
            break;
        case 10:
            if ([[[self.DataDic objectForKey: @"carllcard_filename"] class] isEqual:[UIImage class]]) {
                imageview.image = [self.DataDic objectForKey: @"carllcard_filename"];
                
            }
            break;
        default:
            break;
    }
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section ==1 || section ==8) {
        return [keys objectAtIndex:section];
    }
    else
        return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==1 || indexPath.section ==8) {
        return 88.0f;
    }
    else if (indexPath.section == 2
             ||indexPath.section == 9
             ||indexPath.section == 10)
    {
        return 80.0f;
    }
    else
        return 44.0f;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PBCustonTextVC *custontext = [[PBCustonTextVC alloc] initWithNibName:@"PBCustonTextVC" bundle:nil];
    custontext.show = YES;
    custontext.text = [self.DataDic objectForKey:[keys_Eng objectAtIndex:indexPath.section]];
    switch (indexPath.section) {
        case 0:{
            custontext.keystr = @"institution_name";
            custontext.title = @"请输入你的所在机构名称";
            custontext.show = NO;
            [self.navigationController pushViewController:custontext animated:YES];

        }
             break;
        case 1:{
            custontext.keystr = @"institution_introduce";
            custontext.title = @"请输入机构介绍";
            [self.navigationController pushViewController:custontext animated:YES];

        }
             break;
        case 2:{
            index = indexPath.section;
            [self logimgePicker];
            
        }
            break;
        case 3:{
            custontext.keystr = @"person_name";
            custontext.title = @"请输入你的姓名";
            custontext.show = NO;
            [self.navigationController pushViewController:custontext animated:YES];

        }
            break;
        case 4:{
            custontext.keystr = @"tel";
            custontext.title = @"请输入你的联系电话";
            custontext.show = NO;
            [self.navigationController pushViewController:custontext animated:YES];

        }
            break;
        case 5:
        {
            //本地表
            NSMutableArray *job = [[NSMutableArray alloc]init];
            NSMutableArray *job1 =  [PBIndustryData search:@"job"];
            for(PBIndustryData *industrydata in job1)
            {
                if (industrydata.name != NULL) {
                    [job addObject:industrydata.name];
                }
            }
            index = indexPath.section;
            [pop.view removeFromSuperview];
            pop._arry = job;
            pop.name = @"职务";
            pop.view.hidden = !pop.view.hidden;
            [pop popClickAction];
            [job release];
        }
            break;
        case 6:
        {
            //本地表
            NSMutableArray *job = [[NSMutableArray alloc]init];
            NSMutableArray *job1 =  [PBKbnMasterModel getKbnInfoByKind:@"sex"];
            for(PBKbnMasterModel *industrydata in job1)
            {
                if (industrydata.name != NULL) {
                    [job addObject:industrydata.name];
                }
            }
            index = indexPath.section;
            [pop.view removeFromSuperview];
            pop._arry = job;
            pop.name = @"性别";
            pop.view.hidden = !pop.view.hidden;
            [pop popClickAction];
            [job release];
        }
            break;
        case 7:
        {
            //本地表
            NSMutableArray *job = [[NSMutableArray alloc]init];
            NSMutableArray *job1 =  [PBKbnMasterModel getKbnInfoByKind:@"province"];
            for(PBKbnMasterModel *industrydata in job1)
            {
                if (industrydata.name != NULL) {
                    [job addObject:industrydata.name];
                }
            }
            index = indexPath.section;
            [pop.view removeFromSuperview];
            pop._arry = job;
            pop.name = @"所在城市";
            pop.view.hidden = !pop.view.hidden;
            [pop popClickAction];
            [job release];
        }
            break;
        case 8:{
            custontext.keystr = @"selfintroduction";
            custontext.title = @"请输入自我介绍";
            [self.navigationController pushViewController:custontext animated:YES];
            
        }
              break;
        case 9:{
            index = indexPath.section;
            [self logimgePicker];
            
        }
             break;
        case 10:{
            index = indexPath.section;
            [self logimgePicker];
        }
             break;
        default:
            break;
    }
}
#pragma mark -POPview delegate
- (void)popView:(POPView *)popview didSelectIndexPath:(NSIndexPath *)indexPath{
    [self.DataDic setValue:[popview._arry objectAtIndex:indexPath.row] forKey:[keys_Eng objectAtIndex:index]];
    [self.tableView reloadData];
}
#pragma mark - 相册
-(void)logimgePicker
{
    if (imagepickerview) {
        [imagepickerview release];
    }
    imagepickerview = [[ImagePickerView alloc]initWithView:self];
    imagepickerview.delegate = self;
    
}
-(void)resultImage:(UIImage *)image
{
     [self.DataDic setValue:image forKey:[keys_Eng objectAtIndex:index]];
    [self.tableView reloadData];
}
//提交申请
-(void)applyDidPush{
    [indicator startAnimating];
    PBdataClass* dataClass = [[PBdataClass alloc]init];
    
    NSString* job = [NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:[self.DataDic objectForKey:@"job"] withKind:@"job"]];
    NSString* sex = [NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:[self.DataDic objectForKey:@"sex"] withKind:@"sex"]];
    NSString* city = [NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:[self.DataDic objectForKey:@"city"] withKind:@"province"]];
    [self.DataDic setObject:job forKey:@"job"];
    [self.DataDic setObject:sex forKey:@"sex"];
    [self.DataDic setObject:city forKey:@"city"];
    [self.DataDic setObject:USERNO forKey:@"userno"];
    dataClass.delegate = self;
    [dataClass uploadImagesAndDatas:APPlYURL withDic:self.DataDic];
}
//数据上传成功
-(void)imageIsSuccesePostOnServer:(int)intvalue{
    [indicator stopAnimating];
    [self dismissModalViewControllerAnimated:YES];
    NSUserDefaults *userData = [NSUserDefaults standardUserDefaults];
    [userData setInteger:2 forKey:@"kind"];
    [userData synchronize];
    UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"申请成功" message:@"申请加盟成功,稍后有服务人员与你联系" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [alt show];
    [alt release];
    [self performSelector:@selector(dismissAlt:) withObject:alt afterDelay:2.0];
}
-(void)dismissAlt:(UIAlertView *)alt{
    [alt dismissWithClickedButtonIndex:0 animated:YES];
}
//提交失败
-(void)searchFilad{
    [indicator stopAnimating];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
