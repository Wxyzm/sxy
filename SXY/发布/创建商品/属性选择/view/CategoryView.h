//
//  CategoryView.h
//  SXY
//
//  Created by yh f on 2018/12/19.
//  Copyright © 2018年 XX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CategoryModel;

//点击的类目，三级第一个自定义
typedef void(^CategoryViewReturnBlock)(CategoryModel *model);

@interface CategoryView : UIView

@property (nonatomic,strong)NSMutableArray *dataArr;

@property (nonatomic,copy)CategoryViewReturnBlock returnBlock;

- (void)AllReloadDatas;


@end
