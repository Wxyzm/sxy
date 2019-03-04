//
//  UserPL.m
//  FyhNewProj
//
//  Created by yh f on 2017/3/4.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "UserPL.h"
#import "User.h"
#import "LoginController.h"
#import "LBNavigationController.h"
#import "AppDelegate.h"
#import "LBTabBarController.h"

@interface UserPL()
@property (nonatomic,strong)User *user;

@end

@implementation UserPL
static UserPL *sharedManager = nil;
+(UserPL *)shareManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedManager = [[self alloc]init];
        sharedManager.user = [[User alloc]init];
     //   sharedManager.token = [[Token alloc] init];
        [sharedManager registerDefaults];
    });
    return sharedManager;
    
}

/**
 *  初始化 registerDefaults方法调用时会check NSUserDefaults里是否已经存在了相同的key，如果有则不会把其覆盖。
 */
- (void)registerDefaults{
    NSDictionary *dictionary = @{User_Id:@"",User_Account:@"",User_Pwd:@"",User_Account:@"",User_api_token:@"",User_avatar:@"",User_Mobile:@"",User_login_type:@"",User_openId:@""};
    [[NSUserDefaults standardUserDefaults]registerDefaults:dictionary];
    
}


/**
 *  加载本地用户数据
 */
- (void)loadUser {
   
}
////////////////////////////////User接口///////////////////////////////////////////

