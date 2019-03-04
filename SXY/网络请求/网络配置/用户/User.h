//
//  User.h
//  FyhNewProj
//
//  Created by yh f on 2017/3/4.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, copy) NSString *userId;            //账号
@property (nonatomic, copy) NSString *addTime;           //
@property (nonatomic, copy) NSString *updateTime;        //
@property (nonatomic, copy) NSString *addUser;           //
@property (nonatomic, copy) NSString *updateUser;        //
@property (nonatomic, copy) NSString *delFlag;           //
@property (nonatomic, copy) NSString *officeId;          //
@property (nonatomic, assign) BOOL    inew;              //
@property (nonatomic, copy) NSString *loginName;         //
@property (nonatomic, copy) NSString *password;          //
@property (nonatomic, copy) NSString *name;              //
@property (nonatomic, copy) NSString *realNameAuth;      //
@property (nonatomic, copy) NSString *pinyin;            //
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *loginIp;           //
@property (nonatomic, copy) NSString *loginDate;         //
@property (nonatomic, copy) NSString *loginFlag;         //
@property (nonatomic, copy) NSString *companyAuth;        //
@property (nonatomic, copy) NSString *token;        //







//@property (nonatomic, copy) NSString *account;            //账号
//@property (nonatomic, copy) NSString *password;           //密码
//@property (nonatomic, copy) NSString *mobile;             //手机号
//@property (nonatomic, copy) NSString *user_id;            //用户唯一ID
//@property (nonatomic, copy) NSString *name;               //用户昵称
//@property (nonatomic, copy) NSString *avatar;             //用户头像
//@property (nonatomic, copy) NSString *api_token;          //用户安全令牌
//
//@property (nonatomic, copy) NSString *openid;           //用户微信登录id
//
//@property (nonatomic, copy) NSString *loginType;          //登录方式 ：1账号密码  2微信

@end
