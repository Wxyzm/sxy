//
//  User.m
//  FyhNewProj
//
//  Created by yh f on 2017/3/4.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "User.h"

@implementation User
-(instancetype)init{
    
    self = [super init];
    if (self) {
        
    }
    return self;
}

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"userId":@"id"};
}

@end
