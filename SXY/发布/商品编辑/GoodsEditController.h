//
//  GoodsEditController.h
//  SXY
//
//  Created by souxiuyun on 2019/1/22.
//  Copyright © 2019 XX. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^CreateGoodsControllerReturnBlock)(GoodsModel *model);

@interface GoodsEditController : BaseViewController
@property (nonatomic,copy)CreateGoodsControllerReturnBlock returnBlock;
@property (nonatomic,strong)GoodsModel *nowModel;

@end

NS_ASSUME_NONNULL_END
