//
//  ChangeAdressController.h
//  SXY
//
//  Created by souxiuyun on 2019/1/22.
//  Copyright © 2019 XX. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^ChangeAdressControllerReturnBlock)(NSString *cityStr);

@interface ChangeAdressController : BaseViewController

@property (nonatomic,strong)NSDictionary *infoDic;

@property (nonatomic,copy)ChangeAdressControllerReturnBlock returnBlock;

@end

NS_ASSUME_NONNULL_END
