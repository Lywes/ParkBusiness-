//
//  CustomTabBar.m
//  CustomTabBar
//
//  Created by Peter Boctor on 1/2/11.
//
// Copyright (c) 2011 Peter Boctor
//

#import "CustomTabBar.h"

#define GLOW_IMAGE_TAG 2394858
#define TAB_ARROW_IMAGE_TAG 2394859
#define SELECTED_ITEM_TAG 2394860

@interface CustomTabBar (PrivateMethods)
- (CGFloat) horizontalLocationFor:(NSUInteger)tabIndex;
-(UIButton *) buttonAtIndex:(NSUInteger)itemIndex width:(CGFloat)width;
-(UILabel *) lableAtIndex:(NSUInteger)itemIndex width:(CGFloat)width;
-(UIImage *) tabBarImage:(UIImage*)startImage size:(CGSize)targetSize backgroundImage:(UIImage*)backgroundImage;
-(UIImage *) blackFilledImageWithWhiteBackgroundUsing:(UIImage*)startImage;
-(UIImage *) tabBarBackgroundImageWithSize:(CGSize)targetSize backgroundImage:(UIImage*)backgroundImage;
@end

@implementation CustomTabBar
@synthesize buttons,delegate;

- (id) initWithItemCount:(NSUInteger)itemCount itemSize:(CGSize)itemSize tag:(NSInteger)objectTag delegate:(NSObject <CustomTabBarDelegate>*)customTabBarDelegate
{
    if (self = [super init])
    {
        //自动调整位置
        self.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        
        // The tag allows callers withe multiple controls to distinguish between them
        self.tag = objectTag;
        
        // Set the delegate
        delegate = customTabBarDelegate;
        
        // Add the background image
        UIImage* backgroundImage = [delegate backgroundImage];
        UIImageView* backgroundImageView = [[[UIImageView alloc] initWithImage:backgroundImage] autorelease];
        backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        backgroundImageView.frame = CGRectMake(0, 0, 320, 49);
        [self addSubview:backgroundImageView];
        
        // Adjust our width based on the number of items & the width of each item
        self.frame = CGRectMake(0, 0, itemSize.width * itemCount, itemSize.height);
        self.buttons = [[NSMutableArray alloc] initWithCapacity:itemCount];
        
        // horizontalOffset tracks the proper x value as we add buttons as subviews
        CGFloat horizontalOffset = 0;
        for (NSUInteger i = 0 ; i < itemCount ; i++)
        {
            UIButton* button = [self buttonAtIndex:i width:self.frame.size.width/itemCount];
            UILabel *  titleLable = [self lableAtIndex:i width:self.frame.size.width/itemCount];
            [button addTarget:self action:@selector(touchDownAction:) forControlEvents:UIControlEventTouchDown];
            [button addTarget:self action:@selector(touchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
            [button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchUpOutside];
            [button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchDragOutside];
            [button addTarget:self action:@selector(otherTouchesAction:) forControlEvents:UIControlEventTouchDragInside];
            [buttons addObject:button];
            button.frame = CGRectMake(horizontalOffset, 0.0, button.frame.size.width, button.frame.size.height);
            [self addSubview:button];
            [self addSubview:titleLable];
            horizontalOffset = horizontalOffset + itemSize.width;
        }
    }
    return self;
}

-(void) dimAllButtonsExcept:(UIButton *)selectedButton
{
    for (UIButton* button in buttons)
    {
        if (button == selectedButton)
        {
            button.selected = YES;
            button.highlighted = NO;
            button.tag = SELECTED_ITEM_TAG; 
            UIImageView* tabBarArrow = (UIImageView*)[self viewWithTag:TAB_ARROW_IMAGE_TAG];
            NSUInteger selectedIndex = [buttons indexOfObjectIdenticalTo:button];
            if (tabBarArrow) {
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.2];
                CGRect frame = tabBarArrow.frame;
                frame.origin.x = [self horizontalLocationFor:selectedIndex];
                tabBarArrow.frame = frame;
                [UIView commitAnimations];
            } else {
                UIImage* tabBarArrowImage = [delegate tabBarArrowImage];              
                UIImageView* tabBarArrow = [[[UIImageView alloc] initWithImage:tabBarArrowImage] autorelease];
                tabBarArrow.tag = TAB_ARROW_IMAGE_TAG;
                CGFloat verticalLocation = -tabBarArrowImage.size.height + 2;
                tabBarArrow.frame = CGRectMake([self horizontalLocationFor:selectedIndex], verticalLocation, tabBarArrowImage.size.width, tabBarArrowImage.size.height);
                [self addSubview:tabBarArrow];
            }
        } else {
            button.selected = NO;
            button.highlighted = NO;
            button.tag = 0;
        }
    }
}

- (void)touchDownAction:(UIButton*)button
{
    [self dimAllButtonsExcept:button];
    
    if ([delegate respondsToSelector:@selector(touchDownAtItemAtIndex:)])
        [delegate touchDownAtItemAtIndex:[buttons indexOfObject:button]];
}

- (void)touchUpInsideAction:(UIButton*)button
{
    [self dimAllButtonsExcept:button];
    
    if ([delegate respondsToSelector:@selector(touchUpInsideItemAtIndex:)])
        [delegate touchUpInsideItemAtIndex:[buttons indexOfObject:button]];
}

- (void)otherTouchesAction:(UIButton*)button
{
    [self dimAllButtonsExcept:button];
}

- (void) selectItemAtIndex:(NSInteger)index
{
    // Get the right button to select
    UIButton* button = [buttons objectAtIndex:index];
    
    [self dimAllButtonsExcept:button];
}

- (CGFloat) horizontalLocationFor:(NSUInteger)tabIndex
{
    UIImageView* tabBarArrow = (UIImageView*)[self viewWithTag:TAB_ARROW_IMAGE_TAG];
    UIButton* button = [buttons objectAtIndex:tabIndex];
    CGFloat tabItemWidth = button.frame.size.width;
    CGFloat halfTabItemWidth = (tabItemWidth / 2.0) - (tabBarArrow.frame.size.width / 2.0);
    return button.frame.origin.x + halfTabItemWidth;
}

// Create a button at the provided index
- (UIButton*) buttonAtIndex:(NSUInteger)itemIndex width:(CGFloat)width
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0.0, 0.0, width, self.frame.size.height-15);
    UIImage* rawButtonImage = [delegate imageFor:self atIndex:itemIndex];
    UIImage* buttonImage = [self tabBarImage:rawButtonImage size:button.frame.size backgroundImage:nil];
    UIImage* buttonPressedImage = [self tabBarImage:rawButtonImage size:button.frame.size backgroundImage:[delegate selectedItemBackgroundImage]];
    [button setImage
     :buttonImage forState:UIControlStateNormal];
    [button setImage:buttonPressedImage forState:UIControlStateHighlighted];
    [button setImage:buttonPressedImage forState:UIControlStateSelected];
    [button setBackgroundImage:[delegate selectedItemImage] forState:UIControlStateHighlighted];
    [button setBackgroundImage:[delegate selectedItemImage] forState:UIControlStateSelected];
    button.adjustsImageWhenHighlighted = NO;
    return button;
}
-(UILabel *) lableAtIndex:(NSUInteger)itemIndex width:(CGFloat)width
{
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(width *itemIndex, self.frame.size.height-15, width, 10)];
    lable.backgroundColor = [UIColor clearColor];
    lable.textColor = [UIColor whiteColor];
    lable.textAlignment = UITextAlignmentCenter;
    lable.font = [UIFont systemFontOfSize:10];
    NSString *title = [delegate titleFor:self atIndex:itemIndex];
    lable.text = title;
    return lable;
}
// Create a tab bar image
-(UIImage*) tabBarImage:(UIImage*)startImage size:(CGSize)targetSize backgroundImage:(UIImage*)backgroundImageSource
{
    UIImage* backgroundImage = [self tabBarBackgroundImageWithSize:startImage.size backgroundImage:backgroundImageSource];
    UIImage* bwImage = [self blackFilledImageWithWhiteBackgroundUsing:startImage];
    CGImageRef imageMask = CGImageMaskCreate(CGImageGetWidth(bwImage.CGImage), CGImageGetHeight(bwImage.CGImage), CGImageGetBitsPerComponent(bwImage.CGImage), CGImageGetBitsPerPixel(bwImage.CGImage), CGImageGetBytesPerRow(bwImage.CGImage), CGImageGetDataProvider(bwImage.CGImage), NULL, YES);
    CGImageRef tabBarImageRef = CGImageCreateWithMask(backgroundImage.CGImage, imageMask);
    UIImage* tabBarImage = [UIImage imageWithCGImage:tabBarImageRef scale:startImage.scale orientation:startImage.imageOrientation];
    CGImageRelease(imageMask);
    CGImageRelease(tabBarImageRef);
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);
    [tabBarImage drawInRect:CGRectMake((targetSize.width/2.0) - (startImage.size.width/2.0), (targetSize.height/2.0) - (startImage.size.height/2.0), startImage.size.width, startImage.size.height)];
    UIImage* resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

