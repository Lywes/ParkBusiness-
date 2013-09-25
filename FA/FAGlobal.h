/*
 Copyright 2012-2014 Jodai Inc. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 1. Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 2. Redistributions in binaryform must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided withthe distribution.
 
 
 */

#import <UIKit/UIKit.h>

// ALog always displays output regardless of the FADEBUG setting
//#define FA_ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define FA_BLog(fmt, ...) \
do { \
if (logging) { \
NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); \
} \
} while(0)

// FADEBUG set in debug build setting's "Other C flags", as -DFADEBUG
//#ifdef FADEBUG
//#define FA_DLog FA_ALog
//#else
#define FA_DLog FA_BLog
extern BOOL logging; // Default is false
//#endif

#define FALOG FA_DLog

// constants
#define kFAProductionServer @"https://go.5asys.com"

#define isOS5() \
([[[UIDevice currentDevice] systemVersion] floatValue]>=5.0)
//legacy paths
#define kFAOldDirectory [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, \
NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString: @"/FA/"]

#define kFAOldDownloadDirectory [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, \
NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString: @"/"]

// color
#define RGBA(r,g,b,a) [UIColor colorWithRed: r/255.0f green: g/255.0f \
blue: b/255.0f alpha: a]

#define BG_RGBA(r,g,b,a) CGContextSetRGBFillColor(context, r/255.0f, \
g/255.0f, b/255.0f, a)

#define kUpdateFGColor RGBA(255, 131, 48, 1)
#define kUpdateBGColor RGBA(255, 228, 201, 1)

#define kInstalledFGColor RGBA(60, 150, 60, 1)
#define kInstalledBGColor RGBA(185, 220, 185, 1)

#define kDownloadingFGColor RGBA(45, 138, 193, 1)
#define kDownloadingBGColor RGBA(173, 213, 237, 1)

#define kPriceFGColor [UIColor darkTextColor]
#define kPriceBorderColor RGBA(185, 185, 185, 1)
#define kPriceBGColor RGBA(217, 217, 217, 1)

// tag
#define __FA_DEPRECATED __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_NA,__MAC_NA,__IPHONE_3_0,__IPHONE_3_0)

// code block
#define RELEASE_SAFELY(__POINTER) { [__POINTER release]; __POINTER = nil; }

#ifdef _FA_VERSION
#define FA_VERSION @ _FA_VERSION
#else
#define FA_VERSION @ "1.0.1"
#endif

#define FA_VERSION_INTERFACE(CLASSNAME)  \
@interface CLASSNAME : NSObject         \
+ (NSString *)get;                      \
@end


#define FA_VERSION_IMPLEMENTATION(CLASSNAME, VERSION_STR)    \
@implementation CLASSNAME                                   \
+ (NSString *)get {                                         \
return VERSION_STR;                                     \
}                                                           \
@end


#define SINGLETON_INTERFACE(CLASSNAME)  \
+ (CLASSNAME*)shared;\



#define SINGLETON_IMPLEMENTATION(CLASSNAME)         \
\
static CLASSNAME* g_shared##CLASSNAME = nil;        \
\
+ (CLASSNAME*)shared                                \
{                                                   \
if (g_shared##CLASSNAME != nil) {                   \
return g_shared##CLASSNAME;                         \
}                                                   \
\
@synchronized(self) {                               \
if (g_shared##CLASSNAME == nil) {                   \
g_shared##CLASSNAME = [[self alloc] init];      \
}                                                   \
}                                                   \
\
return g_shared##CLASSNAME;                         \
}                                                   \
\
+ (id)allocWithZone:(NSZone*)zone                   \
{                                                   \
@synchronized(self) {                               \
if (g_shared##CLASSNAME == nil) {                   \
g_shared##CLASSNAME = [super allocWithZone:zone];    \
return g_shared##CLASSNAME;                         \
}                                                   \
}                                                   \
NSAssert(NO, @ "[" #CLASSNAME                       \
" alloc] explicitly called on singleton class.");   \
return nil;                                         \
}                                                   \
\
- (id)copyWithZone:(NSZone*)zone                    \
{                                                   \
return self;                                        \
}                                                   


#ifndef kCFCoreFoundationVersionNumber_iPhoneOS_4_0
#define kCFCoreFoundationVersionNumber_iPhoneOS_4_0 550.32
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
#define IF_IOS4_OR_GREATER(...) \
if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iPhoneOS_4_0) \
{ \
__VA_ARGS__ \
}
#else
#define IF_IOS4_OR_GREATER(...)
#endif

#define FRIEND_MESSAGE_NOTIFICATION @"FriendMessageCome"
#define GROUP_MESSAGE_NOTIFICATION @"GroupMessageCome"

#define NEW_GROUP_ADD_NOTIFICATION @"newGroupAdd"