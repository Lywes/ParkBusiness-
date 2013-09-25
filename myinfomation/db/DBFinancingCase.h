//
//  DBFinancingCase.h
//  ParkBusiness
//
//  Created by China on 13-8-2.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBFinancingCase : NSObject



@property(nonatomic,assign) int no;
@property(nonatomic,assign) int userno;
@property(nonatomic,assign) int projectno;
@property(nonatomic,assign) int productno;
@property(nonatomic,assign) int companyno;
@property(nonatomic,assign) int type;
@property(nonatomic,assign) int trade;
@property(nonatomic,retain) NSString *companyinfo;
@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain) NSString *casedetail;
+(NSMutableArray*)search;
+(int)SaveId:(int)no
      userno:(int)userno
   projectno:(int)projectno
   productno:(int)productno
   companyno:(int)companyno
        type:(int)type
       trade:(int)trade
 companyinfo:(NSString *)companyinfo
        name:(NSString *)name
  casedetail:(NSString *)casedetail;
-(void)save;
@end
