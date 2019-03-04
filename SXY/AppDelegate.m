//
//  AppDelegate.m
//  SXY
//
//  Created by yh f on 2018/11/3.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "AppDelegate.h"
#import "LBTabBarController.h"
#import "LBNavigationController.h"
#import "ChatViewController.h"
#import "LoginController.h"
#import "IQKeyboardManager.h"

//友盟
#import <UMCommon/UMCommon.h>
#import <UMShare/UMShare.h>
//融云
#import "RongIMKit/RongIMKit.h"

// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif


@interface AppDelegate ()<RCIMUserInfoDataSource,RCIMConnectionStatusDelegate,RCIMReceiveMessageDelegate,JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
    
    //初始化友盟SDK
    [self initUmSDK:launchOptions];
    //初始化融云SDK
    [self initRongCloudSDK];
    //设置键盘
    [self initKeyBoardManage];
    //极光推送
    [self initJpush:launchOptions];
     self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = UIColorFromRGB(WhiteColorValue);

    _mainTab = [[LBTabBarController alloc]init];
    
   
    User *user  =[[UserPL shareManager] getLoginUser];
    if (user.token.length>0) {
        [RCTokenPL getRcTokenWithReturnBlock:^(id returnValue) {
            [GlobalMethod connectRongCloudWithToken:returnValue];
        } andErrorBlock:^(NSString *msg) {
            
        }];
        self.window.rootViewController= _mainTab;

    }else{
        self.window.rootViewController= [[LBNavigationController alloc]initWithRootViewController:[LoginController new]];

    }
    

    //15068521113
    [self.window makeKeyAndVisible];
    
    
   

    return YES;
}

////极光推送
- (void)initJpush:(NSDictionary *)launchOpions{
    
    //Required
    //notice: 3.0.0 及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义 categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOpions appKey:JpushKey
                          channel:@"App Store"
                 apsForProduction:1
            advertisingIdentifier:@""];
    NSLog(@"%@",[JPUSHService registrationID]);
}



//初始化友盟SDK
- (void)initUmSDK:(NSDictionary *)launchOpions
{
    /* 打开调试日志 */
    [UMConfigure setLogEnabled:YES];//设置打开日志
    /* 设置友盟appkey */
    [UMConfigure initWithAppkey:UMKey channel:@"App Store"];
    /* 设置微信的appKey和appSecret */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WXID appSecret:WXSecret redirectURL:@"http://www.umeng.com/social"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQKey appSecret:nil redirectURL:@"http://www.umeng.com/social"];

}


//融云SDK初始化   在登陆时候连接
- (void)initRongCloudSDK{
    [[RCIM sharedRCIM]initWithAppKey:RongKey];
    
    //获取应用程序消息通知标记数（即小红圈中的数字）
    long badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    if (badge>0) {
        //如果应用程序消息通知标记数（即小红圈中的数字）大于0，清除标记。
        badge = 0;
        //清除标记。清除小红圈中数字，小红圈中数字为0，小红圈才会消除。
        [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
    }
    [[RCIM sharedRCIM] setGlobalConversationAvatarStyle:RC_USER_AVATAR_RECTANGLE];
    [[RCIM sharedRCIM] setGlobalMessageAvatarStyle:RC_USER_AVATAR_RECTANGLE];
    [RCIM sharedRCIM].globalNavigationBarTintColor = [UIColor whiteColor];
    //监测链接状态
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    //设置用户信息提供者。
    // [[RCIM sharedRCIM] setUserInfoDataSource:self];
}



/**
 状态监测
 
 @param status status description
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status{
    
    if (status ==ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT || status == ConnectionStatus_LOGIN_ON_WEB) {
        UIAlertController *alertController=[UIAlertController alertControllerWithTitle:@"提示" message:@"您的账号在其他客户端登录，使用聊天功能时需重新登录" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertController addAction:sureAction];
        UIWindow   *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        alertWindow.rootViewController = [[UIViewController alloc] init];
        alertWindow.windowLevel = UIWindowLevelAlert + 1;
        [alertWindow makeKeyAndVisible];
        [alertWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    }
    
}



//初始化键盘控制器
- (void)initKeyBoardManage
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;  //不显示toolBar
    [manager.disabledToolbarClasses addObject:[ChatViewController class]];
    [manager setKeyboardDistanceFromTextField:20];
}








- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        if ([url.host isEqualToString:@"safepay"])
        {
            // 支付跳转支付宝钱包进行支付，处理支付结果
            
        }
    }
    return  result;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    
    BOOL result = [[UMSocialManager defaultManager]handleOpenURL:url options:options];
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
       
    }else if ( [url.absoluteString containsString:@"pay"]) {
       
    }else{
        
    }
   
    return result;
}


#pragma mark ===== 极光推送
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

#pragma mark- JPUSHRegisterDelegate



// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
    }else{
        //从通知设置界面进入应用
    }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required, For systems with less than or equal to iOS 6
    [JPUSHService handleRemoteNotification:userInfo];
}










@end
