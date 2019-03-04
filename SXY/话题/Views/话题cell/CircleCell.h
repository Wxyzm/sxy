//
//  CircleCell.h
//  SXY
//
//  Created by yh f on 2018/12/21.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "BaseTableViewCell.h"
@class WantBuyModel;
@class CircleCell;

typedef void(^CircleCellReturnBlock)(WantBuyModel *model,NSInteger tag,CircleCell *thecell);

@interface CircleCell : BaseTableViewCell

@property (nonatomic,strong)WantBuyModel *model;

@property (nonatomic,copy)CircleCellReturnBlock returnBlock;
@property (nonatomic,strong)NSMutableArray *ImaArr;


+(CGFloat)cellHeightWithModel:(WantBuyModel *)model;


@end
