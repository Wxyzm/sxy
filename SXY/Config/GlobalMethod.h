//
//  GlobalMethod.h
//  FyhNewProj
//
//  Created by yh f on 2017/8/30.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>


#define NUMBERS @"0123456789.-"
//数字
#define NUM @"0123456789"
//字母
#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
//数字和字母
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
//数字和点
#define NUMANDD @".0123456789"





@interface GlobalMethod : NSObject
/********************************************************************************************/
#pragma 启动相关
//是否第一次安装
+ (BOOL)isFirstiInstall;
/********************************************************************************************/

//得到用户id
+ (NSString *)getUserid;


// 获取字符串高度
+ (float) heightForString:(NSString *)value andWidth:(float)width andFont:(UIFont *)font;

// 获取字符串宽度
+ (float) widthForString:(NSString *)value andFont:(UIFont *)font;

//时间戳转时间str 年月日
+ (NSString *)returnTimeStrWith:(NSString *)time;
//时间戳转时间str 年月日 +时间
+ (NSString *)returndetailTimeStrWith:(NSString *)time;


//检查银行卡是否合法
//Luhn算法
+ (BOOL)isValidCardNumber:(NSString *)cardNumber;


/**
 计算字符串长度

 @param text 字符串
 @return 长度
 */
+  (int)textLength:(NSString *)text;

/**
 根据字节数截取字符串

 @param str 字符串
 @param len 指定字节数/2
 @return 截取后的str
 */
+(NSString*)subTextString:(NSString*)str len:(NSInteger)len;



/**
 获取当前屏幕显示的viewcontroller

 @return viewcontroller
 */
+ (UIViewController *)getCurrentVC;

/**
 词典转换为字符串

 @param dic 词典
 @return 字符串
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;


/**
 为view加上主题渐变色

 @param view view description
 */
+ (void)addgradientLayerColorsForView:(UIView *)view;

//删除字典里的null值
+ (NSDictionary *)deleteEmpty:(NSDictionary *)dic;
//删除字典数组里的null值
+ (NSArray *)deleteEmptyArr:(NSArray *)arr;

#pragma mark -是否只包含条件
+(BOOL)isOnlyhasNumberAndpointWithString:(NSString *)string andcondition:(NSString *)condition;


//返回图片
+(NSURL *)returnUrlStrWithImageName:(NSString *)imageName andisThumb:(BOOL)isThum;

//链接融云
+ (void)connectRongCloudWithToken:(NSString *)token;
//是否是自己
+ (BOOL)userIdifSelfId:(NSString *)userId;

//拼接名称
+ (NSString *)GoodsnameWithName:(NSString *)name andPattern:(NSString *)pattern;

//拼接价格
+ (NSString *)GoodsPriceWithPrice:(NSString *)price andUnit:(NSString *)unit;
@end