// Convert the image's fill color to black and background to white
-(UIImage*) blackFilledImageWithWhiteBackgroundUsing:(UIImage*)startImage
{
    CGRect imageRect = CGRectMake(0, 0, CGImageGetWidth(startImage.CGImage), CGImageGetHeight(startImage.CGImage));
    CGContextRef context = CGBitmapContextCreate(NULL, imageRect.size.width, imageRect.size.height, 8, 0, CGImageGetColorSpace(startImage.CGImage), kCGImageAlphaPremultipliedLast);
    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
    CGContextFillRect(context, imageRect);
    CGContextClipToMask(context, imageRect, startImage.CGImage);
    CGContextSetRGBFillColor(context, 0, 0, 0, 1);
    CGContextFillRect(context, imageRect);
    CGImageRef newCGImage = CGBitmapContextCreateImage(context);
    UIImage* newImage = [UIImage imageWithCGImage:newCGImage scale:startImage.scale orientation:startImage.imageOrientation];
    CGContextRelease(context);
    CGImageRelease(newCGImage);
    return newImage;
}

-(UIImage*) tabBarBackgroundImageWithSize:(CGSize)targetSize backgroundImage:(UIImage*)backgroundImage
{
    UIGraphicsBeginImageContextWithOptions(targetSize, NO, 0.0);
    if (backgroundImage)
    {
        [backgroundImage drawInRect:CGRectMake((targetSize.width - CGImageGetWidth(backgroundImage.CGImage)) / 2, (targetSize.height - CGImageGetHeight(backgroundImage.CGImage)) / 2, CGImageGetWidth(backgroundImage.CGImage), CGImageGetHeight(backgroundImage.CGImage))];
    } else {
        [[UIColor lightGrayColor] set];
        UIRectFill(CGRectMake(0, 0, targetSize.width, targetSize.height));
    }
    UIImage* finalBackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return finalBackgroundImage;
}


- (void)dealloc
{
    [super dealloc];
    [buttons release];
}

@end
