//
//  ShowModel.m
//  SXY
//
//  Created by yh f on 2018/12/18.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "ShowModel.h"

@implementation ShowModel

-(instancetype)init{
    
    self = [super init];
    if (self) {
        if (!_actueValue) {
            _actueValue = @"";
        }
    }
    return self;
}

@end
