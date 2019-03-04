//
//  NameChangeController.h
//  SXY
//
//  Created by yh f on 2018/12/26.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^NameChangeControllerReturnBlock)(NSString *nameStr);

@interface NameChangeController : BaseViewController

@property (nonatomic,strong)NSDictionary *infoDic;

@property (nonatomic,copy)NameChangeControllerReturnBlock returnBlock;



@end
