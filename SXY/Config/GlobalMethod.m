//
//  GlobalMethod.m
//  FyhNewProj
//
//  Created by yh f on 2017/8/30.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "GlobalMethod.h"

@implementation GlobalMethod
/********************************************************************************************/
#pragma 启动相关
//是否第一次安装
+ (BOOL)isFirstiInstall
{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:IS_FIRST_LOAD]) {
        return YES;
    }
    return NO;
}
/********************************************************************************************/


//得到用户id
+ (NSString *)getUserid
{
 //   NSString *userid = nil;
    User *user = [[UserPL shareManager] getLoginUser];
  //  userid = [[NSUserDefaults standardUserDefaults] objectForKey:User_Id];
    return user.userId;
}




/**
 @method 获取指定宽度width,字体大小fontSize,字符串value的高度
 @param value 待计算的字符串
 @param fontSize 字体的大小
 @param Width 限制字符串显示区域的宽度
 @result float 返回的高度
 */
+ (float) heightForString:(NSString *)value andWidth:(float)width andFont:(UIFont *)font{
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    // paraStyle.lineSpacing = 8; 行距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle
                          };
    
    CGSize size = [value boundingRectWithSize:CGSizeMake(width, 0) options:\
                   NSStringDrawingTruncatesLastVisibleLine |
                   NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size.height;
}
//注意：再前两种方法中,UITextView在上下左右分别有一个8px的



// 获取字符串宽度
+ (float) widthForString:(NSString *)value andFont:(UIFont *)font{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    // paraStyle.lineSpacing = 8; 行距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle
                          };
    
    CGSize size = [value boundingRectWithSize:CGSizeMake(ScreenWidth, 0) options:\
                   NSStringDrawingTruncatesLastVisibleLine |
                   NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size.width;
    
}




+ (NSString *)returnTimeStrWith:(NSString *)time{
    NSTimeInterval interval    =[time doubleValue] / 1000.0;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:interval];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;

}



+ (NSString *)returndetailTimeStrWith:(NSString *)time{
    NSTimeInterval interval    =[time doubleValue] / 1000.0;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
}

