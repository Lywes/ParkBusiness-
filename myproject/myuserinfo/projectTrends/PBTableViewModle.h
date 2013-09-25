//
//  PBTableViewModle.h
//  ParkBusiness
//
//  Created by lywes lee on 13-3-28.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum 
{
    BIANJIBUTTON = 0,
    ZUIJIABUTTON = 1,
    WANCHENBUTTON = 2,
}RIGHT;
@interface PBTableViewModle : UITableViewController<UITextFieldDelegate,UITextViewDelegate>
@property(nonatomic,retain)NSMutableArray *mustResignFirstResponder;
-(void)navigatorRightButtonType:(RIGHT)type;
-(void)editButtonPress:(id)sender;
-(UITextField *)addTextField:(UITableViewCell *)cell withString:(NSString *)str;
-(UITextView *)addTextView:(UITableViewCell *)cell;
-(UITextView *)addTextView:(UITableViewCell *)cell withFram:(CGRect)frame withString:(NSString *)str;
-(UILabel *)addLable:(UITableViewCell *)cell;
-(UILabel *)addLable:(UITableViewCell *)cell withFram:(CGRect)frame withName:(NSString *)name;
@end
