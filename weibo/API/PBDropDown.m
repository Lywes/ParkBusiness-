//
//  NIDropDown.m
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import "PBDropDown.h"
#import "QuartzCore/QuartzCore.h"

@interface PBDropDown ()
@property(nonatomic, strong) UITableView *table;
@property(nonatomic, strong) UIButton *btnSender;
@property(nonatomic, retain) NSArray *list;
@property(nonatomic, strong)UIImageView *imageView;
@property(nonatomic, strong)NSMutableArray *imageArr;
@end

@implementation PBDropDown
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
- (id)showDropDown:(UIButton *)b height:(CGFloat *)height arr:(NSArray *)arr imageView:(NSArray *)imgArr{
    btnSender = b;
    self = [super init];
    if (self) {
        // Initialization code
        imageArr = [[NSMutableArray alloc] initWithArray:imgArr];
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
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.textLabel.textColor = [UIColor blackColor];
//        cell.textLabel.textColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
    }
//    cell.textLabel.textColor = [UIColor redColor];
//    cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dropnormal.png"]];
    if ([imageArr count]>0) {
        cell.imageView.image = [UIImage imageNamed:[imageArr objectAtIndex:indexPath.row]];
    }
    cell.textLabel.text =[list objectAtIndex:indexPath.row];
    
//    cell.textLabel.highlightedTextColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dropnormal.png"]];
    cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"dropclick.png"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hideDropDown:btnSender];
    UITableViewCell *c = [tableView cellForRowAtIndexPath:indexPath];
    self.title = c.textLabel.text;
    self.rowno = [NSString stringWithFormat:@"%d",indexPath.row];
    self.row = indexPath.row;
    self.image = c.imageView.image;
    [self myDelegate];
}

- (void) myDelegate {
    [self.delegate pbDropDownDelegateMethod:self];   
}

-(void)dealloc {
    [super dealloc];
    [table release];
    [self release];
}

@end
