//
//  PBDetailActivityViewController.h
//  ParkBusiness
//
//  Created by  on 13-3-8.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBParkManager.h"

@interface PBDetailActivityViewController : UIViewController<PBParkManagerDelegate>
{
    NSMutableArray *nodesMutableArr;
    UIButton *btn;
    BOOL isPressed;
    NSMutableDictionary *dic;
    UIBarButtonItem *rightbtn;
    
}
@property (nonatomic,retain) PBParkManager *parkManager;
@property (nonatomic, readwrite,retain)NSMutableDictionary *data;
@property(nonatomic, retain) NSString *titleName;
@property(nonatomic, retain) IBOutlet UITextView *contentTextView; 


@end
