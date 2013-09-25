//
//  PBFinancialDemandController.m
//  ParkBusiness
//
//  Created by QDS on 13-3-21.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBFinancialDemandController.h"

@interface PBFinancialDemandController ()

@end

@implementation PBFinancialDemandController
@synthesize finacialDictionary;
@synthesize financialTabelView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    self.title = NSLocalizedString(@"Left_mainTable_RZXQ", nil);
    
}

#pragma mark -
#pragma mark TableViewDataSourceMethod
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cellidentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];       
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    NSString *str;
    switch (indexPath.section) {
        case 0:
        {
            str = [NSString stringWithFormat:@"%@%@", @"融资额度：",[finacialDictionary objectForKey:@"financingamount"]];
            break;
        }
        case 1:
        {
            str = [NSString stringWithFormat:@"%@%@", @"金额单位：",[finacialDictionary objectForKey:@"amountunit"]];
            break;
        }
        case 2:
        {
            str = [NSString stringWithFormat:@"%@%@", @"出让股权比例：",[finacialDictionary objectForKey:@"financingamount"]];
            break;
        }
        case 3:
        {
            str = [NSString stringWithFormat:@"%@%@", @"其他需求：",[finacialDictionary objectForKey:@"others"]];
            break;
        }
            
        default:
            break;
    }
    cell.textLabel.text = str;
    
    /**********************************
     融资额度 financingamount
     金额单位 amountunit
     出让股权比例 rate
     其他需求 others
     **********************************/
    
    return cell;
}

#pragma mark -
#pragma mark TableViewDelegateMethod

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [finacialDictionary release];
    [financialTabelView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setFinacialDictionary:nil];
    [self setFinancialTabelView:nil];
    [super viewDidUnload];
}
@end
