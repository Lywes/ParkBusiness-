//
//  PBDropManage.m
//  ParkBusiness
//
//  Created by QDS on 13-5-30.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBDropManage.h"
#import "QuartzCore/QuartzCore.h"
#import "AsyncImageView.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Scale.h"
@interface PBDropManage ()
@property(nonatomic, strong) UITableView *table;
@property(nonatomic, strong) UIButton *btnSender;
@property(nonatomic, retain) NSArray *list;
@property(nonatomic, strong)UIImageView *imageView;
@property(nonatomic, strong)NSMutableArray *imageArr;
@end

@implementation PBDropManage
@synthesize table;
@synthesize rowno;
@synthesize row;
@synthesize btnSender;
@synthesize list;
@synthesize delegate;
@synthesize title;
@synthesize imageView;
@synthesize imageArr;
@synthesize image;
- (id)showDropDown:(UIButton *)b height:(CGFloat *)height arr:(NSArray *)arr imageView:(NSArray *)imgArr isAsync:(BOOL)is{
    btnSender = b;
    self = [super init];
    if (self) {
        if (!isPad()) {
            *height += 80.0f;
        }
        // Initialization code
        imageArr = [[NSMutableArray alloc] initWithArray:imgArr];
        isAsync = is;
        CGRect btn = b.frame;
        self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
        self.list = [NSArray arrayWithArray:arr];
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 8;
        self.layer.shadowOffset = CGSizeMake(-5, 5);
        self.layer.shadowRadius = 5;
        self.layer.shadowOpacity = 0.5;
        imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"droptitle.png"]];
        imageView.frame = CGRectMake(0, 0, btn.size.width, 15);
        table = [[UITableView alloc] initWithFrame:CGRectMake(0, 15, btn.size.width, 0)];
        table.delegate = self;
        table.dataSource = self;
        table.layer.cornerRadius = 5;
        table.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dropnormal.png"]];
        table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, *height);
        CGFloat tableheight = 40*[self.list count];
        table.frame = CGRectMake(0, 15, btn.size.width, *height>tableheight?tableheight:*height);
        [UIView commitAnimations];
        
        [b.superview.superview addSubview:self];
        [self addSubview:imageView];
        [self addSubview:table];
    }
    return self;
}

-(void)hideDropDown:(UIButton *)b {
    CGRect btn = b.frame;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.frame = CGRectMake(btn.origin.x, btn.origin.y+btn.size.height, btn.size.width, 0);
    table.frame = CGRectMake(0, 0, btn.size.width, 0);
    imageView.frame = CGRectMake(0, 0, btn.size.width, 0);
    [UIView commitAnimations];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.list count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.textLabel.font = [UIFont systemFontOfSize:isPad()?16:12];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
//        cell.textLabel.textColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
        cell.textLabel.textColor = [UIColor blackColor];
    }else{
        UIImageView* imageV = (UIImageView*)[[cell contentView] viewWithTag:9];
        UILabel* label = (UILabel*)[[cell contentView] viewWithTag:10];
        [label removeFromSuperview];
        [imageV removeFromSuperview];
    }
    if (isAsync&&indexPath.row>0) {
        cell.textLabel.text = @"";
        UIImageView* imageV = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
        NSString* url = [NSString stringWithFormat:@"%@%@",HOST,[imageArr objectAtIndex:indexPath.row]];
        [imageV setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"socialnet.png"]];
        imageV.tag = 9;
        CGRect frame = isPad()?CGRectMake(44, 0, 300, 39):CGRectMake(44, 0, 106, 39);
        UILabel* label = [[UILabel alloc]initWithFrame:frame];
        label.text =[list objectAtIndex:indexPath.row];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        label.tag = 10;
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:isPad()?16:12];
        label.highlightedTextColor = [UIColor blackColor];
        [[cell contentView] addSubview:label];
        [[cell contentView] addSubview:imageV];
        [imageV release];
        [label release];
    }else{
        cell.imageView.image = [[UIImage imageNamed:[imageArr objectAtIndex:indexPath.row]] scaleToSize:CGSizeMake(30.0f, 30.0f)];
        cell.textLabel.text =[list objectAtIndex:indexPath.row];
        cell.textLabel.highlightedTextColor = [UIColor blackColor];
    }
    cell.selectedBackgroundView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dropclick.png"]]autorelease];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideDropDown:btnSender];
    UITableViewCell *c = [tableView cellForRowAtIndexPath:indexPath];
    if (isAsync&&indexPath.row>0) {
        UIImageView* imageV = (UIImageView*)[[c contentView] viewWithTag:9];
        self.image = imageV.image;
        UILabel* label = (UILabel*)[[c contentView] viewWithTag:10];
        self.title = label.text;
    }else{
        self.image = c.imageView.image;
        self.title = c.textLabel.text;
    }
    self.row = indexPath.row;
    self.rowno = [NSString stringWithFormat:@"%d",indexPath.row];
    [self myDelegate];
}

- (void) myDelegate {
    [self.delegate dropDelegateMethod:self];
}

-(void)dealloc {
    [super dealloc];
    [table release];
    [self release];
}

@end
