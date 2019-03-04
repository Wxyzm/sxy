//
//  HUD.h
//  task
//
//  Created by nixinyue on 16/1/14.
//  Copyright © 2016年 nixinyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface HUD : NSObject

+ (void)show:(NSString *)message;

+ (void)showMessage:(NSString *)message inView:(UIView *)view;

+ (void)showLoading:(NSString *)message;

+ (void)showLoading:(NSString *)message inView:(UIView *)view;

+ (void)showNetError;

+ (void)cancel;


@end
