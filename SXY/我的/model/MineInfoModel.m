//
//  MineInfoModel.m
//  SXY
//
//  Created by yh f on 2018/12/24.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "MineInfoModel.h"

@implementation MineInfoModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"theId":@"id"};
}

-(instancetype)init{
    
    self = [super init];
    if (self) {
        if (!_name) {
            _name = @"";
        }
        if (!_cityName) {
            _cityName = @"";
        }
        if (!_userType) {
            _userType = @"";
        }
        if (!_userKind) {
            _userKind = @"";
        }
    }
    
    return self;
}

@end
