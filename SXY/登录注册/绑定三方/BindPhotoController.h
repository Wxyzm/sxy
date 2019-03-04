//
//  BindPhotoController.h
//  SXY
//
//  Created by souxiuyun on 2019/1/21.
//  Copyright © 2019 XX. All rights reserved.
//

#import "BaseViewController.h"
@class UMSocialUserInfoResponse;

NS_ASSUME_NONNULL_BEGIN

@interface BindPhotoController : BaseViewController

@property (nonatomic , strong) UMSocialUserInfoResponse *resp;
@property (nonatomic,assign)BOOL isWx;



@end

NS_ASSUME_NONNULL_END
