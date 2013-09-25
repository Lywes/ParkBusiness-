//
//  PBPersonalBlogViewController.h
//  ParkBusiness
//
//  Created by  on 13-3-15.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBParkManager.h"
#import "PBBlogReplyViewController.h"
#import "YIPopupTextView.h"
#import "UIInputToolbar.h"
#import "PBBlogTitleView.h"
#import "PBPullTableViewController.h"


@interface PBPersonalBlogViewController : UIViewController<PBParkManagerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,YIPopupTextViewDelegate,UIInputToolbarDelegate,PBPullTableViewDelegete>{
   
    PBPullTableViewController* pullController;
    
    NSMutableArray  *nodesMutableArr;
    PBBlogReplyViewController *blogReplyVC;
    BOOL btnPressed;
    YIPopupTextView *popupTextView;
    PBBlogTitleView *titleView;
   
    
}

@property (nonatomic, retain) UITextView *blogContentTextView;
@property (nonatomic, retain) YIPopupTextView *popupTextView;
@property (nonatomic, retain) NSString *blogContent;
@property (nonatomic, retain) UIInputToolbar *inputToolbar;
@property (nonatomic, readwrite,retain)NSString* tcontentno;//UIInputToolbar中的内容
@property (nonatomic, readwrite,retain)NSMutableDictionary *data;
@property (nonatomic, retain) PBParkManager *parkManager;

-(void)refreshData;
-(void)rightBtn;
-(void)requestData:(NSString *)pageno;
-(void)nice:(id)sender;
-(void)submitBlogContent;
-(CGFloat)tableView:(UITableView *)tableView heightForRow:(NSUInteger)row;
-(void)replyWeibo:(id)sender;
@end
