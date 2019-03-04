//
//  HomePL.m
//  SXY
//
//  Created by yh f on 2018/12/1.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "HomePL.h"

@implementation HomePL
#pragma mark   ========== 获取首页
+(void)Home_HomegetHomeListWithDic:(NSDictionary *)dic
                   WithReturnBlock:(PLReturnValueBlock)returnBlock
                    withErrorBlock:(PLErrorCodeBlock)errorBlock{
    [[HttpClient sharedHttpClient] HomegetHomeListWithDic:dic WithReturnBlock:^(id returnValue) {
        
        NSDictionary *dic = [HttpClient valueWithJsonString:returnValue];
        if ([dic[@"state"] boolValue]) {
            NSDictionary *returnDic= dic[@"data"];
            returnBlock(returnDic[@"result"]);
        }else{
            if ([dic[@"errorCode"] intValue]==201 )
            {
                [[UserPL shareManager] showLoginView];
                return ;
            }
            [HUD show:dic[@"message"]];
            errorBlock(dic[@"message"]);
        }
    } andErrorBlock:^(NSString *msg) {
        [HUD show:msg];
        errorBlock(msg);
    }];
    
    
}


@end
