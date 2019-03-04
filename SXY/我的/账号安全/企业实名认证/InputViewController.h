//
//  InputViewController.h
//  SXY
//
//  Created by yh f on 2018/12/28.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "BaseViewController.h"

@class ComTureModel;

typedef void(^InputViewControllerReturnBlock)(ComTureModel *model);

@interface InputViewController : BaseViewController


@property (nonatomic,strong)ComTureModel *model;

@property (nonatomic,copy)InputViewControllerReturnBlock returnBlock;


@end
