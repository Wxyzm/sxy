//
//  ChoseStockCell.h
//  SXY
//
//  Created by yh f on 2019/1/1.
//  Copyright © 2019年 XX. All rights reserved.
//

#import "BaseTableViewCell.h"

typedef void(^ChoseStockCellReturnBlock)(GoodsModel*model);

@interface ChoseStockCell : BaseTableViewCell

@property (nonatomic,strong)GoodsModel *model;


@property (nonatomic,copy)ChoseStockCellReturnBlock returnBlock;


@end
