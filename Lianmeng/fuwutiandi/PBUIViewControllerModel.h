//
//  PBUIViewControllerModel.h
//  PBBank
//
//  Created by lywes lee on 13-5-13.
//  Copyright (c) 2013年 shanghai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBUIViewControllerModel : UIViewController<UITextViewDelegate>
-(UITextView *)addTextViewWithFrame:(CGRect)rect;
//返回按钮
-(void)backUpView;
@end
