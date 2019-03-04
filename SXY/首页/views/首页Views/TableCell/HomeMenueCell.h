//
//  HomeMenueCell.h
//  SXY
//
//  Created by yh f on 2018/11/9.
//  Copyright © 2018年 XX. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HomeMenueCellReturnBlock)(NSInteger tag);
@interface HomeMenueCell : BaseTableViewCell

@property (nonatomic,strong)NSArray *CarouseArr;

@property (nonatomic,copy)HomeMenueCellReturnBlock returnBlock;


+(CGFloat)cellHeight;


@end
