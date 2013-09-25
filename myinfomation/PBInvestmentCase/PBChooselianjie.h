//
//  PBChooselianjie.h
//  ParkBusiness
//
//  Created by China on 13-8-2.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "PBCompanyChoose.h"
@class PBFinancingCase;
@interface PBChooselianjie : PBCompanyChoose
{
    NSInteger index;//存取选中的链接的索引，跟下面的indexpath差不多功能，有点多余。
    BOOL isSelect;//判断是否选了链接。
}
@property(nonatomic,assign)PBFinancingCase *financingcase;//PBFinancingCase 的赋值品
@property(nonatomic,retain) NSIndexPath *indexpath;//存取选中的链接
@end
