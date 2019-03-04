//
//  StockPL.h
//  SXY
//
//  Created by yh f on 2019/1/8.
//  Copyright © 2019年 XX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockPL : NSObject



#pragma mark   ========== 获取商铺信息
+ (void)Store_StoreFindStoreByIdWithDic:(NSDictionary *)infodic
                        withReturnBlock:(PLReturnValueBlock)returnBlock
                          andErrorBlock:(PLErrorCodeBlock)errorBlock;


#pragma mark   ========== 获取商铺列表 /souxiu/store/base/getStoreList
+ (void)Store_StoreGetStoreListWithDic:(NSDictionary *)infodic
                       withReturnBlock:(PLReturnValueBlock)returnBlock
                         andErrorBlock:(PLErrorCodeBlock)errorBlock;


#pragma mark   ========== 获取我的商铺信息 /souxiu/store/findMyStoreDetail
+ (void)Store_StoreFindMyStoreDetailWithDic:(NSDictionary *)infodic
                            withReturnBlock:(PLReturnValueBlock)returnBlock
                              andErrorBlock:(PLErrorCodeBlock)errorBlock;



@end
