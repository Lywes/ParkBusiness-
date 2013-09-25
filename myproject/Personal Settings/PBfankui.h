//
//  PBfankui.h
//  ParkBusiness
//
//  Created by lywes lee on 13-4-21.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBtableViewEdit.h"
#import "PBdataClass.h"
@interface PBfankui : PBtableViewEdit<PBdataClassDelegate>
{
    UITextView *textview;
}
@property(nonatomic,retain)NSString* flag;
@end
