//
//  OtherCategoryController.h
//  SXY
//
//  Created by yh f on 2018/12/19.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "BaseViewController.h"
@class CategoryModel;

//加载的方式
typedef NS_ENUM(NSInteger, CategorType) {
    CategorType_Width         = 1,      //幅宽
    CategorType_Comp          = 2,      //成分
    CategorType_time          = 3,       //时间
    CategorType_vail          = 4      //单位

};

typedef void(^OtherCategoryControllerReturnBlock)(CategoryModel *selectedModel);

@interface OtherCategoryController : BaseViewController

@property (nonatomic,assign)CategorType type;

@property (nonatomic,copy)OtherCategoryControllerReturnBlock returnBlock;


@end
