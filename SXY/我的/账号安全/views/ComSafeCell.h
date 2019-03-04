//
//  ComSafeCell.h
//  SXY
//
//  Created by yh f on 2018/12/28.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "BaseTableViewCell.h"
@class ComTureModel;

@interface ComSafeCell : BaseTableViewCell

@property (nonatomic,copy)UILabel *nameLab;

@property (nonatomic,copy)UILabel *showLab;

@property (nonatomic,copy)UIImageView *rightIma;

@property (nonatomic,strong)ComTureModel *model;



@end
