//
//  PBfuwutiandiVC.m
//  PBBank
//
//  Created by lywes lee on 13-5-10.
//  Copyright (c) 2013年 shanghai. All rights reserved.
//

#import "PBfuwutiandiVC.h"
#import "PBWebVC.h"
#import "PBSuccessprojectList.h"
#import "PBliuyan.h"
@interface PBfuwutiandiVC ()
-(void)initPresentData;
@end
@implementation PBfuwutiandiVC
-(void)dealloc
{
    [self.headArr release];
    [super dealloc];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"服务天地";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initPresentData];

}
-(void)initPresentData
{
    self.headArr = [NSMutableArray arrayWithObjects:@"申请贷款",@"成功案例",@"网上留言",@"加入联盟",@"关于我们", nil];
}
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.text = [self.headArr objectAtIndex:indexPath.section];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 1:
        {
            PBSuccessprojectList *list = [[PBSuccessprojectList alloc]initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:list animated:YES];
            [list release];
        }
               break;
        case 2:
        {
            PBliuyan *liuyan = [[PBliuyan alloc]initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:liuyan animated:YES];
            [liuyan release];
        }
            break;
        case 4:
        {
            PBWebVC *webview = [[PBWebVC alloc]init];
            [self.navigationController pushViewController:webview animated:YES];
            [webview release];
        }
            break;
            
        default:
            break;
    }
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
