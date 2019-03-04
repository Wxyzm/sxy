//
//  CommentModel.m
//  SXY
//
//  Created by yh f on 2019/1/4.
//  Copyright © 2019年 XX. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"theId":@"id"};
}

-(instancetype)init{
    self = [super init];
    if (self) {
        if (!_cellHeight) {
            _cellHeight = 0;
        }
        
    }
    return self;
}

@end
