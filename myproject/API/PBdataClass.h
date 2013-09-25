//
//  PBdataClass.h
//  ParkBusiness
//
//  Created by lywes lee on 13-3-11.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PBdataClass;
@protocol PBdataClassDelegate
@optional
-(void)datasCounts:(NSMutableArray *)datas;
-(void)dataclass:(PBdataClass *)dataclass response:(NSMutableArray *)datas;//单一从网上获取数据成功回调
-(void)dataclass:(PBdataClass *)dataclass OnServer:(NSString*)intvalue;//单一上传服务器成功后的回调
-(void)imageIsSuccesePostOnServer:(int)intvalue;
-(void)requestFilad;
-(void)searchFilad;
@end
@interface PBdataClass : NSObject
{
    id _delegate;
}
@property(nonatomic,assign)id<PBdataClassDelegate> delegate;
@property(nonatomic,retain)NSMutableArray *datas;
@property(nonatomic)BOOL validate;
+(PBdataClass *)sharePBdataClass;
-(void)uploadImages:(NSURL *)url postImages:(NSArray *)imageArr Forkey:(NSString *)filename withOtherDic:(NSDictionary *)dic;
-(void)uploadImagesAndDatas:(NSURL *)url withDic:(NSDictionary *)dic;
-(void)dataResponse:(NSURL *)url postDic:(NSDictionary *)dic searchOrSave:(BOOL)searchOrSave;
-(void)PostImageResponse:(NSURL *)url postImage:(UIImage *)image Forkey:(NSString *)key postOtherDic:(NSDictionary *)dic searchOrSave:(BOOL)searchOrSave;
@end
