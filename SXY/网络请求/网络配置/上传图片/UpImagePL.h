//
//  UpImagePL.h
//  FyhNewProj
//
//  Created by yh f on 2017/4/25.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpImagePL : NSObject


/**
 上传头像

 @param image 头像
 @param returnBlock 成功
 @param errorBlock 失败
 */
- (void)updateImg:(UIImage*)image WithReturnBlock:(PLReturnValueBlock) returnBlock withErrorBlock:(PLErrorCodeBlock) errorBlock ;

/**
 上传多图
 
 @param imageArr 图片数组
 @param returnBlock 成功
 @param errorBlock 失败
 */
- (void)updateToByGoodsImgArr:(NSArray*)imageArr WithReturnBlock:(PLReturnValueBlock) returnBlock withErrorBlock:(PLErrorCodeBlock)errorBlock andImageType:(NSString *)ImageTyoe;



/**
 上传多图

 @param imageArr imageArr 图片数组
 @param returnBlock returnBlock 成功
 @param errorBlock errorBlock 失败
 @param ImageTyoe 1:用户资料 2:用户认证 3:广播/商品（供应/现货/求购）4:消息（收藏/话题/聊天）5:其他(资讯/活动等)
 */
+ (void)updateToByGoodsImgArr:(NSArray*)imageArr WithReturnBlock:(PLReturnValueBlock) returnBlock withErrorBlock:(PLErrorCodeBlock)errorBlock andImageType:(NSString *)ImageTyoe;

/**
 搜图
 
 @param searchimage  图片
 @param returnBlock returnBlock 成功
 @param errorBlock errorBlock 失败
 */
+ (void)SearchImg:(UIImage*)searchImage andTag:(NSString*)tagStr WithReturnBlock:(PLReturnValueBlock) returnBlock withErrorBlock:(PLErrorCodeBlock)errorBlock ;

@end
