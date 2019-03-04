//
//  ParaMCell.h
//  SXY
//
//  Created by yh f on 2018/11/21.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "BaseTableViewCell.h"
@interface ParaMCell : BaseTableViewCell

@property (nonatomic,strong)    UILabel *nameLab;
@property (nonatomic,strong)   UILabel *valueLab;


+(CGFloat)cellHeightWithtitleStr:(NSString *)nameStr andmemoStr:(NSString *)memoStr;

@end
