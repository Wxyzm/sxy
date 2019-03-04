//
//  GoodsClassListController.h
//  SXY
//
//  Created by yh f on 2018/12/18.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "BaseViewController.h"
@class CategoryModel;

typedef void(^ClassListReturnBlock)(CategoryModel *model);
@interface GoodsClassListController : BaseViewController

@property (nonatomic,copy)ClassListReturnBlock returnBlock;


@end
