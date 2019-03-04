//
//  MIneTopCell.h
//  SXY
//
//  Created by yh f on 2018/11/15.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "BaseTableViewCell.h"
@class MineInfoModel;

typedef void(^MIneTopCellReturnBlock)(NSInteger tag);

@interface MIneTopCell : BaseTableViewCell

@property (nonatomic,strong)MineInfoModel *infoModel;



@property (nonatomic,copy)MIneTopCellReturnBlock returnBlock;


@end