#pragma mark ========== 获取验证码
-(void)userUsergetFindAgreementWithReturnBlock:(PLReturnValueBlock)returnBlock
                                 andErrorBlock:(PLErrorCodeBlock)errorBlock{
    [[HttpClient sharedHttpClient] UsergetFindAgreementWithReturnBlock:^(id returnValue) {
        NSDictionary *dic = [HttpClient valueWithJsonString:returnValue];
        if ([dic[@"state"] boolValue]) {
            NSDictionary *returnDic= dic[@"data"];
            returnBlock(returnDic);
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


#pragma mark ========== 获取验证码
- (void)userUsergetRegVerificationCodeDic:(NSDictionary *)infodic
                          WithReturnBlock:(PLReturnValueBlock)returnBlock
                           withErrorBlock:(PLErrorCodeBlock)errorBlock{
    
    [[HttpClient sharedHttpClient] UsergetRegVerificationCodeDic:infodic WithReturnBlock:^(id returnValue) {
        NSDictionary *dic = [HttpClient valueWithJsonString:returnValue];
        if ([dic[@"state"] boolValue]) {
            NSDictionary *returnDic= dic[@"data"];
            returnBlock(returnDic);
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

#pragma mark ==========  手机号登陆，没有注册，直接注册掉
-(void)userUsergetLoginByPhoneDic:(NSDictionary *)infodic
                  WithReturnBlock:(PLReturnValueBlock)returnBlock
                   withErrorBlock:(PLErrorCodeBlock)errorBlock{
    
    [[HttpClient sharedHttpClient] UsergetLoginByPhoneDic:infodic WithReturnBlock:^(id returnValue) {
       
        NSDictionary *dic = [HttpClient valueWithJsonString:returnValue];
        if ([dic[@"state"] boolValue]) {
            NSDictionary *returnDic= dic[@"data"];
            User *user = [User mj_objectWithKeyValues:returnDic[@"result"]];
            user.token = returnDic[@"token"];
            [self setUser:user];
            [self writeUser];
            [HUD show:@"登录成功"];
            returnBlock(returnDic);
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


#pragma mark   ========== 获取验证码(找回密码)
- (void)userUserGetBackVerificationCodeWithDic:(NSDictionary *)infodic
                               WithReturnBlock:(PLReturnValueBlock)returnBlock
                                withErrorBlock:(PLErrorCodeBlock)errorBlock
{
    
    [[HttpClient sharedHttpClient] UserGetBackVerificationCodeWithDic:infodic WithReturnBlock:^(id returnValue) {
        
        NSDictionary *dic = [HttpClient valueWithJsonString:returnValue];
        if ([dic[@"state"] boolValue]) {
            NSDictionary *returnDic= dic[@"data"];
            returnBlock(returnDic);
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

#pragma mark   ========== 获取验证码（注册）
- (void)userUserGetRegVerificationCodeWithDic:(NSDictionary *)infodic
                              WithReturnBlock:(PLReturnValueBlock)returnBlock
                               withErrorBlock:(PLErrorCodeBlock)errorBlock
{
    [[HttpClient sharedHttpClient] UserGetRegVerificationCodeWithDic:infodic WithReturnBlock:^(id returnValue) {
        
        NSDictionary *dic = [HttpClient valueWithJsonString:returnValue];
        if ([dic[@"state"] boolValue]) {
            NSDictionary *returnDic= dic[@"data"];
            returnBlock(returnDic);
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

#pragma mark   ========== 用户登录
- (void)userUserLoginWithDic:(NSDictionary *)infodic
             WithReturnBlock:(PLReturnValueBlock)returnBlock
              withErrorBlock:(PLErrorCodeBlock)errorBlock
{
    [[HttpClient sharedHttpClient] UserLoginWithDic:infodic WithReturnBlock:^(id returnValue) {
        
        NSDictionary *dic = [HttpClient valueWithJsonString:returnValue];
        if ([dic[@"state"] boolValue]) {
            NSDictionary *returnDic= dic[@"data"];
            User *user = [User mj_objectWithKeyValues:returnDic[@"result"]];
            user.token = returnDic[@"token"];
            [self setUser:user];
            [self writeUser];
            [HUD show:@"登录成功"];
            returnBlock(returnDic);
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
/*
 if ([dic[@"state"] boolValue]) {
 NSDictionary *returnDic= dic[@"data"];
 User *user = [User mj_objectWithKeyValues:returnDic[@"result"]];
 user.token = returnDic[@"token"];
 [self setUser:user];
 [self writeUser];
 [HUD show:@"登录成功"];
 //  [self performSelector:@selector(gotoTabbarCOntroller) withObject:nil afterDelay:1.5];
 returnBlock(returnDic);
 }else{
 [HUD show:dic[@"message"]];
 errorBlock(dic[@"message"]);
 }
 */


#pragma mark   ========== 微信登陆
- (void)userUserLoginByWxWithDic:(NSDictionary *)infodic
                 WithReturnBlock:(PLReturnValueBlock)returnBlock
                  withErrorBlock:(PLErrorCodeBlock)errorBlock
{
    [[HttpClient sharedHttpClient] UserLoginByWxWithDic:infodic WithReturnBlock:^(id returnValue) {
        
        NSDictionary *dic = [HttpClient valueWithJsonString:returnValue];
        if ([dic[@"state"] boolValue]) {
            NSDictionary *returnDic= dic[@"data"];
            User *user = [User mj_objectWithKeyValues:returnDic[@"result"]];
            user.token = returnDic[@"token"];
            [self setUser:user];
            [self writeUser];
            [HUD show:@"登录成功"];
            returnBlock(returnDic);
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
#pragma mark   ========== QQ登陆
- (void)userUserLoginByQQWithDic:(NSDictionary *)infodic
                 WithReturnBlock:(PLReturnValueBlock)returnBlock
                  withErrorBlock:(PLErrorCodeBlock)errorBlock{
    [[HttpClient sharedHttpClient] UserLoginByQQWithDic:infodic WithReturnBlock:^(id returnValue) {
        
        NSDictionary *dic = [HttpClient valueWithJsonString:returnValue];
        if ([dic[@"state"] boolValue]) {
            NSDictionary *returnDic= dic[@"data"];
            User *user = [User mj_objectWithKeyValues:returnDic[@"result"]];
            user.token = returnDic[@"token"];
            [self setUser:user];
            [self writeUser];
           // [HUD show:@"登录成功"];
            returnBlock(returnDic);
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

#pragma mark   ========== 用户登录退出
- (void)userUserLogOutWithReturnBlock:(PLReturnValueBlock)returnBlock
                       withErrorBlock:(PLErrorCodeBlock)errorBlock
{
    [[HttpClient sharedHttpClient] UserLogOutWithReturnBlock:^(id returnValue) {
        
        NSDictionary *dic = [HttpClient valueWithJsonString:returnValue];
        if ([dic[@"state"] boolValue]) {
            NSDictionary *returnDic= dic[@"data"];
            returnBlock(returnDic);
        }else{
          //  [HUD show:dic[@"message"]];
            errorBlock(dic[@"message"]);
        }
    } andErrorBlock:^(NSString *msg) {
      //  [HUD show:msg];
        errorBlock(msg);
    }];
    
    
}

#pragma mark   ========== 密码找回
- (void)userUserPwdBackWithWithDic:(NSDictionary *)infodic
                   WithReturnBlock:(PLReturnValueBlock)returnBlock
                    withErrorBlock:(PLErrorCodeBlock)errorBlock
{
    [[HttpClient sharedHttpClient] UserPwdBackWithWithDic:infodic ReturnBlock:^(id returnValue) {
        NSDictionary *dic = [HttpClient valueWithJsonString:returnValue];
        if ([dic[@"state"] boolValue]) {
            NSDictionary *returnDic= dic[@"data"];
            returnBlock(returnDic);
        }else{
            [HUD show:dic[@"message"]];
            errorBlock(dic[@"message"]);
        }
    } andErrorBlock:^(NSString *msg) {
        [HUD show:msg];
        errorBlock(msg);
    }];
}


#pragma mark   ========== 手机号注册用户
- (void)userUserRegisterUserByPhoneWithWithDic:(NSDictionary *)infodic
                               WithReturnBlock:(PLReturnValueBlock)returnBlock
                                withErrorBlock:(PLErrorCodeBlock)errorBlock
{
    [[HttpClient sharedHttpClient] UserRegisterUserByPhoneWithWithDic:infodic ReturnBlock:^(id returnValue) {
        NSDictionary *dic = [HttpClient valueWithJsonString:returnValue];
        if ([dic[@"state"] boolValue]) {
            NSDictionary *returnDic= dic[@"data"];
            returnBlock(returnDic);
        }else{
            [HUD show:dic[@"message"]];
            errorBlock(dic[@"message"]);
        }
    } andErrorBlock:^(NSString *msg) {
        [HUD show:msg];
        errorBlock(msg);
    }];
}

#pragma mark   ========== 绑定新手机号
- (void)userUserBindPhoneWithDic:(NSDictionary *)infodic
                 WithReturnBlock:(PLReturnValueBlock)returnBlock
                  withErrorBlock:(PLErrorCodeBlock)errorBlock
{
    [[HttpClient sharedHttpClient] UserBindPhoneWithDic:infodic ReturnBlock:^(id returnValue) {
        NSDictionary *dic = [HttpClient valueWithJsonString:returnValue];
        if ([dic[@"state"] boolValue]) {
            NSDictionary *returnDic= dic[@"data"];
            returnBlock(returnDic);
        }else{
            [HUD show:dic[@"message"]];
            errorBlock(dic[@"message"]);
        }
    } andErrorBlock:^(NSString *msg) {
        [HUD show:msg];
        errorBlock(msg);
    }];
}


#pragma mark   ========== 根据id查找用户信息
- (void)userUserfindUserByIdWithDic:(NSDictionary *)infodic
                        ReturnBlock:(ReturnBlock)returnBlock
                      andErrorBlock:(ErrorBlock)errorBlock
{
    [[HttpClient sharedHttpClient] UserfindUserByIdWithDic:infodic ReturnBlock:^(id returnValue) {
        NSDictionary *dic = [HttpClient valueWithJsonString:returnValue];
        if ([dic[@"state"] boolValue]) {
            NSDictionary *returnDic= dic[@"data"];
            returnBlock(returnDic);
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

#pragma mark   ========== 用户信息筛选
- (void)userUserfindUserWithDic:(NSDictionary *)infodic
                WithReturnBlock:(PLReturnValueBlock)returnBlock
                 withErrorBlock:(PLErrorCodeBlock)errorBlock
{
    [[HttpClient sharedHttpClient] UserfindUserWithDic:infodic ReturnBlock:^(id returnValue) {
        NSDictionary *dic = [HttpClient valueWithJsonString:returnValue];
        if ([dic[@"state"] boolValue]) {
            NSDictionary *returnDic= dic[@"data"];
            returnBlock(returnDic);
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


#pragma mark   ========== 根据角色，筛选用户列表
- (void)userUserfindUsersByRoleWithDic:(NSDictionary *)infodic
                       WithReturnBlock:(PLReturnValueBlock)returnBlock
                        withErrorBlock:(PLErrorCodeBlock)errorBlock
{
    [[HttpClient sharedHttpClient] UserfindUsersByRoleWithDic:infodic ReturnBlock:^(id returnValue) {
        NSDictionary *dic = [HttpClient valueWithJsonString:returnValue];
        if ([dic[@"state"] boolValue]) {
            NSDictionary *returnDic= dic[@"data"];
            returnBlock(returnDic);
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

#pragma mark   ========== 获取验证码(绑定手机)
- (void)userUserGetBindVerificationCodeWithDic:(NSDictionary *)infodic
                               WithReturnBlock:(PLReturnValueBlock)returnBlock
                                withErrorBlock:(PLErrorCodeBlock)errorBlock
{
    [[HttpClient sharedHttpClient] UserGetBindVerificationCodeWithDic:infodic ReturnBlock:^(id returnValue) {
        NSDictionary *dic = [HttpClient valueWithJsonString:returnValue];
        if ([dic[@"state"] boolValue]) {
            NSDictionary *returnDic= dic[@"data"];
            returnBlock(returnDic);
        }else{
            [HUD show:dic[@"message"]];
            errorBlock(dic[@"message"]);
        }
    } andErrorBlock:^(NSString *msg) {
        [HUD show:msg];
        errorBlock(msg);
    }];
}

#pragma mark   ========== 融云token
- (void)userUserGetRongTokenWithDic:(NSDictionary *)infodic
                    WithReturnBlock:(PLReturnValueBlock)returnBlock
                      andErrorBlock:(PLErrorCodeBlock)errorBlock
{
    
    [[HttpClient sharedHttpClient] UserGetRongTokenWithDic:infodic ReturnBlock:^(id returnValue) {
        NSDictionary *dic = [HttpClient valueWithJsonString:returnValue];
        if ([dic[@"state"] boolValue]) {
            NSDictionary *returnDic= dic[@"data"];
            returnBlock(returnDic);
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


#pragma mark   ========== 用户保存个人信息
- (void)userUserSaveUserInfoWithDic:(NSDictionary *)infodic
                    WithReturnBlock:(PLReturnValueBlock)returnBlock
                     withErrorBlock:(PLErrorCodeBlock)errorBlock
{
    [[HttpClient sharedHttpClient] UserSaveUserInfoWithDic:infodic ReturnBlock:^(id returnValue) {
        NSDictionary *dic = [HttpClient valueWithJsonString:returnValue];
        if ([dic[@"state"] boolValue]) {
            NSDictionary *returnDic= dic[@"data"];
            returnBlock(returnDic);
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

#pragma mark   ========== 修改账号
- (void)userUserSaveUserNameAndPwdWithDic:(NSDictionary *)infodic
                          WithReturnBlock:(PLReturnValueBlock)returnBlock
                           withErrorBlock:(PLErrorCodeBlock)errorBlock
{
    [[HttpClient sharedHttpClient] UserSaveUserNameAndPwdWithDic:infodic ReturnBlock:^(id returnValue) {
        NSDictionary *dic = [HttpClient valueWithJsonString:returnValue];
        if ([dic[@"state"] boolValue]) {
            NSDictionary *returnDic= dic[@"data"];
            returnBlock(returnDic);
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

#pragma mark   ========== 提交公司认证
- (void)userUserSubmitCompanyAuthWithDic:(NSDictionary *)infodic
                         WithReturnBlock:(PLReturnValueBlock)returnBlock
                          withErrorBlock:(PLErrorCodeBlock)errorBlock
{
    [[HttpClient sharedHttpClient] UserSubmitCompanyAuthWithDic:infodic ReturnBlock:^(id returnValue) {
        NSDictionary *dic = [HttpClient valueWithJsonString:returnValue];
        if ([dic[@"state"] boolValue]) {
            NSDictionary *returnDic= dic[@"data"];
            returnBlock(returnDic);
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

#pragma mark   ========== 用户提交实名认证
- (void)userUserSubmitRealNameAuthWithDic:(NSDictionary *)infodic
                          WithReturnBlock:(PLReturnValueBlock)returnBlock
                           withErrorBlock:(PLErrorCodeBlock)errorBlock
{
    [[HttpClient sharedHttpClient] UserSubmitRealNameAuthWithDic:infodic ReturnBlock:^(id returnValue) {
        NSDictionary *dic = [HttpClient valueWithJsonString:returnValue];
        if ([dic[@"state"] boolValue]) {
            NSDictionary *returnDic= dic[@"data"];
            returnBlock(returnDic);
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






























#pragma mark ========== 用户注销

/**
 退出登录
 */
- (void)logout{
    [self userUserLogOutWithReturnBlock:^(id returnValue) {
        
    } withErrorBlock:^(NSString *msg) {
        
    }];
    _user.password = @"";
    _user.userId = @"";
    _user.phone = @"";
    _user.token = @"";
    _user.name = @"";
    [self writeUser];
    [self showLoginView];
}

/**
 *  显示登录界面
 */
- (void)showLoginView {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    LBNavigationController *lbVc = [[LBNavigationController alloc]initWithRootViewController:[[LoginController alloc]init]];
    window.rootViewController = lbVc;
    [window makeKeyAndVisible];
}

/**
 登录成功前往首页
 */
- (void)gotoTabbarCOntroller{
    
    [RCTokenPL getRcTokenWithReturnBlock:^(id returnValue) {
        [GlobalMethod connectRongCloudWithToken:returnValue];
    } andErrorBlock:^(NSString *msg) {
        
    }];
    AppDelegate *app = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    app.mainTab  = [[LBTabBarController alloc] init];
    window.rootViewController = app.mainTab;
    [window makeKeyAndVisible];
}


#pragma mark ========== 获取登录的用户信息

-(User *)getLoginUser{
    User *user = [[User alloc]init];
    user.phone = [[NSUserDefaults standardUserDefaults]objectForKey:User_Mobile];
    user.password = [[NSUserDefaults standardUserDefaults]objectForKey:User_Pwd];
    user.token = [[NSUserDefaults standardUserDefaults]objectForKey:User_api_token];
    user.name = [[NSUserDefaults standardUserDefaults]objectForKey:User_Name];
    user.userId = [[NSUserDefaults standardUserDefaults]objectForKey:User_Id];
    return user;
}

#pragma mark ========== 判断是否登录

- (BOOL)userIsLogin{

    NSUserDefaults *userdefauls =[NSUserDefaults standardUserDefaults];
    if ([userdefauls objectForKey:User_Id]&&![[userdefauls objectForKey:User_Id] isEqualToString:@""]) {
        return YES;
    }else{
        return NO;
    }
}


/**
 *  存入本地
 */
- (void)writeUser{
    
    [[NSUserDefaults standardUserDefaults]setObject:_user.password forKey:User_Pwd];
    [[NSUserDefaults standardUserDefaults]setObject:_user.phone forKey:User_Mobile];
    [[NSUserDefaults standardUserDefaults]setObject:_user.userId forKey:User_Id];
    [[NSUserDefaults standardUserDefaults]setObject:_user.name forKey:User_Name];
    [[NSUserDefaults standardUserDefaults]setObject:_user.token forKey:User_api_token];

    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)setUserData:(User *)user
{
    
    _user = user;
    
}

@end
