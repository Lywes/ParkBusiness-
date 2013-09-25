//
//  PBCustonTextVC.h
//  ParkBusiness
//
//  Created by China on 13-9-4.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    UITEXTFIELD = 0,
    UITEXTVIEW = 1,
}SHOWKIT;
@interface PBCustonTextVC : UIViewController

{

}

@property(nonatomic,retain) IBOutlet UITextField *textfield;
@property(nonatomic,retain) IBOutlet UITextView *textview;
@property(nonatomic,assign) BOOL show;
@property(nonatomic,retain)NSString *keystr;
@property(nonatomic,retain)NSString *text;
@end
