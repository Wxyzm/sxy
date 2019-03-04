//
//  RCTokenPL.m
//  SXY
//
//  Created by yh f on 2019/1/10.
//  Copyright © 2019年 XX. All rights reserved.
//

#import "RCTokenPL.h"

@implementation RCTokenPL

+ (void)getRcTokenWithReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlcok{
    HttpClient *client = [HttpClient sharedHttpClient];
    [client UserGetRongTokenWithDic:nil ReturnBlock:^(id returnValue) {
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
            errorBlcok(dic[@"message"]);
        }
    } andErrorBlock:^(NSString *msg) {
        [HUD show:msg];
        errorBlcok(msg);
    }];
}



@end
