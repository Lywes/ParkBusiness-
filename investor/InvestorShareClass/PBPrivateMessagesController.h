//
//  PBPrivateMessagesController.h
//  ParkBusiness
//
//  Created by QDS on 13-3-22.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBSendData.h"
#import "PBActivityIndicatorView.h"

@interface PBPrivateMessagesController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, SuccessSendMessage>
{
    NSString *resultString;
    int keybordHeight;
}

@property (nonatomic, retain) PBActivityIndicatorView *indicator;
@property (nonatomic, retain) UITextField *messageTitleTextFiled;
@property (nonatomic, retain) PBSendData *sendManager;
@property (nonatomic, retain) NSString *messageInvesterNo;
@property (nonatomic, retain) UITextView *messageTextView;
@property (nonatomic, retain) UILabel *textCountLabel;
@property (retain, nonatomic) IBOutlet UITableView *privateMessageTabel;

@end
