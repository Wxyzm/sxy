//
//  ProParaMView.h
//  SXY
//
//  Created by yh f on 2018/11/20.
//  Copyright © 2018年 XX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GoodsModel;

typedef void(^ProParaMViewReturnBlock)(GoodsModel *model,NSInteger tag);

@interface ProParaMView : UIView


@property (nonatomic,strong)GoodsModel *model;
@property (nonatomic,copy)ProParaMViewReturnBlock returnBlock;

@end
