//
//  CategoryPL.m
//  SXY
//
//  Created by yh f on 2018/12/18.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "CategoryPL.h"

@implementation CategoryPL
#pragma mark   ========== 获取类别详情
/**
 获取类别详情
 */
+(void)Category_CategoryFindCategoryByIdWithDic:(NSDictionary *)dic
                                WithReturnBlock:(PLReturnValueBlock)returnBlock
                                 withErrorBlock:(PLErrorCodeBlock)errorBlock{
    
    [[HttpClient sharedHttpClient] CategoryFindCategoryByIdWithDic:dic WithReturnBlock:^(id returnValue) {
        
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
       [HUD show:dic[@"message"]];
        errorBlock(msg);
    }];
    
}


#pragma mark   ========== 获取类别列表
/**
 获取类别列表
 */
+(void)Category_CategoryGetCategoryListWithDic:(NSDictionary *)dic
                               WithReturnBlock:(PLReturnValueBlock)returnBlock
                                withErrorBlock:(PLErrorCodeBlock)errorBlock
{
    
    [[HttpClient sharedHttpClient] CategoryGetCategoryListWithDic:dic WithReturnBlock:^(id returnValue) {
        
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
       [HUD show:dic[@"message"]];
        errorBlock(msg);
    }];
    
}
    

#pragma mark   ========== 获取类别列表(根据parentId)
/**
 获取类别列表(根据parentId)
 */
+(void)Category_CategoryGetCategoryListByParentIdWithDic:(NSDictionary *)dic
                                         WithReturnBlock:(PLReturnValueBlock)returnBlock
                                          withErrorBlock:(PLErrorCodeBlock)errorBlock
{
    
    [[HttpClient sharedHttpClient] CategoryGetCategoryListByParentIdWithDic:dic WithReturnBlock:^(id returnValue) {
        
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
       [HUD show:dic[@"message"]];
        errorBlock(msg);
    }];
    
}

#pragma mark   ========== 获取幅宽
/**
 获取幅宽
 */
+(void)Category_CategoryGetClothWidthListWithDic:(NSDictionary *)dic
                                 WithReturnBlock:(PLReturnValueBlock)returnBlock
                                  withErrorBlock:(PLErrorCodeBlock)errorBlock
{
    
    [[HttpClient sharedHttpClient] CategoryGetClothWidthListWithDic:dic WithReturnBlock:^(id returnValue) {
        
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
       [HUD show:dic[@"message"]];
        errorBlock(msg);
    }];
    
}

#pragma mark   ========== 获取成分
/**
 获取成分
 */
+(void)Category_CategoryGetComponentListWithDic:(NSDictionary *)dic
                                WithReturnBlock:(PLReturnValueBlock)returnBlock
                                 withErrorBlock:(PLErrorCodeBlock)errorBlock
{
    
    [[HttpClient sharedHttpClient] CategoryGetComponentListWithDic:dic WithReturnBlock:^(id returnValue) {
        
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
       [HUD show:dic[@"message"]];
        errorBlock(msg);
    }];
    
}

#pragma mark   ========== 获取品类标签
/**
 获取品类标签
 */
+(void)Category_CategoryGetGoodsClassListWithDic:(NSDictionary *)dic
                                 WithReturnBlock:(PLReturnValueBlock)returnBlock
                                  withErrorBlock:(PLErrorCodeBlock)errorBlock
{
    
    [[HttpClient sharedHttpClient] CategoryGetGoodsClassListWithDic:dic WithReturnBlock:^(id returnValue) {
        
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
       [HUD show:dic[@"message"]];
        errorBlock(msg);
    }];
    
}
#pragma mark   ========== 获取单位
/**
 获取单位
 */
+(void)Category_CategoryGetUnitListWithDic:(NSDictionary *)dic
                           WithReturnBlock:(PLReturnValueBlock)returnBlock
                            withErrorBlock:(PLErrorCodeBlock)errorBlock
{
    
    [[HttpClient sharedHttpClient] CategoryGetUnitListWithDic:dic WithReturnBlock:^(id returnValue) {
        
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
       [HUD show:dic[@"message"]];
        errorBlock(msg);
    }];
    
}
#pragma mark   ========== 获取供应链类目列表
/**
 获取供应链类目列表
 */
+(void)Category_CategoryGetUserKindListWithDic:(NSDictionary *)dic
                               WithReturnBlock:(PLReturnValueBlock)returnBlock
                                withErrorBlock:(PLErrorCodeBlock)errorBlock
{
    
    [[HttpClient sharedHttpClient] CategoryGetUserKindListWithDic:dic WithReturnBlock:^(id returnValue) {
        
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
       [HUD show:dic[@"message"]];
        errorBlock(msg);
    }];
    
}
#pragma mark   ========== 获取有效时间
/**
 获取有效时间
 */
+(void)Category_CategoryGetVailddaysListWithDic:(NSDictionary *)dic
                                WithReturnBlock:(PLReturnValueBlock)returnBlock
                                 withErrorBlock:(PLErrorCodeBlock)errorBlock
{
    
    [[HttpClient sharedHttpClient] CategoryGetVailddaysListWithDic:dic WithReturnBlock:^(id returnValue) {
        
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
       [HUD show:dic[@"message"]];
        errorBlock(msg);
    }];
    
}

#pragma mark   ========== 删除类别
/**
 删除类别
 */
+(void)Category_CategorydeleteCategoryWithDic:(NSDictionary *)dic
                              WithReturnBlock:(PLReturnValueBlock)returnBlock
                               withErrorBlock:(PLErrorCodeBlock)errorBlock
{
    
    [[HttpClient sharedHttpClient] CategorydeleteCategoryWithDic:dic WithReturnBlock:^(id returnValue) {
        
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
       [HUD show:dic[@"message"]];
        errorBlock(msg);
    }];
    
}
#pragma mark   ========== 删除个人自定义的类别
/**
 删除个人自定义的类别
 */
+(void)Category_CategorydeleteUserCategoryWithDic:(NSDictionary *)dic
                                  WithReturnBlock:(PLReturnValueBlock)returnBlock
                                   withErrorBlock:(PLErrorCodeBlock)errorBlock
{
    
    [[HttpClient sharedHttpClient] CategorydeleteUserCategoryWithDic:dic WithReturnBlock:^(id returnValue) {
        
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
       [HUD show:dic[@"message"]];
        errorBlock(msg);
    }];
    
}

#pragma mark   ========== 发布/编辑个人的自定义标签
+(void)Category_CategorysaveUserCategoryWithDic:(NSDictionary *)dic
                                WithReturnBlock:(PLReturnValueBlock)returnBlock
                                 withErrorBlock:(PLErrorCodeBlock)errorBlock
{
    
    [[HttpClient sharedHttpClient] CategorysaveUserCategoryWithDic:dic WithReturnBlock:^(id returnValue) {
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
       [HUD show:dic[@"message"]];
        errorBlock(msg);
    }];
    
}

@end
