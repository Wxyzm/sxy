//
//  HomePageControl.m
//  SXY
//
//  Created by yh f on 2019/1/15.
//  Copyright © 2019 XX. All rights reserved.
//

#import "HomePageControl.h"

@implementation HomePageControl


-(instancetype)init{
    
    self = [super init];
    if (self) {
        self.userInteractionEnabled = NO;
    }
    return self;
}


-(void)setCurrentPage:(NSInteger)currentPage{
    [super setCurrentPage:currentPage];
    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
        
        UIImageView* subview = [self.subviews objectAtIndex:subviewIndex];
        CGSize size = subview.bounds.size;
        size.height =  2;
        size.width =  14;

        subview.size =  size;
        //        CGSize size;
        
        //        size.height = 12;
        //
        //        size.width = 12;
        //
        //        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,
        //
        //                                     size.width,size.height)];
        
        if (subviewIndex == currentPage)
            
        {   subview.layer.cornerRadius = 0;
            subview.layer.masksToBounds = YES;
        }
        else
            subview.layer.cornerRadius = 0;
            subview.layer.masksToBounds = YES;

        }
        
    
}
























@end
