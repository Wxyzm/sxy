
//
//  YLButton.m
//  YLButton
//
//  Created by HelloYeah on 2016/11/24.
//  Copyright © 2016年 YL. All rights reserved.
//

#import "YLButton.h"

@implementation YLButton

+ (id)buttonWithbackgroundColor:(UIColor *)backgroundcolor titlecolor:(UIColor *)titlcolor cornerRadius:(CGFloat)cornerflot andtarget:(id)target action:(SEL)action titleFont:(UIFont*)font title:(NSString *)title{
    
    YLButton *button = [YLButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titlcolor forState:UIControlStateNormal];
    button.backgroundColor = backgroundcolor;
    button.layer.cornerRadius = cornerflot;
    button.titleLabel.font = font;
    if (target) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return button;
    
}


-(instancetype)init{

    self = [super init];
    if (self) {
       // CGFloat Height = ScreenWidth/4;
       
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    if (!CGRectIsEmpty(self.titleRect) && !CGRectEqualToRect(self.titleRect, CGRectZero)) {
        return self.titleRect;
        
    }
    return [super titleRectForContentRect:contentRect];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    if (!CGRectIsEmpty(self.imageRect) && !CGRectEqualToRect(self.imageRect, CGRectZero)) {
        return self.imageRect;
    }
    return [super imageRectForContentRect:contentRect];
}



@end
