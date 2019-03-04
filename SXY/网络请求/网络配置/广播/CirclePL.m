                                                                                                                                                                                                                                                                                                                                                                                                                                              //
//  CirclePL.m
//  SXY
//
//  Created by yh f on 2018/12/17.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "CirclePL.h"

@implementation CirclePL
#pragma mark   ========== 获取广播详情
+(void)Circle_CircleFindCircleByIdDic:(NSDictionary *)infodic
                      WithReturnBlock:(PLReturnValueBlock)returnBlock
                       withErrorBlock:(PLErrorCodeBlock)errorBlock{
    [[HttpClient sharedHttpClient] CircleFindCircleByIdDic:infodic WithReturnBlock:^(id returnValue) {
        
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

#pragma mark   ========== 获取广播列表
+(void)Circle_CircleGetCircleListWithDic:(NSDictionary *)infodic
                         WithReturnBlock:(PLReturnValueBlock)returnBlock
                          withErrorBlock:(PLErrorCodeBlock)errorBlock{
    
    [[HttpClient sharedHttpClient] CircleGetCircleListWithDic:infodic WithReturnBlock:^(id returnValue) {
        
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

#pragma mark   ========== 删除广播
+(void)Circle_CircleDeleteCircleWithDic:(NSDictionary *)infodic
                        WithReturnBlock:(PLReturnValueBlock)returnBlock
                         withErrorBlock:(PLErrorCodeBlock)errorBlock{
    
    [[HttpClient sharedHttpClient] CircleDeleteCircleWithDic:infodic WithReturnBlock:^(id returnValue) {
        
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

#pragma mark   ========== 发布/编辑广播
+(void)Circle_CircleSaveCircleCircleWithDic:(NSDictionary *)infodic
                            WithReturnBlock:(PLReturnValueBlock)returnBlock
                             withErrorBlock:(PLErrorCodeBlock)errorBlock{
    
    [[HttpClient sharedHttpClient] CircleSaveCircleCircleWithDic:infodic WithReturnBlock:^(id returnValue) {
        
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
