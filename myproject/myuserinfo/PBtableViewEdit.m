//
//  PBtableViewEdit.m
//  ParkBusiness
//
//  Created by 新平 圣 on 13-3-4.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBtableViewEdit.h"
#import <QuartzCore/QuartzCore.h>

@implementation PBtableViewEdit
@synthesize projectname,projectjieshao,projectjieshao_tishi,textViewAndtextFieldHidden;
@synthesize addlable;
@synthesize ProjectStyle;
@synthesize datadic;
@synthesize collectData;
@synthesize productno;
-(void)dealloc
{
    [projectname= nil release];
    [projectjieshao=nil release];
    [projectjieshao_tishi=nil release];
    [addlable=nil release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self viewLoding];
        [self keyboardDown];
        [self backButton];
    }
    return self;
}
-(void)backButton
{
    UIImage *image = [UIImage imageNamed:@"back.png"];
    UIButton *lefbt = [[[UIButton alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)]autorelease];
    [lefbt setBackgroundImage:image forState:UIControlStateNormal];
    [lefbt addTarget:self action:@selector(backUpView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftbutton = [[[UIBarButtonItem alloc]initWithCustomView:lefbt]autorelease];
    self.navigationItem.leftBarButtonItem = leftbutton;
}
-(void)backUpView
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewLoding
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
-(void)keyboardDown
{
    //我添加的代码，此代码可以让keyboard消失
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isedit = YES;
    labletag = 0;
    if (isPad()) {
        self.projectname = [[[UITextField alloc]initWithFrame:CGRectMake(RATIO*45, 0, 586, 44)]autorelease];
        self.projectjieshao = [[[UITextView alloc]initWithFrame:CGRectMake(0, 0, 679, 120)]autorelease];
        
    }
    else {
        self.addlable = [[[UILabel alloc]init]autorelease];
        self.projectname = [[[UITextField alloc]initWithFrame:CGRectMake(85, 0, 215, 44)]autorelease];
        self.projectjieshao = [[[UITextView alloc]initWithFrame:CGRectMake(0, 0, 300, 120)]autorelease];
        self.projectjieshao_tishi = [[[UILabel alloc]initWithFrame:CGRectMake(100, 0, 250, 20)]autorelease];
    }
    self.projectjieshao.tag = 1;
    CGFloat size;
    if (isPad()) {
        size = PadContentFontSize;
    }
    else {
        size = ContentFontSize;
    }
    self.projectjieshao.font = [UIFont systemFontOfSize:size];
    self.projectjieshao.textAlignment = UITextAlignmentLeft;
    self.projectjieshao.backgroundColor = [UIColor clearColor];
    self.projectjieshao.delegate = self;
    
    self.projectname.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.projectname.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.addlable = [[[UILabel alloc]init]autorelease];
    self.projectjieshao_tishi.hidden = YES;
    //tableview背景
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeLableText:) name:@"300" object:nil];
    
}

