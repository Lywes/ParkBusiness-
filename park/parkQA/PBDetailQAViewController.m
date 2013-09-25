//
//  PBDetailQAViewController.m
//  ParkBusiness
//
//  Created by  on 13-3-7.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBDetailQAViewController.h"

@implementation PBDetailQAViewController

@synthesize contentTextView;
@synthesize QLabel;
@synthesize nameLabel;
@synthesize data;
@synthesize dateLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(6, 6, 25, 30);
        [btn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(popBackgoView) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem = backBarBtn;
        [backBarBtn release];
        
    }
    return self;
}

-(void)popBackgoView
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];

}

-(void)viewWillAppear:(BOOL)animated
{
    if (isPad()) {
        dateLabel.frame = CGRectMake(617, 42, 111, 21);
    }
    self.title = [self.data objectForKey:@"question"];
    contentTextView.text = [self.data objectForKey:@"answer"];
    QLabel.text = [self.data objectForKey:@"question"];
    nameLabel.text = [self.data objectForKey:@"myname"];
    dateLabel.text = [self.data objectForKey:@"createdate"];
    
    
    if (isPad()) {
        contentTextView.font = [UIFont systemFontOfSize:PadContentFontSize];
        nameLabel.font = [UIFont systemFontOfSize:PadContentFontSize];
        dateLabel.font = [UIFont systemFontOfSize:PadContentFontSize];
        QLabel.font = [UIFont systemFontOfSize:PadContentFontSize];
    }else{
        contentTextView.font = [UIFont systemFontOfSize:ContentFontSize];
        nameLabel.font = [UIFont systemFontOfSize:ContentFontSize];
        dateLabel.font = [UIFont systemFontOfSize:ContentFontSize];
        QLabel.font = [UIFont systemFontOfSize:ContentFontSize];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
