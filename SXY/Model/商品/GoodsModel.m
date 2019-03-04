//
//  GoodsModel.m
//  SXY
//
//  Created by yh f on 2018/12/1.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "GoodsModel.h"

@implementation GoodsModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"theID":@"id"};
}

+(NSDictionary *)mj_objectClassInArray{
    
    return @{@"specDTOList":@"SpecListModel"};
}


@end
