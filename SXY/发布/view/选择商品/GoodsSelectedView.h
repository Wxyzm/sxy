//
//  GoodsSelectedView.h
//  SXY
//
//  Created by yh f on 2018/12/17.
//  Copyright © 2018年 XX. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GoodsSelectedViewReturnBlock)(NSInteger btnTag);

@interface GoodsSelectedView : UIView

@property (nonatomic,copy)GoodsSelectedViewReturnBlock returnBlock;


@end
