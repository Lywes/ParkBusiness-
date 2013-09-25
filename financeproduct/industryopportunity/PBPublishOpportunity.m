//
//  PBPublishOpportunity.m
//  ParkBusiness
//
//  Created by 上海 on 13-7-1.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBPublishOpportunity.h"
#import "PBIndustryData.h"
#import "PBUserModel.h"
#import "PBKbnMasterModel.h"
#import "UIImageView+WebCache.h"
#import "MyProject.h"
#import "PBAssureCompanyInfo.h"
#import "PBImageScrollView.h"
#define SEARCHONSERVER [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/searchproject",HOST]]
#define BANKURL [NSString stringWithFormat:@"%@/admin/index/addproject",HOST]
@interface PBPublishOpportunity ()
@end
@implementation PBPublishOpportunity
@synthesize userinfos;
@synthesize projectno;
@synthesize mode;
@synthesize type;
@synthesize rootController;
-(void)dealloc
{
    [acitivity release];
    [industry release];
    [LogImageAC=nil release];
    [projectjieshao_tishi=nil release];
    [userinfos release];
    [tradeLabel release];
    [oppTitle release];
    [typeLabel release];
    [content release];
    [projecttype release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewLoding
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-KNavigationBarHeight-KTabBarHeight) style:UITableViewStyleGrouped];
    self.view.frame = self.tableView.frame;
    acitivity = [[PBActivityIndicatorView alloc]initWithFrame:self.view.frame];
    titleArr = [[NSMutableArray alloc]initWithObjects:@"标题:",@"信息类型:",@"所在行业:",@"内容:", @"上传照片:",nil];
    [self initPopView];
    //本地取数据
    industry = [[NSMutableArray alloc]init];
    NSMutableArray *arry1 = [PBIndustryData search:@"industry"];
    for (PBIndustryData * industryData in arry1 ) {
        if (industryData.name != NULL) {
            [industry addObject:industryData.name];
        }
    }
    projecttype = [[NSMutableArray alloc]init];
    NSMutableArray *arry2 = [PBIndustryData search:@"opportunitytype"];
    for (PBIndustryData * industryData in arry2 ) {
        if (industryData.name != NULL) {
            [projecttype addObject:industryData.name];
        }
    }
    [self backButton];
    [self initInputView];
    isedit = NO;
}
-(void)addImage{
    imagepickerview = [[ImagePickerView alloc]initWithView:self];
    imagepickerview.delegate = self;
}
-(void)goNextView:(int)index{
    PBImageScrollView* scroll = [[PBImageScrollView alloc]init];
    scroll.showno = index;
//    scroll.parentsController = self.rootController;
    scroll.nodesMutableArr = mutableImageView.imageArr;
    [self.navigationController pushViewController:scroll animated:YES];
}
#pragma mark - 相册
-(void)resultImage:(UIImage *)image
{
    BOOL repeat = NO;
    NSData* imageData = UIImagePNGRepresentation(image);
    for (UIImage* _image in mutableImageView.imageArr) {//
        NSData* _imageData = UIImagePNGRepresentation(_image);
        if ([_imageData isEqualToData:imageData]) {
            repeat = !repeat;
        }
    }
    if (!repeat) {
        [mutableImageView.imageArr addObject:image];
    }
    [mutableImageView resetImageView];
    
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [oppTitle resignFirstResponder];
    [content resignFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated{
    [acitivity removeFromSuperview];
    [self viewTapped:nil];
    LogImageAC.image = nil;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    mutableImageView = [[PBMutabeImageView alloc]initWithFrame:CGRectMake(5, 5, self.tableView.frame.size.width-(isPad()?110:30), 70)];
    mutableImageView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteImage:) name:@"deleteimage" object:nil];
    
}
-(void)deleteImage:(NSNotification*)notification{
    int index = [(NSString*)notification.object intValue];
    [mutableImageView.imageArr removeObjectAtIndex:index];
    [mutableImageView resetImageView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self.view addSubview:acitivity];
    
}

-(void)initInputView{
    for (int i = 0; i<[titleArr count]; i++){
        CGSize textSize = [[titleArr objectAtIndex:i] sizeWithFont:[UIFont boldSystemFontOfSize:16]];
        CGRect frame = CGRectMake(textSize.width+20, 5, self.tableView.frame.size.width-textSize.width-(isPad()?120:50), 35);
        if (i == 0) {
            oppTitle = [[UITextField alloc]initWithFrame:frame];
        }
        if (i == 1) {
            typeLabel = [[UILabel alloc]initWithFrame:frame];
            typeLabel.backgroundColor = [UIColor clearColor];
            
        }
        if (i == 2) {
            tradeLabel = [[UILabel alloc]initWithFrame:frame];
            tradeLabel.backgroundColor = [UIColor clearColor];
            
        }
        if (i == 3) {
            content = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width-(isPad()?90:20), 60)];
            content.backgroundColor = [UIColor clearColor];
            content.textAlignment = UITextAlignmentLeft;
            content.delegate = self;
            content.tag = 3;
        }
    }
    
}

