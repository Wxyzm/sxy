//
//  SearchHistoryView.h
//  DaMinEPC
//
//  Created by apple on 2018/4/19.
//  Copyright © 2018年 XX. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SearchReturnValueBlock) (NSString *title);


@interface SearchHistoryView : UIView

@property(nonatomic, copy) SearchReturnValueBlock returnValueBlock;

- (void)showInView:(UIView *) view;
- (void)cancelPicker;

@end
