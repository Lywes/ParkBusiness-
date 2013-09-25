//
//  PBFinanceAuctionDetail.m
//  ParkBusiness
//
//  Created by 上海 on 13-6-26.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBFinanceAuctionDetail.h"
#import "CustomImageView.h"
#import "PBAuctionProcess.h"
#import "PBRemarkListController.h"
#import "PBImageScrollView.h"
#define URL [NSString stringWithFormat:@"%@/admin/index/auctionfinanceproduct",HOST]
@interface PBFinanceAuctionDetail ()

@end

@implementation PBFinanceAuctionDetail
@synthesize rootController;
@synthesize dataDic;
@synthesize image;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    self.tableView.backgroundColor = [UIColor clearColor];
    titleArr = [[NSMutableArray alloc]initWithObjects:@"名称:",@"介绍:",@"竞拍人数:",@"起拍价(元):",@"最新出价(元):",@"竞价过程",@"产品图片",@"产品视频",@"拍卖须知", nil];
    endLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 5, 200, 30)];
    endLabel.backgroundColor = [UIColor clearColor];
    endLabel.font = [UIFont systemFontOfSize:isPad()?14:12];
    endLabel.textAlignment = UITextAlignmentCenter;
    [dataDic setObject:@"拍卖须知拍卖须知拍卖须知拍卖须知拍卖须知拍卖须知拍卖须知拍卖须知拍卖须知拍卖须知拍卖须知拍卖须知拍卖须知拍卖须知拍卖须知拍卖须知拍卖须知拍卖须知拍卖须知拍卖须知拍卖须知拍卖须知拍卖须知拍卖须知拍卖须知拍卖须知拍卖须知拍卖须知拍卖须知拍卖须知" forKey:@"auctioninfo"];
    [self initAuctionView];
    indicator = [[PBActivityIndicatorView alloc]initWithFrame:self.navigationController.view.frame];
    [self.rootController.view addSubview:indicator];
    //评论
    UIButton *remarkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    remarkBtn.frame = isPad()?CGRectMake(6, 6, 42, 30):CGRectMake(6, 6, 33, 26);
    [remarkBtn setBackgroundImage:[UIImage imageNamed:@"product_re.png"] forState:UIControlStateNormal];
    [remarkBtn addTarget:self action:@selector(remark) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *remarkBtnItem = [[UIBarButtonItem alloc] initWithCustomView:remarkBtn];
    self.navigationItem.rightBarButtonItem = remarkBtnItem;
    [remarkBtnItem release];
    inputToolbar = [[UIInputToolbar alloc] initWithFrame:CGRectMake(0, isPad()?1024:(isPhone5()?568:480), isPad()?768:320, 40)];
    inputToolbar.delegate = self;
    inputToolbar.textView.placeholder = @"请输入提问";
    [self.navigationController.view addSubview:inputToolbar];
    [inputToolbar addObserverFromController:self];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewDidUnload{
    [super viewDidUnload];
    [inputToolbar removeObserverFromController:self];
}
-(void)inputButtonPressed:(NSString *)inputText
{
    [indicator startAnimating];
    sendmanager = [[PBWeiboDataConnect alloc] init];
    sendmanager.delegate= self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"5", @"type", [NSString stringWithFormat:@"%d", [PBUserModel getUserId]], @"userno", [self.dataDic objectForKey:@"no"], @"commentno", inputText, @"content", nil];
    [sendmanager submitDataFromUrl:REMARKINFO postValuesAndKeys:dic];
    
}
- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    [inputToolbar keyboardWillShowHide:notification];
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    [inputToolbar keyboardWillShowHide:notification];
    [inputToolbar keyboardWillHide];
}
//评论
- (void) remark
{
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) destructiveButtonTitle:nil otherButtonTitles:@"我要评论",@"评论列表", nil];
    [sheet showInView:self.navigationController.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [inputToolbar.textView becomeFirstResponder];
            break;
        case 1:{
            PBRemarkListController *controller = [[PBRemarkListController alloc] init];
            //需要传递一些参数过去
            NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:self.dataDic];
            [dic setObject:@"5" forKey:@"remarktype"];
            controller.infoDic = dic;
            [self.navigationController pushViewController: controller animated:YES];
            [controller release];
        }
            break;
        default:
            break;
    }
}
-(void)initAuctionView{//初始化竞价界面
    auctionView = [[UIView alloc]initWithFrame:self.rootController.view.frame];
    auctionView.hidden = YES;
    auctionView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.rootController.view addSubview:auctionView];
    UIView* middleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, auctionView.frame.size.width*3/4, 150)];
    middleView.backgroundColor = [UIColor whiteColor];
    middleView.center = auctionView.center;
    [auctionView addSubview:middleView];
    [middleView release];
    UIButton* cancelBtn = [self customBarButton:NSLocalizedString(@"nav_btn_qx", nil)];
    cancelBtn.titleLabel.font   = [UIFont boldSystemFontOfSize:13.0f];
    cancelBtn.tag = 1;
    UIButton* submitBtn = [self customBarButton:@"确定"];
    submitBtn.titleLabel.font   = [UIFont boldSystemFontOfSize:13.0f];
    cancelBtn.center = CGPointMake(middleView.frame.size.width/4, middleView.frame.size.height-30);
    submitBtn.center = CGPointMake(middleView.frame.size.width*3/4, middleView.frame.size.height-30);
    [middleView addSubview:cancelBtn];
    [middleView addSubview:submitBtn];
    CGFloat middleheight = middleView.frame.size.height/3;
    minus = [UIButton buttonWithType:UIButtonTypeCustom];
    minus.enabled = NO;
    minus.tag = 1;
    minus.frame = CGRectMake(40, middleheight, 20, 20);
    [minus setBackgroundImage:[UIImage imageNamed:@"product_minus.png"] forState:UIControlStateNormal];
    UIButton* add = [UIButton buttonWithType:UIButtonTypeCustom];
    add.frame = CGRectMake(middleView.frame.size.width-50, middleheight, 20, 20);
    [add setBackgroundImage:[UIImage imageNamed:@"product_add.png"] forState:UIControlStateNormal];
    [add addTarget:self action:@selector(addPrice:) forControlEvents:UIControlEventTouchUpInside];
    [minus addTarget:self action:@selector(addPrice:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn addTarget:self action:@selector(submitDidPush:) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn addTarget:self action:@selector(submitDidPush:) forControlEvents:UIControlEventTouchUpInside];
    [middleView addSubview:add];
    [middleView addSubview:minus];
    nowprice = [[[dataDic objectForKey:@"nowprice"] substringFromIndex:1] intValue];
    priceField = [[UITextField alloc]initWithFrame:CGRectMake(middleView.frame.size.width/2-30, middleheight, 70, 30)];
    priceField.borderStyle = UITextBorderStyleLine;
    priceField.text = [NSString stringWithFormat:@"￥%d",nowprice];
    priceField.enabled = NO;
    [middleView addSubview:priceField];
//    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
//    tapGr.cancelsTouchesInView = NO;
//    [auctionView addGestureRecognizer:tapGr];
}
-(void)addPrice:(UIButton*)sender{
    if (sender.tag==1) {
        nowprice -= 100;
    }else{
        nowprice += 100;
    }
    priceField.text = [NSString stringWithFormat:@"￥%d",nowprice];
    if (nowprice > [[[dataDic objectForKey:@"nowprice"] substringFromIndex:1] intValue]) {
        minus.enabled = YES;
    }else{
        minus.enabled = NO;
    }
}

