//
//  PBManageMoneyView.m
//  ParkBusiness
//
//  Created by wangzhigang on 13-7-11.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBManageMoneyView.h"

@implementation PBManageMoneyView
@synthesize availablefund;
@synthesize timeperiodLabel;
@synthesize expectreturn;
@synthesize delegate;
@synthesize typeLabel;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    [super initWithNibName:nil bundle:nil];
    if (self) {
        // Initialization code
        titleArr = [[NSArray alloc]initWithObjects:NSLocalizedString(@"_tb_lclx", nil),@"可用资金(万元):",@"期望年回报率(%):",@"时间周期(月):", nil];
        _overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _overlayView.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
        [_overlayView addTarget:self
                         action:@selector(dismiss)
               forControlEvents:UIControlEventTouchUpInside];
        CGRect frame;
        if (isPad()) {
            frame = CGRectMake(0, 0, 480, 420);
        }
        else
        {
            frame = self.view.frame;
            frame.size.height -= KNavigationBarHeight;
        }
        self.view.frame = frame;
        self.view.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.view.layer.borderWidth = 1.0f;
        self.view.layer.cornerRadius = 10.0f;
        self.view.clipsToBounds = TRUE;
        if (!isPad()) {
            [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"nav_btn_qx", nil) style:UIBarButtonItemStylePlain target:self action:@selector(hidden)]];
            [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"nav_btn_tj", nil) style:UIBarButtonItemStylePlain target:self action:@selector(manageMoney)]];
        }else{
            UILabel* _titleView = [[UILabel alloc] initWithFrame:CGRectZero];
            _titleView.font = [UIFont systemFontOfSize:17.0f];
            _titleView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topnavigation.png"]];
            _titleView.textAlignment = UITextAlignmentCenter;
            _titleView.textColor = [UIColor whiteColor];
            CGFloat xWidth = self.view.bounds.size.width;
            _titleView.lineBreakMode = UILineBreakModeTailTruncation;
            _titleView.frame = CGRectMake(0, 0, xWidth, 32.0f);
            _titleView.text = NSLocalizedString(@"PBMyManageMoneyNeedsList_WYLC", nil);
            [self.view addSubview:_titleView];
            frame.origin.y += 32.f;
            frame.size.height -= 32.0f;
            [_titleView release];
        }
        
        tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        [self initInputView:frame];
        tableView.delegate = self;
        tableView.dataSource = self;        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapViewPush:)];
        tap.cancelsTouchesInView = NO;
        [tableView addGestureRecognizer:tap];
        
        [self.view addSubview:tableView];
        timeperiod = [[NSMutableArray alloc]init];
        NSMutableArray *arry = [PBIndustryData search:@"timeperiod"];
        for (PBIndustryData * industryData in arry ) {
            if (industryData.name != NULL) {
                [timeperiod addObject:industryData.name];
            }
        }
        earor = [[NSMutableArray alloc]init];
        arry = [PBIndustryData search:@"earor"];
        for (PBIndustryData * industryData in arry ) {
            if (industryData.name != NULL) {
                [earor addObject:industryData.name];
            }
        }
        mmtype = [[NSMutableArray alloc]init];
        arry = [PBIndustryData search:@"mmtype"];
        for (PBIndustryData * industryData in arry ) {
            if (industryData.name != NULL) {
                [mmtype addObject:industryData.name];
            }
        }
    }
    return self;
}
-(void)hidden{
    [self dismissModalViewControllerAnimated:YES];
}
-(void)dismiss{
    [self fadeOut];
}
-(void)show:(UINavigationController*)navi{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [navi.view addSubview:_overlayView];
    [navi.view addSubview:self.view];
    self.view.center = CGPointMake(keywindow.bounds.size.width/2.0f,
                                   keywindow.bounds.size.height/3.0f);
    self.view.transform = CGAffineTransformIdentity;
    self.view.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
}
- (void)fadeIn{
    self.view.transform = CGAffineTransformIdentity;
    self.view.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
}
- (void)fadeOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.view.transform = CGAffineTransformIdentity;
        //CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [_overlayView removeFromSuperview];
            [self.view removeFromSuperview];
        }
    }];
}
-(void)tapViewPush:(UITapGestureRecognizer*)tap{
    [availablefund resignFirstResponder];
}
-(void)initInputView:(CGRect)_frame{//初始化输入框
    UIFont* font = [UIFont systemFontOfSize:isPad()?16:14];
    for (int i = 0; i<[titleArr count]; i++){
        CGSize textSize = [[titleArr objectAtIndex:2] sizeWithFont:font];
        CGRect frame = CGRectMake(textSize.width+20, 5, _frame.size.width-textSize.width-(isPad()?120:50), 35);
        switch (i) {
            case 0:{
                typeLabel = [[UILabel alloc]initWithFrame:frame];
                typeLabel.text = @"请选择理财类型";
                typeLabel.font = font;
            }
                break;
            case 1:
                availablefund = [[UITextField alloc]initWithFrame:frame];
                availablefund.keyboardType = UIKeyboardTypeNumberPad;
                availablefund.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                [availablefund setBorderStyle:UITextBorderStyleRoundedRect];
                availablefund.font = font;
                break;
            case 2:{
                expectreturn = [[UILabel alloc]initWithFrame:frame];
                expectreturn.text = @"请选择期望年回报率";
                expectreturn.font = font;
            }
                
                break;
            case 3:{
                timeperiodLabel = [[UILabel alloc]initWithFrame:frame];
                timeperiodLabel.text = @"请选择时间周期";
                timeperiodLabel.font = font;
            }
                break;
                
            default:
                break;
        }
    }
    
}
-(BOOL)checkText{
    if([availablefund.text length]>0&&![expectreturn.text isEqualToString:@"请选择时期望年回报率"]&&![timeperiodLabel.text isEqualToString:@"请选择时间周期"]&&![typeLabel.text isEqualToString:@"请选择理财类型"]){
        return YES;
    }
    return NO;
}
-(void)initPopView:(UIViewController*)controller
{
    //弹出选择画面
    pop =[[POPView alloc]init];
    pop.delegate = self;
    pop.view.hidden = YES;
    [controller.view addSubview:pop.view];
    
}
#pragma mark -POPview delegate
- (void)popView:(POPView *)popview didSelectIndexPath:(NSIndexPath *)indexPath{
    if ([pop._arry isEqualToArray:timeperiod]) {
        timeperiodLabel.text = [popview._arry objectAtIndex:indexPath.row];
    }
    if ([pop._arry isEqualToArray:earor]) {
        expectreturn.text = [popview._arry objectAtIndex:indexPath.row];
    }
    if ([pop._arry isEqualToArray:mmtype]) {
        typeLabel.text = [popview._arry objectAtIndex:indexPath.row];
    }
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:identifier] autorelease];
    
    int section = indexPath.section;
    cell.textLabel.text = [titleArr objectAtIndex:section];
    cell.textLabel.font = [UIFont systemFontOfSize:isPad()?16:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (section) {
        case 0:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [[cell contentView] addSubview:typeLabel];
            break;
        case 1:
            [[cell contentView] addSubview:availablefund];
            break;
        case 2:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [[cell contentView] addSubview:expectreturn];
            break;
        case 3:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [[cell contentView] addSubview:timeperiodLabel];
            break;
            
        default:
            break;
    }
    for (UILabel* label in [[cell contentView] subviews]) {
        if ([label isKindOfClass:[UILabel class]]) {
            label.backgroundColor = [UIColor clearColor];
        }
    }
    return cell;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [titleArr count];
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==[titleArr count]-1) {
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, isPad()?5:0, self.view.frame.size.width, 55)];
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 255, 50);
        [btn setBackgroundImage:[UIImage imageNamed:@"custom_button.png"] forState:UIControlStateNormal];
        [view addSubview:btn];
        btn.center = view.center;
        [btn addTarget:self action:@selector(manageMoney) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:NSLocalizedString(@"PBMyManageMoneyNeedsList_WYLC", nil) forState:UIControlStateNormal];
        btn.titleLabel.textAlignment = UITextAlignmentCenter;
        submit = btn;
        return view;
    }
    return nil;
}
-(void)manageMoney{//我要理财
    if ([self checkText]) {
        NSString* mmtypes = [NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:typeLabel.text withKind:@"mmtype"]];
         NSString* expectreturns = [NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:expectreturn.text withKind:@"earor"]];
         NSString* timeperiods = [NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:timeperiodLabel.text withKind:@"timeperiod"]];
        NSArray* arr1 = [NSArray arrayWithObjects:USERNO,mmtypes,availablefund.text?availablefund.text:@"",expectreturns,timeperiods, nil];
        NSArray* arr2 = [NSArray arrayWithObjects:@"userno",@"type",@"availablefund",@"expectreturn",@"timeperiod",nil];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjects:arr1 forKeys:arr2];
        [delegate popViewWillShow:dic];
    }else{
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请完善理财需求信息！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}
-(void)setSubmitBtn:(BOOL)enabled{
    submit.enabled = enabled;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==[titleArr count]-1) {
        return 55.0f;
    }
    return 0.0f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
#pragma mark - UIPopoverListViewDelegate
-(void)tableView:(UITableView *)_tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        pop._arry = mmtype;
        pop.name = NSLocalizedString(@"_tb_lclx", nil);
        [pop popClickAction];
    }
    if (indexPath.section==2) {
        pop._arry = earor;
        pop.name = NSLocalizedString(@"_tb_qwnhbl", nil);
        [pop popClickAction];
    }
    if (indexPath.section==3) {
        pop._arry = timeperiod;
        pop.name = NSLocalizedString(@"_tb_sjzq", nil);
        [pop popClickAction];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
