//
//  HUD.m
//  task
//
//  Created by nixinyue on 16/1/14.
//  Copyright © 2016年 nixinyue. All rights reserved.
//

#import "HUD.h"

@implementation HUD

+ (void)show:(NSString *)message
{
    [self cancel];
    
    MBProgressHUD *hud = [MBProgressHUD sharedHUD];
    
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    hud.labelText = message;
    [hud show:YES];
    [hud hide:YES afterDelay:1];
}

+ (void)showLoading:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD shareLoadHUD];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    hud.labelText = message;
    [hud show:YES];
}

+ (void)showLoading:(NSString *)message inView:(UIView *)view
{
    MBProgressHUD *hud = [MBProgressHUD shareLoadHUD];
    [view addSubview:hud];
    hud.labelText = message;
    [hud show:YES];
}

+ (void)showMessage:(NSString *)message inView:(UIView *)view
{
    [self cancel];
    
    MBProgressHUD *hud = [MBProgressHUD sharedHUD];
    [view addSubview:hud];
    hud.labelText = message;
    [hud show:YES];
    [hud hide:YES afterDelay:1];
}

+ (void)showNetError
{
    [self cancel];
    [self show:@"亲，网络出错了哦^_^"];
}

+ (void)cancel
{
    [[MBProgressHUD shareLoadHUD] hide:YES];
}

@end
