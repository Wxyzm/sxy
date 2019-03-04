//
//  UserHomeTopView.h
//  SXY
//
//  Created by yh f on 2019/1/8.
//  Copyright © 2019年 XX. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MineInfoModel;
@interface UserHomeTopView : UIView

@property (nonatomic,strong)MineInfoModel *model;

@property (nonatomic,strong)UIButton *focBtn;      //关注
@property (nonatomic,strong)UIButton *chatBtn;         //私信


@end
