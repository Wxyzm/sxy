//
//  RCTokenPL.h
//  SXY
//
//  Created by yh f on 2019/1/10.
//  Copyright © 2019年 XX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCTokenPL : NSObject

+ (void)getRcTokenWithReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlcok;


@end
