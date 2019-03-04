//
//  TureImageView.h
//  SXY
//
//  Created by souxiuyun on 2019/1/21.
//  Copyright © 2019 XX. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^TureImageViewReturnBlock)(NSInteger tag);

@interface TureImageView : UIView


@property (nonatomic,strong)UILabel *Lab;    //正反面
@property (nonatomic,strong)UIButton *btn;   //照片显示
@property (nonatomic,strong)UIButton *deletebtn;    //删除按钮
@property (nonatomic,strong)UIImageView *upImageView;    //

@property (nonatomic,copy)TureImageViewReturnBlock reurnBlock;    //

@end

NS_ASSUME_NONNULL_END
