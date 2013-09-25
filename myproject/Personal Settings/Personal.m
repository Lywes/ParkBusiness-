//
//  Personal.m
//  ParkBusiness
//
//  Created by lywes lee on 13-2-27.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#define SWITCH 300
#import "Personal.h"
#import "PBShezhiData.h"
#import "PBUserModel.h"
@interface Personal ()

@end

@implementation Personal
@synthesize _datas,flag;
-(void)dealloc
{
    [_tableview release];
    [_dataarry  release];
    [_switcharry release];
    [self._datas release];
    [super dealloc];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    _tableview = nil;
    _dataarry = nil;
    _switcharry = nil;
    self._datas = nil;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    int a = [PBUserModel getUserId];
    self._datas = [PBShezhiData searchBy:a];
    PBShezhiData *data = [self._datas objectAtIndex:0];
    int soundno = data.soundflg;
    int messageno = data.messageflg;
    int showno = data.showflg;
    for (int i=0;i<3;i++) {
        UISwitch *sw = [_switcharry objectAtIndex:i];
        if (i == 0) {
            if (soundno == 0) {
                [sw setOn:NO];
            }
            else {
                [sw setOn:YES];
            }
        }
        if (i == 1) {
            if (messageno == 0) {
                [sw setOn:NO];
            }
            else {
                [sw setOn:YES];
            }
        }
        if (i == 2) {
            if (showno == 0) {
                [sw setOn:NO];
            }
            else {
                [sw setOn:YES];
            }
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"个人设置";
    //左返回按钮
    if (![self.flag isEqualToString:@"setting"]) {
//        UIImage *image = [UIImage imageNamed:@"back.png"];
//        UIButton *lefbt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];;
//        [lefbt setBackgroundImage:image forState:UIControlStateNormal];
//        [lefbt addTarget:self action:@selector(backUpView) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *leftbutton = [[[UIBarButtonItem alloc]initWithCustomView:lefbt]autorelease];
//        self.navigationItem.leftBarButtonItem = leftbutton;
    }
    //tableview
    _tableview = [[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped]autorelease];
    if (isPad()) {
        _tableview.frame = CGRectMake(0, 0, 768, 1024);
    }
      _tableview.delegate = self;
    _tableview.dataSource = self;
    [self.view addSubview:_tableview];
    //datasource
    _dataarry = [[NSMutableArray alloc]init];
    NSArray *shezhi = [[[NSArray alloc]initWithObjects:@"声音提示",@"接收私信",@"园内隐身" ,nil]autorelease];
    NSArray *data = [NSArray arrayWithObjects:@"个人帐户",shezhi,@"反馈意见", nil];
    [_dataarry addObjectsFromArray:data];
    //switch
    _switcharry = [[NSMutableArray alloc]init];
    for (int i = 0; i<3; i++) {
        UISwitch *sw = [[UISwitch alloc]init];
        sw.tag = SWITCH+i;
        if (isPad()) {
            sw.center = CGPointMake(RATIO*250, 25);
        }
        else {
            sw.center = CGPointMake(250, 25);
        }
        sw.on = YES;
        [sw addTarget:self action:@selector(switchPress:) forControlEvents:UIControlEventValueChanged];
        [_switcharry addObject:sw];
    }
}
-(void)switchPress:(id)sender
{
    UISwitch *sw = (UISwitch *)sender;
    [sw setOn:sw.on animated:YES];
    if (sw.on == YES) {
        flagno = 1;
    }
    if (sw.on == NO) {
        flagno = 0;
    }
    PBdataClass *pdataclass = [[PBdataClass alloc]init];
    pdataclass.delegate = self;
    if (sw.tag == SWITCH) {
        flagname = @"soundflg";
    }
    if (sw.tag == SWITCH +1) {
        flagname = @"messageflg";
    }
    if (sw.tag == SWITCH+2) {
        flagname = @"showflg";
    }
    [pdataclass dataResponse:[NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/setusermasterflg",HOST]] postDic:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",flagno],flagname,USERNO,@"no", nil] searchOrSave:NO];
}
-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue
{
    if ([flagname isEqualToString:@"soundflg"]) {
        [PBShezhiData SaveSound:flagno useid:[PBUserModel getUserId]];
    }
    if ([flagname isEqualToString:@"messageflg"]) {
        [PBShezhiData SaveMessage:flagno useid:[PBUserModel getUserId]];
    }
    if ([flagname isEqualToString:@"showflg"]) {
        [PBShezhiData SaveShow:flagno useid:[PBUserModel getUserId]];
    }
  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 1) {
        return [self.flag isEqualToString:@"setting"]?2:3;
    }
    else
        return 1;
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text = [_dataarry objectAtIndex:0];
        cell.imageView.image = [UIImage imageNamed:@"shezhi0.png"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 1) {
        cell.textLabel.text = [[_dataarry objectAtIndex:1]objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"shezhi%d.png",indexPath.row+1]];
        [cell.contentView addSubview:[_switcharry objectAtIndex:indexPath.row]];
    }
    if (indexPath.section == 2) {
        cell.textLabel.text = [_dataarry objectAtIndex:2];
        cell.imageView.image = [UIImage imageNamed:@"shezhi4.png"];
         cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (setting) {
            [setting release];
        }
        if ([self.flag isEqualToString:@"setting"]) {
            setting = [[PBSettings alloc]initWithStyle:UITableViewStyleGrouped withString:@"投资相关设置"];
            self._datas = setting.datas;
        }
        else
        {
            setting = [[PBSettings alloc]initWithStyle:UITableViewStyleGrouped withString:@"行业划分:"];
            self._datas = setting.datas;
        }
        [self.navigationController pushViewController:setting animated:YES];
    }
    if (indexPath.section == 2) {
        if (!pbfankui) {
            pbfankui = [[PBfankui alloc]initWithStyle:UITableViewStyleGrouped];
        }
        [self.navigationController pushViewController:pbfankui animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0f;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
