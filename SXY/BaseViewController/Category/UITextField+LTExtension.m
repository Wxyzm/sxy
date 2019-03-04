//
//  UITextField+LTExtension.m
//  SXY
//
//  Created by yh f on 2018/12/18.
//  Copyright © 2018年 XX. All rights reserved.
//

#import "UITextField+LTExtension.h"
#import <objc/runtime.h>

static NSString *maxInputLenghtKey = @"maxInputLenghtKey";




@interface UITextField ()

/** 是否已经设置过最大值 */
@property (nonatomic, assign) NSInteger isSetupMaxInputLenght;

@end

@implementation UITextField (LTExtension)


#pragma mark - < 方法交换 >

+ (void)load
{
    Method dealloc = class_getInstanceMethod(self, NSSelectorFromString(@"dealloc"));
    Method lt_dealloc = class_getInstanceMethod(self, @selector(lt_dealloc));
    method_exchangeImplementations(dealloc, lt_dealloc);
    
    Method initWithFrame = class_getInstanceMethod(self, NSSelectorFromString(@"initWithFrame:"));
    Method lt_initWithFrame = class_getInstanceMethod(self, @selector(lt_initWithFrame:));
    method_exchangeImplementations(initWithFrame, lt_initWithFrame);
    
    
    Method initWithCoder = class_getInstanceMethod(self, NSSelectorFromString(@"initWithCoder:"));
    Method lt_initWithCoder = class_getInstanceMethod(self, @selector(lt_initWithCoder:));
    method_exchangeImplementations(initWithCoder, lt_initWithCoder);
}

- (void)lt_dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self lt_dealloc];
}

- (instancetype)lt_initWithFrame:(CGRect)frame
{
    [self lt_initWithFrame:frame];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lt_category_maxInputLenght_textDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
    
    return self;
}

- (instancetype)lt_initWithCoder:(NSCoder *)coder
{
    [self lt_initWithCoder:coder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(lt_category_maxInputLenght_textDidChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
    return self;
}

#pragma mark - < 属性绑定 >

- (void)setMaxInputLenght:(NSInteger)maxInputLenght
{
    objc_setAssociatedObject(self, (__bridge const void *)(maxInputLenghtKey), @(maxInputLenght), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)maxInputLenght
{
    NSNumber *maxInputLenght = objc_getAssociatedObject(self, (__bridge const void *)(maxInputLenghtKey));
    return maxInputLenght.integerValue;
}

#pragma mark - < 输入框内容处理 >

- (void)lt_category_maxInputLenght_textDidChangeNotification:(NSNotification *)notification
{
    if (self.maxInputLenght <= 0) return;
    
    NSString *InputMethodType = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    
    // 如果当前输入法为汉语输入法
    if ([InputMethodType isEqualToString:@"zh-Hans"]) {
        
        // 获取标记部分
        UITextRange *selectedRange = [self markedTextRange];
        
        //获取标记部分, 此部分为用户未决定输入部分
        UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
        
        // 当没有标记部分时截取字符串
        if (position == nil) {
            if (self.text.length > self.maxInputLenght) {
                self.text = [self.text substringToIndex:self.maxInputLenght];
            }
        }
    }else {
        if (self.text.length > self.maxInputLenght) {
            self.text = [self.text substringToIndex:self.maxInputLenght];
        }
    }
}




@end
