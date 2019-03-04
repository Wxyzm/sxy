//
//  ChoseTopView.h
//  SXY
//
//  Created by yh f on 2019/1/1.
//  Copyright © 2019年 XX. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ChoseTopViewSelectedBlock)(NSInteger index);

@interface ChoseTopView : UIView

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
