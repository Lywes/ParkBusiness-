//
//  PBLecturerDetail.m
//  ParkBusiness
//
//  Created by China on 13-7-2.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBLecturerDetail.h"
#import "NSObject+NVBackBtn.h"
#import "NSObject+PBLableHeight.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+WebCache.h"
@interface PBLecturerDetail ()

@end

@implementation PBLecturerDetail
-(void)dealloc
{
    RB_SAFE_RELEASE(_arr);
    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       self.title = @"培训讲师信息";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	NSArray *s1 = [[NSArray alloc]initWithObjects:@"职务",@"单位", nil];
    NSArray *s2 = [[NSArray alloc]initWithObjects:@"讲师简介", nil];
    self.headArr = [[[NSMutableArray alloc]initWithObjects:s1,s2, nil]autorelease];
    [s1 release];
    [s2 release];
    
    NSArray *arr = [[NSArray alloc]initWithObjects:[self.DataDic objectForKey:@"job"],[self.DataDic objectForKey:@"company"], nil];
    _arr = [[NSMutableArray alloc]initWithObjects:[self.DataDic objectForKey:@"name"],arr,[self.DataDic objectForKey:@"introduce"], nil];
    [self customButtomItem:self];

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier]autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section != 2) {
            UILabel *detailTextLabel;
            detailTextLabel = [[UILabel alloc]init];
            detailTextLabel.backgroundColor = [UIColor clearColor];
            detailTextLabel.tag = 130;
            detailTextLabel.numberOfLines = 0;
            [cell.contentView addSubview:detailTextLabel];
            [detailTextLabel release];
        }
 
    }
    //头数据
    if (indexPath.section == 1) {
        cell.textLabel.text = [[self.headArr objectAtIndex:indexPath.section - 1] objectAtIndex:indexPath.row];
    }
    //主要数据
    UILabel *detailTextLabel = (UILabel *)[cell.contentView viewWithTag:130];
    float (^myblock)(NSString *) = ^(NSString *str)
    {
        CGSize a = [str sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(isPad() ? 480 : 210, 1000) lineBreakMode:NSLineBreakByWordWrapping];
        detailTextLabel.text = str;
        return MAX(a.height, 44);
    };
    id text = [_arr objectAtIndex:indexPath.section];
    if ([text isKindOfClass:[NSArray class]]) {
        detailTextLabel.text = [text objectAtIndex:indexPath.row];
         [detailTextLabel setFrame:CGRectMake(isPad()? 250:150, 0, isPad()? 350:150, myblock([text objectAtIndex:indexPath.row]))];
    }
    else
    {
         [detailTextLabel setFrame:CGRectMake(isPad()? 250:150, 0, isPad()? 250:150, myblock(text))];
         detailTextLabel.text = text;
    }
    
    if (indexPath.section == 2) {
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.text = [_arr objectAtIndex:2];
    }
    if (indexPath.section == 0) {
        NSString *str = [self.DataDic objectForKey:@"imagepath"];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOST,str]];
        [cell.imageView setImageWithURL:url];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            NSString *str =  [_arr objectAtIndex:0];
            CGSize a = [str sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(isPad() ? 480 : 210, 1000) lineBreakMode:NSLineBreakByWordWrapping];
            return    MAX(a.height, 44);
        }
        case 1:
        {
            if (indexPath.row == 0) {
                NSString *str =  [[_arr objectAtIndex:1] objectAtIndex:0];
                CGSize a = [str sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(isPad() ? 480 : 210, 1000) lineBreakMode:NSLineBreakByWordWrapping];
                NSLog(@"------%f",MAX(a.height, 44));
                return    MAX(a.height, 44);
            }
            else
            {
                NSString *str =  [[_arr objectAtIndex:1] objectAtIndex:1];
                CGSize a = [str sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(isPad() ? 480 : 210, 1000) lineBreakMode:NSLineBreakByWordWrapping];
                NSLog(@"++++++++++%f",MAX(a.height, 44));
                return    MAX(a.height, 44);
            }

        }
        case 2:
             NSLog(@"////////%f",[self HeightAStr:[self.DataArr objectAtIndex:1]]);
            return [self HeightAStr:[self.DataArr objectAtIndex:1]];
        default:
            return 44.0f;
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        NSString *str = [[self.headArr objectAtIndex:section - 1] objectAtIndex:0];
        return str;
    }
    else
        return nil;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger num = 0;
    switch (section) {
        case 0:
            num = 1;
            break;
        case 1:
            num = 2;
            break;
        case 2:
            num = 1;
            break;
        default:
            break;
    }
    return num;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
