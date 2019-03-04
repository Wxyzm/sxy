//
//  NewsPL.h
//  SXY
//
//  Created by yh f on 2019/1/2.
//  Copyright © 2019年 XX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsPL : NSObject

#pragma mark   ========== 获取资讯详情
+(void)News_NewsFindNewsByIdWithDic:(NSDictionary *)infodic
                        ReturnBlock:(PLReturnValueBlock)returnBlock
                      andErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark   ========== 获取资讯列表
+(void)News_NewsGetNewsListWithDic:(NSDictionary *)infodic
                       ReturnBlock:(PLReturnValueBlock)returnBlock
                     andErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark   ========== 删除资讯
+(void)News_NewsDeleteNewsListWithDic:(NSDictionary *)infodic
                          ReturnBlock:(PLReturnValueBlock)returnBlock
                        andErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark   ========== 发布/编辑资讯
+(void)News_NewsSaveNewsListWithDic:(NSDictionary *)infodic
                        ReturnBlock:(PLReturnValueBlock)returnBlock
                      andErrorBlock:(PLErrorCodeBlock)errorBlock;


@end
