//
//  PeopleNeedsView.h
//  ZhongFangTong
//
//  Created by apple on 2018/7/18.
//  Copyright © 2018年 XX. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^PeopleNeedsViewBlock)(NSString *selectedStr);

@interface PeopleNeedsView : UIView


@property (nonatomic , strong) NSArray *dataArr;         //

@property (nonatomic , copy) PeopleNeedsViewBlock returnBlock;         //

- (void)showinView:(UIView *)view;
- (void)dismiss;

@end
