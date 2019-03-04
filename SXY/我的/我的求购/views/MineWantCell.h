//
//  MineWantCell.h
//  SXY
//
//  Created by yh f on 2018/11/17.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface MineWantCell : BaseTableViewCell


@property (nonatomic,strong)WantBuyModel *model;


+(CGFloat )cellheightWithModel:(WantBuyModel *)model;


@end
