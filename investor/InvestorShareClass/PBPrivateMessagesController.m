//
//  PBPrivateMessagesController.m
//  ParkBusiness
//
//  Created by QDS on 13-3-22.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBPrivateMessagesController.h"
#import "PBUserModel.h"

#define kURLSTRING [NSString stringWithFormat:@"%@admin/index/insertmessage", HOST]

@interface PBPrivateMessagesController ()

@end

@implementation PBPrivateMessagesController
@synthesize messageInvesterNo;
@synthesize textCountLabel;
@synthesize messageTextView;
@synthesize sendManager;
@synthesize messageTitleTextFiled;
@synthesize indicator;
@synthesize privateMessageTabel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        UIButton *sbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sbtn.frame = CGRectMake(6, 6, 48, 32);
        [sbtn setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"send_btn_bg.png"]]];
        [sbtn setTitle:@"发送" forState:UIControlStateNormal];
        sbtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [sbtn addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *sendBtn = [[UIBarButtonItem alloc] initWithCustomView:sbtn];
        self.navigationItem.rightBarButtonItem = sendBtn;
        [sendBtn release];

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(7, 7, 25, 30);
        [btn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(popBackAgoView) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = backBarBtn;
        [backBarBtn release];
    }
    return self;
}

- (void) popBackAgoView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"发私信";
    resultString = [NSString string];
    
//    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
//    [defaultCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [self keyboardDown];
}

#pragma mark - 
#pragma mark TableViewDataSourceMethod
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CellIdentifier";
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, 54, 21)];
        label1.text = @"标题：";
        label1.font = [UIFont systemFontOfSize:14.0];
        label1.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:label1];
        [label1 release];
        
        messageTitleTextFiled = [[UITextField alloc] initWithFrame:CGRectMake(50, 14, isPad() ? 620 : 240, 21)];
        messageTitleTextFiled.backgroundColor = [UIColor clearColor];
        messageTitleTextFiled.placeholder = @"输入私信标题";
        messageTitleTextFiled.font = [UIFont systemFontOfSize:(isPad() ? PadContentFontSize : ContentFontSize)];
        [cell.contentView addSubview:messageTitleTextFiled];
    } else {
        messageTextView = [[UITextView alloc] initWithFrame:CGRectMake(6, 6, isPad() ? 668 : 288, isPad() ? 100 : 160)];
        messageTextView.delegate = self;
        messageTextView.font = [UIFont systemFontOfSize:isPad() ? PadContentFontSize : ContentFontSize];
        [cell.contentView addSubview:messageTextView];
        
        textCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(isPad() ? 528 : 140, isPad() ? 103 : 163, 140, 21)];
        textCountLabel.font = [UIFont systemFontOfSize:isPad() ? PadContentFontSize :ContentFontSize];
        textCountLabel.text = @"您还可以输入300个字";
        textCountLabel.textAlignment = UITextAlignmentRight;
        textCountLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:textCountLabel];
    }
    return cell;
}


#pragma mark -
#pragma mark TableViewDelegateMethod
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = isPad() ? 122.0 : 182.0;
    if (indexPath.section == 0) {
        height = 44.0;
    }
    return height;
}



#pragma mark -
#pragma mark TextViewDelegateMethod
//发送私信需要限制字数，当字数超过300时应该禁止继续输入
- (void) textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 300) {
        textView.text = [textView.text substringToIndex:300];
    }
    textCountLabel.text = [NSString stringWithFormat:@"您还可以输入%u个字", 300 - [messageTextView.text length]];
}


- (void) textViewDidBeginEditing:(UITextView *)textView
{
    if (!isPad() && !isPhone5()) {
        CGRect frame = privateMessageTabel.frame;
        frame.origin.y = [[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString:@"en-US"] ? -40 : -80;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.3];
        privateMessageTabel.frame = frame;
        [UIView commitAnimations];
    }
}

//获取键盘的高度
//- (void) keyboardWillShow:(NSNotification *) aNotification
//{
//    NSDictionary *userInfo = [aNotification userInfo];
//    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    CGRect keybordRect = [aValue CGRectValue];
//    keybordHeight = keybordRect.size.height;
//}

- (void) sendMessage {
    if (messageTitleTextFiled.text.length == 0) {
        [self alertWarning:@"请输入私信标题"];
    }  else if (messageTextView.text.length == 0) {
        [self alertWarning:@"请输入私信内容"];
    }
    
    if (messageTextView.text.length != 0 && messageTitleTextFiled.text.length != 0) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        indicator = [[PBActivityIndicatorView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:indicator];
        [indicator startAnimating];
        sendManager = [[PBSendData alloc] init];
        sendManager.delegate = self;
        NSDictionary *sendDic = [NSDictionary dictionaryWithObjectsAndKeys:messageTitleTextFiled.text, @"title", messageTextView.text, @"content", USERNO, @"suserno", messageInvesterNo, @"ruserno", nil];
        [sendManager sendDataWithURL:kURLSTRING andValueAndKeyDic:sendDic];
    }
}

#pragma mark -
#pragma mark SuccessSendMessageMethod
- (void) successSendData
{
    [indicator stopAnimating];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    if ([sendManager.warnSting isEqualToString:@"failed"]) {
        [self alertWarning:@"私信发送失败"];
    } else {
        [self alertWarning:@"私信发送成功"];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) alertWarning:(NSString *) str
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"私信" message:str delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
    [alert show];
    [alert release];
}

//隐藏键盘
-(void)keyboardDown
{
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [messageTextView resignFirstResponder];
    CGRect frame = privateMessageTabel.frame;
    frame.origin.y = 0;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    privateMessageTabel.frame = frame;
    [UIView commitAnimations];

    [messageTitleTextFiled resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    [indicator release];
    [messageInvesterNo release];
    [messageTitleTextFiled release];
    [textCountLabel release];
    [privateMessageTabel release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setPrivateMessageTabel:nil];
    [self setIndicator:nil];
    [self setMessageTitleTextFiled:nil];
    [self setTextCountLabel:nil];
    [self setMessageTextView:nil];
    [self setMessageInvesterNo:nil];
    [self setPrivateMessageTabel:nil];
    [super viewDidUnload];
}

@end
