//
//  ImagePickerView.m
//  ParkBusiness
//
//  Created by lywes lee on 13-4-15.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "ImagePickerView.h"
@implementation ImagePickerView
@synthesize sheetview;
@synthesize poovercontroller;
@synthesize delegate;
@synthesize Controller;
-(id)initWithView:(UIViewController *)viewController
{
    self = [super init];
    if (self) {
        self.Controller = viewController;
        [viewController.view addSubview:self.sheetview];
        UIActionSheet * actionsheet = [[UIActionSheet alloc]initWithTitle:@"头像选择" delegate:self cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) destructiveButtonTitle:@"相册" otherButtonTitles:@"照相机", nil];
        [actionsheet showInView:viewController.view];
    }
    return self;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self getImagePicker:self.Controller.view];
    }
    if (buttonIndex == 1) {
        [self getcamera:self.Controller.view];
    }
}
#pragma mark - 相册
-(void)getImagePicker:(UIView *)view
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagepicker = [[UIImagePickerController alloc]init];
        imagepicker.delegate = self;
        imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; 
        if (isPad()) {
            UIPopoverController *popover = [[UIPopoverController alloc]initWithContentViewController:imagepicker];
            self.poovercontroller = popover;
            [self.poovercontroller presentPopoverFromRect:CGRectMake(100,-450,600,600) inView:view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        }
        else {
            [self.Controller  presentModalViewController:imagepicker animated:YES];
            
        }
        [imagepicker release];
    }
}
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{


        NSData *data;
        
        //切忌不可直接使用originImage，因为这是没有经过格式化的图片数据，可能会导致选择的图片颠倒或是失真等现象的发生，从UIImagePickerControllerOriginalImage中的Origin可以看出，很原始，哈哈
        UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImageWriteToSavedPhotosAlbum(originImage, self , @selector(image:didFinishSavingWithError:contextinfo:), NULL);
        }
    
    
        //图片压缩，因为原图都是很大的，不必要传原图
        UIImage *scaleImage = [self scaleImage:originImage toScale:0.3];
        
        //以下这两步都是比较耗时的操作，最好开一个HUD提示用户，这样体验会好些，不至于阻塞界面
        if (UIImagePNGRepresentation(scaleImage) == nil) {
            //将图片转换为JPG格式的二进制数据
            data = UIImageJPEGRepresentation(scaleImage, 1);
        } else {
            //将图片转换为PNG格式的二进制数据
            data = UIImagePNGRepresentation(scaleImage);
        }
        
        //将二进制数据生成UIImage
        UIImage *image = [UIImage imageWithData:data];
        
        //将图片传递给截取界面进行截取并设置回调方法（协议）
        
    
        [self.delegate resultImage:image];
        if (isPad()) {
            [self.poovercontroller dismissPopoverAnimated:YES];
        }
        else {
            [self.Controller dismissModalViewControllerAnimated:YES];
        }



           
}
#pragma mark - 照相机
-(void)getcamera:(UIView *)view
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagepicker = [[UIImagePickerController alloc]init];
        imagepicker.delegate = self;
        imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        if (isPad()) {
            UIPopoverController *popover = [[UIPopoverController alloc]initWithContentViewController:imagepicker];
            self.poovercontroller = popover;
            [self.poovercontroller presentPopoverFromRect:CGRectMake(100,-450,600,600) inView:view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        }
        else {
            [self.Controller  presentModalViewController:imagepicker animated:YES];
            
        }
        [imagepicker release];
    }
}
#pragma mark - 照相机保存照片的SEL。判断是否保存成功
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)erro contextinfo:(void *)contextinfo{
    if (erro) {
        
    }
    else{
        
    }
}
@end
