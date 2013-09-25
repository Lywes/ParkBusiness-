//
//  PBClassRoomDeatil.h
//  ParkBusiness
//
//  Created by China on 13-7-22.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBdataClass.h"
#import "UIInputToolbar.h"
@class PBActivityIndicatorView;
@interface PBClassRoomDeatil : UIViewController<PBdataClassDelegate,UIInputToolbarDelegate,UIActionSheetDelegate,UIWebViewDelegate>
{
    UIInputToolbar* inputToolbar;
    PBActivityIndicatorView *act;
    PBdataClass* remarkData;
}
@property(nonatomic,retain)NSString * isURL_str;
@property(nonatomic,retain)NSString * detailTitle_str;
@property(nonatomic,retain)NSDictionary * datadic;
@end
