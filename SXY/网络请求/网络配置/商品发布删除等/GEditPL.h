//
//  GEditPL.h
//  SXY
//
//  Created by yh f on 2018/12/10.
//  Copyright © 2018年 XX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GEditPL : NSObject

#pragma mark   ========== 发布/编辑商品
+(void)Goods_GoodsSaveGoodsWithDic:(NSDictionary *)dic
                   WithReturnBlock:(PLReturnValueBlock)returnBlock
                    withErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark   ========== 删除商品
+(void)Goods_GoodsDeleteGoodsWithDic:(NSDictionary *)dic
                     WithReturnBlock:(PLReturnValueBlock)returnBlock
                      withErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark   ========== 获取商品列表
+(void)Goods_GoodsGetGoodsListWithDic:(NSDictionary *)dic
                      WithReturnBlock:(PLReturnValueBlock)returnBlock
                       withErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark   ========== 获取商品详情
+(void)Goods_GoodsFindGoodsByIdWithDic:(NSDictionary *)dic
                       WithReturnBlock:(PLReturnValueBlock)returnBlock
                        withErrorBlock:(PLErrorCodeBlock)errorBlock;



@end
