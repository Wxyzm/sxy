//
//  UserPL.h
//  FyhNewProj
//
//  Created by yh f on 2017/3/4.
//  Copyright © 2017年 fyh. All rights reserved.
//



//用户登录session管理类
#import <Foundation/Foundation.h>
@class User;
//@class Token;

@interface UserPL : NSObject



/**
 *  创建单利管理类
 */
+ (UserPL *)shareManager;

/**
 *  设置用户数据
 *
 *  @param user user description
 */
- (void)setUserData:(User *)user;

////////////////////////////////User接口///////////////////////////////////////////

#pragma mark ========== 获取验证码
-(void)userUsergetFindAgreementWithReturnBlock:(PLReturnValueBlock)returnBlock
                                 andErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark ========== 获取验证码
- (void)userUsergetRegVerificationCodeDic:(NSDictionary *)infodic
                          WithReturnBlock:(PLReturnValueBlock)returnBlock
                           withErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark ==========  手机号登陆，没有注册，直接注册掉
-(void)userUsergetLoginByPhoneDic:(NSDictionary *)infodic
                  WithReturnBlock:(PLReturnValueBlock)returnBlock
                   withErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark   ========== 获取验证码(找回密码)
- (void)userUserGetBackVerificationCodeWithDic:(NSDictionary *)infodic
                               WithReturnBlock:(PLReturnValueBlock)returnBlock
                                withErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark   ========== 获取验证码（注册）
- (void)userUserGetRegVerificationCodeWithDic:(NSDictionary *)infodic
                              WithReturnBlock:(PLReturnValueBlock)returnBlock
                               withErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark   ========== 用户登录
- (void)userUserLoginWithDic:(NSDictionary *)infodic
             WithReturnBlock:(PLReturnValueBlock)returnBlock
              withErrorBlock:(PLErrorCodeBlock)errorBlock;


#pragma mark   ========== 微信登陆
- (void)userUserLoginByWxWithDic:(NSDictionary *)infodic
                 WithReturnBlock:(PLReturnValueBlock)returnBlock
                  withErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark   ========== QQ登陆
- (void)userUserLoginByQQWithDic:(NSDictionary *)infodic
                 WithReturnBlock:(PLReturnValueBlock)returnBlock
                  withErrorBlock:(PLErrorCodeBlock)errorBlock;


#pragma mark   ========== 用户登录退出
- (void)userUserLogOutWithReturnBlock:(PLReturnValueBlock)returnBlock
                       withErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark   ========== 密码找回
- (void)userUserPwdBackWithWithDic:(NSDictionary *)infodic
                   WithReturnBlock:(PLReturnValueBlock)returnBlock
                    withErrorBlock:(PLErrorCodeBlock)errorBlock;
#pragma mark   ========== 手机号注册用户
/**
 弃用
 */
- (void)userUserRegisterUserByPhoneWithWithDic:(NSDictionary *)infodic
                               WithReturnBlock:(PLReturnValueBlock)returnBlock
                                withErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark   ========== 绑定新手机号
- (void)userUserBindPhoneWithDic:(NSDictionary *)infodic
                 WithReturnBlock:(PLReturnValueBlock)returnBlock
                  withErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark   ========== 根据id查找用户信息
- (void)userUserfindUserByIdWithDic:(NSDictionary *)infodic
                    ReturnBlock:(ReturnBlock)returnBlock
                  andErrorBlock:(ErrorBlock)errorBlock;

#pragma mark   ========== 用户信息筛选
- (void)userUserfindUserWithDic:(NSDictionary *)infodic
                WithReturnBlock:(PLReturnValueBlock)returnBlock
                 withErrorBlock:(PLErrorCodeBlock)errorBlock;


#pragma mark   ========== 根据角色，筛选用户列表
- (void)userUserfindUsersByRoleWithDic:(NSDictionary *)infodic
                       WithReturnBlock:(PLReturnValueBlock)returnBlock
                        withErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark   ========== 获取验证码(绑定手机)
- (void)userUserGetBindVerificationCodeWithDic:(NSDictionary *)infodic
                               WithReturnBlock:(PLReturnValueBlock)returnBlock
                                withErrorBlock:(PLErrorCodeBlock)errorBlock;


#pragma mark   ========== 融云token
- (void)userUserGetRongTokenWithDic:(NSDictionary *)infodic
                    WithReturnBlock:(PLReturnValueBlock)returnBlock
                      andErrorBlock:(PLErrorCodeBlock)errorBlock;


#pragma mark   ========== 用户保存个人信息
- (void)userUserSaveUserInfoWithDic:(NSDictionary *)infodic
                    WithReturnBlock:(PLReturnValueBlock)returnBlock
                     withErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark   ========== 修改账号
- (void)userUserSaveUserNameAndPwdWithDic:(NSDictionary *)infodic
                          WithReturnBlock:(PLReturnValueBlock)returnBlock
                           withErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark   ========== 提交公司认证
- (void)userUserSubmitCompanyAuthWithDic:(NSDictionary *)infodic
                         WithReturnBlock:(PLReturnValueBlock)returnBlock
                          withErrorBlock:(PLErrorCodeBlock)errorBlock;

#pragma mark   ========== 用户提交实名认证
- (void)userUserSubmitRealNameAuthWithDic:(NSDictionary *)infodic
                          WithReturnBlock:(PLReturnValueBlock)returnBlock
                           withErrorBlock:(PLErrorCodeBlock)errorBlock;








#pragma mark ========== 去首页

- (void)gotoTabbarCOntroller;

#pragma mark ========== 向本地写入用户信息
/**
 *  向本地写入用户信息
 */
- (void)writeUser;


#pragma mark ========== 用户注销

/**
 *  用户注销
 */
- (void)logout;




#pragma mark ========== 获取登录的用户信息
/**
 *  获取登录的用户信息
 *
 *  @return 登录的用户
 */
- (User*)getLoginUser;


#pragma mark ========== 判断是否登录
/**
 判断是否登录

 @return 是 或否
 */
- (BOOL)userIsLogin;
/**
 *  显示登录界面
 */
- (void)showLoginView;

@end
