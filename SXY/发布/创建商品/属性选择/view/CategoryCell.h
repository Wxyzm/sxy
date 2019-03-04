//
//  CategoryCell.h
//  SXY
//
//  Created by yh f on 2018/12/19.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "BaseTableViewCell.h"
@class CategoryModel;

typedef void(^CategoryCellReturnBlock)(CategoryModel *model);
@interface CategoryCell : BaseTableViewCell

@property (nonatomic,strong)CategoryModel *model;

@property (nonatomic,copy)CategoryCellReturnBlock returnBlock;

@property (nonatomic,strong)UIButton *deleteBtn;

@end
