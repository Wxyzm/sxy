//
//  FourPalacesCell.h
//  SXY
//
//  Created by yh f on 2018/11/14.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "BaseTableViewCell.h"
@class FourPalacesCell;



typedef void(^FourPalacesCellReturnBlock)(FourPalacesCell *cell,GoodsModel *model);

@interface FourPalacesCell : BaseTableViewCell

@property (nonatomic,strong)NSArray *FourPalacesArr;

@property (nonatomic,strong)UILabel *nameLab;

@property (nonatomic,copy)FourPalacesCellReturnBlock returnBlock;

+(CGFloat)cellHeightWithArr:(NSArray *)arr;

@end
