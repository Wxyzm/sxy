//
//  CategoryModel.h
//  SXY
//
//  Created by yh f on 2018/12/19.
//  Copyright © 2018年 XX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryModel : NSObject


@property (nonatomic,copy)NSString *theId;       // 当前ID
@property (nonatomic,copy)NSString *name;        // 名称
@property (nonatomic,copy)NSString *name2;       //备用
@property (nonatomic,copy)NSString *kind;        //类别
@property (nonatomic,copy)NSString *parentId;    //父类

@property (nonatomic,assign)BOOL isSelected;     //是否选中


@property (nonatomic,strong)NSMutableArray *CategoryArr;    //



@end
