//
//  StockPL.m
//  SXY
//
//  Created by yh f on 2019/1/8.
//  Copyright © 2019年 XX. All rights reserved.
//

#import "StockPL.h"

@implementation StockPL


#pragma mark   ========== 获取商铺信息
+ (void)Store_StoreFindStoreByIdWithDic:(NSDictionary *)infodic
                        withReturnBlock:(PLReturnValueBlock)returnBlock
                          andErrorBlock:(PLErrorCodeBlock)errorBlock
{
    [[HttpClient sharedHttpClient] StoreFindStoreByIdWithDic:infodic ReturnBlock:^(id returnValue) {
        
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


#pragma mark   ========== 获取商铺列表 /souxiu/store/base/getStoreList
+ (void)Store_StoreGetStoreListWithDic:(NSDictionary *)infodic
                       withReturnBlock:(PLReturnValueBlock)returnBlock
                         andErrorBlock:(PLErrorCodeBlock)errorBlock
{
    [[HttpClient sharedHttpClient] StoreGetStoreListWithDic:infodic ReturnBlock:^(id returnValue) {
        
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


#pragma mark   ========== 获取我的商铺信息 /souxiu/store/findMyStoreDetail
+ (void)Store_StoreFindMyStoreDetailWithDic:(NSDictionary *)infodic
                            withReturnBlock:(PLReturnValueBlock)returnBlock
                              andErrorBlock:(PLErrorCodeBlock)errorBlock
{
    [[HttpClient sharedHttpClient] StoreFindMyStoreDetailWithDic:infodic ReturnBlock:^(id returnValue) {
        
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
