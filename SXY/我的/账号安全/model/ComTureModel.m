//
//  ComTureModel.m
//  SXY
//
//  Created by yh f on 2018/12/28.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "ComTureModel.h"

@implementation ComTureModel

-(instancetype)init{
    
    self = [super init];
    if (self) {
        if (!_Title) {
            _Title = @"";
        }
        if (!_value1) {
            _value1 = @"";
        }
        if (!_value2) {
            _value2 = @"";
        }
        if (!_value3) {
            _value3 = @"";
        }
    }
    
    return self;
}

@end
