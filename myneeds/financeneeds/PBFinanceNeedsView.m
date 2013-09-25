//
//  PBFinanceNeedsView.m
//  ParkBusiness
//
//  Created by wangzhigang on 13-7-11.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBFinanceNeedsView.h"

@implementation PBFinanceNeedsView
@synthesize fundLabel;
@synthesize difficultyLabel;
@synthesize fundused;
@synthesize tradeLabel;
@synthesize yearsaleLabel;
@synthesize delegate;
@synthesize periodLabel;
@synthesize rateLabel;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Initialization code
        
        titleArr = [[NSArray alloc]initWithObjects:@"资金需求(万元):",@"所在行业:",@"年销售额(万元):",@"融资困难原因:",@"融资周期:",@"年利率范围(%):",@"资金用途:", nil];
        industry = [[NSMutableArray alloc]init];
        NSMutableArray *arry1 = [PBIndustryData search:@"industry"];
        for (PBIndustryData * industryData in arry1 ) {
            if (industryData.name != NULL) {
                [industry addObject:industryData.name];
            }
        }
        yearsale = [[NSMutableArray alloc]init];
        NSMutableArray *arry2 = [PBIndustryData search:@"yearsale"];
        for (PBIndustryData * industryData in arry2 ) {
            if (industryData.name != NULL) {
                [yearsale addObject:industryData.name];
            }
        }
        difficulty = [[NSMutableArray alloc]init];
        NSMutableArray *arry3 = [PBIndustryData search:@"difficulty"];
        for (PBIndustryData * industryData in arry3 ) {
            if (industryData.name != NULL) {
                [difficulty addObject:industryData.name];
            }
        }
        period = [[NSMutableArray alloc]init];
        NSMutableArray *arry4 = [PBIndustryData search:@"period"];
        for (PBIndustryData * industryData in arry4 ) {
            if (industryData.name != NULL) {
                [period addObject:industryData.name];
            }
        }
        raterange = [[NSMutableArray alloc]init];
        NSMutableArray *arry5 = [PBIndustryData search:@"raterange"];
        for (PBIndustryData * industryData in arry5 ) {
            if (industryData.name != NULL) {
                [raterange addObject:industryData.name];
            }
        }
        fund = [NSMutableArray new];
        NSMutableArray *arry6 = [PBIndustryData search:@"fund"];
        for (PBIndustryData * industryData in arry6 ) {
            if (industryData.name != NULL) {
                [fund addObject:industryData.name];
            }
        }
        _overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _overlayView.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];
        [_overlayView addTarget:self
                         action:@selector(dismiss)
               forControlEvents:UIControlEventTouchUpInside];
        CGRect frame;
        if (isPad()) {
            frame = CGRectMake(0, 0, 480, 600);
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
            [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"nav_btn_tj", nil) style:UIBarButtonItemStylePlain target:self action:@selector(submitBtnDidPush)]];
            
        }else{
            UILabel* _titleView = [[UILabel alloc] initWithFrame:CGRectZero];
            _titleView.font = [UIFont systemFontOfSize:17.0f];
            _titleView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"topnavigation.png"]];
            _titleView.textAlignment = UITextAlignmentCenter;
            _titleView.textColor = [UIColor whiteColor];
            CGFloat xWidth = self.view.bounds.size.width;
            _titleView.lineBreakMode = UILineBreakModeTailTruncation;
            _titleView.frame = CGRectMake(0, 0, xWidth, 32.0f);
            _titleView.text = NSLocalizedString(@"MyFinanceNeedsList_WYRZ", nil);
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
    [fundLabel resignFirstResponder];
    [fundused resignFirstResponder];
}
-(void)initInputView:(CGRect)_frame{//初始化输入框
    UIFont* font = [UIFont systemFontOfSize:isPad()?16:14];
    for (int i = 0; i<[titleArr count]; i++){
        CGSize textSize = [[titleArr objectAtIndex:2] sizeWithFont:font];
        CGRect frame = CGRectMake(textSize.width+20, 5, _frame.size.width-textSize.width-(isPad()?120:50), 35);
        switch (i) {
            case 0:
                fundLabel = [[UILabel alloc]initWithFrame:frame];
                fundLabel.text = @"请选择资金需求";
                fundLabel.font = font;
                break;
            case 1:
                tradeLabel = [[UILabel alloc]initWithFrame:frame];
                tradeLabel.text = @"请选择行业";
                tradeLabel.font = font;
                break;
            case 2:
                yearsaleLabel = [[UILabel alloc]initWithFrame:frame];
                yearsaleLabel.text = @"请选择年销售额";
                yearsaleLabel.font = font;
                break;
            case 3:{
                difficultyLabel = [[UILabel alloc]initWithFrame:frame];
                difficultyLabel.text = @"请选择融资困难原因";
                difficultyLabel.numberOfLines = 0;
                difficultyLabel.font = font;
            }
            case 4:
                periodLabel = [[UILabel alloc]initWithFrame:frame];
                periodLabel.text = @"请选择融资周期";
                periodLabel.font = font;
            case 5:
                rateLabel = [[UILabel alloc]initWithFrame:frame];
                rateLabel.text = @"请选择年利率范围";
                rateLabel.font = font;
                break;
            case 6:
            {
                fundused = [[UITextView alloc]initWithFrame:CGRectMake(2, 2, _frame.size.width-(isPad()?80:20), 44)];
                fundused.backgroundColor = [UIColor clearColor];
                fundused.textAlignment = UITextAlignmentLeft;
                fundused.font = font;
                if (!isPad()) {
                    fundused.delegate = self;
                }
                UIImageView* textViewBackgroundImage = [[UIImageView alloc] initWithFrame:fundused.frame];
                textViewBackgroundImage.image          = [UIImage imageNamed:@"textbg"];
                textViewBackgroundImage.contentMode    = UIViewContentModeScaleToFill;
                textViewBackgroundImage.contentStretch = CGRectMake(0.5, 0.5, 0, 0);
                [fundused addSubview:textViewBackgroundImage];
                [fundused sendSubviewToBack:textViewBackgroundImage];
            }
                break;
                
            default:
                break;
        }
    }
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    UITableViewCell *cell = (UITableViewCell *)[[textView superview]superview];
    CGRect frame = cell.frame;
    int offset = frame.origin.y - (self.view.frame.size.height-KNavigationBarHeight-KTabBarHeight - 216.0);//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    if(offset > 0)
    {
        offset = MIN(offset, 216);
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
-(BOOL)checkText{
    if([fundLabel.text isEqualToString:@"请选择资金需求"]||[fundused.text isEqualToString:@""]||[difficultyLabel.text isEqualToString:@"请选择融资困难原因"]||[tradeLabel.text isEqualToString:@"请选择行业"]||[yearsaleLabel.text isEqualToString:@"请选择年销售额"]||[difficultyLabel.text isEqualToString:@"请选择融资周期"]||[tradeLabel.text isEqualToString:@"请选择年利率范围"]){
        return NO;
    }
    return YES;
}

-(void)initPopView:(UIViewController*)controller
{
    //弹出选择画面
    pop =[[POPView alloc]init];
    pop.delegate = self;
    pop.view.hidden = YES;
    [controller.view addSubview:pop.view];
    multipop = [[PBMultiPopView alloc]init];
    multipop.delegate = self;
    multipop.view.hidden = YES;
    [controller.view addSubview:multipop.view];

}
#pragma mark -POPview delegate
- (void)popView:(POPView *)popview didSelectIndexPath:(NSIndexPath *)indexPath{
    if ([pop._arry isEqualToArray:fund]) {
        fundLabel.text = [popview._arry objectAtIndex:indexPath.row];
    }
    if ([pop._arry isEqualToArray:industry]) {
        tradeLabel.text = [popview._arry objectAtIndex:indexPath.row];
    }
    if ([pop._arry isEqualToArray:yearsale]) {
        yearsaleLabel.text = [popview._arry objectAtIndex:indexPath.row];
    }
    if ([pop._arry isEqualToArray:period]) {
        periodLabel.text = [popview._arry objectAtIndex:indexPath.row];
    }
    if ([pop._arry isEqualToArray:raterange]) {
        rateLabel.text = [popview._arry objectAtIndex:indexPath.row];
    }
    
}
-(void)popView:(PBMultiPopView *)popview{
    difficultyLabel.text = popview.dataStr;
    [tableView reloadData];
}



#pragma mark - UIPopoverListViewDataSource
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *identifier = @"cell";
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:identifier] autorelease];
    
    int section = indexPath.section;
    if (section<[titleArr count]-1) {
        cell.textLabel.text = [titleArr objectAtIndex:section];
        cell.textLabel.font = [UIFont systemFontOfSize:isPad()?16:14];
    }
    switch (section) {
        case 0:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [[cell contentView] addSubview:fundLabel];
            break;
        case 1:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [[cell contentView] addSubview:tradeLabel];
            break;
        case 2:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [[cell contentView] addSubview:yearsaleLabel];
            break;
        case 3:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [[cell contentView] addSubview:difficultyLabel];
            break;
        case 4:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [[cell contentView] addSubview:periodLabel];
            break;
        case 5:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [[cell contentView] addSubview:rateLabel];
            break;
        case 6:
            [[cell contentView] addSubview:fundused];
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
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == [titleArr count]-1) {
        return [titleArr objectAtIndex:section];
    }
    return nil;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section==[titleArr count]-1) {
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, isPad()?5:0, self.view.frame.size.width, 55)];
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 255, 50);
        [btn setBackgroundImage:[UIImage imageNamed:@"custom_button.png"] forState:UIControlStateNormal];
        [view addSubview:btn];
        btn.center = view.center;
        [btn addTarget:self action:@selector(submitBtnDidPush) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:NSLocalizedString(@"MyFinanceNeedsList_WYRZ", nil) forState:UIControlStateNormal];
        btn.titleLabel.textAlignment = UITextAlignmentCenter;
        submit = btn;
        return view;
    }
    return nil;
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
    if (indexPath.section != 3&&indexPath.section != 6) {
//        [pop.view removeFromSuperview];
        if (indexPath.section==0) {
            pop._arry = fund;
            pop.name = @"资金需求";
        }
        if (indexPath.section==1) {
            pop._arry = industry;
            pop.name = @"行业分类";
        }
        if (indexPath.section==2) {
            pop._arry = yearsale;
            pop.name = @"年销售额";
        }
        if (indexPath.section==4) {
            pop._arry = period;
            pop.name = @"融资周期";
        }
        if (indexPath.section==5) {
            pop._arry = raterange;
            pop.name = @"年利率";
        }
//        pop.view.hidden = !pop.view.hidden;
        [pop popClickAction];
    }else if(indexPath.section == 3){
        [multipop.view removeFromSuperview];
        multipop._arry = difficulty;
        multipop.name = @"融资困难原因";
        multipop.view.hidden = !multipop.view.hidden;
        [multipop popClickAction];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==[titleArr count]-1) {
        return 50.0f;
    }
    if (indexPath.section==3) {
        return [self heightForRow:difficultyLabel defaultHeight:35.0f]+9.0f;
    }
    return 44.0f;
}

