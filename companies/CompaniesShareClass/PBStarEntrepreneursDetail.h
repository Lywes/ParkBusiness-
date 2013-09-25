//
//  PBStarEntrepreneursDetail.h
//  ParkBusiness
//
//  Created by lywes lee on 13-3-8.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBCompanyDataManager.h"
#import "PBdataClass.h"

@interface PBStarEntrepreneursDetail : UIViewController <UITableViewDataSource, UITableViewDelegate, PBdataClassDelegate>
{
    NSArray *starEntrepreneursDatarow;
    PBdataClass *dataclass;
}

//把字典数据传过来，那么no和imagepath直接从字典中取
@property (nonatomic, retain) NSString *no;
@property (nonatomic, retain) NSDictionary *dataDictionary;
@property (retain, nonatomic) IBOutlet UITableView *starDetailTabelView;
@end
