//
//  CirclePL.h
//  SXY
//
//  Created by yh f on 2018/12/17.
//  Copyright © 2018年 XX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CirclePL : NSObject

//////////////////////////////////////广播/////////////////////////////////

#pragma mark   ========== 获取广播详情
+(void)Circle_CircleFindCircleByIdDic:(NSDictionary *)infodic
                      WithReturnBlock:(PLReturnValueBlock)returnBlock
                       withErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark   ========== 获取广播列表
/**
 "isExpiration": "false:非过期广播 true:已过期广播",
 "id": "id",
 "title": "标题（模糊）",
 "userId": "用户id",
 "content": "内容（模糊）",
 "goodsModules": "0：求购 1：现货  2：供应链   3：话题",
 "status": "审核 0：未审核，1：审核中 2：审核不通过 3：审核通过"
 */
+(void)Circle_CircleGetCircleListWithDic:(NSDictionary *)infodic
                         WithReturnBlock:(PLReturnValueBlock)returnBlock
                          withErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark   ========== 删除广播
+(void)Circle_CircleDeleteCircleWithDic:(NSDictionary *)infodic
                        WithReturnBlock:(PLReturnValueBlock)returnBlock
                         withErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark   ========== 发布/编辑广播
+(void)Circle_CircleSaveCircleCircleWithDic:(NSDictionary *)infodic
                            WithReturnBlock:(PLReturnValueBlock)returnBlock
                             withErrorBlock:(PLErrorCodeBlock)errorBlock;


@end
