//
//  PBAnswer.h
//  ParkBusiness
//
//  Created by QDS on 13-6-20.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBtableViewEdit.h"
#import "UIInputToolbar.h"
#import "PBdataClass.h"
@interface PBAnswer : PBtableViewEdit<UIInputToolbarDelegate,PBdataClassDelegate>
@property(nonatomic,retain)NSDictionary * data_dic;
@property(nonatomic,retain)UIInputToolbar *keytoolbar;
@end
