//
//  SafeImputCell.h
//  SXY
//
//  Created by souxiuyun on 2019/1/21.
//  Copyright © 2019 XX. All rights reserved.
//

#import "BaseTableViewCell.h"
@class ComTureModel;

NS_ASSUME_NONNULL_BEGIN

@interface SafeImputCell : BaseTableViewCell

@property (nonatomic,strong)UILabel *nameLab;

@property (nonatomic,strong)UITextField *inputTxt;

@property (nonatomic,strong)ComTureModel *model;

@end

NS_ASSUME_NONNULL_END
