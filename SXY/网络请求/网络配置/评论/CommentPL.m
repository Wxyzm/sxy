//
//  CommentPL.m
//  SXY
//
//  Created by yh f on 2019/1/4.
//  Copyright © 2019年 XX. All rights reserved.
//

#import "CommentPL.h"

@implementation CommentPL
#pragma mark   ========== //////////////////////////////////////评论////////////////////////////////////////

#pragma mark   ========== 删除评论
+ (void)Comment_CommentDeleteMyCommentWithDic:(NSDictionary *)infodic
                              withReturnBlock:(PLReturnValueBlock)returnBlock
                                andErrorBlock:(PLErrorCodeBlock)errorBlock{
    [[HttpClient sharedHttpClient] CommentDeleteMyCommentWithDic:infodic ReturnBlock:^(id returnValue) {
        
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


#pragma mark   ========== 获取广播评论
+ (void)Comment_CommentGetCircleCommentListWithDic:(NSDictionary *)infodic
                                   withReturnBlock:(PLReturnValueBlock)returnBlock
                                     andErrorBlock:(PLErrorCodeBlock)errorBlock{
    [[HttpClient sharedHttpClient] CommentGetCircleCommentListWithDic:infodic ReturnBlock:^(id returnValue) {
        
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

#pragma mark   ========== 获取商品评论
+ (void)Comment_CommentGetGoodsCommentListWithDic:(NSDictionary *)infodic
                                  withReturnBlock:(PLReturnValueBlock)returnBlock
                                    andErrorBlock:(PLErrorCodeBlock)errorBlock{
    [[HttpClient sharedHttpClient] CommentGetGoodsCommentListWithDic:infodic ReturnBlock:^(id returnValue) {
        
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


#pragma mark   ========== 获取资讯评论
+ (void)Comment_CommentGetNewsCommentListWithDic:(NSDictionary *)infodic
                                 withReturnBlock:(PLReturnValueBlock)returnBlock
                                   andErrorBlock:(PLErrorCodeBlock)errorBlock{
    [[HttpClient sharedHttpClient] CommentGetNewsCommentListWithDic:infodic ReturnBlock:^(id returnValue) {
        
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

#pragma mark   ========== 发布广播评论
+ (void)Comment_CommentSaveCircleCommentWithDic:(NSDictionary *)infodic
                                withReturnBlock:(PLReturnValueBlock)returnBlock
                                  andErrorBlock:(PLErrorCodeBlock)errorBlock{
    [[HttpClient sharedHttpClient] CommentSaveCircleCommentWithDic:infodic ReturnBlock:^(id returnValue) {
        
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


#pragma mark   ========== 发布商品评论
+ (void)Comment_CommentSaveGoodsCommentWithDic:(NSDictionary *)infodic
                               withReturnBlock:(PLReturnValueBlock)returnBlock
                                 andErrorBlock:(PLErrorCodeBlock)errorBlock{
    [[HttpClient sharedHttpClient] CommentSaveGoodsCommentWithDic:infodic ReturnBlock:^(id returnValue) {
        
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

#pragma mark   ========== 发布资讯评论
+ (void)Comment_CommentSaveNewsCommentWithDic:(NSDictionary *)infodic
                              withReturnBlock:(PLReturnValueBlock)returnBlock
                                andErrorBlock:(PLErrorCodeBlock)errorBlock{
    [[HttpClient sharedHttpClient] CommentSaveNewsCommentWithDic:infodic ReturnBlock:^(id returnValue) {
        
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

#pragma mark   ========== 添加/删除评论点倒赞
+ (void)Comment_CommentUnzanWithDic:(NSDictionary *)infodic
                    withReturnBlock:(PLReturnValueBlock)returnBlock
                      andErrorBlock:(PLErrorCodeBlock)errorBlock{
    [[HttpClient sharedHttpClient] CommentUnzanWithDic:infodic ReturnBlock:^(id returnValue) {
        
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

#pragma mark   ========== 添加/删除评论点赞
+ (void)Comment_CommentZanWithDic:(NSDictionary *)infodic
                  withReturnBlock:(PLReturnValueBlock)returnBlock
                    andErrorBlock:(PLErrorCodeBlock)errorBlock{
    [[HttpClient sharedHttpClient] CommentZanWithDic:infodic ReturnBlock:^(id returnValue) {
        
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
