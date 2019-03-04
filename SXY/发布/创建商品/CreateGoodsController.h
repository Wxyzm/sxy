//
//  CreateGoodsController.h
//  SXY
//
//  Created by yh f on 2018/12/18.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^CreateGoodsControllerReturnBlock)(GoodsModel *model);
@interface CreateGoodsController : BaseViewController

@property (nonatomic,copy)CreateGoodsControllerReturnBlock returnBlock;

@property (nonatomic,assign)ReleaseType releaseType;     //现货 1  供应2

@end
