//
//  PBPOPViewSetting.h
//  ParkBusiness
//
//  Created by China on 13-7-18.
//  Copyright (c) 2013年 wangzhigang. All rights reserved.
//

#import "UITbavleViewControllerModel.h"
@class PBFinancalProductsController;
@interface PBPOPViewSetting : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray* mainArr;
}
@property(nonatomic,assign)PBFinancalProductsController*fin;
@property(nonatomic,assign)UITableView *maintableView;
@property(nonatomic,assign)UITableView *subtableView;
@property(nonatomic,assign)int projecttype;
@property(nonatomic,retain)NSMutableArray *headArr;//每个cell上前面的提示标题
@property(nonatomic,retain)NSMutableArray *licaiArr;//每个cell上前面的提示标题
@property(nonatomic,retain)NSMutableArray *DataArr;//每个cell上正式内容
@end
