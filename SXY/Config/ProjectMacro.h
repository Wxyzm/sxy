//
//  ProjectMacro.h
//  DaMinEPC
//
//  Created by apple on 2017/12/22.
//  Copyright © 2017年 XX. All rights reserved.
//

#ifndef ProjectMacro_h
#define ProjectMacro_h

#define PAGE_SIZE_NUMBER  @"20"

/////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////    三方SDK   ///////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////


#define UMKey                @"5c231c64b465f5a867000088"
#define JpushKey             @"f8b5d45f606218c715bc60af"
#define RongKey              @"c9kqb3rdc4y5j"
#define RongSec              @"xMXlLI5BS5PUN"
#define QQKey                @"1108027747"
#define WXID                 @"wxf67a2f57bd6cb366"
#define WXSecret             @"f9a15939b242992e2be82f447d3f6ad6"
//融云通知设置
#define RCChatListShouldRefresh           @"FYH-RCChatListShouldRefresh"        //聊天列表
#define RCChatListUserShouldRefresh       @"FYH-RCChatListUserShouldRefresh"    //个人信息
#define RCChatListGroupShouldRefresh      @"FYH-RCChatListGroupShouldRefresh"   //群组
#define TIMEOUT             60

#define MaginX  20.0f

//比例系数
#define TimeScaleX  ScreenWidth/375
#define TimeScaleY  ScreenHeight/667
// 获取屏幕高度.
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
// 获取屏幕宽度
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

//字体大小
#define APPFONT(x) [UIFont systemFontOfSize:(x)]

#define WeakSelf(type)  __weak typeof(type) weak##type = type;


//////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////    设置颜色   /////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
// 设置颜色.
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define Color_RGB(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0  alpha:1.0]
#define Color_RGB_Alpha(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0  alpha:(a)]

#define UIColorFromRGB_Alpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]


//--------------      常用颜色     -------------------------
#define WhiteColorValue          0xffffff       //白色
#define BlackColorValue          0x333333       //黑色正文
#define LitterBlackColorValue    0x939393       //浅黑说明
#define BTNColorValue            0xC0B451       //按钮黄色


#define PLAColorValue            0xE0E0E0      //placeholderColor
#define LineColorValue           0xf4f4f4       //分割线颜色
#define BackColorValue           0xefefef       //背景色
#define NAVColorValue            0x3f7be9       //背景色
#define GrayColorValue           0xcccccc       //灰色字体
#define RedColorValue            0xE74922       //红色


//////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////  账号、密码 /////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
#define IS_FIRST_LOAD          @"IS_FIRST_LOAD"          //是否第一次加载
#define AppVerison             @"appverison"             //app当前版本号
#define User_Id                @"User_Id"                //用户id
#define User_Mobile            @"User_Mobile"            //用户电话
#define User_Account           @"User_Account"           //用户账号
#define User_Pwd               @"User_Pwd"               //用户密码
#define User_Name              @"User_Name"              //用户姓名
#define User_avatar            @"User_avatar"            //用户头像
#define User_api_token         @"User_api_token"         //用户安全令牌
#define User_login_type         @"User_login_type"        //用户登录方式
#define User_openId             @"User_openId"            //用户微信登录Id
#define SearchHistory    @"SearchHistory"            //用户搜索历史

//用户登录
#define UserLoginMsg            @"userLoginMsg"
//用户登出
#define UserLogutMsg            @"userLogutMsg"

#define ImageURL                @"http://zcczlkj.oss-cn-hangzhou.aliyuncs.com/"

//http://zcczlkj.oss-cn-hangzhou.aliyuncs.com/service/0879852cda23ae13ede90a9b97912f99.png

//////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////  通知/////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////

#define MineVcShouldRefresh    @"mineVcShouldRefresh"            //用户是否登录

/**
 *  判断是否是空字符串 空字符串 = yes
 *
 *  @param string
 *
 *  @return
 */
#define  IsEmptyStr(string) string == nil || string == NULL ||[string isKindOfClass:[NSNull class]]|| [string isEqualToString:@""] ||[[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0 ? YES : NO

#define  EmptyStr(string) string == nil || string == NULL ||[string isKindOfClass:[NSNull class]]|| [string isEqualToString:@""] ||[[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0 ? @"" : string
//--------------    iphone各机型判断    -------------------------
//////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////    iphone各机型判断   /////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////

#define iPad               CGSizeEqualToSize(CGSizeMake(768, 1024), [[UIScreen mainScreen] bounds].size)
#define iPhone5               CGSizeEqualToSize(CGSizeMake(320, 568), [[UIScreen mainScreen] bounds].size)
#define iPhone6               CGSizeEqualToSize(CGSizeMake(375, 667), [[UIScreen mainScreen] bounds].size)
#define iPhone6p               CGSizeEqualToSize(CGSizeMake(414, 736), [[UIScreen mainScreen] bounds].size)
#define iPhoneX               CGSizeEqualToSize(CGSizeMake(375, 812), [[UIScreen mainScreen] bounds].size)||CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(414, 896))

//////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////     常用高度控制   /////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
#define TABBAR_HEIGHT           (iPhoneX?72:49)  //tabbar的默认高度
#define STATUSBAR_HEIGHT        (iPhoneX?44:20)  //状态栏高度
#define NaviHeight64   (STATUSBAR_HEIGHT+44)//navigation+statue默认高度

//////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////     常用字体大小  /////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
#define APPFONT(x) [UIFont systemFontOfSize:(x)]
#define APPFONT12 [UIFont systemFontOfSize:12]
#define APPFONT13 [UIFont systemFontOfSize:13]
#define APPFONT14 [UIFont systemFontOfSize:14]
#define APPFONT15 [UIFont systemFontOfSize:15]
#define APPFONT16 [UIFont systemFontOfSize:16]
#define APPFONT17 [UIFont systemFontOfSize:17]
#define APPFONT18 [UIFont systemFontOfSize:18]
#define APPBLODFONTT(x) [UIFont boldSystemFontOfSize:(x)]


//////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////    加载方式   ///////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////

#define PageSize          @"10"    //分页加载时  每页的数量
#define NET_TIME_OUT      20

//#define kbaseUrl        @"http://souxiu.emb-fashion.com"      //接口
#define kbaseUrl        @"https://sxy-good.emb-fashion.com"      //接口


#define GoodsImage          @"1"    //首页图片显示






#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"\n %s:%d   %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],__LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(...)
#endif
#endif /* ProjectMacro_h */
