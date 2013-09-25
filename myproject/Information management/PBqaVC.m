//
//  PBqaVC.m
//  ParkBusiness
//
//  Created by lywes lee on 13-3-27.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBqaVC.h"

@interface PBqaVC ()

@end

@implementation PBqaVC
@synthesize qa;
-(void)dealloc
{
//    [myname release];
//    [createdate release];
//    [answer release];
//    [question release];
    [qa release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 2;
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
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
        if (indexPath.section == 0) {
            UILabel *lable = [[[UILabel alloc]initWithFrame:CGRectMake(2, 0, 300, cell.frame.size.height)]autorelease];
            [cell.contentView addSubview:lable];
            lable.backgroundColor = [UIColor clearColor];
            lable.tag = 10;
            if (isPad()) {
                lable.frame = CGRectMake(2, 0, 679, cell.frame.size.height);
            }
        }
        if (indexPath.section == 1) {
            UITextView *lable = [[[UITextView alloc]initWithFrame:CGRectMake(0, 0, 300, 200)]autorelease];
            [cell.contentView addSubview:lable];
            lable.textAlignment = UITextAlignmentLeft;
            lable.backgroundColor = [UIColor clearColor];
            [lable setEditable:NO];
            lable.tag = 20;
            if (isPad()) {
                lable.frame = CGRectMake(0, 0, 679, 200);
            }
        }
        
    }

    UILabel *question = (UILabel *)[cell.contentView viewWithTag:10];
    question.text = [self.qa objectForKey:@"question"];
    UITextView *answer = (UITextView *)[cell.contentView viewWithTag:20];
    answer.text = [self.qa objectForKey:@"answer"];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat i;
    if (indexPath.section == 0) {
        i = 44;
    }
    else {
        i = 200;
    }
    return i;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *str;
    if (section == 0) {
        str = @"问题";
    }
    else {
        str = @"回复";
    }
    return str;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{

    if (section == 1) {
        NSString *name = [self.qa objectForKey:@"myname"];
        NSString *time = [self.qa objectForKey:@"createdate"];
        NSString *str = [NSString stringWithFormat:@"回复人:%@        %@",name,time];
        return str;
    }
    else {
        return nil;
    }
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
