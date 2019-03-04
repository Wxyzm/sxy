//
//  HomePL.h
//  SXY
//
//  Created by yh f on 2018/12/1.
//  Copyright © 2018年 XX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomePL : NSObject

#pragma mark   ========== 获取首页
+(void)Home_HomegetHomeListWithDic:(NSDictionary *)dic
                   WithReturnBlock:(PLReturnValueBlock)returnBlock
                    withErrorBlock:(PLErrorCodeBlock)errorBlock;

@end
