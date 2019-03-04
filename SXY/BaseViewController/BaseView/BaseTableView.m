//
//  BaseTableView.m
//  FyhNewProj
//
//  Created by yh f on 2017/11/8.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "BaseTableView.h"

@implementation BaseTableView

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
       
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    
    return self;
}

@end
