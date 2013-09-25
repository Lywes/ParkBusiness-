//
//  PBMyNeedsSelectView.m
//  ParkBusiness
//
//  Created by wangzhigang on 13-7-12.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBMyNeedsSelectView.h"
#import "UIImage+Scale.h"
#define FURL [NSString stringWithFormat:@"%@admin/index/submitfinanceneeds", HOST]
#define MURL [NSString stringWithFormat:@"%@admin/index/submitmanagemoneyneeds", HOST]
@interface PBMyNeedsSelectView ()

@end

@implementation PBMyNeedsSelectView
@synthesize dic;
@synthesize type;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(7, 7, 25, 30);
        [btn addTarget:self action:@selector(backHomeView) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = barButton;
        UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(saveGroupChange)];
        self.navigationItem.rightBarButtonItem=rightButton;
        self.title = @"请选择专委会";
        [barButton release];
        [rightButton release];
    }
    return self;
}
-(void)backHomeView{
    [self dismissModalViewControllerAnimated:YES];
}
- (void)saveGroupChange{//保存群组信息
    NSString* boardnos = @"";
    for (int i=0;i<[checkArr count]; i++) {
        if ([[checkArr objectAtIndex:i] boolValue]) {
            boardnos = [NSString stringWithFormat:@"%@,%d",boardnos,i+1];
        }
    }
    if ([boardnos length]>0) {
        [indicator startAnimating];
        PBWeiboDataConnect* connect = [[PBWeiboDataConnect alloc]init];
        connect.delegate = self;
        boardnos = [boardnos substringFromIndex:1];
        [dic setObject:boardnos forKey:@"institudes"];
        [dic setObject:type forKey:@"type"];
        [connect submitDataFromUrl:[type isEqualToString:@"1"]?FURL:MURL postValuesAndKeys:dic];
    }else{
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请至少选择一个专业委员会" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

-(void)sucessSendPostData:(PBWeiboDataConnect *)weiboDatas{
    [self dismissModalViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sucessSendData" object:nil];
}
- (void)dealloc
{
    [super dealloc];
    [allData release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    allData = [[NSMutableArray alloc]init];
    checkArr = [[NSMutableArray alloc]init];
    NSArray* arr = [PBKbnMasterModel getKbnInfoByKind:@"policytype"];
    for (PBKbnMasterModel* model in arr) {
        [allData addObject:model.name];
        [checkArr addObject:[NSNumber numberWithBool:FALSE]];
    }
    indicator = [[PBActivityIndicatorView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:indicator];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [allData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    NSString *checkImage = [[checkArr objectAtIndex:indexPath.row] boolValue]?@"plugin_open":@"like_headbg";
    cell.imageView.image = [[UIImage imageNamed:checkImage] scaleToSize:CGSizeMake(27.0f, 27.0f)];
    cell.textLabel.text = [allData objectAtIndex:indexPath.row];
    
    // Configure the cell...
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    BOOL check = ![[checkArr objectAtIndex:indexPath.row] boolValue];
    [checkArr replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:check]];
    NSString *checkImage = check?@"plugin_open":@"like_headbg";
    cell.imageView.image = [[UIImage imageNamed:checkImage] scaleToSize:CGSizeMake(27.0f, 27.0f)];
}
@end