-(void)submitDidPush:(UIButton*)sender{
    if (sender.tag==1) {
        [self setAuctionViewHidden:YES];
    }else{
        [indicator startAnimating];
        PBWeiboDataConnect* connect = [[PBWeiboDataConnect alloc]init];
        connect.delegate = self;
        NSArray* arr1 = [[NSArray alloc]initWithObjects:[dataDic objectForKey:@"no"],USERNO,[NSString stringWithFormat:@"%d",[PBUserModel getCompanyno]],[NSString stringWithFormat:@"%d",nowprice], nil];
        NSArray* arr2 = [[NSArray alloc]initWithObjects:@"productno",@"userno",@"companyno",@"price", nil];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjects:arr1 forKeys:arr2];
        [connect submitDataFromUrl:URL postValuesAndKeys:dic];
    }
}
-(void)sucessSendPostData:(PBWeiboDataConnect *)weiboDatas{
    NSString* str = weiboDatas.receiveStr;
    [indicator stopAnimating];
    if (sendmanager==weiboDatas) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"评论信息已提交" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        if ([[str substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"0"]) {
            nowprice = [[str substringFromIndex:1] intValue];
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"竞价过低！请重新输入！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            [self setAuctionViewHidden:YES];
            [dataDic setObject:[NSString stringWithFormat:@"￥%d",nowprice] forKey:@"nowprice"];
            [self.tableView reloadData];
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"已成功出价！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}
-(UIButton*)customBarButton:(NSString *)buttonLabel{
    /* Create custom send button*/
    UIImage *buttonImage = [UIImage imageNamed:@"buttonbg.png"];
    buttonImage          = [buttonImage stretchableImageWithLeftCapWidth:floorf(buttonImage.size.width/2) topCapHeight:floorf(buttonImage.size.height/2)];
    
    UIButton *button               = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.shadowOffset = CGSizeMake(0, -1);
    button.titleEdgeInsets         = UIEdgeInsetsMake(0, 2, 0, 2);
    button.contentStretch          = CGRectMake(0.5, 0.5, 0, 0);
    button.contentMode             = UIViewContentModeScaleToFill;
    
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setTitle:buttonLabel forState:UIControlStateNormal];
    [button sizeToFit];
    return button;
}
-(void)viewTapped:(UITapGestureRecognizer*)tapGr{//点击阴影画面操作
    
    [self setAuctionViewHidden:YES];
    
}
-(void)auctionDidPush{//点击我要出价按钮
    [self setAuctionViewHidden:NO];
}
-(void)setAuctionViewHidden:(BOOL)hidden{//是否隐藏出价界面
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    auctionView.hidden = hidden;
    [UIView commitAnimations];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

//自定义textView显示高度
-(CGFloat) heightForTextView:(NSString*)contentStr
{
    CGSize size = [contentStr sizeWithFont:[self getTextFont] constrainedToSize:CGSizeMake(isPad() ? 480 : 210, 1000) lineBreakMode:UILineBreakModeWordWrap];
    return MAX(42.0, size.height);
}

- (UIFont *) getTextFont
{
    return [UIFont systemFontOfSize:isPad() ? 14 : 12];
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 44.0f;
    switch (indexPath.section) {
        case 0:
        {
            height = 80.0f;
            break;
        }
        case 1:
        {
            NSString *str = [dataDic  objectForKey:@"introduce"];
            height = [self heightForTextView:str] + 10;
            break;
        }
        case 8:
        {
            NSString *str = [dataDic  objectForKey:@"auctioninfo"];
            CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:isPad()?14:12] constrainedToSize:CGSizeMake(isPad() ? 480 : 210, 1000) lineBreakMode:UILineBreakModeWordWrap];
            height = MAX(42.0, size.height)+10;
            break;
        }
        default:
            break;
    }
    return height;
}
- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1||section==8) {
        return [titleArr objectAtIndex:section];
    }
    return  nil;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {//倒计时设置
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateLabel) userInfo:nil repeats:YES];
        // Timer运行开始
        endLabel.text = [self updateLabel].text ;//时间
        NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateLabel) userInfo:nil repeats:YES];
        [runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
        return endLabel;
    }
    if (section == 7){//我要出价按钮
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, isPad()?55:40)];
        UIButton* auctionbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        auctionbtn.frame = isPad()?CGRectMake(0,0, 350, 45): CGRectMake(0,0, 208, 33);
        auctionbtn.center = view.center;
        [auctionbtn setBackgroundImage:[UIImage imageNamed:@"product_auctionbtn.png"] forState:UIControlStateNormal];
        [auctionbtn addTarget:self action:@selector(auctionDidPush) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:auctionbtn];
        return view;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 30;
    }
    if (section == 7) {
        return isPad()?55:40;
    }
    return 0;
}
//倒计时
-(UILabel*)updateLabel
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* enddate = [formatter dateFromString:[dataDic objectForKey:@"enddate"]];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    int units = NSDayCalendarUnit | NSHourCalendarUnit| NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *components = [calendar components:units fromDate:[NSDate date] toDate:enddate options:0];
    NSString* dateStr = [NSString stringWithFormat:@"%d天%d小时%d分%d秒", [components day], [components hour], [components minute], [components second]];
    [endLabel setText:[NSString stringWithFormat:@"倒计时:%@",dateStr]];
    return endLabel;
}
#pragma mark UITableViewDataSourceMethod

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, isPad() ?3:0, tableView.frame.size.width-40,isPad() ?30: 40)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:isPad()?16:14];
    titleLabel.text = [titleArr objectAtIndex:indexPath.section];
    switch (indexPath.section) {
        case 0:
        {
            CustomImageView *bossPhotoImageView = [[CustomImageView alloc] initWithFrame:isPad() ?CGRectMake(5, 2, 110 , 70):CGRectMake(5, 5, 90 , 60)withBackColor:[UIColor whiteColor]];
            [bossPhotoImageView.imageView setImage:self.image];
            [cell.contentView addSubview:bossPhotoImageView];
            [bossPhotoImageView release];
            
            CGFloat originX2 = isPad() ? 130 : 110;
            UIImageView *imageaView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"projectname.png"]];
            imageaView1.frame = CGRectMake(originX2, 12, 21, 21);
            [cell.contentView addSubview:imageaView1];
            [imageaView1 release];
            
            UIImageView *imageaView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trade.png"]];
            imageaView2.frame = CGRectMake(originX2, 42, 21, 21);
            [cell.contentView addSubview:imageaView2];
            [imageaView2 release];
            
            CGFloat originX3 = isPad() ? 160 : 140;
            CGFloat labelWidth = isPad() ? 500 : 150;
            UILabel *bossNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX3, isPad()?6:2, labelWidth,isPad() ?30: 40)];
            bossNameLabel.numberOfLines = 0;
            bossNameLabel.text = [dataDic objectForKey:@"name"];
            bossNameLabel.backgroundColor = [UIColor clearColor];
            bossNameLabel.font = [self getTextFont];
            [cell.contentView addSubview:bossNameLabel];
            [bossNameLabel release];
            
            UILabel *bossIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX3, 35, labelWidth, 35)];
            bossIDLabel.text = [dataDic objectForKey:@"state"];
            bossIDLabel.numberOfLines = 0;
            bossIDLabel.backgroundColor = [UIColor clearColor];
            bossIDLabel.font = [self getTextFont];
            [cell.contentView addSubview:bossIDLabel];
            [bossIDLabel release];
            break;
        }
        case 1:
        {
            CGFloat textWidth = isPad() ? 670 : 280;
            NSString *str = [dataDic  objectForKey:@"introduce"];
            UILabel *signatureTextView = [[UILabel alloc] initWithFrame:CGRectMake(isPad() ? 8 : 4, 2, textWidth, [self heightForTextView:str])];
            signatureTextView.numberOfLines = 0;
            signatureTextView.text = str;
            signatureTextView.font = [self getTextFont];
            signatureTextView.backgroundColor = [UIColor clearColor];
            [cell.contentView addSubview:signatureTextView];
            [signatureTextView release];
            break;
        }
        case 2:
            titleLabel.text = [NSString stringWithFormat:@"%@  %@人",titleLabel.text,[dataDic objectForKey:@"number"]];
            break;
        case 3:
            titleLabel.text = [NSString stringWithFormat:@"%@  %@",titleLabel.text,[dataDic objectForKey:@"startprice"]];
            break;
        case 4:
            titleLabel.text = [NSString stringWithFormat:@"%@  %@",titleLabel.text,[dataDic objectForKey:@"nowprice"]];
            break;
        case 5:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            break;
        case 6:
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 7:
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 8:{
            NSString *str = [dataDic  objectForKey:@"auctioninfo"];
            titleLabel.numberOfLines = 0;
            titleLabel.font = [UIFont systemFontOfSize:isPad()?14:12];
            CGSize size = [str sizeWithFont:titleLabel.font constrainedToSize:CGSizeMake(isPad() ? 480 : 210, 1000) lineBreakMode:UILineBreakModeWordWrap];
            CGFloat height = MAX(42.0, size.height);
            titleLabel.frame = CGRectMake(10, 0, isPad()?tableView.frame.size.width-100:tableView.frame.size.width-40, height);
            titleLabel.text = [dataDic objectForKey:@"auctioninfo"];
        }
            break;
        default:
            break;
    }
    if (indexPath.section>1&&indexPath.section<=8) {
        
        [cell.contentView addSubview:titleLabel];
        
    }
    [titleLabel release];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==5) {
        PBAuctionProcess* process = [[PBAuctionProcess alloc]init];
        process.no = [dataDic objectForKey:@"no"];
        process.title  = [titleArr objectAtIndex:indexPath.section];
        [self.navigationController pushViewController:process animated:YES];
    }
    if(indexPath.section==6){
        PBImageScrollView* scroll = [[PBImageScrollView alloc]init];
        scroll.parentsController = self.rootController;
        scroll.urlStr = [NSString stringWithFormat:@"%@/admin/index/searchauctionmedia",HOST];
        scroll.data = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[dataDic objectForKey:@"no"],@"no",@"1",@"type", nil];
        [self.navigationController pushViewController:scroll animated:YES];
    }

}

@end
