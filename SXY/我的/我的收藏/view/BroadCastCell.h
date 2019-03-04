//
//  BroadCastCell.h
//  SXY
//
//  Created by yh f on 2018/11/19.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "BaseTableViewCell.h"

@class CollectCirModel;

typedef void(^BroadCastCellReturnBlock)(CollectCirModel *model);

@interface BroadCastCell : BaseTableViewCell

@property (nonatomic,strong)CollectCirModel *model;

@property (nonatomic,copy)BroadCastCellReturnBlock returnBlock;


+(CGFloat)cellHeightWithModel:(CollectCirModel*)model;

@end