-(CGFloat)heightForRow:(UILabel*)label defaultHeight:(CGFloat)height{
    CGRect frame = label.frame;
    CGFloat contentWidth = frame.size.width;
    UIFont *font = [UIFont systemFontOfSize:isPad()?16:14];
    CGSize size = [label.text sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:UILineBreakModeWordWrap];
    frame.size.height = MAX(size.height, height);
    label.frame = frame;
    return MAX(size.height, height);
}
-(void)submitBtnDidPush{//我要融资
    NSString* trades = [NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:tradeLabel.text?tradeLabel.text:@"" withKind:@"industry"]];
    NSString* yearsales = [NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:yearsaleLabel.text?yearsaleLabel.text:@"" withKind:@"yearsale"]];
    NSString* periods = [NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:periodLabel.text?periodLabel.text:@"" withKind:@"period"]];
    NSString* rateranges = [NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:rateLabel.text?rateLabel.text:@"" withKind:@"raterange"]];
    NSString* funds = [NSString stringWithFormat:@"%d",[PBKbnMasterModel getKbnIdByName:fundLabel.text?fundLabel.text:@"" withKind:@"fund"]];
    NSArray* arr1 = [NSArray arrayWithObjects:USERNO,trades,yearsales,funds,fundused.text?fundused.text:@"",difficultyLabel.text?difficultyLabel.text:@"",@"1",periods,rateranges,nil];
    NSArray* arr2 = [NSArray arrayWithObjects:@"userno",@"trade",@"yearsale",@"fundneed",@"fundused",@"difficulty",@"type",@"period",@"raterange",nil];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc]initWithObjects:arr1 forKeys:arr2];
    [delegate popViewWillShow:dic];
}
-(void)setSubmitBtn:(BOOL)enabled{
    submit.enabled = enabled;
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
