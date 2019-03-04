//
//  GoodsShowView.h
//  SXY
//
//  Created by yh f on 2019/1/1.
//  Copyright © 2019年 XX. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GoodsShowViewReturnBlock)(GoodsModel *model,NSInteger type);
@interface GoodsShowView : UIView

@property (nonatomic,strong)GoodsModel *model;

@property (nonatomic,copy)GoodsShowViewReturnBlock returnBlock;


@end
