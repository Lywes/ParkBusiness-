//
//  ImagePickerView.h
//  ParkBusiness
//
//  Created by lywes lee on 13-4-15.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol imageviewPickerdelegate
-(void)resultImage:(UIImage *)image;

@end
@interface ImagePickerView : NSObject<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,retain) UIView*sheetview;
@property(nonatomic,retain)UIPopoverController *poovercontroller;
@property(nonatomic,retain)id<imageviewPickerdelegate>delegate;
@property(nonatomic,retain)UIViewController *Controller;
-(id)initWithView:(UIViewController *)viewController;

@end
