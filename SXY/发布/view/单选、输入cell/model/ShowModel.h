//
//  ShowModel.h
//  SXY
//
//  Created by yh f on 2018/12/18.
//  Copyright © 2018年 XX. All rights reserved.
//

#import <Foundation/Foundation.h>

//加载的方式
typedef NS_ENUM(NSInteger, CellType) {
    CellType_Selected        = 1,
    CellType_Input           = 2
};

@interface ShowModel : NSObject


@property (nonatomic,copy)NSString *title;                   //显示标题

@property (nonatomic,copy)NSString *actueValue;              //实际值

@property (nonatomic,copy)NSString *actueID;                 //实际值的ID（有些不需要）


@property (nonatomic,assign)UIKeyboardType KeyboardType;     //键盘类型

@property (nonatomic,copy)NSString *upStr;                   //上传时的键

@property (nonatomic,assign)CellType cellType;               //cell类型


@end