/*
 上传失败
 */
-(void)requestFilad
{
    [acitivity stopAnimating];
}

#pragma mark - 数据上传到服务器
-(void)postDataOnserver
{
    if ([oppTitle.text length]>0&&[content.text length]>0&&[typeLabel.text length]>0&&[tradeLabel.text length]>0) {
        [acitivity startAnimating];
        PBdataClass *pb = [[PBdataClass alloc]init];
        pb.delegate = self;
        NSString *userid = USERNO;
        NSString *typeno = [NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:typeLabel.text withKind:@"opportunitytype"]];
        NSString *tradeno = [NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:tradeLabel.text withKind:@"industry"]];
        NSArray *a1 = [[NSArray alloc]initWithObjects:@"userno",@"name",@"type",@"trade",@"content", nil];
        NSArray *a2 = [[NSArray alloc]initWithObjects:userid,
                       oppTitle.text,
                       typeno,
                       tradeno,
                       content.text,
                       nil];
        [pb dataResponse:[NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/publishindustryopportunity",HOST]] postDic:[[NSDictionary alloc]initWithObjects:a2 forKeys:a1] searchOrSave:NO];
    }else{
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请完善发布内容" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}
-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue
{
    
    //图片上传
    if ([mutableImageView.imageArr count]>0) {
        PBdataClass *pb = [[PBdataClass alloc]init];
        pb.delegate = self;
        [pb uploadImages:[NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/uploadindustryopportunityicon",HOST]] postImages:mutableImageView.imageArr Forkey:@"uploadedfile" withOtherDic:[NSDictionary dictionaryWithObjectsAndKeys:intvalue,@"no", nil]];
    }else{
        [self nextDidPush];
    }
    
}
-(void)imageIsSuccesePostOnServer:(int)intvalue
{
    if (intvalue > 0) {
        [self nextDidPush];
    }
    else {
        UIAlertView *aletview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"图片上传失败" delegate:self cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) otherButtonTitles:nil, nil];
        [aletview show];
        [aletview release];
        [acitivity stopAnimating];
    }
}
-(void)nextDidPush//跳转下一步
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshOpportunityData" object:nil];
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
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return 1;
}
#pragma mark - cell内容设置
-(void)addSubViewForCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section<3) {
        cell.textLabel.text = [titleArr objectAtIndex:indexPath.section];
    }
    if (indexPath.section == 0) {
        [[cell contentView] addSubview:oppTitle];
        [oppTitle setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [oppTitle setBorderStyle:UITextBorderStyleRoundedRect];
    }
    if (indexPath.section == 1) {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [[cell contentView] addSubview:typeLabel];
    }
    if (indexPath.section == 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [[cell contentView] addSubview:tradeLabel];
    }
    if (indexPath.section == 3) {
        [[cell contentView] addSubview:content];
    }
    if (indexPath.section == 4)
    {
        [[cell contentView] addSubview:mutableImageView];
    }
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section>2) {
        return [titleArr objectAtIndex:section];
    }
    else {
        return NULL;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return [self TishiView];
    }

    return nil;
}

#pragma mark - IPAD 调试
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        return 60.0f;
    }
    if (indexPath.section == 4) {
        return mutableImageView.frame.size.height+10;
    }
    return 44.0f;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 1) {
        [pop.view removeFromSuperview];
        pop._arry = projecttype;
        pop.view.hidden = !pop.view.hidden;
        [pop popClickAction];
    }
    if (indexPath.section == 2) {
        [pop.view removeFromSuperview];
        pop._arry = industry;
        pop.view.hidden = !pop.view.hidden;
        [pop popClickAction];
    }
}
#pragma mark -POPview delegate
- (void)popView:(POPView *)popview didSelectIndexPath:(NSIndexPath *)indexPath{
    if ([pop._arry isEqualToArray:industry]) {
        tradeLabel.text = [popview._arry objectAtIndex:indexPath.row];
    }
    if ([pop._arry isEqualToArray:projecttype]) {
        typeLabel.text = [popview._arry objectAtIndex:indexPath.row];
    }
}


@end
