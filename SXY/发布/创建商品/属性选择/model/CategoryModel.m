//
//  CategoryModel.m
//  SXY
//
//  Created by yh f on 2018/12/19.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "CategoryModel.h"

@implementation CategoryModel


+(NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"theId":@"id"};
    
}

-(instancetype)init{
    
    self = [super init];
    if (self) {
        if (!_CategoryArr) {
            _CategoryArr = [NSMutableArray arrayWithCapacity:0];
        }
    }
    
    
 return self;
}


@end
