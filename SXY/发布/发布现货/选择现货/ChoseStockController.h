//
//  ChoseStockController.h
//  SXY
//
//  Created by yh f on 2019/1/1.
//  Copyright © 2019年 XX. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^ChoseStockControllerReturnBlock)(GoodsModel *selectModel);

@interface ChoseStockController : BaseViewController

@property (nonatomic,copy)ChoseStockControllerReturnBlock returnBlock;
@property (nonatomic,assign)ReleaseType releaseType;


@end
