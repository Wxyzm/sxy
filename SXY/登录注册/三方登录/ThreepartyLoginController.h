//
//  ThreepartyLoginController.h
//  SXY
//
//  Created by yh f on 2019/1/18.
//  Copyright © 2019 XX. All rights reserved.
//

#import "BaseViewController.h"
@class UMSocialUserInfoResponse;

NS_ASSUME_NONNULL_BEGIN

@interface ThreepartyLoginController : BaseViewController

@property (nonatomic , strong) UMSocialUserInfoResponse *resp;

@property (nonatomic,assign)BOOL isWx;


@end

NS_ASSUME_NONNULL_END
