//
//  WantBuyViewCell.h
//  SXY
//
//  Created by yh f on 2018/11/14.
//  Copyright © 2018年 XX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WantBuyViewCell;

typedef void(^WantBuyViewCellReturnBlock)(WantBuyModel *buyModel,NSInteger btntag,WantBuyViewCell *theCell);

@interface WantBuyViewCell : BaseTableViewCell


@property (nonatomic,strong)WantBuyModel *buyModel;

@property (nonatomic,copy)WantBuyViewCellReturnBlock returnBlock;

@property (nonatomic,strong)NSMutableArray *ImaArr;


+(CGFloat)cellHeight;

@end
