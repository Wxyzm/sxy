//
//  WantBuyModel.m
//  SXY
//
//  Created by yh f on 2018/12/1.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "WantBuyModel.h"

@implementation WantBuyModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"theID":@"id"};
}

+(NSDictionary *)mj_objectClassInArray{
    
    return @{@"commentDTOList":@"CommentModel"};
}
@end
