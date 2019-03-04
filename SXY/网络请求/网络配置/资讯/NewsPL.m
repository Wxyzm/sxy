//
//  NewsPL.m
//  SXY
//
//  Created by yh f on 2019/1/2.
//  Copyright © 2019年 XX. All rights reserved.
//

#import "NewsPL.h"

@implementation NewsPL

#pragma mark   ========== 获取资讯详情
+(void)News_NewsFindNewsByIdWithDic:(NSDictionary *)infodic
                        ReturnBlock:(PLReturnValueBlock)returnBlock
                      andErrorBlock:(PLErrorCodeBlock)errorBlock{
    [[HttpClient sharedHttpClient] NewsFindNewsByIdWithDic:infodic ReturnBlock:^(id returnValue) {
        
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

#pragma mark   ========== 获取资讯列表
+(void)News_NewsGetNewsListWithDic:(NSDictionary *)infodic
                       ReturnBlock:(PLReturnValueBlock)returnBlock
                     andErrorBlock:(PLErrorCodeBlock)errorBlock
{
    [[HttpClient sharedHttpClient] NewsGetNewsListWithDic:infodic ReturnBlock:^(id returnValue) {
        
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

#pragma mark   ========== 删除资讯
+(void)News_NewsDeleteNewsListWithDic:(NSDictionary *)infodic
                          ReturnBlock:(PLReturnValueBlock)returnBlock
                        andErrorBlock:(PLErrorCodeBlock)errorBlock
{
    [[HttpClient sharedHttpClient] NewsDeleteNewsListWithDic:infodic ReturnBlock:^(id returnValue) {
        
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

#pragma mark   ========== 发布/编辑资讯
+(void)News_NewsSaveNewsListWithDic:(NSDictionary *)infodic
                        ReturnBlock:(PLReturnValueBlock)returnBlock
                      andErrorBlock:(PLErrorCodeBlock)errorBlock
{
    [[HttpClient sharedHttpClient] NewsSaveNewsListWithDic:infodic ReturnBlock:^(id returnValue) {
        
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
