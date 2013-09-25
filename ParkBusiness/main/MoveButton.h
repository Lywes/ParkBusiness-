//
//  MoveButton.h
//  CustomButton
//
//  Created by lywes on 13-8-24.
//  Copyright (c) 2013年 lywes. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MoveButton;
@protocol MoveButtonDelegate <NSObject>

-(void)touchUpInside:(UIButton*)sender;

@end
@interface MoveButton : UIButton{
    UIButton* countBtn;
    @private
        BOOL canMove;
}
-(void)setTitleWithUnreadCount;
@property(nonatomic,assign)id<MoveButtonDelegate> delegate;
@end
