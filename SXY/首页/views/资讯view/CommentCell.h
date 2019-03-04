//
//  CommentCell.h
//  SXY
//
//  Created by yh f on 2019/1/4.
//  Copyright © 2019年 XX. All rights reserved.
//

#import "BaseTableViewCell.h"
@class CommentModel;

typedef void(^CommentCellReturnBlock)(CommentModel *model);

@interface CommentCell : BaseTableViewCell

@property (nonatomic,strong)CommentModel *model;

@property (nonatomic,copy)CommentCellReturnBlock returnBlock;

@property (nonatomic , strong)UIButton *agreeBtn;


+(CGFloat )cellHeightWithModel:(CommentModel *)model;

@end
