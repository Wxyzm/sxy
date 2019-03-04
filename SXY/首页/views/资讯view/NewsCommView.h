//
//  NewsCommView.h
//  SXY
//
//  Created by yh f on 2019/1/4.
//  Copyright © 2019年 XX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCommView : UIView

@property (nonatomic,strong)YLButton *moreBtn;

@property (nonatomic,strong)NSMutableArray  *dataArr;

+(CGFloat)ViewHeightWithArr:(NSMutableArray *)dataArr;
@end
