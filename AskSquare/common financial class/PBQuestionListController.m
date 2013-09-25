//
//  PBQuestionListController.m
//  ParkBusiness
//
//  Created by QDS on 13-5-28.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "QuestionListCell.h"
#import "PBQuestionListController.h"
#import "PBQuestionDetailController.h"
#import "UIImageView+CreditLevel.h"
#define kURLSTRING [NSString stringWithFormat:@"%@admin/index/searchquestioninfolist", HOST]
@interface PBQuestionListController ()

@end

@implementation PBQuestionListController
@synthesize qaNoString, manager, pullController, typeString, titleString, textField, submitBtn, askView;
@synthesize sendmanager;

//实现下拉更新操作
-(void)getDataSource:(PBPullTableViewController *)view
{
    [self requestData:@"1"];
    
}

//点击查看更多按钮
-(void)getMoreButtonDidPush:(PBRefreshTableHeaderView *)view
{
    [self requestData:[NSString stringWithFormat:@"%d",pullController.pageno]];
}

//拖动tableView时实现
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [textField resignFirstResponder];
	[pullController._refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

//停止拖动时
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[pullController._refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(7, 7, 25, 30);
        [backButton setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(popPreView) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = item;
        [item release];
    }
    return self;
}

- (void) popPreView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.title = titleString;
    
    CGFloat viewWidth = isPad() ? 768 : 320;
    CGFloat viewHeight = (isPad() ? 1024 : (isPhone5() ? 568 :480))  - KNavigationBarHeight;
    
    pullController = [[PBPullTableViewController alloc]initWithFrame:CGRectMake(0, 44, viewWidth, viewHeight - 44.0)];
    
    //创建提问窗口
    askView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewHeight, 44)];
    //添加提问对话框
    CGFloat textWidth = isPad() ? 688 : 272;
    textField = [[UITextField alloc] initWithFrame:CGRectMake(8, 8, textWidth - 16, 28.0)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    submitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    submitBtn.frame = CGRectMake(textWidth, 8, isPad() ? 72 : 40, 28);
    [submitBtn setTitle:NSLocalizedString(@"nav_btn_tw", nil) forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [askView addSubview:textField];
    [askView addSubview:submitBtn];
    [self.view addSubview:askView];
    
    pullController.delegate =self;
    pullController.tableViews.delegate = self;
    pullController.tableViews.dataSource = self;
    [self.view addSubview:pullController.tableViews];
    [self.view addSubview:pullController.indicator];
    manager.acIndicator = pullController.indicator;
    
    manager = [[PBManager alloc] init];
    manager.delegate = self;
    [self requestData:@"1"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [textField resignFirstResponder];
}
//提交提问时的操作
- (void) submit
{
    if (textField.text.length > 0) {
        [textField resignFirstResponder];
        submitBtn.enabled = NO;
        
        sendmanager = [[PBSendData alloc] init];
        sendmanager.delegate= self;     
        
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:typeString, @"type", [NSString stringWithFormat:@"%d", [PBUserModel getUserId]], @"userno", qaNoString, @"questionno", textField.text, @"question", nil];
        [sendmanager sendDataWithURL:QUESTIONINFO andValueAndKeyDic:dic];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入问题内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
}

//提问发送成功
- (void) successSendData
{
    textField.text = @"";	
    submitBtn.enabled = YES;
    [pullController.allData removeAllObjects];
    [self requestData:@"1"];
}

- (void) requestData:(NSString*)page
{
    [pullController.indicator startAnimating];
    
    NSDictionary *dataDic = [NSDictionary dictionaryWithObjectsAndKeys:page, @"pageno", qaNoString, @"questionno", typeString, @"type", nil];
    [manager requestBackgroundXMLData:kURLSTRING forValueAndKey:dataDic];
}

#pragma mark -
#pragma mark ParseDataDelegateMethod
- (void) sucessParseXMLData {
    [pullController successGetXmlData:pullController withData:manager.parseData withNumber:10];
//    if (pullController.allData.count > 0 && type.length < 1) {
//        type = [[pullController.allData objectAtIndex:0] objectForKey:@"type"];
//        questionno = [[pullController.allData objectAtIndex:0] objectForKey:@"questionno"];
//    }
}

#pragma mark -
#pragma mark TableViewDataSourse
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [pullController.allData count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"QuestionListCell";
    //cell不能为空
    static BOOL nibsRegisted = NO;
    QuestionListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        nibsRegisted = NO;
    }
    
    if (!nibsRegisted) {
        NSString *nibName = isPad() ? @"QuestionListCell_iPad" : @"QuestionListCell";
        UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        nibsRegisted = YES;
    }
    if (cell==nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    } else {
        [cell.questionLogoImageView removeFromSuperview];
    }
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    [imageView setImage:[[UIImage imageNamed:@"fillcell.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]];
    cell.backgroundView = imageView;
    [imageView release];
    
    if([pullController.allData count]>0) {
        NSDictionary *dic = [pullController.allData objectAtIndex:indexPath.row];
        cell.questionAskNameLabel.text = [dic objectForKey:@"userno"];
        
        //问题的LOGO已固定从。。以后更改
        NSString *logoURLStr = [NSString stringWithFormat:@"%@upd/usermasterimage/default.jpg", HOST];
        CGFloat originX = isPad() ? 10 : 1;
        cell.questionLogoImageView = [[CustomImageView alloc]initWithFrame:CGRectMake(originX, 1, 64, 64)];
        [[cell contentView] addSubview:cell.questionLogoImageView];
        [cell.questionLogoImageView.imageView loadImage: logoURLStr];
        [cell.starImage setStarImageWithCredit:[[dic objectForKey:@"credit"] intValue]];
        cell.questionTimeLabel.text = [dic objectForKey:@"cdate"];
        //这里显示职务
        cell.questionLabel.text = [dic objectForKey:@"question"];
    }
    return cell;
}


#pragma mark -
#pragma mark TableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PBQuestionDetailController *controller = [[PBQuestionDetailController alloc] init];
    controller.noString = [[pullController.allData objectAtIndex:indexPath.row] objectForKey:@"no"];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidUnload {
    [self setAskView:nil];
    [self setSendmanager:nil];
    [self setSubmitBtn:nil];
    [self setTextField:nil];
    [self setTitleString:nil];
    [self setTypeString:nil];
    [self setManager:nil];
    [self setPullController:nil];
    [self setQaNoString:nil];
    [super viewDidUnload];
}

- (void) dealloc {
    [askView release];
    [sendmanager release];
    [submitBtn release];
    [textField release];
    [titleString release];
    [typeString release];
    [manager release];
    [pullController release];
    [qaNoString release];
    [super dealloc];
}

@end
