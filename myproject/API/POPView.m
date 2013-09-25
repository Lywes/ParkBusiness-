//
//  POPView.m
//  ParkBusiness
//
//  Created by 新平 圣 on 13-3-24.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "POPView.h"

@implementation POPView
@synthesize _arry,name,delegate;
-(void)dealloc
{
    [self._arry release];
    [self.name release];
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
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}
- (void)popClickAction
{
    CGFloat xWidth;
    CGFloat yHeight;
    CGFloat yOffset;
    if (isPad()) {
        xWidth = 600.0f;
        yHeight = 300.0f;
        yOffset = (self.view.bounds.size.height - yHeight)/3.0f;
    }
    else
    {
        xWidth = self.view.bounds.size.width - 20.0f;
        yHeight = 200.0f;
        yOffset = (self.view.bounds.size.height - yHeight)/3.0f;
    }
    UIPopoverListView *poplistview = [[UIPopoverListView alloc] initWithFrame:CGRectMake(10, yOffset, xWidth, yHeight)];
    poplistview.delegate = self;
    poplistview.datasource = self;
    poplistview.listView.scrollEnabled = TRUE;
    [poplistview setTitle:self.name];
    [poplistview show];
    [poplistview release];
}


#pragma mark - UIPopoverListViewDataSource

- (UITableViewCell *)popoverListView:(UIPopoverListView *)popoverListView
                    cellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:identifier] autorelease];
    
    int row = indexPath.row;
    cell.textLabel.text = [self._arry objectAtIndex:row];

    
    return cell;
}

- (NSInteger)popoverListView:(UIPopoverListView *)popoverListView
       numberOfRowsInSection:(NSInteger)section
{
    return [self._arry count];
}

#pragma mark - UIPopoverListViewDelegate
- (void)popoverListView:(UIPopoverListView *)popoverListView
     didSelectIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate popView:self didSelectIndexPath:indexPath];
}

- (CGFloat)popoverListView:(UIPopoverListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
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

@end
