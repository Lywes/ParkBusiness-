//
//  FAServerURL.h
//  benesse
//
//  Created by  on 12-9-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FAServerURL: NSObject

@property(nonatomic,copy) NSString *regdeviceurl;
@property(nonatomic,copy) NSString *chgaliasurl;
@property(nonatomic,copy) NSString *writeurl;
@property(nonatomic,copy) NSString *searchinfourl;
@property(nonatomic,copy) NSString *validateurl;
@property(nonatomic,copy) NSString *singlemessageurl;
@property(nonatomic,copy) NSString *groupmessageurl;
@property(nonatomic,copy) NSString *invitegroupurl;
@property(nonatomic,copy) NSString *answergroupurl;
@property(nonatomic,copy) NSString *invitefreindurl;
@property(nonatomic,copy) NSString *answerfreindurl;
@property(nonatomic,copy) NSString *addgroupurl;
@property(nonatomic,copy) NSString *searchfriendurl;
@property(nonatomic,copy) NSString *quitgroupurl;

@end
