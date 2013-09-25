//
//  PBAnswer.m
//  ParkBusiness
//
//  Created by QDS on 13-6-20.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//
#define HUIDA_URL [NSURL URLWithString:[NSString stringWithFormat:@"%@/admin/index/answerquestioninfo",HOST]]
#import "PBAnswer.h"
#import "NSObject+PBLableHeight.h"
@interface PBAnswer ()
-(void)ifViewDataHasChanged;
@end

@implementation PBAnswer
@synthesize data_dic;
@synthesize keytoolbar;
-(void)dealloc
{
    [keytoolbar release];
    [data_dic release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
     self.title = @"提问回答";
    }
    return self;
}
//隐藏tableview没有内容下面的cell线
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [view release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setExtraCellLineHidden:self.tableView];
    //添加回答输入框
    self.keytoolbar = [[[UIInputToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 40)]autorelease];
    keytoolbar.delegate = self;
    keytoolbar.textView.placeholder = @"请输入回复";
    [self.view addSubview:self.keytoolbar];
 
   
}
-(void)backUpView
{
    [self dismissModalViewControllerAnimated:YES];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[self.data_dic objectForKey:@"answer"]isEqual:@""]) {
         [self navigatorRightButtonType:HUIDA];//添加回答按钮
    }
    
}
-(void)ifViewDataHasChanged
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"回答的通知" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.keytoolbar removeObserverFromController:self];
}
//点击回答按钮
-(void)editButtonPress:(id)sender
{
    self.navigationItem.rightBarButtonItem = nil;
    [self.keytoolbar addObserverFromController:self];
    [self.keytoolbar.textView becomeFirstResponder];
}
-(void)handleWillShowKeyboard:(NSNotification *)notification
{
    [self.keytoolbar keyboardWillShowHide:notification];
}
- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    [self.keytoolbar keyboardWillShowHide:notification];
    [self.keytoolbar keyboardWillHide];
}
//点击发送的回调
-(void)inputButtonPressed:(NSString *)inputText
{

    PBdataClass *dataclass = [PBdataClass sharePBdataClass];
    dataclass.delegate = self;
    [dataclass dataResponse:HUIDA_URL postDic:[NSDictionary dictionaryWithObjectsAndKeys:inputText,@"answer",[self.data_dic objectForKey:@"no"],@"no",[NSString stringWithFormat:@"%d",[PBUserModel getUserId] ],@"userno", nil] searchOrSave:NO];
        [self.data_dic setValue:inputText forKey:@"answer"];
}
//回答成功的回调
-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue
{
    //将问题置为已回答列表
    [self.tableView reloadData];
    [self   ifViewDataHasChanged];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
       return  [self HeightAStr:[self.data_dic objectForKey:@"question"]] + 30.0f;
    }
    else
        return self.view.frame.size.height;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    
    switch (indexPath.row) {
        case 0:
        {
            UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 20)];
            name.numberOfLines = 0;
            name.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleWidth;
            [cell.contentView addSubview:name];
            
            UILabel *date = [[UILabel alloc]initWithFrame:CGRectMake(230, 50, 80, 20)];
            date.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleWidth;
            [cell.contentView addSubview:date];
            
            UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(name.frame.origin.x, name.frame.size.height + 5, 300, 20)];
            text.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleWidth;
            [cell.contentView addSubview:text];
            
//            name.font = [UIFont systemFontOfSize:15];
//            date.font = [UIFont systemFontOfSize:15];
//            text.font = [UIFont systemFontOfSize:15];
            name.text = [self.data_dic objectForKey:@"name"];
            text.text = [self.data_dic objectForKey:@"question"];
            date.text = [self.data_dic objectForKey:@"cdate"];
            
            [name release];
            [text release];
            [date release];
        }
            break;
        case 1:
        {
            UITextView *answer = [[UITextView alloc]initWithFrame:CGRectMake(5, 0, 300, self.view.frame.size.height)];
            answer.autoresizingMask =UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleWidth;
            answer.text = [self.data_dic objectForKey:@"answer"];
            answer.editable = NO;
            answer.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:answer];
            [answer release];
           
        }
        default:
            break;
    }
    return cell;
}
@end
