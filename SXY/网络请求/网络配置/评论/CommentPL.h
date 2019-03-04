//
//  CommentPL.h
//  SXY
//
//  Created by yh f on 2019/1/4.
//  Copyright © 2019年 XX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentPL : NSObject

#pragma mark   ========== //////////////////////////////////////评论////////////////////////////////////////

#pragma mark   ========== 删除评论
+ (void)Comment_CommentDeleteMyCommentWithDic:(NSDictionary *)infodic
                              withReturnBlock:(PLReturnValueBlock)returnBlock
                                andErrorBlock:(PLErrorCodeBlock)errorBlock;


#pragma mark   ========== 获取广播评论
+ (void)Comment_CommentGetCircleCommentListWithDic:(NSDictionary *)infodic
                                   withReturnBlock:(PLReturnValueBlock)returnBlock
                                     andErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark   ========== 获取商品评论
+ (void)Comment_CommentGetGoodsCommentListWithDic:(NSDictionary *)infodic
                                  withReturnBlock:(PLReturnValueBlock)returnBlock
                                    andErrorBlock:(PLErrorCodeBlock)errorBlock;


#pragma mark   ========== 获取资讯评论
+ (void)Comment_CommentGetNewsCommentListWithDic:(NSDictionary *)infodic
                                 withReturnBlock:(PLReturnValueBlock)returnBlock
                                   andErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark   ========== 发布广播评论
+ (void)Comment_CommentSaveCircleCommentWithDic:(NSDictionary *)infodic
                                withReturnBlock:(PLReturnValueBlock)returnBlock
                                  andErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark   ========== 发布商品评论
+ (void)Comment_CommentSaveGoodsCommentWithDic:(NSDictionary *)infodic
                               withReturnBlock:(PLReturnValueBlock)returnBlock
                                 andErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark   ========== 发布资讯评论
+ (void)Comment_CommentSaveNewsCommentWithDic:(NSDictionary *)infodic
                              withReturnBlock:(PLReturnValueBlock)returnBlock
                                andErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark   ========== 添加/删除评论点倒赞
+ (void)Comment_CommentUnzanWithDic:(NSDictionary *)infodic
                    withReturnBlock:(PLReturnValueBlock)returnBlock
                      andErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark   ========== 添加/删除评论点赞
+ (void)Comment_CommentZanWithDic:(NSDictionary *)infodic
                  withReturnBlock:(PLReturnValueBlock)returnBlock
                    andErrorBlock:(PLErrorCodeBlock)errorBlock;


@end
