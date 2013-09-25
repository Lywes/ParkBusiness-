//
//  ViewController.h
//
//  Created by Alex Barinov
//  Project home page: http://alexbarinov.github.com/UIBubbleTableView/
//
//  This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Unported License.
//  To view a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/
//

#import <UIKit/UIKit.h>
#import "UIBubbleTableViewDataSource.h"
#import "FAPush.h"
#import "PBMessageToolBar.h"
@interface FAPeopleChatView : UIViewController <UIBubbleTableViewDataSource,FAPushNotificationObserver,UIInputToolbarDelegate>
{

}
@property(nonatomic,retain) PBMessageToolBar* inputToolbar;
@property(nonatomic,retain,readwrite) NSString* friendname;
@property(nonatomic,retain,readwrite) NSString* imgpath;
@property(nonatomic,readwrite) int friendid;
@property(nonatomic,readwrite) int groupid;
@property(nonatomic,readwrite) int readflg;
@property(nonatomic,readwrite) int groupflg;
@property(nonatomic,readwrite) int actionflg;
@end
