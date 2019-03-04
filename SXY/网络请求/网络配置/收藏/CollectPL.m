//
//  CollectPL.m
//  SXY
//
//  Created by yh f on 2018/12/26.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "CollectPL.h"

@implementation CollectPL
#pragma mark   ========== 判断广播是否被收藏
/**
 判断广播是否被收藏
 */
+(void)Collect_CollectFindCircleCollectWithDic:(NSDictionary *)infodic
                               WithReturnBlock:(PLReturnValueBlock)returnBlock
                                withErrorBlock:(PLErrorCodeBlock)errorBlock
{
    
    [[HttpClient sharedHttpClient] CollectFindCircleCollectWithDic:infodic ReturnBlock:^(id returnValue) {
        
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

#pragma mark   ========== 用户的广播收藏列表
/**
 用户的广播收藏列表
 */
+(void)Collect_CollectFindCircleCollectListWithDic:(NSDictionary *)infodic
                                   WithReturnBlock:(PLReturnValueBlock)returnBlock
                                    withErrorBlock:(PLErrorCodeBlock)errorBlock
{
    
    [[HttpClient sharedHttpClient] CollectFindCircleCollectListWithDic:infodic ReturnBlock:^(id returnValue) {
        
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

#pragma mark   ========== 判断商品是否被收藏
/**
 判断商品是否被收藏
 */
+(void)Collect_CollectFindGoodsCollectWithDic:(NSDictionary *)infodic
                              WithReturnBlock:(PLReturnValueBlock)returnBlock
                               withErrorBlock:(PLErrorCodeBlock)errorBlock
{
    
    [[HttpClient sharedHttpClient] CollectFindGoodsCollectWithDic:infodic ReturnBlock:^(id returnValue) {
        
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

#pragma mark   ========== 用户的商品收藏列表
/**
 用户的商品收藏列表
 */
+(void)Collect_CollectFindGoodsCollectListWithDic:(NSDictionary *)infodic
                                  WithReturnBlock:(PLReturnValueBlock)returnBlock
                                   withErrorBlock:(PLErrorCodeBlock)errorBlock
{
    
    [[HttpClient sharedHttpClient] CollectFindGoodsCollectListWithDic:infodic ReturnBlock:^(id returnValue) {
        
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

#pragma mark   ========== 判断用户是否被关注
/**
 判断用户是否被关注
 */
+(void)Collect_CollectFindUserCollectWithDic:(NSDictionary *)infodic
                             WithReturnBlock:(PLReturnValueBlock)returnBlock
                              withErrorBlock:(PLErrorCodeBlock)errorBlock
{
    
    [[HttpClient sharedHttpClient] CollectFindUserCollectWithDic:infodic ReturnBlock:^(id returnValue) {
        
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


#pragma mark   ========== 用户的关注列表
/**
 用户的关注列表
 */
+(void)Collect_CollectFndUserCollectListWithDic:(NSDictionary *)infodic
                                WithReturnBlock:(PLReturnValueBlock)returnBlock
                                 withErrorBlock:(PLErrorCodeBlock)errorBlock
{
    
    [[HttpClient sharedHttpClient] CollectFndUserCollectListWithDic:infodic ReturnBlock:^(id returnValue) {
        
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

#pragma mark   ========== 添加/删除广播收藏
/**
 添加/删除广播收藏
 */
+(void)Collect_CollectSaveCircleCollectWithDic:(NSDictionary *)infodic
                               WithReturnBlock:(PLReturnValueBlock)returnBlock
                                withErrorBlock:(PLErrorCodeBlock)errorBlock
{
    
    [[HttpClient sharedHttpClient] CollectSaveCircleCollectWithDic:infodic ReturnBlock:^(id returnValue) {
        
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

#pragma mark   ========== 添加/删除商品收藏
/**
 添加/删除商品收藏
 */
+(void)Collect_CollectSaveGoodsCollectWithDic:(NSDictionary *)infodic
                              WithReturnBlock:(PLReturnValueBlock)returnBlock
                               withErrorBlock:(PLErrorCodeBlock)errorBlock
{
    
    [[HttpClient sharedHttpClient] CollectSaveGoodsCollectWithDic:infodic ReturnBlock:^(id returnValue) {
        
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


#pragma mark   ========== 话题点赞和取消赞
/**
 话题点赞和取消赞
 */
+(void)Collect_CollectSaveTopicZanWithDic:(NSDictionary *)infodic
                          WithReturnBlock:(PLReturnValueBlock)returnBlock
                           withErrorBlock:(PLErrorCodeBlock)errorBlock{
    
    [[HttpClient sharedHttpClient] CollectSaveTopicZanWithDic:infodic ReturnBlock:^(id returnValue) {
        
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

#pragma mark   ========== 关注/取消关注用户
/**
 关注/取消关注用户
 */
+(void)Collect_CollectSaveUserCollectWithDic:(NSDictionary *)infodic
                             WithReturnBlock:(PLReturnValueBlock)returnBlock
                              withErrorBlock:(PLErrorCodeBlock)errorBlock
{
    
    [[HttpClient sharedHttpClient] CollectSaveUserCollectWithDic:infodic ReturnBlock:^(id returnValue) {
        
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
