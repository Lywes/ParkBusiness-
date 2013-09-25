//
//  ViewController.m
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

// 
// Images used in this example by Petr Kratochvil released into public domain
// http://www.publicdomainpictures.net/view-image.php?image=9806
// http://www.publicdomainpictures.net/view-image.php?image=1358
//

#import "FAPeopleChatView.h"
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"
#import "FAFriendData.h"
#import "FAGroupData.h"
#import "FAMessageData.h"
#import "FAUserData.h"
#import "FAChatManager.h"
#import "UIView+AnimationOptionsForCurve.h"
@interface FAPeopleChatView ()
{
    IBOutlet UIBubbleTableView *bubbleTable;

    NSMutableArray *bubbleData;
    
}
-(void)originalBubbleTable:(NSNotification*)aNotification;
@end

@implementation FAPeopleChatView
@synthesize friendid,groupid,readflg,inputToolbar,groupflg,friendname,imgpath,actionflg;
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        actionflg = 0;
    }
    return self;
}
-(void)originalBubbleTable:(NSNotification*)aNotification
{
    NSMutableArray *resdata = [NSMutableArray array];
    NSMutableArray *messagedata = [NSMutableArray array];
    if (self.groupid>0) {
        resdata = [FAGroupData search:self.groupid name:nil limit:-1];
        FAGroupData *data = [resdata objectAtIndex:0];
        if (self.groupflg>0&&self.actionflg == 0) {
            messagedata = [FAMessageData searchByFriendid:self.friendid groupid:self.groupid isreadflg:self.readflg];
            FAMessageData *frienddata = [messagedata objectAtIndex:0];
            self.title = frienddata.friendname;
        }else{
            messagedata = [FAMessageData searchByFriendid:-1 groupid:self.groupid isreadflg:self.readflg];
            self.title = data.groupname;
        }
    }else{
        resdata = [FAFriendData search:self.friendid friendgroupid:-1 name:nil limit:-1];
        FAFriendData *frienddata = [resdata objectAtIndex:0];
        self.title = frienddata.friendname;
        messagedata = [FAMessageData searchByFriendid:self.friendid groupid:-1 isreadflg:self.readflg];
    }
    FAMessageData *message;
    bubbleData = [NSMutableArray array];
    [bubbleData retain];
    FAUserData *user = [FAUserData search];
    for (int i=0; i<[messagedata count]; i++) {
        message = [messagedata objectAtIndex:i];
        NSBubbleData *textBubble;
        if (message.whosaid==0) {
            textBubble = [NSBubbleData dataWithText:message.content date:message.createtime type:BubbleTypeSomeoneElse];
            textBubble.imgpath = message.imgpath;
        }else{
            textBubble = [NSBubbleData dataWithText:message.content date:message.createtime type:BubbleTypeMine];
            textBubble.avatar = user.icon;
        }
        
        [bubbleData addObject:textBubble];
    }
    /*NSBubbleData *heyBubble = [NSBubbleData dataWithText:@"Hey, halloween is soon" date:[NSDate dateWithTimeIntervalSinceNow:-300] type:BubbleTypeSomeoneElse];
     heyBubble.avatar = [UIImage imageNamed:@"avatar1.png"];
     
     NSBubbleData *photoBubble = [NSBubbleData dataWithImage:[UIImage imageNamed:@"halloween.jpg"] date:[NSDate dateWithTimeIntervalSinceNow:-290] type:BubbleTypeSomeoneElse];
     photoBubble.avatar = [UIImage imageNamed:@"avatar1.png"];
     
     NSBubbleData *replyBubble = [NSBubbleData dataWithText:@"Wow.. Really cool picture out there. iPhone 5 has really nice camera, yeah?" date:[NSDate dateWithTimeIntervalSinceNow:-5] type:BubbleTypeMine];
     replyBubble.avatar = nil;*/
    
    
    bubbleTable.bubbleDataSource = self;
    
    // The line below sets the snap interval in seconds. This defines how the bubbles will be grouped in time.
    // Interval of 120 means that if the next messages comes in 2 minutes since the last message, it will be added into the same group.
    // Groups are delimited with header which contains date and time for the first message in the group.
    
    bubbleTable.snapInterval = 120;
    
    // The line below enables avatar support. Avatar can be specified for each bubble with .avatar property of NSBubbleData.
    // Avatars are enabled for the whole table at once. If particular NSBubbleData misses the avatar, a default placeholder will be set (missingAvatar.png)
    
    bubbleTable.showAvatars = YES;
    
    // Uncomment the line below to add "Now typing" bubble
    // Possible values are
    //    - NSBubbleTypingTypeSomebody - shows "now typing" bubble on the left
    //    - NSBubbleTypingTypeMe - shows "now typing" bubble on the right
    //    - NSBubbleTypingTypeNone - no "now typing" bubble
    
    bubbleTable.typingBubble = NSBubbleTypingTypeNobody;
    
    [bubbleTable reloadData];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (isPhone5()) {
        CGRect frame = self.view.frame;
        frame.size.height = 548.0f;
        self.view.frame = frame;
    }
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topnavigation.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.inputToolbar = [[PBMessageToolBar alloc] initWithFrame:CGRectMake(0, (isPhone5()?548:self.view.frame.size.height)-60, self.view.frame.size.width, 40)];
    CGRect frame = bubbleTable.frame;
    frame.size.height = (isPad()?1024:(isPhone5()?568:480))-KTabBarHeight;
    bubbleTable.frame = frame;
    bubbleTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.inputToolbar];
    inputToolbar.delegate = self;
    inputToolbar.textView.placeholder = @"请输入内容";
    [self originalBubbleTable:nil];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(7, 7, 25, 30);
    [btn addTarget:self action:@selector(backDidPush) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = barButton;
    // Keyboard events
    if (self.readflg==1) {
        [self.inputToolbar setHidden:YES];
        self.title = [NSString stringWithFormat:@"与%@的聊天记录",self.title];

    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(originalBubbleTable:) name:FRIEND_MESSAGE_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(originalBubbleTable:) name:GROUP_MESSAGE_NOTIFICATION object:nil];
    bubbleTable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"chat_back.png"]];
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [bubbleTable addGestureRecognizer:tapGr];
    
}
-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [self.inputToolbar keyboardWillHide];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self scrollToBottomAnimated:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillShowKeyboard:)
												 name:UIKeyboardWillShowNotification
                                               object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillHideKeyboard:)
												 name:UIKeyboardWillHideNotification
                                               object:nil];
}
- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger sections = [bubbleTable numberOfSections];
    if (sections>0) {
        NSInteger rows = [bubbleTable numberOfRowsInSection:sections-1];
        
        if(rows > 0) {
            [bubbleTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:sections-1]
                               atScrollPosition:UITableViewScrollPositionBottom
                                       animated:animated];
        }
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
    
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

