//
//  CircleComCell.h
//  SXY
//
//  Created by yh f on 2019/1/15.
//  Copyright © 2019 XX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WantBuyModel;
@class CircleComCell;

typedef void(^CircleComCellReturnBlock)(WantBuyModel *model,NSInteger tag,CircleComCell *thecell);

@interface CircleComCell : BaseTableViewCell

@property (nonatomic,strong)UIImageView *faceIma;

@property (nonatomic,strong)UIButton *replyBtn;

@property (nonatomic,strong)NSMutableArray *ImaArr;

@property (nonatomic,strong)WantBuyModel *model;

@property (nonatomic,copy)CircleComCellReturnBlock returnBlock;


+(CGFloat)cellHeightWithModel:(WantBuyModel *)model;


@end


