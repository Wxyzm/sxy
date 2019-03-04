//
//  MineInfoModel.h
//  SXY
//
//  Created by yh f on 2018/12/24.
//  Copyright © 2018年 XX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineInfoModel : NSObject


@property (nonatomic,copy)NSString *theId;     //

/**
 生日
 */
@property (nonatomic,copy)NSString *birthDate;     //
/**
 市区 列绍兴市
 */
@property (nonatomic,copy)NSString *cityName;     //
/**
 公司
 */
@property (nonatomic,copy)NSString *company;     //
/**
 企业认证
 */
@property (nonatomic,copy)NSString *companyAuth;     //
/**
 登录时间
 */
@property (nonatomic,copy)NSString *loginDate;     //
/**
 名字
 */
@property (nonatomic,copy)NSString *name;     //
/**
 头像
 */
@property (nonatomic,copy)NSString *photo;     //
/**
 省份
 */
@property (nonatomic,copy)NSString *provinceName;     //
/**
 实名
 */
@property (nonatomic,copy)NSString *realNameAuth;     //
/**
 性别
 */
@property (nonatomic,copy)NSString *sex;     //
/**
 签名
 */
@property (nonatomic,copy)NSString *signature;     //
/**
 用户2级类别（底部供应商）
 */
@property (nonatomic,copy)NSString *userKind;     //
/**
 用户1级类别 （供应链）
 */
@property (nonatomic,copy)NSString *userType;     //









@end