-(void)inputButtonPressed:(NSString *)inputText//发送信息
{
    FAUserData *user = [FAUserData search];
    bubbleTable.typingBubble = NSBubbleTypingTypeNobody;
    
    NSBubbleData *sayBubble = [NSBubbleData dataWithText:inputText date:[NSDate dateWithTimeIntervalSinceNow:0] type:BubbleTypeMine];
    sayBubble.avatar = user.icon;
    [bubbleData addObject:sayBubble];
    [bubbleTable reloadData];
    [self scrollToBottomAnimated:YES];
    FAChatManager *manager = [[[FAChatManager alloc] init]autorelease];
    if (self.groupid>0) {
        if(self.groupflg>0){
            if (self.actionflg == 1) {
                [manager sendMessageToFreind:-1 withGroupId:self.groupid fromId:user.no withMessage:inputText];
            }else{
                [manager sendMessageToFreind:self.friendid withGroupId:self.groupid fromId:user.no withMessage:inputText];
            }
        }else{
            [manager sendMessageTogroup:self.groupid fromId:user.no withMessage:inputText];
        }
    }else if(self.friendid>0){
        [manager sendMessageToFreind:self.friendid withGroupId:-1 fromId:user.no withMessage:inputText];
    }
    [self.inputToolbar.textView clearText];
    FAMessageData *messagedata = [[[FAMessageData alloc]init]autorelease];
    if (self.groupid>0&&(self.groupflg==0||self.actionflg == 1)) {
        messagedata.friendid = user.no;
    }else{
        messagedata.friendid = self.friendid;
        messagedata.friendname = self.friendname;
        messagedata.imgpath = self.imgpath;
    }
    messagedata.groupid = self.groupid;
    messagedata.actionflg = self.actionflg;
    messagedata.content = inputText;
    messagedata.isread = 1;
    messagedata.whosaid = 1;
    messagedata.createtime = [NSDate new];
    [messagedata saveRecord];
}
-(void)backDidPush{
    [FAMessageData updateMessageReadflgById:self.friendid groupid:self.groupid groupflg:self.groupflg];
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - UIBubbleTableViewDataSource implementation

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [bubbleData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [bubbleData objectAtIndex:row];
}

- (void)keyboardWillShowHide:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:[UIView animationOptionsForCurve:curve]
                     animations:^{
                         CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;
                         
                         CGRect inputViewFrame = self.inputToolbar.frame;
                         self.inputToolbar.frame = CGRectMake(inputViewFrame.origin.x,
                                                           keyboardY - inputViewFrame.size.height,
                                                           inputViewFrame.size.width,
                                                           inputViewFrame.size.height);
                         CGRect tableFrame = bubbleTable.frame;
                         tableFrame.size.height = keyboardY - 40;
                         bubbleTable.frame = tableFrame;
//                         UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
//                                                                0.0f,
//                                                                self.view.frame.size.height - self.inputToolbar.frame.origin.y - 44.0f,
//                                                                0.0f);
//                         bubbleTable.contentInset = insets;
//                         bubbleTable.scrollIndicatorInsets = insets;
                         [self scrollToBottomAnimated:YES];
                        
                     }
                     completion:^(BOOL finished) {
                     }];
}

@end
