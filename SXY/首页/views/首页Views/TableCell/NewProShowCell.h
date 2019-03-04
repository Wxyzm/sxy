//
//  NewProShowCell.h
//  SXY
//
//  Created by yh f on 2018/11/10.
//  Copyright © 2018年 XX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsModel;

typedef void(^NewProShowCellReturnBlock)(GoodsModel *model);

@interface NewProShowCell : BaseTableViewCell


@property (nonatomic,strong)NSArray *proArr;

@property (nonatomic,copy)NewProShowCellReturnBlock returnBlock;


+(CGFloat)cellHeight;

@end
