//
//  CategoryPL.h
//  SXY
//
//  Created by yh f on 2018/12/18.
//  Copyright © 2018年 XX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryPL : NSObject
#pragma mark   ========== 获取类别详情
/**
 获取类别详情
 */
+(void)Category_CategoryFindCategoryByIdWithDic:(NSDictionary *)dic
                                WithReturnBlock:(PLReturnValueBlock)returnBlock
                                 withErrorBlock:(PLErrorCodeBlock)errorBlock;


#pragma mark   ========== 获取类别列表
/**
 获取类别列表
 */
+(void)Category_CategoryGetCategoryListWithDic:(NSDictionary *)dic
                               WithReturnBlock:(PLReturnValueBlock)returnBlock
                                withErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark   ========== 获取类别列表(根据parentId)
/**
 获取类别列表(根据parentId)
 */
+(void)Category_CategoryGetCategoryListByParentIdWithDic:(NSDictionary *)dic
                                         WithReturnBlock:(PLReturnValueBlock)returnBlock
                                          withErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark   ========== 获取幅宽
/**
 获取幅宽
 */
+(void)Category_CategoryGetClothWidthListWithDic:(NSDictionary *)dic
                                 WithReturnBlock:(PLReturnValueBlock)returnBlock
                                  withErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark   ========== 获取成分
/**
 获取成分
 */
+(void)Category_CategoryGetComponentListWithDic:(NSDictionary *)dic
                                WithReturnBlock:(PLReturnValueBlock)returnBlock
                                 withErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark   ========== 获取品类标签
/**
  获取品类标签
 */
+(void)Category_CategoryGetGoodsClassListWithDic:(NSDictionary *)dic
                                 WithReturnBlock:(PLReturnValueBlock)returnBlock
                                  withErrorBlock:(PLErrorCodeBlock)errorBlock;
#pragma mark   ========== 单位
/**
  获取单位
 */
+(void)Category_CategoryGetUnitListWithDic:(NSDictionary *)dic
                           WithReturnBlock:(PLReturnValueBlock)returnBlock
                            withErrorBlock:(PLErrorCodeBlock)errorBlock;
#pragma mark   ========== 获取供应链类目列表
/**
  获取供应链类目列表
 */
+(void)Category_CategoryGetUserKindListWithDic:(NSDictionary *)dic
                               WithReturnBlock:(PLReturnValueBlock)returnBlock
                                withErrorBlock:(PLErrorCodeBlock)errorBlock;
#pragma mark   ========== 获取有效时间
/**
获取有效时间
 */
+(void)Category_CategoryGetVailddaysListWithDic:(NSDictionary *)dic
                                WithReturnBlock:(PLReturnValueBlock)returnBlock
                                 withErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark   ========== 删除类别
/**
  删除类别
 */
+(void)Category_CategorydeleteCategoryWithDic:(NSDictionary *)dic
                              WithReturnBlock:(PLReturnValueBlock)returnBlock
                               withErrorBlock:(PLErrorCodeBlock)errorBlock;
#pragma mark   ========== 删除个人自定义的类别
/**
 删除个人自定义的类别
 */
+(void)Category_CategorydeleteUserCategoryWithDic:(NSDictionary *)dic
                                  WithReturnBlock:(PLReturnValueBlock)returnBlock
                                   withErrorBlock:(PLErrorCodeBlock)errorBlock;


#pragma mark   ========== 发布/编辑类别(后台)
#pragma mark   ========== 发布/编辑个人的自定义标签
/**
 发布/编辑个人的自定义标签
 */
+(void)Category_CategorysaveUserCategoryWithDic:(NSDictionary *)dic
                                WithReturnBlock:(PLReturnValueBlock)returnBlock
                                 withErrorBlock:(PLErrorCodeBlock)errorBlock;


@end
