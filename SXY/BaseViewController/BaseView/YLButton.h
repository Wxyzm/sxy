//
//  YLButton.h
//  YLButton
//
//  Created by HelloYeah on 2016/11/24.
//  Copyright © 2016年 YL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLButton : UIButton
@property (nonatomic,assign) CGRect titleRect;
@property (nonatomic,assign) CGRect imageRect;
@property (nonatomic,assign) BOOL on;
@property (nonatomic,copy) NSString *name;

+ (id)buttonWithbackgroundColor:(UIColor *)backgroundcolor titlecolor:(UIColor *)titlcolor cornerRadius:(CGFloat)cornerflot andtarget:(id)target action:(SEL)action titleFont:(UIFont*)font title:(NSString *)title;


@end
