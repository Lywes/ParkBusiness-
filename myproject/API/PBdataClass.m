//
//  PBdataClass.m
//  ParkBusiness
//
//  Created by lywes lee on 13-3-11.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBdataClass.h"
#import "ASIFormDataRequest.h"
#import "APXML.h"
static PBdataClass *sharePBdata = nil;
@implementation PBdataClass
@synthesize datas;
@synthesize validate;
@synthesize delegate = _delegate;
-(id)init
{
    if (self =[super init]) {
        validate = YES;
    }
    return self;
}
+(id)sharePBdataClass
{
    if (!sharePBdata) {
        sharePBdata  = [[super alloc]init];
        
    }

    return sharePBdata;
}
- (void)ASIHttpRequestFailed:(ASIHTTPRequest *)request{
//    if (request) {
//        NSError *error = [request error];
//        NSLog(@"the error is %@",error);
//        [request release];
//    }
//    UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取数据失败" delegate:self cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) otherButtonTitles:nil, nil];
//    [alertview show];
//    [alertview release];
    PBAlertView* alert = [[PBAlertView alloc]initWithMessage:@"网络不给力 请稍后再试"];
    [alert show];
    [alert release];
    if ([_delegate respondsToSelector:@selector(searchFilad)]) {
        [_delegate searchFilad];
    }
}
- (NSString *)decodeFromPercentEscapeString:(NSString *)string {
    NSMutableString* outputStr = [NSMutableString stringWithString:string];
    [outputStr replaceOccurrencesOfString:@"+" withString:@" " options:NSLiteralSearch range:NSMakeRange(0,outputStr.length)];
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
#pragma mark - 查询成功
- (void)searchASIHttpRequestSuceed:(ASIHTTPRequest *)request{
    
    //成功  这里怎么写
    NSString *str = [request responseString];
    NSLog(@"request:%@",str);
    APDocument *document = [APDocument documentWithXMLString:str];
    APElement *elemnt = [document rootElement];
    NSArray *arry = [elemnt childElements];
    //根节点
    datas = [[NSMutableArray alloc]init];
    for (int i=0;i<[arry count]; i++) {
        
        id children  = [[arry objectAtIndex:i]childElements];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        for (APElement * child in children)
        {
            if ([child childCount]>0) {
                NSArray *childArr = [child childElements];
                NSMutableArray* subArr = [[NSMutableArray alloc]init];
                for (int j=0;j<[childArr count]; j++) {
                    id subchildren  = [[childArr objectAtIndex:j]childElements];
                    NSMutableDictionary *subDic = [[NSMutableDictionary alloc]init];
                    for (APElement * subchild in subchildren){
                        [subDic setObject:[self decodeFromPercentEscapeString:subchild.value==NULL?@"":subchild.value] forKey:subchild.name];
                    }
                    [subArr addObject:subDic];
                }
                [dic setObject:subArr forKey:child.name];
            }else{
                [dic setObject:[self decodeFromPercentEscapeString:child.value==NULL?@"":child.value] forKey:child.name];
            }
        }
        [datas addObject:dic];
    }
    [self.delegate dataclass:self response:datas];
}
-(void)SaveASIHttpRequestSuceed:(ASIHTTPRequest *)request
{
    NSString *str = [request responseString];
    NSLog(@"request:%@",str);
    [self.delegate dataclass:self OnServer:str];
}


-(void)dataResponse:(NSURL *)url postDic:(NSDictionary *)dic searchOrSave:(BOOL)searchOrSave
{
	ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setValidatesSecureCertificate:NO];
    [request setDelegate:self];
    [request setDidFailSelector:@selector(ASIHttpRequestFailed:)];
    if (searchOrSave == YES) {
        [request setDidFinishSelector:@selector(searchASIHttpRequestSuceed:)];
    }
    else {
        [request setDidFinishSelector:@selector(SaveASIHttpRequestSuceed:)];
    }
    [request setRequestMethod:@"POST"];
    for (NSString * key in [dic allKeys]) {
        NSString* value = [dic objectForKey:key];
        if (!searchOrSave&&[value isEqualToString:@""]&&validate) {
            [self invalidData];
            return;
        }
        [request setPostValue:value forKey:key];
    }
    
    [request startAsynchronous];
//    [request setShouldAttemptPersistentConnection:NO];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
}
-(void)PostImageResponse:(NSURL *)url postImage:(UIImage *)image Forkey:(NSString *)key postOtherDic:(NSDictionary *)dic searchOrSave:(BOOL)searchOrSave
{
    NSData * dataForPNGFile = [[NSData alloc] initWithData:UIImageJPEGRepresentation(image, 0.0)];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    [request setData:dataForPNGFile withFileName:@"image4.jpg" andContentType:@"image/jpeg" forKey:key];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestFinished:)];
    for (NSString * key in [dic allKeys]) {
        NSString* value = [dic objectForKey:key];
        [request setPostValue:value forKey:key];
    }
    [request setTimeOutSeconds:500];
    [request setShouldAttemptPersistentConnection:NO];
    [request startAsynchronous];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];

}
-(void)uploadImages:(NSURL *)url postImages:(NSArray *)imageArr Forkey:(NSString *)filename withOtherDic:(NSDictionary *)dic
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    for(int i=0 ;i<[imageArr count];i++) {
        UIImage* image = [imageArr objectAtIndex:i];
        NSData * dataForPNGFile = [[NSData alloc] initWithData:UIImageJPEGRepresentation(image, 0.0)];
        NSString* imageName = [NSString stringWithFormat:@"image%d.jpg",i];
        NSString* key = [NSString stringWithFormat:@"%@%d",filename,i+1];
        [request setData:dataForPNGFile withFileName:imageName andContentType:@"image/jpeg" forKey:key];
    }
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestFinished:)];
    for (NSString * key in [dic allKeys]) {
        NSString* value = [dic objectForKey:key];
        [request setPostValue:value forKey:key];
    }
    [request setTimeOutSeconds:500];
    [request setShouldAttemptPersistentConnection:NO];
    [request startAsynchronous];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    
}
-(void)uploadImagesAndDatas:(NSURL *)url withDic:(NSDictionary *)dic
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setDelegate:self];
    [request setRequestMethod:@"POST"];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setDidFinishSelector:@selector(requestFinished:)];
    for (NSString * key in [dic allKeys]) {
        if (
            /*[key isEqualToString:@"institution_logo_filename"]||*/
            [key isEqualToString:@"idcardpic_filename"]||[key isEqualToString:@"carllcard_filename"]) {
            UIImage* image = [dic objectForKey:key];
            if (!image||[image isEqual:@""]) {
                [self invalidData];
                return;
            }
            NSData * dataForPNGFile = [[NSData alloc] initWithData:UIImageJPEGRepresentation(image, 0.0)];
            NSString* imageName = [NSString stringWithFormat:@"image_%@.jpg",key];
            [request setData:dataForPNGFile withFileName:imageName andContentType:@"image/jpeg" forKey:key];
        }
        else if (![key isEqualToString:@"institution_logo_filename"]){
            NSString* value = [dic objectForKey:key];
            if ([value isEqualToString:@""]) {
                [self invalidData];
                return;
            }
            [request setPostValue:value forKey:key];
        }

    }
    [request setTimeOutSeconds:500];
    [request setShouldAttemptPersistentConnection:NO];
    [request startAsynchronous];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    
}
-(void)requestFinished:(ASIHTTPRequest*)request
{
    NSString *str = [request responseString];
    NSLog(@"request:%@",str);
    int a = [str intValue];
    if ([str isEqualToString:@""]) {
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"亲,上传有误" delegate:self cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) otherButtonTitles:nil, nil];
        [alertview show];
        [alertview release];
    }
    else {
        [self.delegate imageIsSuccesePostOnServer:a];
    }
}
-(void)invalidData{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请完善数据再提交！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
    [alert release];
    if ([_delegate respondsToSelector:@selector(searchFilad)]) {
        [_delegate searchFilad];
    }
}
#pragma mark - 查询或者提交失败
-(void)requestFailed:(ASIHTTPRequest*)request
{
//    if (request) {
//        NSError *error = [request error];
//        NSLog(@"the error is %@",error);
//        [request release];
//    }

    if ([_delegate respondsToSelector:@selector(requestFilad)]) {
        [_delegate requestFilad];
    }
    
    PBAlertView* alert = [[PBAlertView alloc]initWithMessage:@"网络不给力 请稍后再试"];
    [alert show];
    [alert release];
//    UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"亲,上传失败" delegate:self cancelButtonTitle:NSLocalizedString(@"nav_btn_qx", nil) otherButtonTitles:nil, nil];
//    [alertview show];
//    [alertview release];
}
@end
