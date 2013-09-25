//
//  FADataManager.h
//  benesse
//
//  Created by  on 12-9-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FAGlobal.h"
#import "FACloud.h"

@protocol FADataManagerDelegate
@optional

- (void)saveData:(NSDictionary *)data primaryKey:(NSString *)key;
-(void)searchResult:(NSArray *)res withFormatId:(int)formatid;
@end

@interface FADataManager : NSObject

@property (nonatomic, retain) id<FADataManagerDelegate> delegate;

- (void)writeWithFormatId:(int)fid  sendData:(NSDictionary *)data ;
- (void)searchDataWithFormatId:(int)fid condition:(NSDictionary *)data;
@end
