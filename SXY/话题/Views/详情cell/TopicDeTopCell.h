//
//  TopicDeTopCell.h
//  SXY
//
//  Created by yh f on 2019/1/16.
//  Copyright © 2019 XX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TopicDeTopCell;
NS_ASSUME_NONNULL_BEGIN

typedef void(^TopicDeTopCellBlock)(WantBuyModel *model,NSInteger btnTag,TopicDeTopCell *thecell);

@interface TopicDeTopCell : BaseTableViewCell

@property (nonatomic,strong)WantBuyModel *detailModel;

@property (nonatomic , copy) TopicDeTopCellBlock returnBlock;
@property (nonatomic,strong)NSMutableArray *ImaArr;

+(CGFloat)cellHeightWithModel:(WantBuyModel *)model;

@end

NS_ASSUME_NONNULL_END