//检查银行卡是否合法
//Luhn算法
+(BOOL)isValidCardNumber:(NSString *)cardNumber
{
    int oddsum = 0;     //奇数求和
    int evensum = 0;    //偶数求和
    int allsum = 0;
    int cardNoLength = (int)[cardNumber length];
    int lastNum = [[cardNumber substringFromIndex:cardNoLength-1] intValue];
    
    cardNumber = [cardNumber substringToIndex:cardNoLength - 1];
    for (int i = cardNoLength -1 ; i>=1;i--) {
        NSString *tmpString = [cardNumber substringWithRange:NSMakeRange(i-1, 1)];
        int tmpVal = [tmpString intValue];
        if (cardNoLength % 2 ==1 ) {
            if((i % 2) == 0){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }else{
            if((i % 2) == 1){
                tmpVal *= 2;
                if(tmpVal>=10)
                    tmpVal -= 9;
                evensum += tmpVal;
            }else{
                oddsum += tmpVal;
            }
        }
    }
    
    allsum = oddsum + evensum;
    allsum += lastNum;
    if((allsum % 10) == 0)
        return YES;
    else
        return NO;
}
//剔除卡号里的非法字符
+(NSString *)getDigitsOnly:(NSString*)s
{
    NSString *digitsOnly = @"";
    char c;
    for (int i = 0; i < s.length; i++)
    {
        c = [s characterAtIndex:i];
        if (isdigit(c))
        {
            digitsOnly =[digitsOnly stringByAppendingFormat:@"%c",c];
        }
    }
    return digitsOnly;
}

+ (int)textLength:(NSString *)text//计算字符串长度
{
    int strlength = 0;
    char* p = (char*)[text cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[text lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}

+(NSString*)subTextString:(NSString*)str len:(NSInteger)len{
    if(str.length<=len)return str;
    int count=0;
    NSMutableString *sb = [NSMutableString string];
    
    for (int i=0; i<str.length; i++) {
        NSRange range = NSMakeRange(i, 1) ;
        NSString *aStr = [str substringWithRange:range];
        count += [aStr lengthOfBytesUsingEncoding:NSUTF8StringEncoding]>1?2:1;
        [sb appendString:aStr];
        if(count >= len*2) {
            return (i==str.length-1)?[sb copy]:[NSString stringWithFormat:@"%@",[sb copy]];
        }
    }
    return str;
}

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;  
}

//词典转换为字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}



+ (void)addgradientLayerColorsForView:(UIView *)view{
    
    //  创建 CAGradientLayer 对象
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    //  设置 gradientLayer 的 Frame
    gradientLayer.frame = view.bounds;
    //  gradientLayer.cornerRadius = 10;
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(id)UIColorFromRGB(0xff2d66).CGColor,
                             (id)UIColorFromRGB(0xff4452).CGColor,
                             (id)UIColorFromRGB(0xff5d3b).CGColor];
    //  设置三种颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@(0.1f) ,@(0.5f),@(1.0f)];
    
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    [view.layer addSublayer:gradientLayer];

}


//删除字典里的null值
+ (NSDictionary *)deleteEmpty:(NSDictionary *)dic
{
    NSMutableDictionary *mdic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    NSMutableArray *set = [[NSMutableArray alloc] init];
    NSMutableDictionary *dicSet = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *arrSet = [[NSMutableDictionary alloc] init];
    for (id obj in mdic.allKeys)
    {
        id value = mdic[obj];
        if ([value isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *changeDic = [self deleteEmpty:value];
            [dicSet setObject:changeDic forKey:obj];
        }
        else if ([value isKindOfClass:[NSArray class]])
        {
            NSArray *changeArr = [self deleteEmptyArr:value];
            [arrSet setObject:changeArr forKey:obj];
        }
        else
        {
            if ([value isKindOfClass:[NSNull class]]) {
                [set addObject:obj];
            }
        }
    }
    for (id obj in set)
    {
        mdic[obj] = @"";
    }
    for (id obj in dicSet.allKeys)
    {
        mdic[obj] = dicSet[obj];
    }
    for (id obj in arrSet.allKeys)
    {
        mdic[obj] = arrSet[obj];
    }
    
    return mdic;
}

//删除数组中的null值
+ (NSArray *)deleteEmptyArr:(NSArray *)arr
{
    NSMutableArray *marr = [NSMutableArray arrayWithArray:arr];
    NSMutableArray *set = [[NSMutableArray alloc] init];
    NSMutableDictionary *dicSet = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *arrSet = [[NSMutableDictionary alloc] init];
    
    for (id obj in marr)
    {
        if ([obj isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *changeDic = [self deleteEmpty:obj];
            NSInteger index = [marr indexOfObject:obj];
            [dicSet setObject:changeDic forKey:@(index)];
        }
        else if ([obj isKindOfClass:[NSArray class]])
        {
            NSArray *changeArr = [self deleteEmptyArr:obj];
            NSInteger index = [marr indexOfObject:obj];
            [arrSet setObject:changeArr forKey:@(index)];
        }
        else
        {
            if ([obj isKindOfClass:[NSNull class]]) {
                NSInteger index = [marr indexOfObject:obj];
                [set addObject:@(index)];
            }
        }
    }
    for (id obj in set)
    {
        marr[(int)obj] = @"";
    }
    for (id obj in dicSet.allKeys)
    {
        int index = [obj intValue];
        marr[index] = dicSet[obj];
    }
    for (id obj in arrSet.allKeys)
    {
        int index = [obj intValue];
        marr[index] = arrSet[obj];
    }
    return marr;
}



#pragma mark -是否只包含数字，小数点，负号等

+(BOOL)isOnlyhasNumberAndpointWithString:(NSString *)string andcondition:(NSString *)condition{

    NSCharacterSet *cs=[[NSCharacterSet characterSetWithCharactersInString:condition] invertedSet];
    
    NSString *filter=[[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return [string isEqualToString:filter];
    
}
//返回图片
+(NSURL *)returnUrlStrWithImageName:(NSString *)imageName andisThumb:(BOOL)isThum andTYpe:(NSString *)imageType
{
   
    if ([imageName containsString:@"http"]) {
        return [NSURL URLWithString:imageName];
    }
    
    NSDictionary *info;
    if (isThum) {
        info  = @{@"address":imageName,
                  @"isThumb":@"true",
                  @"imageType":imageType
                 };
    }else{
        info  = @{@"address":imageName,
                  @"isThumb":@"false",
                  @"imageType":imageType
                 };
    }
    
        NSURL *url;
        NSArray *keyArray = [info allKeys];
        NSMutableString *str = [NSMutableString string];
        [str appendString:@"?"];
        NSString *key = keyArray[0];
        [str appendString:[NSString stringWithFormat:@"%@=%@",key,[info objectForKey:key]]];
        for (int i = 1;i < keyArray.count;i++) {
            key = keyArray[i];
            if (key.length)
                [str appendString:[NSString stringWithFormat:@"&%@=%@",key,[info objectForKey:key]]];
        }
        url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@/souxiu/system/base/queryPic%@",kbaseUrl,str] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
        return url;
    
}
+(NSURL *)returnUrlStrWithImageName:(NSString *)imageName andisThumb:(BOOL)isThum{
    if (!imageName) {
        return nil;
    }
    if ([imageName containsString:@"http"]) {
        return [NSURL URLWithString:imageName];
    }
    
    NSDictionary *info;
    if (isThum) {
        info  = @{@"address":imageName,
                  @"isThumb":@"true"
                  };
    }else{
        info  = @{@"address":imageName,
                  @"isThumb":@"false"
                  };
    }
    
    NSURL *url;
    NSArray *keyArray = [info allKeys];
    NSMutableString *str = [NSMutableString string];
    [str appendString:@"?"];
    NSString *key = keyArray[0];
    [str appendString:[NSString stringWithFormat:@"%@=%@",key,[info objectForKey:key]]];
    for (int i = 1;i < keyArray.count;i++) {
        key = keyArray[i];
        if (key.length)
            [str appendString:[NSString stringWithFormat:@"&%@=%@",key,[info objectForKey:key]]];
    }
    url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@/souxiu/system/base/queryPic%@",kbaseUrl,str] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    return url;
    
}

//链接融云
+ (void)connectRongCloudWithToken:(NSString *)token{
    
    //连接融云服务器
    if ([[UserPL shareManager] userIsLogin]) {
        // 连接融云服务器。
        [[RCIM sharedRCIM] connectWithToken:token    success:^(NSString *userId) {
            NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
            dispatch_async(dispatch_get_main_queue(), ^
                           {
                               //新建一个聊天会话View Controller对象,建议这样初始化
                               // [self.navigationController pushViewController:nav animated:YES];
                               
                           });
            
            
        } error:^(RCConnectErrorCode status) {
            NSLog(@"登陆的错误码为:%ld", (long)status);

        } tokenIncorrect:^{
            //token过期或者不正确。
            //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
            //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
            [RCTokenPL getRcTokenWithReturnBlock:^(id returnValue) {
                                                                                                                                                                                                                         [self connectRongCloudWithToken:token];
            } andErrorBlock:^(NSString *msg) {

            }];
            
            NSLog(@"token错误");
        }];
    }
    
}

+ (BOOL)userIdifSelfId:(NSString *)userId{
    
    User *user = [[UserPL shareManager] getLoginUser];
    if ([userId isEqualToString:user.userId]) {
        return YES;
    }
    return NO;
}

//拼接名称
+ (NSString *)GoodsnameWithName:(NSString *)name andPattern:(NSString *)pattern
{
    NSString *nameStr = [NSString stringWithFormat:@"%@%@",name,pattern];
    return nameStr;
}
//拼接价格
+ (NSString *)GoodsPriceWithPrice:(NSString *)price andUnit:(NSString *)unit{
    if (price.length<=0 || unit.length<=0) {
        return @"面议";
        
    }
    if ([price floatValue]==0) {
        return @"面议";
    }
    
    return [NSString stringWithFormat:@"￥  %@/%@",price,unit];
    
}

@end
