//
//  TopView.h
//  ZhongFangTong
//
//  Created by apple on 2018/6/21.
//  Copyright © 2018年 XX. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^TopViewSelectedBlock)(NSInteger index);

@interface TopView : UIView

-(instancetype)initWithArr:(NSMutableArray *)dataArr;


/**
 点击按钮回调
 */
@property (nonatomic , copy)TopViewSelectedBlock returnBlock;



/**
 设置选中的按钮

 @param index index
 */
- (void)setSelectedIndex:(NSInteger)index;


@end
