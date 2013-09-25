//
//  PBgzVC.m
//  ParkBusiness
//
//  Created by lywes lee on 13-3-26.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBgzVC.h"
#import "UIImageView+WebCache.h"
@interface PBgzVC ()

@end

@implementation PBgzVC
@synthesize guanzhu;
-(void)dealloc
{
    [tableview release];
    [guanzhu release];
    [celltext release];
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    NSString *imagepath = [NSString stringWithFormat:@"%@%@",HOST,[guanzhu objectForKey:@"picture"]];
    NSLog(@"%@",guanzhu);
    UIImageView *imaeview = [cellcontview objectAtIndex:0];
    [imaeview setImageWithURL:[NSURL URLWithString:imagepath]];
    UILabel *myname=  [cellcontview objectAtIndex:1];
    myname.text = [guanzhu objectForKey:@"myname"];
    UILabel *sex=  [cellcontview objectAtIndex:2];
    sex.text = [guanzhu objectForKey:@"sex"];
    UILabel *sketch=  [cellcontview objectAtIndex:3];
    sketch.text = [guanzhu objectForKey:@"signature"];
    UILabel *tel=  [cellcontview objectAtIndex:4];
    tel.text = [guanzhu objectForKey:@"tel"];
    UILabel *qq=  [cellcontview objectAtIndex:5];
    qq.text = [guanzhu objectForKey:@"qq"];
    UILabel *sinablog=  [cellcontview objectAtIndex:6];
    sinablog.text = [guanzhu objectForKey:@"sinablog"];
    [tableview reloadData];

}
- (void)viewDidLoad
{
    [super viewDidLoad];

    if (isPad()) {
         tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024) style:UITableViewStyleGrouped];
    }
    else if (isPhone5()) {
        tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 548) style:UITableViewStyleGrouped];
    }
    else {
        tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 460) style:UITableViewStyleGrouped];
    }
    tableview.delegate =self;
    tableview.dataSource = self;
    [self.view addSubview:tableview];
    
    NSMutableArray *section1  = [NSMutableArray arrayWithObjects:@"头像:",@"姓名:",@"性别:",@"个人介绍:", nil];
    NSMutableArray *section2  = [NSMutableArray arrayWithObjects:@"TEL:",@"QQ:",@"微博:", nil];
    celltext  = [[NSMutableArray alloc]initWithObjects:section1,section2 ,nil];
    cellcontview = [[NSMutableArray alloc]init];
    UIImageView *imageview;
    imageview = [[[UIImageView alloc]initWithFrame:CGRectMake(tableview.center.x, 10, 50, 50)]autorelease];
    imageview.layer.shadowRadius = 5.0f;
    imageview.layer.masksToBounds = YES;
    imageview.layer.cornerRadius = 5;
    [cellcontview addObject:imageview];
    for (int i = 0; i<7; i++) {
        UILabel *lable ;
        if (i == 2) {
            if (isPad()) {
              lable = [[[UILabel alloc]initWithFrame:CGRectMake(tableview.center.x, 0, 500, 80)]autorelease];
            }
            else {
                lable = [[[UILabel alloc]initWithFrame:CGRectMake(tableview.center.x, 0, 200, 80)]autorelease];
            }

        }
        else
            lable = [[[UILabel alloc]initWithFrame:CGRectMake(tableview.center.x, 0, 150, 35)]autorelease];
        if (isPad()) {
            lable.font = [UIFont systemFontOfSize:PadContentFontSize];
        }
        else {
            lable.font = [UIFont systemFontOfSize:ContentFontSize];
        }
        lable.backgroundColor = [UIColor clearColor];
        [cellcontview addObject:lable];
        
    }
    UIImage *image = [UIImage imageNamed:@"back.png"];
    UIButton *lefbt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [lefbt setBackgroundImage:image forState:UIControlStateNormal];
    [lefbt addTarget:self action:@selector(backUpView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftbutton = [[[UIBarButtonItem alloc]initWithCustomView:lefbt]autorelease];
    self.navigationItem.leftBarButtonItem = leftbutton;
}
-(void)backUpView
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (section == 0) {
        return 4;
    }
    else {
        return 3;
    }
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
        
        
    }
    while ([cell.contentView.subviews lastObject] != nil) {  
        [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];  
    } 
    if (indexPath.section == 0 ) {
        cell.textLabel.text = [[celltext objectAtIndex:0]objectAtIndex:indexPath.row];
        [cell addSubview:[cellcontview objectAtIndex:indexPath.row]];
    }
    else {
        cell.textLabel.text = [[celltext objectAtIndex:1]objectAtIndex:indexPath.row];
        [cell addSubview:[cellcontview objectAtIndex:indexPath.row+4]];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 70.0;
        }
      if (indexPath.row == 3) {
          UILabel *lable = [cellcontview objectAtIndex:3];
          lable.numberOfLines = 0;
          NSString *str = lable.text;
          CGFloat contentWidth = 250;
          UIFont *font = [UIFont systemFontOfSize:isPad()?PadContentFontSmallSize:ContentFontSmallSize];
          CGSize size = [str sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:UILineBreakModeWordWrap];
          CGFloat  height = MAX(size.height, 44.0f);
          CGSize rectf = lable.frame.size;
          rectf.height = height;
          if (isPad()) {
              lable.frame = CGRectMake(200,0,rectf.width,rectf.height);
          }
          else {
               lable.frame = CGRectMake(100,0,rectf.width,rectf.height);
          }
          return rectf.height;
        }
        else {
            return 45.0f;
        }
    }
   else {
        return 45.0f;
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
