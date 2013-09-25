//
//  FAChatManager.h
//  benesse
//
//  Created by  on 12-9-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FAGlobal.h"
#import "FACloud.h"
#import "PBActivityIndicatorView.h"
@protocol FAChatManagerDelegate

@optional
- (void)saveGroup:(NSString *)name withGroupId:(int)gid;
-(void)getGroupMemberResult:(NSArray *)res;
-(void)getGroupMemberResultByName:(NSArray *)res;

@end

@interface FAChatManager : NSObject
@property (nonatomic, retain) PBActivityIndicatorView* activity;
@property (nonatomic, retain) id<FAChatManagerDelegate> delegate;

-(void)sendMessageToFreind:(int)toid withGroupId:(int)gid fromId:(int)fromid withMessage:(NSString *)message;
-(void)sendMessageTogroup:(int)gid fromId:(int)fromid withMessage:(NSString *)message;
-(void)inviteToGroup:(int)gid toFreind:(int)fid fromid:(int)fromid;
-(void)reponseToBeGroupMember:(int)gid withId:(int)userid;
-(void)inviteToBeFreindTo:(int)fid fromId:(int)fromid;
-(void)reponseToBeFreind:(int)fid withId:(int)userid;
-(void)addNewGroupWithName:(NSString *)name byId:(int)userid;
-(void)searchGroupMemberByGroupId:(int)gid doById:(int)userid;
-(void)searchGroupMemberByName:(NSString *)name doById:(int)userid;
-(void)quitFromGroup:(int)gid withUserid:(int)userid;
@end