-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    //取消重用机制
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    while ([cell.contentView.subviews lastObject] != nil) {  
        [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];  
    } 
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self addSubViewForCell:cell indexPath:indexPath];
    return cell;
}
-(void)addSubViewForCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath
{
    
}
-(void)addTextfiledForCell:(UITableViewCell *)cell
{
    self.projectname.textAlignment = UITextAlignmentLeft;
    self.projectname.delegate = self;
    [cell.contentView addSubview:projectname];
    
}
-(void)addTextViewForCell:(UITableViewCell *)cell
{
    [cell.contentView addSubview:self.projectjieshao];
}
-(UIView *)TishiView
{
    UILabel *lable;
    CGFloat size;
    if (isPad()) {
        size = PadContentFontSmallSize;
        lable = [[[UILabel alloc]initWithFrame:CGRectMake(RATIO*100, -4, RATIO*250, 20)]autorelease];

    }
    else {
        size = 10;
        lable = [[[UILabel alloc]initWithFrame:CGRectMake(100, -4, 250, 20)]autorelease];
    }
    lable.tag = 110 +labletag;

    lable.backgroundColor = [UIColor clearColor];
    lable.textAlignment = UITextAlignmentCenter;
    lable.font = [UIFont fontWithName:@"Hoefler Text" size:size];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    
    [view addSubview:lable];
    return view;
}
-(void)addLableForCell:(UITableViewCell *)cell withFram:(CGRect)farm
{
    [cell.contentView addSubview:self.addlable];
    self.addlable.frame = farm;
    self.addlable.backgroundColor = [UIColor clearColor];
    self.addlable.text = @"测试lable";
}
#pragma mark - 编辑
-(void)navigatorRightButtonType:(rightbutton)type
{
    if (type == BIANJI) {
        UIBarButtonItem *rightbutton = [[[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editButtonPress:)]autorelease];
        self.navigationItem.rightBarButtonItem = rightbutton;
        rightbutton.tag = BIANJI+100;
        self.tableView.allowsSelection = NO;
    }
    if (type == ZUIJIA) {
        UIBarButtonItem *rightbutton = [[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"nav_btn_zj", nil) style:UIBarButtonItemStylePlain target:self action:@selector(editButtonPress:)]autorelease];
        self.navigationItem.rightBarButtonItem = rightbutton;
        rightbutton.tag = ZUIJIA+100;
        
    }
    if (type == WANCHEN) {
        UIBarButtonItem *rightbutton = [[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"nav_btn_wc", nil) style:UIBarButtonItemStylePlain target:self action:@selector(editButtonPress:)]autorelease];
        self.navigationItem.rightBarButtonItem = rightbutton;
        rightbutton.tag = WANCHEN+100;
    }
    if (type == FANKUI) {
        UIBarButtonItem *rightbutton = [[[UIBarButtonItem alloc]initWithTitle:@"反馈" style:UIBarButtonItemStylePlain target:self action:@selector(editButtonPress:)]autorelease];
        self.navigationItem.rightBarButtonItem = rightbutton;
        rightbutton.tag = FANKUI+100;
    }
    if (type == NEXT) {
        UIBarButtonItem *rightbutton = [[[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(editButtonPress:)]autorelease];
        self.navigationItem.rightBarButtonItem = rightbutton;
        rightbutton.tag = NEXT+100;
        self.tableView.allowsSelection = YES;
        self.textViewAndtextFieldHidden = NO;
        isedit = NO;
        [self editState];
    }
    if (type == HUIDA) {
        UIBarButtonItem *rightbutton = [[[UIBarButtonItem alloc]initWithTitle:@"回答" style:UIBarButtonItemStylePlain target:self action:@selector(editButtonPress:)]autorelease];
        self.navigationItem.rightBarButtonItem = rightbutton;
        rightbutton.tag = HUIDA+100;
    }
}
-(void)setTextViewAndtextFieldHidden:(BOOL)textViewAndtextFieldHiddens
{
    if (textViewAndtextFieldHiddens) {
        [self.projectname setBorderStyle:UITextBorderStyleNone];     
    }
    else
    {
        [self.projectname setBorderStyle:UITextBorderStyleRoundedRect];
    }
}
-(void)editButtonPress:(id)sender
{
    UIButton * x = (UIButton *)sender;
    if (x.tag == BIANJI+100) {
        self.tableView.allowsSelection = YES;
        isedit = !isedit;
        if (isedit == NO) {
            self.textViewAndtextFieldHidden = NO;
            self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"nav_btn_wc", nil);
            [self editState];
        }
        else
        {
            self.textViewAndtextFieldHidden = YES;
            self.navigationItem.rightBarButtonItem.title = @"编辑";
            [self.projectname resignFirstResponder];
            [self.projectjieshao resignFirstResponder];
            self.tableView.allowsSelection = NO;
            [self postDataOnserver];
        }
    }
    if (x.tag == ZUIJIA+100) {
        [self postDataOnserver];
    }
    if (x.tag == WANCHEN+100) {
        [self postDataOnserver];
    }
    if (x.tag == FANKUI+100) {
        [self postDataOnserver];
    }
    if (x.tag == NEXT+100) {
        [self postDataOnserver];
    }

}

-(void)editState
{
    
}
-(void)postDataOnserver
{
    
}

#pragma mark - 输入框delegate
//textfield
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (isedit) {
        return NO;
        
        
    }
    else
        
        return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    UITableViewCell *cell = (UITableViewCell *)[[textView superview]superview];    
    CGRect frame = cell.frame;
    int offset = frame.origin.y - (self.view.frame.size.height-KNavigationBarHeight - 246.0);//键盘高度216
    NSTimeInterval animationDuration = 0.30f;                   
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];                   
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;           
    if(offset > 0)        
    {
        offset = offset>216?216:offset;
        CGRect rect = CGRectMake(0.0f, -offset,width,height);                   
        self.view.frame = rect;
    }           
    [UIView commitAnimations];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSTimeInterval animationDuration = 0.30f;           
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];       
    [UIView setAnimationDuration:animationDuration];           
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);           
    self.view.frame = rect;      
    [UIView commitAnimations];         
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder]; 
    return YES; 
}
//textview
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setObject:[NSString stringWithFormat:@"%d",textView.tag] forKey:@"tag"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"300" object:[NSNumber numberWithInt:textView.text.length -1] userInfo:dic];
    if (isedit) {
        return NO;
    }
    else
    {
        return YES;
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{    
    if ([text isEqualToString:@"\n"]||range.location>=300
        ) {    
        
        if ([text isEqualToString:@"\n"]) {
            [textView resignFirstResponder]; 
        }
        return NO;    
        
    }
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
    [dic setObject:[NSString stringWithFormat:@"%d",textView.tag] forKey:@"tag"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"300" object:[NSNumber numberWithInt:range.location] userInfo:dic];
    return YES;    
    
}
-(void)changeLableText:(NSNotification *)notification
{
    int a = [notification.object intValue];
    int b = [[notification.userInfo objectForKey:@"tag"] intValue];
    UILabel *lable = (UILabel *)[self.view viewWithTag:110 +b];
    lable.text = [NSString stringWithFormat:@"你还可以输入%d个字",299-a];
}

#pragma mark - Table view delegate
//自定义textView高度
-(CGFloat)textViewHeightWithView:(UITextView*)textView defaultHeight:(CGFloat)defaultHeight{
    CGFloat height = textView.contentSize.height;
    CGRect farm = textView.frame;
    farm.size.height = height;
    textView.frame = farm;
    if (textView.contentSize.height > defaultHeight) {
        height = textView.contentSize.height;
        CGRect farm = textView.frame;
        farm.size.height = height;
        textView.frame = farm;
    }
    else {
        height = defaultHeight;
        CGRect farm = textView.frame;
        farm.size.height = defaultHeight;
        textView.frame = farm;
    }
    return height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
