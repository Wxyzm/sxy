//
//  GEditPL.m
//  SXY
//
//  Created by yh f on 2018/12/10.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "GEditPL.h"

@implementation GEditPL

#pragma mark   ========== 发布/编辑商品
+(void)Goods_GoodsSaveGoodsWithDic:(NSDictionary *)infodic
                   WithReturnBlock:(PLReturnValueBlock)returnBlock
                    withErrorBlock:(PLErrorCodeBlock)errorBlock{
    
    [[HttpClient sharedHttpClient] GoodsSaveGoodsWithDic:infodic WithReturnBlock:^(id returnValue) {
        
        NSDictionary *dic = [HttpClient valueWithJsonString:returnValue];
        if ([dic[@"state"] boolValue]) {
            NSDictionary *returnDic= dic[@"data"];
            returnBlock(returnDic[@"result"]);
        }else{
            if ([dic[@"errorCode"] intValue]==201 )
            {
                [[UserPL shareManager] showLoginView];
                return ;
            }
            [HUD show:dic[@"message"]];
            errorBlock(dic[@"message"]);
        }
    } andErrorBlock:^(NSString *msg) {
        errorBlock(msg);
    }];
    
}

#pragma mark   ========== 删除商品
+(void)Goods_GoodsDeleteGoodsWithDic:(NSDictionary *)infodic
                     WithReturnBlock:(PLReturnValueBlock)returnBlock
                      withErrorBlock:(PLErrorCodeBlock)errorBlock{
    
    [[HttpClient sharedHttpClient] GoodsDeleteGoodsWithDic:infodic WithReturnBlock:^(id returnValue) {
        
        NSDictionary *dic = [HttpClient valueWithJsonString:returnValue];
        if ([dic[@"state"] boolValue]) {
            NSDictionary *returnDic= dic[@"data"];
            returnBlock(returnDic[@"result"]);
        }else{
            if ([dic[@"errorCode"] intValue]==201 )
            {
                [[UserPL shareManager] showLoginView];
                return ;
            }
            [HUD show:dic[@"message"]];
            errorBlock(dic[@"message"]);
        }
    } andErrorBlock:^(NSString *msg) {
        [HUD show:msg];
        errorBlock(msg);
    }];
    
}

#pragma mark   ========== 获取商品列表
+(void)Goods_GoodsGetGoodsListWithDic:(NSDictionary *)infodic
                      WithReturnBlock:(PLReturnValueBlock)returnBlock
                       withErrorBlock:(PLErrorCodeBlock)errorBlock{
    
    [[HttpClient sharedHttpClient] GoodsGetGoodsListWithDic:infodic WithReturnBlock:^(id returnValue) {
        
        NSDictionary *dic = [HttpClient valueWithJsonString:returnValue];
        if ([dic[@"state"] boolValue]) {
            NSDictionary *returnDic= dic[@"data"];
            returnBlock(returnDic[@"result"]);
        }else{
            if ([dic[@"errorCode"] intValue]==201 )
            {
                [[UserPL shareManager] showLoginView];
                return ;
            }
            [HUD show:dic[@"message"]];
            errorBlock(dic[@"message"]);
        }
    } andErrorBlock:^(NSString *msg) {
        [HUD show:msg];
        errorBlock(msg);
    }];
    
}

#pragma mark   ========== 获取商品详情
+(void)Goods_GoodsFindGoodsByIdWithDic:(NSDictionary *)infodic
                       WithReturnBlock:(PLReturnValueBlock)returnBlock
                        withErrorBlock:(PLErrorCodeBlock)errorBlock{
    
    [[HttpClient sharedHttpClient] GoodsFindGoodsByIdWithDic:infodic WithReturnBlock:^(id returnValue) {
        
        NSDictionary *dic = [HttpClient valueWithJsonString:returnValue];
        if ([dic[@"state"] boolValue]) {
            NSDictionary *returnDic= dic[@"data"];
            returnBlock(returnDic[@"result"]);
        }else{
            if ([dic[@"errorCode"] intValue]==201 )
            {
                [[UserPL shareManager] showLoginView];
                return ;
            }
            [HUD show:dic[@"message"]];
            errorBlock(dic[@"message"]);
        }
    } andErrorBlock:^(NSString *msg) {
        [HUD show:msg];
        errorBlock(msg);
    }];
    
}




@end
